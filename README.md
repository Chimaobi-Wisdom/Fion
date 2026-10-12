# Fion

A responsive landing page for a simulated money-management experience: account overview, payments, savings vaults, a help centre and a guided support chat. It has automatic dark/light mode and a navy-and-purple glassmorphism look.

Plain HTML, CSS and JavaScript. No build step.

## Two designs

- `index.html` is the original navy-and-purple design.
- `v2.html` (version 2.1) is the second design (liquid-glass red and deep purple, Sora and Inter fonts). On GitHub Pages it is at `/v2.html`.

- `login.html` is the mobile-first login screen. "Online Banking", "Get Started" and "Customer sign in" link to it. It is a simulated sign-in with no backend.

- `manager-login.html` is the manager login screen, linked from the footer ("Manager Login"). Both login pages show a 1-second preloader and use a split-screen layout on desktop. Sign-in is simulated with no backend. Passwords must be at least 8 characters.
- **Partners & sponsors** logos on `v2.html` are placeholder names. Replace them with real partner logos.

## Run locally

Open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000
```

Then visit http://localhost:8000.

## Deploy to GitHub Pages

1. Push this repo to GitHub.
2. In **Settings → Pages**, set **Source** to **GitHub Actions**.
3. Every push to `main` publishes the site (see `.github/workflows/pages.yml`).

## Notes

- **Chart:** the Live market overview uses [TradingView Lightweight Charts](https://github.com/tradingview/lightweight-charts) (jsDelivr) with live BTC/USD hourly candles, trying Binance, then Coinbase, then Kraken public APIs. If none respond it shows generated sample candles and marks them "sample data".
- **Font:** headings use Glancyr Bold (`assets/fonts/`). Check the font's licence allows web and commercial use before publishing.
- **Content:** all balances, transfers and savings figures are simulated. The footer fine print says so. Keep it if you publish the page.
- **Icons:** the security and help icons load from icons8 and fall back to built-in SVGs if they can't load.
- **Support chat:** a front-end demo with guided answers from the help-centre FAQ and an automated reply. Connect a real service in the script at the bottom of `index.html` if you need live support.
- **Theme:** follows the system setting; the nav toggle overrides it and is remembered in `localStorage`.
- **Footer links:** most are placeholders (`#`) or in-page anchors. Point them at real pages when they exist.
- **Photos:** `assets/photos/` holds the three stock-style photos used on `v2.html`. Make sure you have the right to use them before publishing.
- **Customer photos** in `assets/` are AI-generated (thispersondoesnotexist.com). Replace them with real, consented photos if you present them as customers.

## Structure

```
index.html
v2.html
login.html
manager-login.html
assets/            logo, fonts, photos and customer avatars
.github/workflows/ GitHub Pages deploy
```
