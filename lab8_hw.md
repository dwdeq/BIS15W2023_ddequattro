---
title: "Lab 8 Homework"
author: "Please Add Your Name Here"
date: "2023-02-09"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(here)
```

## Install `here`
The package `here` is a nice option for keeping directories clear when loading files. I will demonstrate below and let you decide if it is something you want to use.  

```r
#install.packages("here")
```

## Data
For this homework, we will use a data set compiled by the Office of Environment and Heritage in New South Whales, Australia. It contains the enterococci counts in water samples obtained from Sydney beaches as part of the Beachwatch Water Quality Program. Enterococci are bacteria common in the intestines of mammals; they are rarely present in clean water. So, enterococci values are a measurement of pollution. `cfu` stands for colony forming units and measures the number of viable bacteria in a sample [cfu](https://en.wikipedia.org/wiki/Colony-forming_unit).   

This homework loosely follows the tutorial of [R Ladies Sydney](https://rladiessydney.org/). If you get stuck, check it out!  

1. Start by loading the data `sydneybeaches`. Do some exploratory analysis to get an idea of the data structure.

```r
sydneybeaches <- read_csv(here("data","sydneybeaches.csv"))
```

```
## Rows: 3690 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (4): Region, Council, Site, Date
## dbl (4): BeachId, Longitude, Latitude, Enterococci (cfu/100ml)
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
sydneybeaches
```

```
## # A tibble: 3,690 × 8
##    BeachId Region                    Council Site  Longi…¹ Latit…² Date  Enter…³
##      <dbl> <chr>                     <chr>   <chr>   <dbl>   <dbl> <chr>   <dbl>
##  1      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 02/0…      19
##  2      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 06/0…       3
##  3      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 12/0…       2
##  4      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 18/0…      13
##  5      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 30/0…       8
##  6      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 05/0…       7
##  7      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 11/0…      11
##  8      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 23/0…      97
##  9      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 07/0…       3
## 10      25 Sydney City Ocean Beaches Randwi… Clov…    151.   -33.9 25/0…       0
## # … with 3,680 more rows, and abbreviated variable names ¹​Longitude, ²​Latitude,
## #   ³​`Enterococci (cfu/100ml)`
```

If you want to try `here`, first notice the output when you load the `here` library. It gives you information on the current working directory. You can then use it to easily and intuitively load files.

```r
library(here)
```

The quotes show the folder structure from the root directory.

```r
sydneybeaches <-read_csv(here("data", "sydneybeaches.csv")) %>% janitor::clean_names()
```

```
## Rows: 3690 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (4): Region, Council, Site, Date
## dbl (4): BeachId, Longitude, Latitude, Enterococci (cfu/100ml)
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

2. Are these data "tidy" per the definitions of the tidyverse? How do you know? Are they in wide or long format?

```r
glimpse(sydneybeaches)
```

```
## Rows: 3,690
## Columns: 8
## $ beach_id              <dbl> 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, …
## $ region                <chr> "Sydney City Ocean Beaches", "Sydney City Ocean …
## $ council               <chr> "Randwick Council", "Randwick Council", "Randwic…
## $ site                  <chr> "Clovelly Beach", "Clovelly Beach", "Clovelly Be…
## $ longitude             <dbl> 151.2675, 151.2675, 151.2675, 151.2675, 151.2675…
## $ latitude              <dbl> -33.91449, -33.91449, -33.91449, -33.91449, -33.…
## $ date                  <chr> "02/01/2013", "06/01/2013", "12/01/2013", "18/01…
## $ enterococci_cfu_100ml <dbl> 19, 3, 2, 13, 8, 7, 11, 97, 3, 0, 6, 0, 1, 8, 3,…
```
Yes, they are tidy, since each variable has its own column and each observation has its own row.

3. We are only interested in the variables site, date, and enterococci_cfu_100ml. Make a new object focused on these variables only. Name the object `sydneybeaches_long`

```r
sydneybeaches_long <- sydneybeaches %>% 
  select("site","date","enterococci_cfu_100ml")
sydneybeaches_long
```

```
## # A tibble: 3,690 × 3
##    site           date       enterococci_cfu_100ml
##    <chr>          <chr>                      <dbl>
##  1 Clovelly Beach 02/01/2013                    19
##  2 Clovelly Beach 06/01/2013                     3
##  3 Clovelly Beach 12/01/2013                     2
##  4 Clovelly Beach 18/01/2013                    13
##  5 Clovelly Beach 30/01/2013                     8
##  6 Clovelly Beach 05/02/2013                     7
##  7 Clovelly Beach 11/02/2013                    11
##  8 Clovelly Beach 23/02/2013                    97
##  9 Clovelly Beach 07/03/2013                     3
## 10 Clovelly Beach 25/03/2013                     0
## # … with 3,680 more rows
```


4. Pivot the data such that the dates are column names and each beach only appears once. Name the object `sydneybeaches_wide`

```r
sydneybeaches_wide <- sydneybeaches_long %>% 
  pivot_wider(names_from = site,
              values_from = enterococci_cfu_100ml)
sydneybeaches_wide
```

```
## # A tibble: 344 × 12
##    date  Clove…¹ Cooge…² Gordo…³ Littl…⁴ Malab…⁵ Marou…⁶ South…⁷ South…⁸ Bondi…⁹
##    <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 02/0…      19      15      NA       9       2       1       1      12       3
##  2 06/0…       3       4      NA       3       4       1       0       2       1
##  3 12/0…       2      17      NA      72     390      20      33     110       2
##  4 18/0…      13      18      NA       1      15       2       2      13       1
##  5 30/0…       8      22      NA      44      13      11      13     100       6
##  6 05/0…       7       2      NA       7      13       0       0     630       5
##  7 11/0…      11     110      NA     150     140       4      30      79     600
##  8 23/0…      97     630      NA     330     390      60      92     570      67
##  9 07/0…       3      11      NA      31       6       1      13      69       1
## 10 25/0…       0      82       4     420      28      33      17      37       0
## # … with 334 more rows, 2 more variables: `Bronte Beach` <dbl>,
## #   `Tamarama Beach` <dbl>, and abbreviated variable names ¹​`Clovelly Beach`,
## #   ²​`Coogee Beach`, ³​`Gordons Bay (East)`, ⁴​`Little Bay Beach`,
## #   ⁵​`Malabar Beach`, ⁶​`Maroubra Beach`, ⁷​`South Maroubra Beach`,
## #   ⁸​`South Maroubra Rockpool`, ⁹​`Bondi Beach`
```


5. Pivot the data back so that the dates are data and not column names.

```r
sydneybeaches_long_again <- sydneybeaches_wide %>% 
  pivot_longer(cols = `Clovelly Beach`:`Tamarama Beach`,
               names_to = "beach",
               values_to = "bacteria_mL") %>% 
  arrange(beach)
sydneybeaches_long_again
```

```
## # A tibble: 3,784 × 3
##    date       beach       bacteria_mL
##    <chr>      <chr>             <dbl>
##  1 02/01/2013 Bondi Beach           3
##  2 06/01/2013 Bondi Beach           1
##  3 12/01/2013 Bondi Beach           2
##  4 18/01/2013 Bondi Beach           1
##  5 30/01/2013 Bondi Beach           6
##  6 05/02/2013 Bondi Beach           5
##  7 11/02/2013 Bondi Beach         600
##  8 23/02/2013 Bondi Beach          67
##  9 07/03/2013 Bondi Beach           1
## 10 25/03/2013 Bondi Beach           0
## # … with 3,774 more rows
```


6. We haven't dealt much with dates yet, but separate the date into columns day, month, and year. Do this on the `sydneybeaches_long` data.

```r
sydney <- sydneybeaches_long_again
```


```r
sydney <- sydney %>% separate(date, into = c("day","month","year"))
```

7. What is the average `enterococci_cfu_100ml` by year for each beach. Think about which data you will use- long or wide.

```r
sydney_x <- sydney %>% 
  group_by(year) %>% 
  summarize(avg_bacteria = mean(bacteria_mL,na.rm=T))
```


8. Make the output from question 7 easier to read by pivoting it to wide format.

```r
sydney_x %>% 
  pivot_wider(names_from = "year",
              values_from = "avg_bacteria")
```

```
## # A tibble: 1 × 6
##   `2013` `2014` `2015` `2016` `2017` `2018`
##    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1   50.6   26.3   31.2   42.2   20.7   33.1
```


9. What was the most polluted beach in 2018?

```r
sydney %>% 
  filter(year == 2018) %>% 
  slice_max(bacteria_mL) %>% 
  select(beach)
```

```
## # A tibble: 1 × 1
##   beach           
##   <chr>           
## 1 Little Bay Beach
```


10. Please complete the class project survey at: [BIS 15L Group Project](https://forms.gle/H2j69Z3ZtbLH3efW6)


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
