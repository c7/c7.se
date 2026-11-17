#!/bin/sh
# Switch the body font between the free alternatives to FF Tisa.
# Each font's metric-adjusted fallback @font-face lives in sass/main.scss.
set -eu

cd "$(dirname "$0")"

base_size='16px'
line_height='1.428'
heading_scale='1.0'

case "${1:-}" in
  faustina)
    family='Faustina'
    weight='400'
    code_size='0.89'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=Faustina:ital,wght@0,400;0,700;1,400;1,700&display=swap'
    credit='Faustina <https://fonts.google.com/specimen/Faustina>'
    ;;
  source-serif-4)
    family='Source Serif 4'
    weight='400'
    code_size='0.86'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,wght@0,400;0,700;1,400;1,700&display=swap'
    credit='Source Serif 4 <https://fonts.google.com/specimen/Source+Serif+4>'
    ;;
  pt-serif)
    family='PT Serif'
    weight='400'
    code_size='0.90'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&display=swap'
    credit='PT Serif <https://fonts.google.com/specimen/PT+Serif>'
    ;;
  bitter)
    family='Bitter'
    weight='500'
    code_size='0.95'
    base_size='15px'
    heading_scale='1.0667'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=Bitter:ital,wght@0,400;0,500;0,700;1,400;1,500;1,700&display=swap'
    credit='Bitter <https://fonts.google.com/specimen/Bitter>'
    ;;
  charis-sil)
    family='Charis SIL'
    weight='400'
    code_size='0.87'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=Charis+SIL:ital,wght@0,400;0,700;1,400;1,700&display=swap'
    credit='Charis SIL <https://fonts.google.com/specimen/Charis+SIL>'
    ;;
  inter)
    family='Inter'
    weight='400'
    code_size='0.98'
    stack='Helvetica,Arial,sans-serif'
    href='https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap'
    credit='Inter <https://fonts.google.com/specimen/Inter>'
    ;;
  lora)
    family='Lora'
    weight='400'
    code_size='0.90'
    stack='Georgia,Cambria,serif'
    href='https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,700;1,400;1,700&display=swap'
    credit='Lora <https://fonts.google.com/specimen/Lora>'
    ;;
  *)
    echo "Usage: $0 {faustina|source-serif-4|pt-serif|bitter|charis-sil|inter|lora}" >&2
    exit 2
    ;;
esac

# Replace only the line inside the body-font markers.
awk -v link="    <link href=\"$href\" rel=\"stylesheet\">" '
  /<!-- body-font:start -->/ { print; getline; print link; inside = 1; next }
  inside && /<!-- body-font:end -->/   { print; inside = 0; next }
  inside { next }
  { print }
' layouts/partials/header.html > layouts/partials/header.html.switch-font.tmp
cat layouts/partials/header.html.switch-font.tmp > layouts/partials/header.html
rm layouts/partials/header.html.switch-font.tmp

replace_containing() {
  file=$1 needle=$2 replacement=$3
  awk -v needle="$needle" -v replacement="$replacement" '
    index($0, needle) { print replacement; next }
    { print }
  ' "$file" > "$file.switch-font.tmp"
  cat "$file.switch-font.tmp" > "$file"
  rm "$file.switch-font.tmp"
}

# main.scss: point .container at the chosen font and its own fallback face,
# and size inline code to visually match that body font's x-height.
awk -v family="$family" -v weight="$weight" -v stack="$stack" -v code_size="$code_size" '
  /^\.container \{/ { in_container = 1 }
  in_container && /^  font-family: / {
    print "  font-family: \"" family "\", \"" family " Fallback\"," stack ";"
    weight_line = 1
    next
  }
  in_container && weight_line && /^  font-weight: / {
    print "  font-weight: " weight ";"
    weight_line = 0
    in_container = 0
    next
  }
  /^code \{/ { in_code = 1 }
  in_code && /^  font-size: [0-9.]+em;$/ {
    print "  font-size: " code_size "em;"
    in_code = 0
    next
  }
  { print }
' sass/main.scss > sass/main.scss.switch-font.tmp
cat sass/main.scss.switch-font.tmp > sass/main.scss
rm sass/main.scss.switch-font.tmp

replace_containing sass/main.scss \
  '--font-size-default:' \
  "  --font-size-default: $base_size;"

replace_containing sass/main.scss \
  '--body-line-height:' \
  "  --body-line-height: $line_height;"

replace_containing sass/main.scss \
  '--heading-scale:' \
  "  --heading-scale: $heading_scale;"

replace_containing static/humans.txt \
  '  Fonts:' \
  "  Fonts:        $credit"

# Rebuild the committed stylesheet from Sass.
make css

echo "Body font switched to $family (weight $weight, code $code_size em)"
