---
title: "Weekly OSM: updates of OSMstats data"
date: 2021-11-02
slug: weekly-osm-updates-osmstats-data
categories: [OpenStreetMap]
tags: [github actions, web scraping]
source: 02-weekly-osm-actualizaciones-datos-osmstats.md
summary: "Recently the OSMstats site achieved ten years worth of data; to celebrate it (and to apply new methods I've learned) I am currently developing a repository that gathers that data on a weekly basis, and uses it to update its own database."
---

When I started this blog, I decided to do so by sharing my first data analysis
project: obtaining information about OpenStreetMap (OSM) by means of *web scraping*
in the [OSMstats](https://osmstats.neis-one.org) website, developed by
[Pascal Neis](https://neis-one.org/about). Since then ---while learning more
about R and how to properly code--- I've discovered new methods that would
allow me to replicate that project, but in a more concise and reproducible manner.

That's why I am currently developing a GitHub repository with this purpose: to maintain
a database of summarized information from OSMstats. Data would be obtained every week and
would show the activity that has happened in all available countries. Before explaining
what is the procedure, I must mention that OpenStreetMap ---as well as anything derived
from it--- is *open data*, is a property of its contributors (© OpenStreetMap contributors),
and possesses an [ODC Open Database License](https://www.openstreetmap.org/copyright). The
database I will generate will therefore have the same license.

In a nutshell, the procedure I am doing is:

1. Create the repository in GitHub and `git clone` it
2. Transform it to a RStudio project, with a `renv` private environment
3. Program :smirk_cat:
4. Create the database, with data since the beginning of OSMstats until today
5. Update the repository and the database via `git push`
6. Create the mechanism for the repository to update itself onward

Regarding the first step, the repository [Weekly OSM](https://github.com/ruevko/weekly-osm) is
already online; I chose that name to signify the fact that it will be updated once per week.
Such frequency has two advantages: to reduce the granularity of the observations, and to maintain
a *cache* ---the service GitHub Actions keeps them one week at most--- of required packages.

After cloning the repository, the second step was to launch RStudio and associate the `Weekly-OSM`
directory with a new project. Once this was done, the first commands I executed in the project were:

```
install.packages("renv")
renv::init(bare = TRUE)
```

The purpose of [`renv`](https://rstudio.github.io/renv) is to generate a reproducible
working environment. What this means is that, during development, my project will have
its own R packages library, isolated from other projects that I may develop in the same
computer. It also means that I can easily reproduce this library in another computer,
which is crucial, since it will allow the execution of *scripts* from the project as
part of a GitHub Actions *workflow*.

The third step is, precisely, to write those *scripts*. In this post I
will not delve into how does Weekly OSM function; that information is in the
[README](https://github.com/ruevko/Weekly-OSM/blob/main/readme.md) and each of the
*scripts*, which are thoroughly commented. However I will mention that, after programming,
one should run `renv::snapshot()` to write `renv.lock`, a file registering all the packages
that have been used ---`dplyr` and `rvest` in my case--- and their dependencies too. The
registries it writes look like this:

```
    "magrittr": {
      "Package": "magrittr",
      "Version": "2.0.1",
      "Source": "Repository",
      "Repository": "CRAN",
      "Hash": "41287f1ac7d28a92f0a286ed507928d3"
    }
```

To accomplish the fourth step I wrote the [`main_yearly.R`](https://github.com/ruevko/Weekly-OSM/blob/main/R/main_yearly.R) *script*;
when executed, it obtains from OSMstats all the observations of certain year, i.e. of
every date and every country that had activity during those dates. Then it computes a
weekly summary of the observations ---applying functions such as `sum()` and `max()`---
and writes the results to `.csv` files; hence, there will be 52 o 53 files per year. Once
that I ran the *script* for each year from 2011 to 2021, I added all those files to the
online repository, and so I accomplished the fifth step.

Finally, the sixth step consisted in writing
[`main.yaml`](https://github.com/ruevko/Weekly-OSM/blob/main/.github/workflows/main.yaml),
a *workflow* that will run every Monday at 03:13 UTC approximately, through GitHub Actions.
I won't talk about *workflow* syntax, but I do want to show some of the steps; for instance,
the one below serves to create a *cache* with installed packages. While the first *workflow*
run took several minutes, thanks to the *cache* subsequent runs were completed in less than
a minute. Furthermore, as long as `renv.lock` doesn't change, the *cache* will remain valid.

```
    # create/restore cache
    - name: Cache packages
      uses: actions/cache@v2
      with:
        path: ${{ env.RENV_PATHS_ROOT }}
        key: renv-${{ hashFiles('renv.lock') }}
```

In the next step the `renv::restore()` function is executed, and it performs
the installation (or, if a *cache* already exists, the restoration) of the
packages registered in `renv.lock`. And the last step I show here executes
[`main.R`](https://github.com/ruevko/Weekly-OSM/blob/main/R/main.R), a *script*
containing all the operations that need to be done every week in the repository.

```
    # install/restore packages
    - name: Restore packages
      run: Rscript -e 'renv::restore()'
    # source main script
    - name: Obtain weekly data
      run: Rscript R/main.R
```

That's about everything I can say regarding Weekly OSM up to now. Since I added `main.yaml`
the database has correctly been updated; now I just need to keep in mind that the *workflow*
must be renewed every now and then, because otherwise GitHub Actions will disable it :joy_cat:.
This post will have a continuation, where I will demonstrate how to utilize the database.
