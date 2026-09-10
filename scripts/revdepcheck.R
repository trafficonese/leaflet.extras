# usethis::use_revdep()
# usethis::use_version()

# devtools::install_github('r-lib/revdepcheck')
library(revdepcheck)

revdep_check(num_workers = 4)
beepr::beep(4)
revdep_report(pkg = ".", all = TRUE)
# revdep_report_summary()

#' During execution, run these in a separate R process to view status completed checks:
# revdep_summary()                 # table of results by package
# revdep_details(".", "pdxTrees") # full details for the specified package








# Manage a “todo” list of packages to examine:
# revdep_add(pkg = ".", <packages>)  # add <packages> to the list
# revdep_rm(pkg = ".", <packages>).  # remove <packages> from list
# revdep_add_broken()  # add all broken packages
# revdep_add_new()     # add newly available packages
# revdep_todo()        # list packages in the todo list

# Clear out all previous results
# revdep_reset()
