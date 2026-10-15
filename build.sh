#!/bin/bash
# Generates a redirect page at /<slug>/ for every line in links.tsv.
set -euo pipefail
cd "$(dirname "$0")"
grep -vE '^\s*(#|$)' links.tsv | while IFS=$'\t' read -r slug url; do
  mkdir -p "$slug"
  cat > "$slug/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="robots" content="noindex">
<meta http-equiv="refresh" content="0; url=$url">
<link rel="canonical" href="$url">
<title>Redirecting...</title>
<script>location.replace("$url");</script>
</head>
<body><p>Redirecting to <a href="$url">$url</a>...</p></body>
</html>
HTML
  echo "/$slug -> $url"
done
