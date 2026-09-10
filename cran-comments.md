## 2026-09-09

Resubmission after archival on 2026-02-19. CRAN tests failed because
example GeoJSON/TopoJSON were downloaded from the defunct rawgit.com
service (`test-geojson_mini.R`, `test-heatmaps.R`).

- Tests now read local fixtures and no longer need the internet.
- Remaining rawgit.com links in examples and docs now use
  raw.githubusercontent.com.
- Long example URLs in Rd files are wrapped under 100 characters.

This submission is from the previous CRAN maintainer of 2.0.1. 
Version 2.0.2 was published from a temporary fork after archival.

## Test environments
Local (Windows 11 x64 (build 26200) - R version 4.4.0 Patched)
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

`devtools::test()`: 992 passed, 0 failed

All checks on GHA use this setup:
    - {os: macos-latest,   r: 'release'}
    - {os: windows-latest, r: 'release'}
    - {os: ubuntu-latest,   r: 'devel', http-user-agent: 'release'}
    - {os: ubuntu-latest,   r: 'release'}
    - {os: ubuntu-latest,   r: 'oldrel-1'}

## Reverse dependencies
No new revdepcheck for this resubmission. The changes are confined
to tests, example URLs, and documentation.



## Test environments
Local (Windows 11 x64 (build 22631) - R version 4.4.0 Patched)
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

All checks on GHA are fine with this setup:
    - {os: macos-latest,   r: 'release'}
    - {os: windows-latest, r: 'release'}
    - {os: ubuntu-latest,   r: 'devel', http-user-agent: 'release'}
    - {os: ubuntu-latest,   r: 'release'}
    - {os: ubuntu-latest,   r: 'oldrel-1'}
