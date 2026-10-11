# Fion

A responsive crypto investment landing page with automatic dark/light mode, a TradingView candlestick chart, a floating support chat and a navy-and-purple glassmorphism look.

Plain HTML, CSS and JavaScript. No build step.

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

- **Chart:** uses [TradingView Lightweight Charts](https://github.com/tradingview/lightweight-charts) (loaded from jsDelivr) and tries live BTC/USDT hourly candles from Binance's public API. If the request fails, it shows generated sample candles and labels them "sample data".
- **Icons:** the security, fast and support icons load from icons8 and fall back to built-in SVGs if they can't load.
- **Support chat:** a front-end demo with automatic replies. Connect a real service (tawk.to, Intercom, etc.) in the script at the bottom of `index.html`.
- **Theme:** follows the system setting; the nav toggle overrides it and is remembered in `localStorage`.
- **Footer links** point to finometra.com as provided. Update them for your own site.
- **Customer photos** in `assets/` are AI-generated (thispersondoesnotexist.com). Replace them with real, consented customer photos before launch.

## Structure

```
index.html
assets/            logo and customer photos
.github/workflows/ GitHub Pages deploy
```
