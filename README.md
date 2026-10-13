# Fion

A responsive banking-style website concept with a landing page, customer login, customer dashboard and an admin console.
**Simulated money only. No real funds are moved.**

Plain HTML, CSS and JavaScript. No build step.

## Pages and how they connect

```
index.html  (landing page)  ->  login.html  ->  dashboard.html
                                                 |  log out
                                                 v
                                            login.html

footer "Manager Login"  ->  manager-login.html  ->  admin.html
                                                       |  log out
                                                       v
                                                  manager-login.html
```

| File | What it is |
| --- | --- |
| `index.html` | The landing page (version 2.1) and the site's home page. "Online Banking" and "Get Started" open the login. |
| `v1.html` | Original first design of the landing page, kept for reference. |
| `login.html` | Customer login (username and password). |
| `dashboard.html` | Customer dashboard: balance card, quick actions, this month, latest activity, savings vault. Logging out returns to `login.html`. |
| `manager-login.html` | Separate admin login. |
| `admin.html` | Admin console, built from the admin brief (see below). |
| `tools/credentials.html` | Makes a salted hash for a new username and password. |
| `backend/` | PostgreSQL schema and the plan for the real backend. |

## Admin console features
1. **Customer accounts**: create, find, edit and manage profiles.
2. **Photo upload**: upload, crop, preview and update a customer photo during account creation.
3. **Demo balances**: adjust fictional GBP balances with a reason and a recorded transaction.
4. **Transactions**: search transfers, references, amounts, dates and statuses (CSV export).
5. **Savings vaults**: view goals and balances, make deposits and withdrawals.
6. **Access control**: block or unblock accounts. A blocked customer is signed out and cannot sign in.
7. **Security & roles**: separate admin login, role permissions (Super admin, Support read-only), an extra password check for sensitive actions, 15-minute inactivity sign-out.
8. **Audit & reports**: every change is logged (who, what, when) with trend charts and CSV export.

New customers are created with a username and a temporary password (shown once). They can then sign in at `login.html`.

## Credentials
Passwords are **not** stored in this repo, only salted PBKDF2 hashes. You were given the starting usernames and passwords separately:
a customer (`fion-owner`), an admin (`fion-admin`) and a read-only support account (`fion-support`).
To change one, open `tools/credentials.html`, make a hash, then paste it:
- customer: over `CRED=` in `login.html`
- admin or support: into the `ADMINS=` list in **both** `manager-login.html` and `admin.html` (keep the `"role"`).

## Run locally
Open the files in a browser, or serve the folder (sign-in needs `https://` or `localhost`):

```bash
python3 -m http.server 8000
```

Then visit http://localhost:8000/. The pages share data through the browser's `localStorage`, so
use the same browser and the same address for the admin and customer pages.

## Deploy to GitHub Pages
1. Push this repo to GitHub (the branch must be `main`).
2. In **Settings → Pages**, set **Source** to **GitHub Actions**.
3. Every push to `main` publishes the site (see `.github/workflows/pages.yml`). The site opens at `https://<your-username>.github.io/<repo-name>/`, which shows the landing page.
4. Use that same address for every page when testing, so the customer and admin pages share the same browser storage.

## Important: this is a prototype
Everything runs in the browser, so the logins and the admin permissions can be bypassed by someone technical,
and data lives only in the browser it was entered in. Before real use, build the backend described in `backend/README.md`
(Next.js + TypeScript + PostgreSQL, server-side authorization, validation and audit logs).

## Live chat with tawk.to
The chat button on `index.html` is already connected to tawk.to (property `6ace6a4b9964bd34cdd410f8`, widget `default`). If tawk.to can't load, it falls back to a built-in demo chat. To use a different tawk.to property:
1. Create a free property at tawk.to and open **Administration → Channels → Chat Widget**.
2. Copy the two IDs from the widget code: `https://embed.tawk.to/<PROPERTY_ID>/<WIDGET_ID>`.
3. In `index.html`, find `var TAWK={property:'...',widget:'...'}` and paste them in.

The page loads tawk.to, hides its default bubble, and your own "Need a hand?" button opens and closes the real chat. Leave both IDs empty to use only the demo chat.
Make sure your privacy policy and a cookie notice cover tawk.to, because it stores chat data and sets cookies.

## Notes
- The "Partners & sponsors" names on `index.html` are placeholders. Replace them with real partner logos.
- Photos in `assets/photos/` and the AI-generated faces in `assets/customer-*.jpg`: make sure you have the right to use them.
- Headings on `v1.html` use Glancyr Bold (`assets/fonts/`). Check its licence allows web and commercial use.
- The Bitcoin chart uses [TradingView Lightweight Charts](https://github.com/tradingview/lightweight-charts) and public price APIs. It shows sample data if none respond.

## Structure
```
index.html  v1.html  login.html  dashboard.html  manager-login.html  admin.html
assets/             logo, photos, fonts, avatars, card image
tools/              credentials helper
backend/            Postgres schema and backend plan
.github/workflows/  GitHub Pages deploy
```
