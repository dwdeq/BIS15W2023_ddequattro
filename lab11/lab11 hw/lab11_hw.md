---
title: "Lab 11 Homework"
author: "Dominic \"DQ\" De Quattro"
date: "2023-02-21"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above. For any included plots, make sure they are clearly labeled. You are free to use any plot type that you feel best communicates the results of your analysis.  

**In this homework, you should make use of the aesthetics you have learned. It's OK to be flashy!**

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(here)
library(naniar)
library(RColorBrewer)
library(paletteer)
```


```r
options(scipen=-1)
```

## Resources
The idea for this assignment came from [Rebecca Barter's](http://www.rebeccabarter.com/blog/2017-11-17-ggplot2_tutorial/) ggplot tutorial so if you get stuck this is a good place to have a look.  

## Gapminder
For this assignment, we are going to use the dataset [gapminder](https://cran.r-project.org/web/packages/gapminder/index.html). Gapminder includes information about economics, population, and life expectancy from countries all over the world. You will need to install it before use. This is the same data that we will use for midterm 2 so this is good practice.

```r
#install.packages("gapminder")
library("gapminder")
```

## Questions
The questions below are open-ended and have many possible solutions. Your approach should, where appropriate, include numerical summaries and visuals. Be creative; assume you are building an analysis that you would ultimately present to an audience of stakeholders. Feel free to try out different `geoms` if they more clearly present your results.  

**1. Use the function(s) of your choice to get an idea of the overall structure of the data frame, including its dimensions, column names, variable classes, etc. As part of this, determine how NA's are treated in the data.**  

```r
glimpse(gapminder)
```

```
## Rows: 1,704
## Columns: 6
## $ country   <fct> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", …
## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, …
## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, …
## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.8…
## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 12…
## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134, …
```


```r
anyNA(gapminder)
```

```
## [1] FALSE
```


```r
gapminder
```

```
## # A tibble: 1,704 × 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.
##  2 Afghanistan Asia       1957    30.3  9240934      821.
##  3 Afghanistan Asia       1962    32.0 10267083      853.
##  4 Afghanistan Asia       1967    34.0 11537966      836.
##  5 Afghanistan Asia       1972    36.1 13079460      740.
##  6 Afghanistan Asia       1977    38.4 14880372      786.
##  7 Afghanistan Asia       1982    39.9 12881816      978.
##  8 Afghanistan Asia       1987    40.8 13867957      852.
##  9 Afghanistan Asia       1992    41.7 16317921      649.
## 10 Afghanistan Asia       1997    41.8 22227415      635.
## # … with 1,694 more rows
```
## As far as I can tell, there are no NAs of any kind in the data set.

**2. Among the interesting variables in gapminder is life expectancy. How has global life expectancy changed between 1952 and 2007?**

```r
gapminder %>% 
  ggplot(aes(x = year, 
             y = lifeExp, 
             group = year)) +
  geom_boxplot(fill = "pink", 
               alpha = .5) +
  labs(x = "Year",
       y = "Life Expectancy",
       title = "Global Life Expectancy by Year") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5)) +
  scale_y_continuous(breaks = seq(0, 85, by = 5)) +
  scale_x_continuous(breaks = seq(1952, 2007, by = 5))
```

![](lab11_hw_files/figure-html/unnamed-chunk-7-1.png)<!-- -->


**3. How do the distributions of life expectancy compare for the years 1952 and 2007?**

```r
gapminder %>% 
  filter(year == 1952 | year == 2007) %>% 
  ggplot(aes(x = lifeExp)) +
  geom_density(fill = "pink", 
               alpha = .5) +
  labs(x = "Life Expectancy",
       y = "Distribution",
       title = "Distribution of Average Life Expectancies (1952 & 2007)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5))+ 
  facet_grid(year~.) +
  scale_x_continuous(breaks = seq(30, 80, by = 5))
```

![](lab11_hw_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

**4. Your answer above doesn't tell the whole story since life expectancy varies by region. Make a summary that shows the min, mean, and max life expectancy by continent for all years represented in the data.**

```r
gapminder %>% 
  group_by(continent,year) %>% 
  summarize(max_lifeExp = max(lifeExp),
            min_lifeExp = min(lifeExp),
            mean_lifeExp = mean(lifeExp)) %>% 
  rename("Max Life Expectancy" = max_lifeExp,
         "Min Life Expectancy" = min_lifeExp,
         "Mean Life Expectancy" = mean_lifeExp) %>% 
  pivot_longer(3:5,
               names_to = "fun_type",
               values_to = "lifeExp") %>% 
  rename("Function Type" = fun_type) %>% 
  ggplot(aes(x = year,
             y = lifeExp,
             color = `Function Type`)) +
  geom_point() +
  scale_colour_brewer(palette = "RdPu") +
  labs(x = "Year",
       y = "Life Expectancy",
       title = "Min, Mean, & Max Life Expectancy by Year (by Continent)") +
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = .5),
        axis.text.x = element_text(vjust = .5,
                                   angle = 90)) + 
  facet_grid(.~continent) +
  scale_y_continuous(breaks = seq(0, 85, by = 5)) +
  scale_x_continuous(breaks = seq(1952, 2007, by = 5))
```

```
## `summarise()` has grouped output by 'continent'. You can override using the
## `.groups` argument.
```

![](lab11_hw_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

**5. How has life expectancy changed between 1952-2007 for each continent?**

```r
gapminder %>%
  group_by(continent,year) %>% 
  summarize(mean_lifeExp = mean(lifeExp)) %>% 
  ggplot(aes(x = year, 
             y = mean_lifeExp)) +
  geom_col(fill = "pink",
           color = "gray20",
           alpha = .5,
           show.legend = FALSE) +
  labs(x = "Year",
       y = "Life Expectancy",
       title = "Global Life Expectancy by Continent (1952-2007)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5)) +
  facet_grid(.~continent) +
  scale_y_continuous(breaks = seq(0, 85, by = 5)) +
  scale_x_continuous(breaks = seq(1952, 2007, by = 55))
```

```
## `summarise()` has grouped output by 'continent'. You can override using the
## `.groups` argument.
```

![](lab11_hw_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

**6. We are interested in the relationship between per capita GDP and life expectancy; i.e. does having more money help you live longer?**

```r
gapminder %>% 
  ggplot(aes(x = gdpPercap, 
             y = lifeExp)) +
  geom_point(fill = "skyblue2", 
             alpha = .3) +
  labs(x = "GDP per Capita",
       y = "Life Expectancy",
       title = "Global Life Expectancy by GDP (per Capita)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5),
        axis.text.x = element_text(vjust = .5)) + 
  scale_x_log10() +
  geom_smooth(method = lm, se = F, color = "hotpink2")
```

```
## `geom_smooth()` using formula = 'y ~ x'
```

![](lab11_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

**7. Which countries have had the largest population growth since 1952?**

```r
gapminder %>% 
  filter(year == 1952 | year == 2007) %>% 
  group_by(country) %>% 
  summarize(pop_change = max(pop)-min(pop)) %>% 
  arrange(desc(pop_change))
```

```
## # A tibble: 142 × 2
##    country       pop_change
##    <fct>              <int>
##  1 China          762419569
##  2 India          738396331
##  3 United States  143586947
##  4 Indonesia      141495000
##  5 Brazil         133408087
##  6 Pakistan       127924057
##  7 Bangladesh     103561480
##  8 Nigeria        101912068
##  9 Mexico          78556574
## 10 Philippines     68638596
## # … with 132 more rows
```

**8. Use your results from the question above to plot population growth for the top five countries since 1952.**

```r
gapminder %>% 
  filter(year == 1952 | year == 2007) %>% 
  group_by(country) %>% 
  summarize(pop_change = max(pop)-min(pop)) %>% 
  arrange(desc(pop_change)) %>% 
  head(n = 5) %>% 
  ggplot(aes(x = reorder(country, pop_change),
             y = pop_change)) +
  geom_col(color = "gray0",
           fill = "pink",
           alpha = .5) +
  labs(x = "Country",
       y = "Change in Population",
       title = "Population Growth by Country (1952-2007)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5),
        axis.text.x = element_text(hjust = 1,
                                   angle = 45))
```

![](lab11_hw_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

**9. How does per-capita GDP growth compare between these same five countries?**

```r
gapminder %>% 
  filter(year == 1952 | year == 2007) %>% 
  filter(country == "China" |
         country == "India" |
         country == "United States" |
         country == "Indonesia" |
         country == "Brazil") %>% 
  group_by(country) %>% 
  summarize(gdp_change = max(gdpPercap)-min(gdpPercap)) %>% 
  arrange(desc(gdp_change)) %>% 
  ggplot(aes(x = reorder(country, gdp_change),
             y = gdp_change)) +
  geom_col(color = "gray0",
           fill = "pink",
           alpha = .5) +
  labs(x = "Country",
       y = "Change in Population Size",
       title = "GDP per Capita Growth by Country (1952-2007)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5),
        axis.text.x = element_text(hjust = 1,
                                   angle = 45))
```

![](lab11_hw_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

**10. Make one plot of your choice that uses faceting!**

```r
gapminder %>% 
  filter(year == 1952 | year == 2007) %>% 
  ggplot(aes(x = lifeExp, 
             fill = continent)) +
  scale_fill_brewer(palette = "RdPu") +
  geom_density(alpha = .5,
               show.legend = FALSE) +
  labs(x = "Life Expectancy",
       y = "Distribution",
       title = "Distribution of Average Life Expectancies by Continent (1952 vs 2007)") +
  theme_classic() +
  theme(plot.title = element_text(hjust = .5))+ 
  facet_grid(continent~year, scales = "free_y") +
  scale_x_continuous(breaks = seq(0, 85, by = 5))
```

![](lab11_hw_files/figure-html/unnamed-chunk-15-1.png)<!-- -->


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
