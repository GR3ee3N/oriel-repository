#!/bin/bash
# tools/pages.sh
# Puts the latest published release's repository add-on on the install page.
# GitHub Pages serves the pages branch, which holds only index.html and that
# zip as repository.oriel.zip: Kodi's file browser lists only files next to
# the page. Run it after publishing a release.
set -euo pipefail
REPO=$(cd "$(dirname "$0")/.." && pwd)
cd "$REPO"
export GH_REPO=GR3ee3N/oriel-repository
PAGES=.cache/pages
rm -rf "$PAGES"
mkdir -p "$PAGES"
gh release download --pattern 'repository.oriel-*.zip' --dir "$PAGES"
ZIP=$(cd "$PAGES" && echo repository.oriel-*.zip)
mv "$PAGES/$ZIP" "$PAGES/repository.oriel.zip"
git show HEAD:index.html > "$PAGES/index.html"
# The branch only ever holds what the page serves, so it is replaced each time.
git -C "$PAGES" init -q -b pages
git -C "$PAGES" add .
git -C "$PAGES" -c user.name="$(git config user.name)" -c user.email="$(git config user.email)" \
    commit -qm "Install page with ${ZIP%.zip}"
git -C "$PAGES" push -qf "$(git remote get-url origin)" pages
echo "The install page now serves ${ZIP%.zip}."
