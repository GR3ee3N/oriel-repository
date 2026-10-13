#!/bin/bash
# tools/release.sh "Release notes"
# Packages the version in addon.xml and uploads it as a draft release;
# publishing it on GitHub releases it. Kodi then updates the repository add-on
# from the latest release's addons.xml.
set -euo pipefail
REPO=$(cd "$(dirname "$0")/.." && pwd)
cd "$REPO"
[[ $# = 1 && -n $1 ]] || { echo 'usage: tools/release.sh "Release notes"' >&2; exit 2; }
export GH_REPO=GR3ee3N/oriel-repository
VERSION=$(python3 -c 'import xml.etree.ElementTree as E; print(E.parse("addon.xml").getroot().get("version"))')
TAG=v$VERSION
COMMIT=$(git rev-parse HEAD)
[[ -z $(git status --porcelain) ]] || { echo "commit first; the tree is not clean" >&2; exit 2; }
git fetch -q origin "refs/tags/$TAG:refs/tags/$TAG" 2>/dev/null || true
RELEASE=$(gh release view "$TAG" --json isDraft -q .isDraft 2>/dev/null || true)
if [[ $RELEASE = true ]]; then
    # Not published yet: the draft and its tag are replaced, also from a newer commit.
    gh release delete "$TAG" --yes --cleanup-tag
    if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then git tag -d "$TAG" >/dev/null; fi
fi
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && [[ $(git rev-parse "$TAG^{commit}") != "$COMMIT" ]]; then
    echo "$TAG was released from another commit; bump the version in addon.xml" >&2
    exit 2
fi
[[ $RELEASE != false ]] || { echo "$TAG is already released"; exit; }

rm -rf .cache/release
python3 build/release.py .cache/release/files

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null || git tag -a "$TAG" -m "$1" "$COMMIT"
git push -q origin "$TAG"
gh release create "$TAG" --draft --verify-tag --title "Oriel repository $VERSION" --notes "$1" .cache/release/files/*
echo "Drafted $TAG; publish it on GitHub to release it, then run tools/pages.sh."
