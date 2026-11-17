# Sonic Frameworks CMake Modules Release Notes

Sonic Frameworks CMake Modules is the shared build toolkit that puts SonicDE's programs and files in the right places on your system.

## Unreleased

- SonicDE now builds on systems that also have parts of Qt 5 installed, such as FreeBSD and GhostBSD: the build toolkit only ever looks for Qt 6.
- When SonicDE is built from source, each part now uses the SonicDE interface components built alongside it, instead of KDE's copies installed on the system, and the build works on systems without KDE.

## 6.31.0 (2026-10-20)

- On Arch Linux-based distributions, SonicDE's helper programs now install to the location those systems expect.

## 6.30.0 (2026-09-12)

No SonicDE-specific changes in this release; it brings the package up to date with upstream.

## 6.29.0 (2026-08-07)

No SonicDE-specific changes in this release; it brings the package up to date with upstream.

## 6.28.0.1 (2026-08-02)

- Behind the scenes: made the code formatting tool more robust and added a test for it, and made Python add-on builds find the modules they need more reliably.

## 6.28.0 (2026-07-14)

- Behind the scenes: restored the code formatting settings and added support for developers' code-navigation tools.

## 6.27.0.1 (2026-06-22)

- Arch Linux-based distributions are now recognized more reliably, so SonicDE installs its files in the right places there.
