---
title: "dplyr Superhero"
date: "2023-01-26"
output:
  html_document: 
    theme: spacelab
    toc: yes
    toc_float: yes
    keep_md: yes
---

## Learning Goals  
*At the end of this exercise, you will be able to:*    
1. Develop your dplyr superpowers so you can easily and confidently manipulate dataframes.  
2. Learn helpful new functions that are part of the `janitor` package.  

## Instructions
For the second part of lab 5 today, we are going to spend time practicing the dplyr functions we have learned and add a few new ones. We will spend most of the time in our breakout rooms. Your lab 5 homework will be to knit and push this file to your repository.  

## Load the tidyverse

```r
library("tidyverse")
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
## ✔ ggplot2 3.4.0      ✔ purrr   1.0.0 
## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
## ✔ tidyr   1.2.1      ✔ stringr 1.5.0 
## ✔ readr   2.1.3      ✔ forcats 0.5.2 
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

## Load the superhero data
These are data taken from comic books and assembled by fans. The include a good mix of categorical and continuous data.  Data taken from: https://www.kaggle.com/claudiodavi/superhero-set  

Check out the way I am loading these data. If I know there are NAs, I can take care of them at the beginning. But, we should do this very cautiously. At times it is better to keep the original columns and data intact.  

```r
superhero_info <- readr::read_csv("data/heroes_information.csv", na = c("", "-99", "-"))
```

```
## Rows: 734 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): name, Gender, Eye color, Race, Hair color, Publisher, Skin color, A...
## dbl (2): Height, Weight
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
superhero_powers <- readr::read_csv("data/super_hero_powers.csv", na = c("", "-99", "-"))
```

```
## Rows: 667 Columns: 168
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr   (1): hero_names
## lgl (167): Agility, Accelerated Healing, Lantern Power Ring, Dimensional Awa...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Data tidy
1. Some of the names used in the `superhero_info` data are problematic so you should rename them here.  

```r
glimpse(superhero_info)
```

```
## Rows: 734
## Columns: 10
## $ name         <chr> "A-Bomb", "Abe Sapien", "Abin Sur", "Abomination", "Abrax…
## $ Gender       <chr> "Male", "Male", "Male", "Male", "Male", "Male", "Male", "…
## $ `Eye color`  <chr> "yellow", "blue", "blue", "green", "blue", "blue", "blue"…
## $ Race         <chr> "Human", "Icthyo Sapien", "Ungaran", "Human / Radiation",…
## $ `Hair color` <chr> "No Hair", "No Hair", "No Hair", "No Hair", "Black", "No …
## $ Height       <dbl> 203, 191, 185, 203, NA, 193, NA, 185, 173, 178, 191, 188,…
## $ Publisher    <chr> "Marvel Comics", "Dark Horse Comics", "DC Comics", "Marve…
## $ `Skin color` <chr> NA, "blue", "red", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
## $ Alignment    <chr> "good", "good", "good", "bad", "bad", "bad", "good", "goo…
## $ Weight       <dbl> 441, 65, 90, 441, NA, 122, NA, 88, 61, 81, 104, 108, 90, …
```

```r
superhero_info <- rename(superhero_info, gender="Gender", eye_color="Eye color", scifi_race="Race", hair_color="Hair color", height="Height", publisher="Publisher", alignment="Alignment", weight="Weight")
superhero_info %>% mutate_if(is.character, as.factor)
```

```
## # A tibble: 734 × 10
##    name     gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##    <fct>    <fct>  <fct>   <fct>   <fct>    <dbl> <fct>   <fct>   <fct>    <dbl>
##  1 A-Bomb   Male   yellow  Human   No Hair    203 Marvel… <NA>    good       441
##  2 Abe Sap… Male   blue    Icthyo… No Hair    191 Dark H… blue    good        65
##  3 Abin Sur Male   blue    Ungaran No Hair    185 DC Com… red     good        90
##  4 Abomina… Male   green   Human … No Hair    203 Marvel… <NA>    bad        441
##  5 Abraxas  Male   blue    Cosmic… Black       NA Marvel… <NA>    bad         NA
##  6 Absorbi… Male   blue    Human   No Hair    193 Marvel… <NA>    bad        122
##  7 Adam Mo… Male   blue    <NA>    Blond       NA NBC - … <NA>    good        NA
##  8 Adam St… Male   blue    Human   Blond      185 DC Com… <NA>    good        88
##  9 Agent 13 Female blue    <NA>    Blond      173 Marvel… <NA>    good        61
## 10 Agent B… Male   brown   Human   Brown      178 Marvel… <NA>    good        81
## # … with 724 more rows, and abbreviated variable names ¹​eye_color, ²​scifi_race,
## #   ³​hair_color, ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

Yikes! `superhero_powers` has a lot of variables that are poorly named. We need some R superpowers...

```r
head(superhero_powers)
```

```
## # A tibble: 6 × 168
##   hero_…¹ Agility Accel…² Lante…³ Dimen…⁴ Cold …⁵ Durab…⁶ Stealth Energ…⁷ Flight
##   <chr>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl> 
## 1 3-D Man TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 2 A-Bomb  FALSE   TRUE    FALSE   FALSE   FALSE   TRUE    FALSE   FALSE   FALSE 
## 3 Abe Sa… TRUE    TRUE    FALSE   FALSE   TRUE    TRUE    FALSE   FALSE   FALSE 
## 4 Abin S… FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 5 Abomin… FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 6 Abraxas FALSE   FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   TRUE  
## # … with 158 more variables: `Danger Sense` <lgl>,
## #   `Underwater breathing` <lgl>, Marksmanship <lgl>, `Weapons Master` <lgl>,
## #   `Power Augmentation` <lgl>, `Animal Attributes` <lgl>, Longevity <lgl>,
## #   Intelligence <lgl>, `Super Strength` <lgl>, Cryokinesis <lgl>,
## #   Telepathy <lgl>, `Energy Armor` <lgl>, `Energy Blasts` <lgl>,
## #   Duplication <lgl>, `Size Changing` <lgl>, `Density Control` <lgl>,
## #   Stamina <lgl>, `Astral Travel` <lgl>, `Audio Control` <lgl>, …
```

## `janitor`
The [janitor](https://garthtarr.github.io/meatR/janitor.html) package is your friend. Make sure to install it and then load the library.  

```r
library("janitor")
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

The `clean_names` function takes care of everything in one line! Now that's a superpower!

```r
superhero_powers <- janitor::clean_names(superhero_powers)
superhero_powers
```

```
## # A tibble: 667 × 168
##    hero_names    agility accel…¹ lante…² dimen…³ cold_…⁴ durab…⁵ stealth energ…⁶
##    <chr>         <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>  
##  1 3-D Man       TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE  
##  2 A-Bomb        FALSE   TRUE    FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
##  3 Abe Sapien    TRUE    TRUE    FALSE   FALSE   TRUE    TRUE    FALSE   FALSE  
##  4 Abin Sur      FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE  
##  5 Abomination   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE  
##  6 Abraxas       FALSE   FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE  
##  7 Absorbing Man FALSE   FALSE   FALSE   FALSE   TRUE    TRUE    FALSE   TRUE   
##  8 Adam Monroe   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE  
##  9 Adam Strange  FALSE   FALSE   FALSE   FALSE   FALSE   TRUE    TRUE    FALSE  
## 10 Agent Bob     FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   TRUE    FALSE  
## # … with 657 more rows, 159 more variables: flight <lgl>, danger_sense <lgl>,
## #   underwater_breathing <lgl>, marksmanship <lgl>, weapons_master <lgl>,
## #   power_augmentation <lgl>, animal_attributes <lgl>, longevity <lgl>,
## #   intelligence <lgl>, super_strength <lgl>, cryokinesis <lgl>,
## #   telepathy <lgl>, energy_armor <lgl>, energy_blasts <lgl>,
## #   duplication <lgl>, size_changing <lgl>, density_control <lgl>,
## #   stamina <lgl>, astral_travel <lgl>, audio_control <lgl>, dexterity <lgl>, …
```

## `tabyl`
The `janitor` package has many awesome functions that we will explore. Here is its version of `table` which not only produces counts but also percentages. Very handy! Let's use it to explore the proportion of good guys and bad guys in the `superhero_info` data.  


```r
tabyl(superhero_info, alignment)
```

```
##  alignment   n     percent valid_percent
##        bad 207 0.282016349    0.28473177
##       good 496 0.675749319    0.68225585
##    neutral  24 0.032697548    0.03301238
##       <NA>   7 0.009536785            NA
```

2. Notice that we have some neutral superheros! Who are they?

```r
filter(superhero_info, alignment == "neutral")
```

```
## # A tibble: 24 × 10
##    name     gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##    <chr>    <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
##  1 Bizarro  Male   black   Bizarro Black      191 DC Com… white   neutral    155
##  2 Black F… Male   <NA>    God / … <NA>        NA DC Com… <NA>    neutral     NA
##  3 Captain… Male   brown   Human   Brown       NA DC Com… <NA>    neutral     NA
##  4 Copycat  Female red     Mutant  White      183 Marvel… blue    neutral     67
##  5 Deadpool Male   brown   Mutant  No Hair    188 Marvel… <NA>    neutral     95
##  6 Deathst… Male   blue    Human   White      193 DC Com… <NA>    neutral    101
##  7 Etrigan  Male   red     Demon   No Hair    193 DC Com… yellow  neutral    203
##  8 Galactus Male   black   Cosmic… Black      876 Marvel… <NA>    neutral     16
##  9 Gladiat… Male   blue    Stront… Blue       198 Marvel… purple  neutral    268
## 10 Indigo   Female <NA>    Alien   Purple      NA DC Com… <NA>    neutral     NA
## # … with 14 more rows, and abbreviated variable names ¹​eye_color, ²​scifi_race,
## #   ³​hair_color, ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

## `superhero_info`
3. Let's say we are only interested in the variables name, alignment, and "race". How would you isolate these variables from `superhero_info`?

```r
supes <- select(superhero_info,"name","alignment","scifi_race")
supes
```

```
## # A tibble: 734 × 3
##    name          alignment scifi_race       
##    <chr>         <chr>     <chr>            
##  1 A-Bomb        good      Human            
##  2 Abe Sapien    good      Icthyo Sapien    
##  3 Abin Sur      good      Ungaran          
##  4 Abomination   bad       Human / Radiation
##  5 Abraxas       bad       Cosmic Entity    
##  6 Absorbing Man bad       Human            
##  7 Adam Monroe   good      <NA>             
##  8 Adam Strange  good      Human            
##  9 Agent 13      good      <NA>             
## 10 Agent Bob     good      Human            
## # … with 724 more rows
```

## Not Human
4. List all of the superheros that are not human.

```r
filter(supes, scifi_race != "Human")
```

```
## # A tibble: 222 × 3
##    name         alignment scifi_race       
##    <chr>        <chr>     <chr>            
##  1 Abe Sapien   good      Icthyo Sapien    
##  2 Abin Sur     good      Ungaran          
##  3 Abomination  bad       Human / Radiation
##  4 Abraxas      bad       Cosmic Entity    
##  5 Ajax         bad       Cyborg           
##  6 Alien        bad       Xenomorph XX121  
##  7 Amazo        bad       Android          
##  8 Angel        good      Vampire          
##  9 Angel Dust   good      Mutant           
## 10 Anti-Monitor bad       God / Eternal    
## # … with 212 more rows
```

## Good and Evil
5. Let's make two different data frames, one focused on the "good guys" and another focused on the "bad guys".

```r
good_guys <- filter(superhero_info, alignment == "good")
```


```r
bad_guys <- filter(superhero_info, alignment == "bad")
```

6. For the good guys, use the `tabyl` function to summarize their "race".

```r
tabyl(good_guys,scifi_race)
```

```
##         scifi_race   n     percent valid_percent
##              Alien   3 0.006048387   0.010752688
##              Alpha   5 0.010080645   0.017921147
##             Amazon   2 0.004032258   0.007168459
##            Android   4 0.008064516   0.014336918
##             Animal   2 0.004032258   0.007168459
##          Asgardian   3 0.006048387   0.010752688
##          Atlantean   4 0.008064516   0.014336918
##         Bolovaxian   1 0.002016129   0.003584229
##              Clone   1 0.002016129   0.003584229
##             Cyborg   3 0.006048387   0.010752688
##           Demi-God   2 0.004032258   0.007168459
##              Demon   3 0.006048387   0.010752688
##            Eternal   1 0.002016129   0.003584229
##     Flora Colossus   1 0.002016129   0.003584229
##        Frost Giant   1 0.002016129   0.003584229
##      God / Eternal   6 0.012096774   0.021505376
##             Gungan   1 0.002016129   0.003584229
##              Human 148 0.298387097   0.530465950
##    Human / Altered   2 0.004032258   0.007168459
##     Human / Cosmic   2 0.004032258   0.007168459
##  Human / Radiation   8 0.016129032   0.028673835
##         Human-Kree   2 0.004032258   0.007168459
##      Human-Spartoi   1 0.002016129   0.003584229
##       Human-Vulcan   1 0.002016129   0.003584229
##    Human-Vuldarian   1 0.002016129   0.003584229
##      Icthyo Sapien   1 0.002016129   0.003584229
##            Inhuman   4 0.008064516   0.014336918
##    Kakarantharaian   1 0.002016129   0.003584229
##         Kryptonian   4 0.008064516   0.014336918
##            Martian   1 0.002016129   0.003584229
##          Metahuman   1 0.002016129   0.003584229
##             Mutant  46 0.092741935   0.164874552
##     Mutant / Clone   1 0.002016129   0.003584229
##             Planet   1 0.002016129   0.003584229
##             Saiyan   1 0.002016129   0.003584229
##           Symbiote   3 0.006048387   0.010752688
##           Talokite   1 0.002016129   0.003584229
##         Tamaranean   1 0.002016129   0.003584229
##            Ungaran   1 0.002016129   0.003584229
##            Vampire   2 0.004032258   0.007168459
##     Yoda's species   1 0.002016129   0.003584229
##      Zen-Whoberian   1 0.002016129   0.003584229
##               <NA> 217 0.437500000            NA
```

7. Among the good guys, Who are the Asgardians?

```r
filter(good_guys,scifi_race == "Asgardian")
```

```
## # A tibble: 3 × 10
##   name      gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##   <chr>     <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
## 1 Sif       Female blue    Asgard… Black      188 Marvel… <NA>    good       191
## 2 Thor      Male   blue    Asgard… Blond      198 Marvel… <NA>    good       288
## 3 Thor Girl Female blue    Asgard… Blond      175 Marvel… <NA>    good       143
## # … with abbreviated variable names ¹​eye_color, ²​scifi_race, ³​hair_color,
## #   ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

8. Among the bad guys, who are the male humans over 200 inches in height?

```r
bad_guys %>% 
  filter(scifi_race == "Human") %>% 
  filter(height > 200)
```

```
## # A tibble: 6 × 10
##   name      gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##   <chr>     <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
## 1 Bane      Male   <NA>    Human   <NA>       203 DC Com… <NA>    bad        180
## 2 Bloodaxe  Female blue    Human   Brown      218 Marvel… <NA>    bad        495
## 3 Doctor D… Male   brown   Human   Brown      201 Marvel… <NA>    bad        187
## 4 Kingpin   Male   blue    Human   No Hair    201 Marvel… <NA>    bad        203
## 5 Lizard    Male   red     Human   No Hair    203 Marvel… <NA>    bad        230
## 6 Scorpion  Male   brown   Human   Brown      211 Marvel… <NA>    bad        310
## # … with abbreviated variable names ¹​eye_color, ²​scifi_race, ³​hair_color,
## #   ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

9. OK, so are there more good guys or bad guys that are bald? (personal interest)

```r
nrow(filter(bad_guys, hair_color == "No Hair"))
```

```
## [1] 35
```

```r
nrow(filter(good_guys, hair_color == "No Hair"))
```

```
## [1] 37
```
there are 2 more bald good guys than there are bald villains.

10. Let's explore who the really "big" superheros are. In the `superhero_info` data, which have a height over 300 or weight greater than or equal to 450?

```r
filter(superhero_info, height > 300 | weight > 450)
```

```
## # A tibble: 14 × 10
##    name     gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##    <chr>    <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
##  1 Bloodaxe Female blue    Human   Brown    218   Marvel… <NA>    bad        495
##  2 Darkseid Male   red     New God No Hair  267   DC Com… grey    bad        817
##  3 Fin Fan… Male   red     Kakara… No Hair  975   Marvel… green   good        18
##  4 Galactus Male   black   Cosmic… Black    876   Marvel… <NA>    neutral     16
##  5 Giganta  Female green   <NA>    Red       62.5 DC Com… <NA>    bad        630
##  6 Groot    Male   yellow  Flora … <NA>     701   Marvel… <NA>    good         4
##  7 Hulk     Male   green   Human … Green    244   Marvel… green   good       630
##  8 Juggern… Male   blue    Human   Red      287   Marvel… <NA>    neutral    855
##  9 MODOK    Male   white   Cyborg  Brownn   366   Marvel… <NA>    bad        338
## 10 Onslaug… Male   red     Mutant  No Hair  305   Marvel… <NA>    bad        405
## 11 Red Hulk Male   yellow  Human … Black    213   Marvel… red     neutral    630
## 12 Sasquat… Male   red     <NA>    Orange   305   Marvel… <NA>    good       900
## 13 Wolfsba… Female green   <NA>    Auburn   366   Marvel… <NA>    good       473
## 14 Ymir     Male   white   Frost … No Hair  305.  Marvel… white   good        NA
## # … with abbreviated variable names ¹​eye_color, ²​scifi_race, ³​hair_color,
## #   ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

11. Just to be clear on the `|` operator,  have a look at the superheros over 300 in height...

```r
filter(superhero_info, height > 300)
```

```
## # A tibble: 8 × 10
##   name      gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##   <chr>     <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
## 1 Fin Fang… Male   red     Kakara… No Hair   975  Marvel… green   good        18
## 2 Galactus  Male   black   Cosmic… Black     876  Marvel… <NA>    neutral     16
## 3 Groot     Male   yellow  Flora … <NA>      701  Marvel… <NA>    good         4
## 4 MODOK     Male   white   Cyborg  Brownn    366  Marvel… <NA>    bad        338
## 5 Onslaught Male   red     Mutant  No Hair   305  Marvel… <NA>    bad        405
## 6 Sasquatch Male   red     <NA>    Orange    305  Marvel… <NA>    good       900
## 7 Wolfsbane Female green   <NA>    Auburn    366  Marvel… <NA>    good       473
## 8 Ymir      Male   white   Frost … No Hair   305. Marvel… white   good        NA
## # … with abbreviated variable names ¹​eye_color, ²​scifi_race, ³​hair_color,
## #   ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```

12. ...and the superheros over 450 in weight. Bonus question! Why do we not have 16 rows in question #10?

```r
filter(superhero_info, weight >= 450)
```

```
## # A tibble: 8 × 10
##   name      gender eye_c…¹ scifi…² hair_…³ height publi…⁴ Skin …⁵ align…⁶ weight
##   <chr>     <chr>  <chr>   <chr>   <chr>    <dbl> <chr>   <chr>   <chr>    <dbl>
## 1 Bloodaxe  Female blue    Human   Brown    218   Marvel… <NA>    bad        495
## 2 Darkseid  Male   red     New God No Hair  267   DC Com… grey    bad        817
## 3 Giganta   Female green   <NA>    Red       62.5 DC Com… <NA>    bad        630
## 4 Hulk      Male   green   Human … Green    244   Marvel… green   good       630
## 5 Juggerna… Male   blue    Human   Red      287   Marvel… <NA>    neutral    855
## 6 Red Hulk  Male   yellow  Human … Black    213   Marvel… red     neutral    630
## 7 Sasquatch Male   red     <NA>    Orange   305   Marvel… <NA>    good       900
## 8 Wolfsbane Female green   <NA>    Auburn   366   Marvel… <NA>    good       473
## # … with abbreviated variable names ¹​eye_color, ²​scifi_race, ³​hair_color,
## #   ⁴​publisher, ⁵​`Skin color`, ⁶​alignment
```
There is overlap between the two subsets of data; at least 4 superheroes are both taller than 300 and heavier than 450.

## Height to Weight Ratio
13. It's easy to be strong when you are heavy and tall, but who is heavy and short? Which superheros have the highest height to weight ratio?

```r
superhero_info %>% 
  mutate(ratio = height/weight) %>% 
  select("name","height","weight","ratio") %>% 
  arrange(desc(ratio))
```

```
## # A tibble: 734 × 4
##    name            height weight  ratio
##    <chr>            <dbl>  <dbl>  <dbl>
##  1 Groot              701      4 175.  
##  2 Galactus           876     16  54.8 
##  3 Fin Fang Foom      975     18  54.2 
##  4 Longshot           188     36   5.22
##  5 Jack-Jack           71     14   5.07
##  6 Rocket Raccoon     122     25   4.88
##  7 Dash               122     27   4.52
##  8 Howard the Duck     79     18   4.39
##  9 Swarm              196     47   4.17
## 10 Yoda                66     17   3.88
## # … with 724 more rows
```

## `superhero_powers`
Have a quick look at the `superhero_powers` data frame.  

```r
glimpse(superhero_powers)
```

```
## Rows: 667
## Columns: 168
## $ hero_names                   <chr> "3-D Man", "A-Bomb", "Abe Sapien", "Abin …
## $ agility                      <lgl> TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, F…
## $ accelerated_healing          <lgl> FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, FA…
## $ lantern_power_ring           <lgl> FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, …
## $ dimensional_awareness        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ cold_resistance              <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ durability                   <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, T…
## $ stealth                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ flight                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ danger_sense                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ underwater_breathing         <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ marksmanship                 <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ weapons_master               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ power_augmentation           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_attributes            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ longevity                    <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, F…
## $ intelligence                 <lgl> FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FA…
## $ super_strength               <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE…
## $ cryokinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telepathy                    <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ energy_armor                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_blasts                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ duplication                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ size_changing                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ density_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ stamina                      <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FAL…
## $ astral_travel                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ audio_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ dexterity                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnitrix                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ super_speed                  <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FA…
## $ possession                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_oriented_powers       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ weapon_based_powers          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ electrokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ darkforce_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ death_touch                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ teleportation                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ enhanced_senses              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telekinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_beams                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magic                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ hyperkinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ jump                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ clairvoyance                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ dimensional_travel           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ power_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ shapeshifting                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ peak_human_condition         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ immortality                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, F…
## $ camouflage                   <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, …
## $ element_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ phasing                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ astral_projection            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ electrical_transport         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ fire_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ projection                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ summoning                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_memory              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ reflexes                     <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ invulnerability              <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, T…
## $ energy_constructs            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ force_fields                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ self_sustenance              <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, …
## $ anti_gravity                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ empathy                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_nullifier              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radiation_control            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ psionic_powers               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ elasticity                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ substance_secretion          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ elemental_transmogrification <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ technopath_cyberpath         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ photographic_reflexes        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ seismic_power                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animation                    <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, …
## $ precognition                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ fire_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_absorption             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_hearing             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ nova_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ insanity                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ hypnokinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_control               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ natural_armor                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ intangibility                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_sight               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ molecular_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ heat_generation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ adaptation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ gliding                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_suit                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_blast                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ probability_manipulation     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ gravity_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ regeneration                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ light_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ echolocation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ levitation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ toxin_and_disease_control    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ banish                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_manipulation          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ heat_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ natural_weapons              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ time_travel                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_smell               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ illusions                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ thirstokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ hair_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ illumination                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnipotent                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ cloaking                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ changing_armor               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_cosmic                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ biokinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ water_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radiation_immunity           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_telescopic            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ toxin_and_disease_resistance <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ spatial_awareness            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_resistance            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telepathy_resistance         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ molecular_combustion         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnilingualism               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ portal_creation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magnetism                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_control_resistance      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ plant_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sonar                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sonic_scream                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ time_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_touch               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magic_resistance             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ invisibility                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sub_mariner                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ radiation_absorption         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ intuitive_aptitude           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_microscopic           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ melting                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ wind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ super_breath                 <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, …
## $ wallcrawling                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_night                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_infrared              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ grim_reaping                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ matter_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ the_force                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ resurrection                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ terrakinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_heat                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vitakinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radar_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ qwardian_power_ring          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ weather_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_x_ray                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_thermal               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ web_creation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ reality_warping              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ odin_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ symbiote_costume             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ speed_force                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ phoenix_force                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ molecular_dissipation        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_cryo                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnipresent                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omniscient                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
```

14. How many superheros have a combination of accelerated healing, durability, and super strength?

```r
superhero_powers %>% 
  filter(accelerated_healing == TRUE) %>% 
  filter(durability == TRUE) %>% 
  filter(super_strength == TRUE)
```

```
## # A tibble: 97 × 168
##    hero_names   agility accele…¹ lante…² dimen…³ cold_…⁴ durab…⁵ stealth energ…⁶
##    <chr>        <lgl>   <lgl>    <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>  
##  1 A-Bomb       FALSE   TRUE     FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
##  2 Abe Sapien   TRUE    TRUE     FALSE   FALSE   TRUE    TRUE    FALSE   FALSE  
##  3 Angel        TRUE    TRUE     FALSE   FALSE   FALSE   TRUE    TRUE    FALSE  
##  4 Anti-Monitor FALSE   TRUE     FALSE   TRUE    FALSE   TRUE    FALSE   TRUE   
##  5 Anti-Venom   FALSE   TRUE     FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
##  6 Aquaman      TRUE    TRUE     FALSE   FALSE   TRUE    TRUE    TRUE    FALSE  
##  7 Arachne      TRUE    TRUE     FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
##  8 Archangel    TRUE    TRUE     FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
##  9 Ardina       TRUE    TRUE     FALSE   FALSE   TRUE    TRUE    FALSE   FALSE  
## 10 Ares         TRUE    TRUE     FALSE   FALSE   FALSE   TRUE    FALSE   FALSE  
## # … with 87 more rows, 159 more variables: flight <lgl>, danger_sense <lgl>,
## #   underwater_breathing <lgl>, marksmanship <lgl>, weapons_master <lgl>,
## #   power_augmentation <lgl>, animal_attributes <lgl>, longevity <lgl>,
## #   intelligence <lgl>, super_strength <lgl>, cryokinesis <lgl>,
## #   telepathy <lgl>, energy_armor <lgl>, energy_blasts <lgl>,
## #   duplication <lgl>, size_changing <lgl>, density_control <lgl>,
## #   stamina <lgl>, astral_travel <lgl>, audio_control <lgl>, dexterity <lgl>, …
```

## Your Favorite
15. Pick your favorite superhero and let's see their powers!

```r
filter(superhero_powers, hero_names == "Scarlet Witch")
```

```
## # A tibble: 1 × 168
##   hero_…¹ agility accel…² lante…³ dimen…⁴ cold_…⁵ durab…⁶ stealth energ…⁷ flight
##   <chr>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl> 
## 1 Scarle… TRUE    FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   TRUE  
## # … with 158 more variables: danger_sense <lgl>, underwater_breathing <lgl>,
## #   marksmanship <lgl>, weapons_master <lgl>, power_augmentation <lgl>,
## #   animal_attributes <lgl>, longevity <lgl>, intelligence <lgl>,
## #   super_strength <lgl>, cryokinesis <lgl>, telepathy <lgl>,
## #   energy_armor <lgl>, energy_blasts <lgl>, duplication <lgl>,
## #   size_changing <lgl>, density_control <lgl>, stamina <lgl>,
## #   astral_travel <lgl>, audio_control <lgl>, dexterity <lgl>, …
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
