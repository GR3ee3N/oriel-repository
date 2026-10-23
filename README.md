# Oriel repository

The Kodi install source for [Oriel](https://github.com/GR3ee3N/Oriel). The
repository add-on installs and updates Oriel and its dependencies,
[Oriel framework](https://github.com/GR3ee3N/oriel-framework),
[Oriel WebKit](https://github.com/GR3ee3N/oriel-webkit) and
[Oriel display](https://github.com/GR3ee3N/oriel-display), from their latest
GitHub releases.

## Status

> [!WARNING]
> **Experimental software.** CoreELEC or Kodi updates can break it.

No support is provided.

## Hardware

Requires an Amlogic device with a Mali GPU running CoreELEC 22
(Kodi 22, 64-bit). Tested on:

- Ugoos AM9 Pro (S905X5M, Mali-G310)
- Ugoos AM6B+ (S922X, Mali-G52)

Other devices and CoreELEC versions have not been tested.

## Installation

1. In Kodi, enable **Settings → System → Add-ons → Unknown sources**.
2. Go to **Settings → File manager → Add source**, enter
   `https://gr3ee3n.github.io/oriel-repository/` and name it **Oriel**.
3. Go to **Add-ons → Install from zip file → Oriel** and select
   `repository.oriel.zip`.
4. Go to **Add-ons → Install from repository → Oriel repository → Video add-ons**,
   select **Oriel**, then **Install**. Kodi also installs its dependencies.
