## 2024-6-10

- I will be the new maintainer
- I updated most JavaScript dependencies, added new features and fixed some bugs

## Test environments
Local (Windows 11 x64 (build 22631) - R version 4.4.0 Patched)
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

All checks on GHA are fine with this setup:
    - {os: macos-latest,   r: 'release'}
    - {os: windows-latest, r: 'release'}
    - {os: ubuntu-latest,   r: 'devel', http-user-agent: 'release'}
    - {os: ubuntu-latest,   r: 'release'}
    - {os: ubuntu-latest,   r: 'oldrel-1'}
    
## revdepcheck results
We checked 17 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.
 * We saw 0 new problems
 * We failed to check 0 packages


# Comments

## 2018-4-21
Resubmitting with leaflet added to cran.  Updated test environments below.

Thank you for you patience!

- Barret


## 2018-4-20
leafet accpeted
- CRAN

## 2018-4-20
...submit leaflet first...
- Uwe

## 2018-4-20
This submission is in conjunction with the `leaflet` package submission.

This submission is done by Barret Schloerke <barret@rstudio.com> on behalf of Bhaskar Karambelkar <bhaskarvk@gmail.com>. Please submit any changes to be made to <barret@rstudio.com>.

- Barret


## Test environments
* local OS X install, R 3.4.0
  * * 0 errors | 0 warnings | 0 note
* ubuntu 12.04 (on travis-ci), R version 3.4.4 (2017-01-27)
  * 0 errors | 0 warnings | 0 note
* devtools::build_win() x86_64-w64-mingw32, R version 3.4.4 (2018-03-15)
  * 0 errors | 0 warnings | 0 notes

* rhub
  * Platform:   Windows Server 2008 R2 SP1, R-release, 32/64 bit
    https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-d26059cae2d5494ba0a12bc7733ad893
    0 errors ✔ | 0 warnings ✔ | 0 notes ✔

  * Platform:   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
    https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-01fadce20eef49c89de7c52d77f9a3b1
    0 errors ✔ | 0 warnings ✔ | 0 notes ✔

  * Platform:   Ubuntu Linux 16.04 LTS, R-release, GCC
    https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-1e183a3a665648a28b434aa936f75121
    0 errors ✔ | 0 warnings ✔ | 0 notes ✔

  * Platform:   Fedora Linux, R-devel, clang, gfortran
    https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-3919eac30a1d4f0bb9d60d18c627e582
    0 errors ✔ | 0 warnings ✔ | 0 notes ✔



## Reverse dependencies

* All revdep maintainers were notified on March 29, 2018 for a release date of April 16th.

* I have run R CMD check on the 3 downstream dependencies.
  * https://github.com/bhaskarvk/leaflet.extras/blob/master/revdep/problems.md

* No errors, warnings, or notes were introduced due to changes in leaflet.extras
