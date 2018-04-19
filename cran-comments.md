# Comments

## 2018-4-19
This submission is in conjunction with the `leaflet` package submission.

This submission is done by Barret Schloerke <barret@rstudio.com> on behalf of Bhaskar Karambelkar <bhaskarvk@gmail.com>. Please submit any changes to be made to <barret@rstudio.com>.

- Barret


## Test environments
* local OS X install, R 3.4.0
  * * 0 errors | 0 warnings | 0 note
* ubuntu 12.04 (on travis-ci), R version 3.4.4 (2017-01-27)
  * 0 errors | 0 warnings | 0 note

I believe the warning and note below are transient within r-hub.
  * NOTE: checking examples:
    * The examples are taking a longer time only on windows and hardly any time is user or system.
  * NOTE: Unknown, possibly mis-spelled, fields in DESCRIPTION
    * This field has been removed for submission.
    * Was needed to test with rhub directly as the development branch of leaflet was required.


* Platform:   Windows Server 2008 R2 SP1, R-release, 32/64 bit
  https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-5767ab94b0ec4ad68438e925e28e774b
  ❯ checking CRAN incoming feasibility ... NOTE
    Maintainer: 'Bhaskar Karambelkar <bhaskarvk@gmail.com>'

    Unknown, possibly mis-spelled, fields in DESCRIPTION:
      'Remotes'

  ❯ checking examples ... NOTE
    Examples with CPU or elapsed time > 5s
                 user system elapsed
    omnivore     2.67   1.03   14.25
    utils        3.19   0.19    7.36
    measure-path 0.36   0.17    7.78

  0 errors ✔ | 0 warnings ✔ | 2 notes ✖

* Platform:   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-d8ad025e0d6042e7aff97a704e5bf702
  ❯ checking CRAN incoming feasibility ... NOTE
    Maintainer: 'Bhaskar Karambelkar <bhaskarvk@gmail.com>'

    Unknown, possibly mis-spelled, fields in DESCRIPTION:
      'Remotes'

  ❯ checking examples ... NOTE
    Examples with CPU or elapsed time > 5s
                 user system elapsed
    measure-path 0.33   0.19    9.45

  0 errors ✔ | 0 warnings ✔ | 2 notes ✖

* Platform:   Ubuntu Linux 16.04 LTS, R-release, GCC
  * https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-938402b710e94a02a4f34d4c9a24e93c
  ❯ checking CRAN incoming feasibility ... NOTE
    Maintainer: ‘Bhaskar Karambelkar <bhaskarvk@gmail.com>’

    Unknown, possibly mis-spelled, fields in DESCRIPTION:
      ‘Remotes’

  0 errors ✔ | 0 warnings ✔ | 1 note ✖

* Platform:   Fedora Linux, R-devel, clang, gfortran
  https://builder.r-hub.io/status/leaflet.extras_1.0.0.tar.gz-4fad0f4175e44eba8368c6887a50ac60
  ❯ checking CRAN incoming feasibility ... NOTE
    Maintainer: ‘Bhaskar Karambelkar <bhaskarvk@gmail.com>’

    Unknown, possibly mis-spelled, fields in DESCRIPTION:
      ‘Remotes’

  0 errors ✔ | 0 warnings ✔ | 1 note ✖



## Reverse dependencies

* All revdep maintainers were notified on March 29, 2018 for a release date of April 16th.

* I have run R CMD check on the 60 downstream dependencies.
  * https://github.com/bhaskarvk/leaflet.extras/blob/master/revdep/problems.md

* No errors, warnings, or notes were introduced due to changes in leaflet.extras
