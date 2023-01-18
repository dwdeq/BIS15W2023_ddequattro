---
title: "Lab 3 Homework"
author: "Dominic \"DQ\" De Quattro"
date: "2023-01-17"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---

## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the tidyverse

```r
library(tidyverse)
```

## Mammals Sleep
1. For this assignment, we are going to use built-in data on mammal sleep patterns. From which publication are these data taken from? Since the data are built-in you can use the help function in R.

```r
import <- readr::read_csv("mammals_sleep_allison_cicchetti_1976.csv")
```

```
## Rows: 62 Columns: 11
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (1): species
## dbl (10): body weight in kg, brain weight in g, slow wave ("nondreaming") sl...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

2. Store these data into a new data frame `sleep`.

```r
sleep <- import
```

3. What are the dimensions of this data frame (variables and observations)? How do you know? Please show the *code* that you used to determine this below.  

```r
dim(sleep)
```

```
## [1] 62 11
```
62 rows and 11 columns


4. Are there any NAs in the data? How did you determine this? Please show your code.  

```r
colMeans(sleep[,2:11])
```

```
##                                               body weight in kg 
##                                                      198.789984 
##                                               brain weight in g 
##                                                      283.134194 
##                       slow wave ("nondreaming") sleep (hrs/day) 
##                                                     -218.866129 
##                        paradoxical ("dreaming") sleep (hrs/day) 
##                                                     -191.764516 
## total sleep (hrs/day)  (sum of slow wave and paradoxical sleep) 
##                                                      -54.598387 
##                                       maximum life span (years) 
##                                                      -45.856452 
##                                           gestation time (days) 
##                                                       68.717742 
##                                           predation index (1-5) 
##                                                        2.870968 
##                                      sleep exposure index (1-5) 
##                                                        2.419355 
##                                      overall danger index (1-5) 
##                                                        2.612903
```
# there are no NAs, since all of the values exist; however, several values have been replaced with "-999"


```r
sleep <- replace(sleep, sleep < 0, NA) 
sleep
```

```
## # A tibble: 62 × 11
##    species       body …¹ brain…² slow …³ parad…⁴ total…⁵ maxim…⁶ gesta…⁷ preda…⁸
##    <chr>           <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 African elep… 6.65e+3  5712      NA      NA       3.3    38.6     645       3
##  2 African gian… 1   e+0     6.6     6.3     2       8.3     4.5      42       3
##  3 Arctic Fox    3.38e+0    44.5    NA      NA      12.5    14        60       1
##  4 Arctic groun… 9.2 e-1     5.7    NA      NA      16.5    NA        25       5
##  5 Asian elepha… 2.55e+3  4603       2.1     1.8     3.9    69       624       3
##  6 Baboon        1.06e+1   180.      9.1     0.7     9.8    27       180       4
##  7 Big brown bat 2.3 e-2     0.3    15.8     3.9    19.7    19        35       1
##  8 Brazilian ta… 1.6 e+2   169       5.2     1       6.2    30.4     392       4
##  9 Cat           3.3 e+0    25.6    10.9     3.6    14.5    28        63       1
## 10 Chimpanzee    5.22e+1   440       8.3     1.4     9.7    50       230       1
## # … with 52 more rows, 2 more variables: `sleep exposure index (1-5)` <dbl>,
## #   `overall danger index (1-5)` <dbl>, and abbreviated variable names
## #   ¹​`body weight in kg`, ²​`brain weight in g`,
## #   ³​`slow wave ("nondreaming") sleep (hrs/day)`,
## #   ⁴​`paradoxical ("dreaming") sleep (hrs/day)`,
## #   ⁵​`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`,
## #   ⁶​`maximum life span (years)`, ⁷​`gestation time (days)`, …
```
# I've now replaced all of the -999s with NAs, so yes, there are now NAs.


5. Show a list of the column names is this data frame.

```r
names(sleep)
```

```
##  [1] "species"                                                        
##  [2] "body weight in kg"                                              
##  [3] "brain weight in g"                                              
##  [4] "slow wave (\"nondreaming\") sleep (hrs/day)"                    
##  [5] "paradoxical (\"dreaming\") sleep (hrs/day)"                     
##  [6] "total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)"
##  [7] "maximum life span (years)"                                      
##  [8] "gestation time (days)"                                          
##  [9] "predation index (1-5)"                                          
## [10] "sleep exposure index (1-5)"                                     
## [11] "overall danger index (1-5)"
```

6. How many herbivores are represented in the data?  

```r
sum(sleep[,9] == 2)
```

```
## [1] 15
```

7. We are interested in two groups; small and large mammals. Let's define small as less than or equal to 1kg body weight and large as greater than or equal to 200kg body weight. Make two new dataframes (large and small) based on these parameters.

```r
small <- sleep[(sleep$`body weight in kg` <= 1),]
large <- sleep[(sleep$`body weight in kg` >= 200),]
small
```

```
## # A tibble: 21 × 11
##    species       body …¹ brain…² slow …³ parad…⁴ total…⁵ maxim…⁶ gesta…⁷ preda…⁸
##    <chr>           <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 African gian…   1         6.6     6.3     2       8.3     4.5      42       3
##  2 Arctic groun…   0.92      5.7    NA      NA      16.5    NA        25       5
##  3 Big brown bat   0.023     0.3    15.8     3.9    19.7    19        35       1
##  4 Chinchilla      0.425     6.4    11       1.5    12.5     7       112       5
##  5 Desert hedge…   0.55      2.4     7.6     2.7    10.3    NA        NA       2
##  6 Eastern Amer…   0.075     1.2     6.3     2.1     8.4     3.5      42       1
##  7 European hed…   0.785     3.5     6.6     4.1    10.7     6        42       2
##  8 Galago          0.2       5       9.5     1.2    10.7    10.4     120       2
##  9 Golden hamst…   0.12      1      11       3.4    14.4     3.9      16       3
## 10 Ground squir…   0.101     4      10.4     3.4    13.8     9        28       5
## # … with 11 more rows, 2 more variables: `sleep exposure index (1-5)` <dbl>,
## #   `overall danger index (1-5)` <dbl>, and abbreviated variable names
## #   ¹​`body weight in kg`, ²​`brain weight in g`,
## #   ³​`slow wave ("nondreaming") sleep (hrs/day)`,
## #   ⁴​`paradoxical ("dreaming") sleep (hrs/day)`,
## #   ⁵​`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`,
## #   ⁶​`maximum life span (years)`, ⁷​`gestation time (days)`, …
```

```r
large
```

```
## # A tibble: 7 × 11
##   species        body …¹ brain…² slow …³ parad…⁴ total…⁵ maxim…⁶ gesta…⁷ preda…⁸
##   <chr>            <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 African eleph…    6654    5712    NA      NA       3.3    38.6     645       3
## 2 Asian elephant    2547    4603     2.1     1.8     3.9    69       624       3
## 3 Cow                465     423     3.2     0.7     3.9    30       281       5
## 4 Giraffe            529     680    NA       0.3    NA      28       400       5
## 5 Gorilla            207     406    NA      NA      12      39.3     252       1
## 6 Horse              521     655     2.1     0.8     2.9    46       336       5
## 7 Okapi              250     490    NA       1      NA      23.6     440       5
## # … with 2 more variables: `sleep exposure index (1-5)` <dbl>,
## #   `overall danger index (1-5)` <dbl>, and abbreviated variable names
## #   ¹​`body weight in kg`, ²​`brain weight in g`,
## #   ³​`slow wave ("nondreaming") sleep (hrs/day)`,
## #   ⁴​`paradoxical ("dreaming") sleep (hrs/day)`,
## #   ⁵​`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`,
## #   ⁶​`maximum life span (years)`, ⁷​`gestation time (days)`, …
```

8. What is the mean weight for both the small and large mammals?

```r
mean(small$`body weight in kg`)
```

```
## [1] 0.3324286
```

```r
mean(large$`body weight in kg`)
```

```
## [1] 1596.143
```

9. Using a similar approach as above, do large or small animals sleep longer on average?  

```r
mean(small$`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`)
```

```
## [1] 12.71905
```

```r
mean(large$`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`,na.rm=TRUE)
```

```
## [1] 5.2
```
#According to the data, small animals sleep more

10. Which animal is the sleepiest among the entire dataframe?

```r
x <- max(sleep[,6],na.rm=TRUE)
na.exclude(sleep[(sleep[,6]==x),])
```

```
## # A tibble: 1 × 11
##   species        body …¹ brain…² slow …³ parad…⁴ total…⁵ maxim…⁶ gesta…⁷ preda…⁸
##   <chr>            <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 Little brown …    0.01    0.25    17.9       2    19.9      24      50       1
## # … with 2 more variables: `sleep exposure index (1-5)` <dbl>,
## #   `overall danger index (1-5)` <dbl>, and abbreviated variable names
## #   ¹​`body weight in kg`, ²​`brain weight in g`,
## #   ³​`slow wave ("nondreaming") sleep (hrs/day)`,
## #   ⁴​`paradoxical ("dreaming") sleep (hrs/day)`,
## #   ⁵​`total sleep (hrs/day)  (sum of slow wave and paradoxical sleep)`,
## #   ⁶​`maximum life span (years)`, ⁷​`gestation time (days)`, …
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
