#!/usr/bin/env bash
# Build the shiro-hd cursor theme (cursors/ stow package) from the 32 px-only
# shiro theme, which win2xcur converted from the Windows 白マウスカーソル set, by adding
# nearest-neighbour upscaled 48 px and 64 px images (keeps pixel art crisp and
# keeps every animation frame, hotspot and delay). The original theme is untouched.
# Needs xcur2png (AUR), xcursorgen (xorg-xcursorgen) and ImageMagick.
set -euo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
src="$repo/cursors/.local/share/icons/shiro"
dst="$repo/cursors/.local/share/icons/shiro-hd"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

rm -rf "$dst"
mkdir -p "$dst/cursors"
printf '[Icon Theme]\nName=shiro-hd\nComment=shiro cursors upscaled to 32/48/64 px\n' > "$dst/index.theme"

for f in "$src"/cursors/*; do
  name=$(basename "$f")
  [ -L "$f" ] && continue                      # links are recreated below
  if [ "$(head -c 4 "$f")" != "Xcur" ]; then    # e.g. a stray index.theme: copy as-is
    cp -p "$f" "$dst/cursors/$name"; continue
  fi
  d="$work/$name"; mkdir -p "$d"
  xcur2png -d "$d" -c "$d/orig.conf" "$f" >/dev/null
  : > "$d/all.conf"
  # orig.conf lines: size xhot yhot png delay (first line is a comment)
  grep -v '^#' "$d/orig.conf" | while read -r size xh yh png delay; do
    for target in 32 48 64; do
      if [ "$target" -eq "$size" ]; then
        out="$png"
      else
        out="${png%.png}_${target}.png"
        magick "$png" -filter point -resize "${target}x${target}" "$out"
      fi
      # scale the hotspot with the image (integer division, stays inside the image)
      sx=$(( xh * target / size )); sy=$(( yh * target / size ))
      echo "$target $sx $sy $out ${delay:-0}" >> "$d/all.conf"
    done
  done
  xcursorgen "$d/all.conf" "$dst/cursors/$name"
done

# recreate the symlinks exactly as in the source theme
for f in "$src"/cursors/*; do
  [ -L "$f" ] && ln -sfn "$(readlink "$f")" "$dst/cursors/$(basename "$f")"
done
echo "built $dst: $(find "$dst/cursors" -type f | wc -l) files, $(find "$dst/cursors" -type l | wc -l) links"
