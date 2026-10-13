# Backend plan

The site currently runs entirely in the browser. `admin.html` and `dashboard.html` share data through
`localStorage` (key `fion.db.v1`) and the sign-ins check salted PBKDF2 hashes stored inside the pages.
That makes a good, clickable prototype, but it is **not secure** and data is not shared between devices.

The brief for the live version is **Next.js + TypeScript + PostgreSQL**, with these rules:

- Simulated money only. No real funds are moved.
- Every admin change needs **server-side authorization, validation and an audit log entry**.
- Separate admin login, role permissions and an extra check for sensitive actions.
- Blocked users lose their sessions and transfer access immediately.

## What is here
`supabase-schema.sql` is a PostgreSQL schema (works on Supabase or any Postgres) that mirrors the prototype:
profiles with roles (`customer`, `admin`, `support`) and a `status` (`active` / `blocked`), accounts, savings goals,
transactions with references, and an `audit_logs` table. Row Level Security means a customer can only read their own
rows (and not at all once blocked), support is read-only, and only admins can write.

## Suggested next steps
1. Create a Supabase project (or a Postgres database) and run `supabase-schema.sql`.
2. Turn **off** public sign-ups. Create the admin and a test customer in Authentication, then add their `profiles` rows.
3. Build the API with Next.js route handlers or server actions. For each admin action: check the caller's role on the server,
   validate the input (amounts, usernames, reasons, file type/size), run the change and the audit insert in **one database
   transaction**, and re-check the admin password for sensitive actions.
4. Replace the two data functions the pages use today (`FDB.load` / `FDB.save` in each page) with calls to that API,
   and replace the in-page password checks with real authentication (Supabase Auth or NextAuth).
5. To block a user, set `status = 'blocked'` and revoke their refresh tokens. The policies already hide their data.
6. Store customer photos in object storage (for example Supabase Storage) and save the URL in `profiles.photo_url`.

The anon key is designed to be public because Row Level Security does the protecting. Never put a `service_role` key in
front-end code.
