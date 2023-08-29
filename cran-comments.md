## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Chanyub Park <mrchypark@gmail.com>'
  
  New submission

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [3s/10s] NOTE
  Maintainer: ‘Chanyub Park <mrchypark@gmail.com>’
  
  New submission

0 errors ✔ | 0 warnings ✔ | 4 notes ✖

## Notes comments

Run `urlchecker::url_update()` and all fix done.

The two notes appear to be because it is a new submission. lastMiKTeXException is a known bug of the rhub check, and the note on ubuntu was confirmed to be due to the host system's settings. 
