#!/bin/bash
# Generates a redirect page at /<slug>/ for every line in links.tsv.
set -euo pipefail
cd "$(dirname "$0")"
grep -vE '^\s*(#|$)' links.tsv | while IFS=$'\t' read -r slug url label; do
  label="${label:-page}"
  mkdir -p "$slug"
  cat > "$slug/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<meta http-equiv="refresh" content="2; url=$url">
<link rel="canonical" href="$url">
<title>Redirecting you to the $label...</title>
<style>
  :root { --bg: #fafafa; --fg: #222; --muted: #666; --link: #2557d6; }
  @media (prefers-color-scheme: dark) { :root { --bg: #161616; --fg: #eee; --muted: #aaa; --link: #8ab4ff; } }
  body { margin: 0; min-height: 100vh; display: grid; place-items: center; padding: 16px; box-sizing: border-box;
         background: var(--bg); color: var(--fg); font-family: system-ui, -apple-system, sans-serif; text-align: center; }
  h1 { font-size: 1.4rem; font-weight: 600; margin: 0 0 .5rem; }
  p { color: var(--muted); margin: 0; }
  a { color: var(--link); }
</style>
<script>setTimeout(function () { location.replace("$url"); }, 1000);</script>
</head>
<body>
  <main>
    <h1>Redirecting you to the $label, please hold...</h1>
    <p>Not redirected? <a href="$url">Click here to open the $label</a>.</p>
  </main>
</body>
</html>
HTML
  echo "/$slug -> $url"
done
