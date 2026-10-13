-- Fion backend starter (PostgreSQL, written for Supabase but plain Postgres + Row Level Security).
-- It mirrors what the admin console prototype does, so the front end can be wired to it later.
-- SIMULATED MONEY ONLY: balances are fictional GBP.

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'customer' check (role in ('customer','admin','support')),
  username text not null unique check (username ~ '^[a-z0-9._-]{3,24}$'),
  full_name text not null,
  email text,
  phone text,
  photo_url text,
  status text not null default 'active' check (status in ('active','blocked')),
  created_at timestamptz not null default now()
);

create table public.accounts (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  balance numeric(14,2) not null default 0 check (balance >= 0),
  expenses numeric(14,2) not null default 0 check (expenses >= 0),
  savings numeric(14,2) not null default 0 check (savings >= 0),
  change_balance_pct numeric(6,2) not null default 0,
  change_expenses_pct numeric(6,2) not null default 0,
  change_savings_pct numeric(6,2) not null default 0,
  income_monthly numeric(14,2)[] not null default array_fill(0::numeric, array[12]),
  spend_monthly numeric(14,2)[] not null default array_fill(0::numeric, array[12]),
  updated_at timestamptz not null default now()
);

create table public.savings_goals (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  saved numeric(14,2) not null default 0 check (saved >= 0),
  target numeric(14,2) not null default 0 check (target >= 0)
);

create table public.transactions (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  reference text not null unique,
  activity text not null,
  occurred_on date not null default current_date,
  kind text not null check (kind in ('credit','debit')),
  amount numeric(14,2) not null check (amount > 0),
  status text not null default 'Success' check (status in ('Success','Pending','Failed')),
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

-- Who changed what and when. Written by the server on every admin change; never edited.
create table public.audit_logs (
  id bigint generated always as identity primary key,
  at timestamptz not null default now(),
  actor_id uuid not null references auth.users(id),
  actor_role text not null,
  action text not null,      -- e.g. customer.create, balance.adjust, access.block, vault.deposit, password.reset
  target text not null,      -- e.g. @username
  detail text not null
);

-- Role helpers
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin' and status = 'active');
$$;
create or replace function public.is_staff() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role in ('admin','support') and status = 'active');
$$;
create or replace function public.is_active_customer() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and status = 'active');
$$;

-- Row Level Security
alter table public.profiles enable row level security;
alter table public.accounts enable row level security;
alter table public.savings_goals enable row level security;
alter table public.transactions enable row level security;
alter table public.audit_logs enable row level security;

-- Customers read only their own rows, and only while the account is active (blocked users lose access).
-- Staff (admin + support) can read everything.
create policy "read own or staff" on public.profiles      for select using ((id = auth.uid() and public.is_active_customer()) or public.is_staff());
create policy "read own or staff" on public.accounts      for select using ((user_id = auth.uid() and public.is_active_customer()) or public.is_staff());
create policy "read own or staff" on public.savings_goals for select using ((user_id = auth.uid() and public.is_active_customer()) or public.is_staff());
create policy "read own or staff" on public.transactions  for select using ((user_id = auth.uid() and public.is_active_customer()) or public.is_staff());
create policy "staff read audit"  on public.audit_logs    for select using (public.is_staff());

-- Only admins can change data. Support is read-only. Audit rows can be inserted, never updated or deleted.
create policy "admin writes" on public.profiles      for all using (public.is_admin()) with check (public.is_admin());
create policy "admin writes" on public.accounts      for all using (public.is_admin()) with check (public.is_admin());
create policy "admin writes" on public.savings_goals for all using (public.is_admin()) with check (public.is_admin());
create policy "admin writes" on public.transactions  for all using (public.is_admin()) with check (public.is_admin());
create policy "admin audit insert" on public.audit_logs for insert with check (public.is_admin() and actor_id = auth.uid());

-- Promote your first admin in the SQL editor after creating the user in Authentication > Users:
-- insert into public.profiles (id, role, username, full_name) values ('<user-uuid>', 'admin', 'fion-admin', 'Fion Admin');
