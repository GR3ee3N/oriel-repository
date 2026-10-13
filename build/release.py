#!/usr/bin/env python3
"""Packages the repository add-on: its zip, and Kodi's addons.xml listing it
so that Kodi updates the repository add-on like any other, with sha256 files
for both.

    build/release.py <files dir>
"""
import hashlib
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
import zipfile

REPO = Path(__file__).resolve().parent.parent


def main():
    files = Path(sys.argv[1])
    text = (REPO / "addon.xml").read_text()
    element = ET.fromstring(text)
    addon_id = element.get("id")
    zip_name = f"{addon_id}-{element.get('version')}.zip"
    files.mkdir(parents=True)
    with zipfile.ZipFile(files / zip_name, "w", zipfile.ZIP_DEFLATED) as archive:
        archive.mkdir(addon_id)
        archive.writestr(f"{addon_id}/addon.xml", text)
    metadata = element.find('extension[@point="xbmc.addon.metadata"]')
    # A release has no folders: Kodi finds the zip by this path, next to addons.xml.
    ET.SubElement(metadata, "path").text = zip_name
    addons = ET.Element("addons")
    addons.append(element)
    ET.indent(addons)
    ET.ElementTree(addons).write(files / "addons.xml", encoding="UTF-8", xml_declaration=True)
    for name in (zip_name, "addons.xml"):
        digest = hashlib.sha256((files / name).read_bytes()).hexdigest()
        (files / f"{name}.sha256").write_text(f"{digest}  {name}\n")


if __name__ == "__main__":
    main()
