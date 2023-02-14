---
title: "Lab 9 Homework"
author: "Please Add Your Name Here"
date: "2023-02-13"
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
library(naniar)
library(dplyr)
```

For this homework, we will take a departure from biological data and use data about California colleges. These data are a subset of the national college scorecard (https://collegescorecard.ed.gov/data/). Load the `ca_college_data.csv` as a new object called `colleges`.

```r
colleges <- read_csv(here("data","ca_college_data.csv"))
```

```
## Rows: 341 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (4): INSTNM, CITY, STABBR, ZIP
## dbl (6): ADM_RATE, SAT_AVG, PCIP26, COSTT4_A, C150_4_POOLED, PFTFTUG1_EF
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

The variables are a bit hard to decipher, here is a key:  

INSTNM: Institution name  
CITY: California city  
STABBR: Location state  
ZIP: Zip code  
ADM_RATE: Admission rate  
SAT_AVG: SAT average score  
PCIP26: Percentage of degrees awarded in Biological And Biomedical Sciences  
COSTT4_A: Annual cost of attendance  
C150_4_POOLED: 4-year completion rate  
PFTFTUG1_EF: Percentage of undergraduate students who are first-time, full-time degree/certificate-seeking undergraduate students  

1. Use your preferred function(s) to have a look at the data and get an idea of its structure. Make sure you summarize NA's and determine whether or not the data are tidy. You may also consider dealing with any naming issues.

```r
glimpse(colleges)
```

```
## Rows: 341
## Columns: 10
## $ INSTNM        <chr> "Grossmont College", "College of the Sequoias", "College…
## $ CITY          <chr> "El Cajon", "Visalia", "San Mateo", "Ventura", "Oxnard",…
## $ STABBR        <chr> "CA", "CA", "CA", "CA", "CA", "CA", "CA", "CA", "CA", "C…
## $ ZIP           <chr> "92020-1799", "93277-2214", "94402-3784", "93003-3872", …
## $ ADM_RATE      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
## $ SAT_AVG       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
## $ PCIP26        <dbl> 0.0016, 0.0066, 0.0038, 0.0035, 0.0085, 0.0151, 0.0000, …
## $ COSTT4_A      <dbl> 7956, 8109, 8278, 8407, 8516, 8577, 8580, 9181, 9281, 93…
## $ C150_4_POOLED <dbl> NA, NA, NA, NA, NA, NA, 0.2334, NA, NA, NA, NA, 0.1704, …
## $ PFTFTUG1_EF   <dbl> 0.3546, 0.5413, 0.3567, 0.3824, 0.2753, 0.4286, 0.2307, …
```


```r
colleges <- colleges %>% 
  na_if("NA") %>%  
  rename("name"=INSTNM,"state"=STABBR,"tuition"=COSTT4_A,"grad_rate"=C150_4_POOLED,"percent_bio"=PCIP26,"percent_FTFT"=PFTFTUG1_EF) %>% 
  clean_names() %>% 
  arrange(name)
colleges
```

```
## # A tibble: 341 × 10
##    name        city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##    <chr>       <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 Academy of… San … CA    94105  NA          NA  0        38000   0.370   0.343
##  2 Academy of… Oakl… CA    94612  NA          NA NA           NA  NA      NA    
##  3 Allan Hanc… Sant… CA    9345…  NA          NA  0.0069    9932  NA       0.398
##  4 Alliant In… San … CA    92131   0.857      NA  0        28258  NA      NA    
##  5 American A… Los … CA    90028   0.770      NA  0        51581  NA       0.920
##  6 American B… Berk… CA    9470…  NA          NA NA           NA  NA      NA    
##  7 American B… West… CA    91790  NA          NA  0           NA  NA       0.781
##  8 American C… Los … CA    90004  NA          NA  0           NA  NA       0.412
##  9 American C… San … CA    9410…  NA          NA  0        47827  NA      NA    
## 10 American F… Los … CA    9002…  NA          NA NA           NA  NA      NA    
## # … with 331 more rows, and abbreviated variable names ¹​adm_rate, ²​percent_bio,
## #   ³​grad_rate, ⁴​percent_ftft
```


2. Which cities in California have the highest number of colleges?

```r
colleges %>% 
  count(city) %>% 
  arrange(desc(n))
```

```
## # A tibble: 161 × 2
##    city              n
##    <chr>         <int>
##  1 Los Angeles      24
##  2 San Diego        18
##  3 San Francisco    15
##  4 Sacramento       10
##  5 Berkeley          9
##  6 Oakland           9
##  7 Claremont         7
##  8 Pasadena          6
##  9 Fresno            5
## 10 Irvine            5
## # … with 151 more rows
```

3. Based on your answer to #2, make a plot that shows the number of colleges in the top 10 cities.

```r
colleges %>% 
  count(city) %>% 
  arrange(desc(n)) %>% 
  head(n=10) %>% 
  ggplot(aes(x=city, y=n)) +
    geom_col() +
    coord_flip()
```

![](lab9_hw_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
colleges %>% 
  filter(city == "Berkeley")
```

```
## # A tibble: 9 × 10
##   name         city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##   <chr>        <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 American Ba… Berk… CA    9470…  NA          NA  NA          NA  NA      NA    
## 2 Berkeley Ci… Berk… CA    94704  NA          NA   0       13200  NA       0.203
## 3 Church Divi… Berk… CA    9470…  NA          NA  NA          NA  NA      NA    
## 4 Dominican S… Berk… CA    9470…  NA          NA  NA          NA  NA      NA    
## 5 Graduate Th… Berk… CA    94709  NA          NA  NA          NA  NA      NA    
## 6 Pacific Sch… Berk… CA    94709  NA          NA  NA          NA  NA      NA    
## 7 Starr King … Berk… CA    9470…  NA          NA  NA          NA  NA      NA    
## 8 The Wright … Berk… CA    9470…  NA          NA  NA          NA  NA      NA    
## 9 University … Berk… CA    94720   0.169    1422   0.105   34924   0.916   0.709
## # … with abbreviated variable names ¹​adm_rate, ²​percent_bio, ³​grad_rate,
## #   ⁴​percent_ftft
```

4. The column `COSTT4_A` is the annual cost of each institution. Which city has the highest average cost? Where is it located?

```r
colleges %>% 
  group_by(city) %>% 
  summarize(avg_tuition = mean(tuition)) %>% 
  arrange(desc(avg_tuition))
```

```
## # A tibble: 161 × 2
##    city                avg_tuition
##    <chr>                     <dbl>
##  1 Malibu                    66152
##  2 Valencia                  64686
##  3 Redlands                  61542
##  4 Moraga                    61095
##  5 Atherton                  56035
##  6 Thousand Oaks             54373
##  7 Rancho Palos Verdes       50758
##  8 La Verne                  50603
##  9 Belmont                   50415
## 10 La Mirada                 48857
## # … with 151 more rows
```

5. Based on your answer to #4, make a plot that compares the cost of the individual colleges in the most expensive city. Bonus! Add UC Davis here to see how it compares :>).

```r
colleges %>% 
  filter(city == "Malibu"|city == "Davis") %>% 
  ggplot(aes(x=name,y=tuition))+
    geom_col()+
    coord_flip()
```

![](lab9_hw_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

6. The column `ADM_RATE` is the admissions rate by college and `C150_4_POOLED` is the four-year completion rate. Use a scatterplot to show the relationship between these two variables. What do you think this means?

```r
colleges %>% 
  ggplot(aes(x=adm_rate,y=grad_rate))+geom_point()+geom_smooth(method=lm, se=F, na.rm=T)
```

```
## `geom_smooth()` using formula = 'y ~ x'
```

```
## Warning: Removed 251 rows containing missing values (`geom_point()`).
```

![](lab9_hw_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

7. Is there a relationship between cost and four-year completion rate? (You don't need to do the stats, just produce a plot). What do you think this means?

```r
colleges %>% 
  ggplot(aes(x=tuition,y=grad_rate))+geom_point()+geom_smooth(method=lm, se=F, na.rm=T)
```

```
## `geom_smooth()` using formula = 'y ~ x'
```

```
## Warning: Removed 225 rows containing missing values (`geom_point()`).
```

![](lab9_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

8. The column titled `INSTNM` is the institution name. We are only interested in the University of California colleges. Make a new data frame that is restricted to UC institutions. You can remove `Hastings College of Law` and `UC San Francisco` as we are only interested in undergraduate institutions.

```r
uc_colleges <- colleges %>% 
  subset(grepl("University of California",name))
uc_colleges
```

```
## # A tibble: 10 × 10
##    name        city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##    <chr>       <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
##  1 University… Berk… CA    94720   0.169    1422   0.105   34924   0.916   0.709
##  2 University… Davis CA    9561…   0.423    1218   0.198   33904   0.850   0.605
##  3 University… San … CA    9410…  NA          NA  NA          NA  NA      NA    
##  4 University… Irvi… CA    92697   0.406    1206   0.107   31198   0.876   0.725
##  5 University… Los … CA    9009…   0.180    1334   0.155   33078   0.911   0.661
##  6 University… Rive… CA    92521   0.663    1078   0.149   31494   0.73    0.811
##  7 University… La J… CA    92093   0.357    1324   0.216   31043   0.872   0.662
##  8 University… San … CA    9414…  NA          NA  NA          NA  NA      NA    
##  9 University… Sant… CA    93106   0.358    1281   0.108   34998   0.816   0.708
## 10 University… Sant… CA    9506…   0.578    1201   0.193   34608   0.776   0.786
## # … with abbreviated variable names ¹​adm_rate, ²​percent_bio, ³​grad_rate,
## #   ⁴​percent_ftft
```

Remove `Hastings College of Law` and `UC San Francisco` and store the final data frame as a new object `univ_calif_final`.

```r
univ_calif_final <- uc_colleges  %>% 
  filter(!grepl("Hastings|Francisco",name))
univ_calif_final
```

```
## # A tibble: 8 × 10
##   name         city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##   <chr>        <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 University … Berk… CA    94720   0.169    1422   0.105   34924   0.916   0.709
## 2 University … Davis CA    9561…   0.423    1218   0.198   33904   0.850   0.605
## 3 University … Irvi… CA    92697   0.406    1206   0.107   31198   0.876   0.725
## 4 University … Los … CA    9009…   0.180    1334   0.155   33078   0.911   0.661
## 5 University … Rive… CA    92521   0.663    1078   0.149   31494   0.73    0.811
## 6 University … La J… CA    92093   0.357    1324   0.216   31043   0.872   0.662
## 7 University … Sant… CA    93106   0.358    1281   0.108   34998   0.816   0.708
## 8 University … Sant… CA    9506…   0.578    1201   0.193   34608   0.776   0.786
## # … with abbreviated variable names ¹​adm_rate, ²​percent_bio, ³​grad_rate,
## #   ⁴​percent_ftft
```

Use `separate()` to separate institution name into two new columns "UNIV" and "CAMPUS".

```r
univ_calif_final <- univ_calif_final %>% 
  separate(name,into=c("univ","campus"),sep='-')
```

9. The column `ADM_RATE` is the admissions rate by campus. Which UC has the lowest and highest admissions rates? Produce a numerical summary and an appropriate plot.

```r
univ_calif_final %>% 
  filter(adm_rate == max(adm_rate) | adm_rate == min(adm_rate))
```

```
## # A tibble: 2 × 11
##   univ  campus city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##   <chr> <chr>  <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 Univ… Berke… Berk… CA    94720   0.169    1422   0.105   34924   0.916   0.709
## 2 Univ… River… Rive… CA    92521   0.663    1078   0.149   31494   0.73    0.811
## # … with abbreviated variable names ¹​adm_rate, ²​percent_bio, ³​grad_rate,
## #   ⁴​percent_ftft
```


```r
univ_calif_final %>% 
  filter(adm_rate == max(adm_rate) | adm_rate == min(adm_rate)) %>% 
  ggplot(aes(x=campus,y=adm_rate))+geom_col()+coord_flip()
```

![](lab9_hw_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

10. If you wanted to get a degree in biological or biomedical sciences, which campus confers the majority of these degrees? Produce a numerical summary and an appropriate plot.

```r
univ_calif_final %>% 
  slice_max(percent_bio)
```

```
## # A tibble: 1 × 11
##   univ  campus city  state zip   adm_r…¹ sat_avg perce…² tuition grad_…³ perce…⁴
##   <chr> <chr>  <chr> <chr> <chr>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 Univ… San D… La J… CA    92093   0.357    1324   0.216   31043   0.872   0.662
## # … with abbreviated variable names ¹​adm_rate, ²​percent_bio, ³​grad_rate,
## #   ⁴​percent_ftft
```


```r
univ_calif_final %>% 
  arrange(desc(percent_bio)) %>% 
  ggplot(aes(x=reorder(campus,+percent_bio),y=percent_bio))+geom_col()+coord_flip()
```

![](lab9_hw_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

## Knit Your Output and Post to [GitHub](https://github.com/FRS417-DataScienceBiologists)
