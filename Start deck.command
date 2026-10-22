#!/bin/zsh
# Double-click to present: starts Grid (port 3100) and the deck server (port 3101), then opens the deck.
# Embedded websites only work when the deck is served over http, not opened as a file.
DECK="$(cd "$(dirname "$0")" && pwd)"
GRID="$HOME/steep/grid"
mkdir -p "$DECK/deck"

if ! curl -s -o /dev/null http://127.0.0.1:3100/; then
  echo "Starting Grid (next dev) on :3100 …"
  (cd "$GRID" && nohup npm run dev > "$DECK/deck/grid-dev.log" 2>&1 &)
fi
if ! curl -s -o /dev/null http://127.0.0.1:3101/index.html; then
  echo "Starting deck server on :3101 …"
  (nohup python3 -m http.server 3101 --bind 127.0.0.1 --directory "$DECK" > "$DECK/deck/deck-server.log" 2>&1 &)
fi

for i in {1..40}; do curl -s -o /dev/null http://127.0.0.1:3100/ && curl -s -o /dev/null http://127.0.0.1:3101/index.html && break; sleep 0.5; done
open "http://127.0.0.1:3101/index.html"
echo "Deck: http://127.0.0.1:3101/index.html   Grid: http://127.0.0.1:3100/"
