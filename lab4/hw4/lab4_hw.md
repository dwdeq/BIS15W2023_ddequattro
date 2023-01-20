---
title: "Lab 4 Homework"
author: "Dominic \"DQ\" De Quattro"
date: "2023-01-20"
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

## Data
For the homework, we will use data about vertebrate home range sizes. The data are in the class folder, but the reference is below.  

**Database of vertebrate home range sizes.**  
Reference: Tamburello N, Cote IM, Dulvy NK (2015) Energy and the scaling of animal space use. The American Naturalist 186(2):196-211. http://dx.doi.org/10.1086/682070.  
Data: http://datadryad.org/resource/doi:10.5061/dryad.q5j65/1  

**1. Load the data into a new object called `homerange`.**

```r
homerange <- readr::read_csv("hw4_data/Tamburelloetal_HomeRangeDatabase.csv")
```

```
## Rows: 569 Columns: 24
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (16): taxon, common.name, class, order, family, genus, species, primarym...
## dbl  (8): mean.mass.g, log10.mass, mean.hra.m2, log10.hra, dimension, preyma...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

**2. Explore the data. Show the dimensions, column names, classes for each variable, and a statistical summary. Keep these as separate code chunks.**  

```r
glimpse(homerange)
```

```
## Rows: 569
## Columns: 24
## $ taxon                      <chr> "lake fishes", "river fishes", "river fishe…
## $ common.name                <chr> "american eel", "blacktail redhorse", "cent…
## $ class                      <chr> "actinopterygii", "actinopterygii", "actino…
## $ order                      <chr> "anguilliformes", "cypriniformes", "cyprini…
## $ family                     <chr> "anguillidae", "catostomidae", "cyprinidae"…
## $ genus                      <chr> "anguilla", "moxostoma", "campostoma", "cli…
## $ species                    <chr> "rostrata", "poecilura", "anomalum", "fundu…
## $ primarymethod              <chr> "telemetry", "mark-recapture", "mark-recapt…
## $ N                          <chr> "16", NA, "20", "26", "17", "5", "2", "2", …
## $ mean.mass.g                <dbl> 887.00, 562.00, 34.00, 4.00, 4.00, 3525.00,…
## $ log10.mass                 <dbl> 2.9479236, 2.7497363, 1.5314789, 0.6020600,…
## $ alternative.mass.reference <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ mean.hra.m2                <dbl> 282750.00, 282.10, 116.11, 125.50, 87.10, 3…
## $ log10.hra                  <dbl> 5.4514026, 2.4504031, 2.0648696, 2.0986437,…
## $ hra.reference              <chr> "Minns, C. K. 1995. Allometry of home range…
## $ realm                      <chr> "aquatic", "aquatic", "aquatic", "aquatic",…
## $ thermoregulation           <chr> "ectotherm", "ectotherm", "ectotherm", "ect…
## $ locomotion                 <chr> "swimming", "swimming", "swimming", "swimmi…
## $ trophic.guild              <chr> "carnivore", "carnivore", "carnivore", "car…
## $ dimension                  <dbl> 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3…
## $ preymass                   <dbl> NA, NA, NA, NA, NA, NA, 1.39, NA, NA, NA, N…
## $ log10.preymass             <dbl> NA, NA, NA, NA, NA, NA, 0.1430148, NA, NA, …
## $ PPMR                       <dbl> NA, NA, NA, NA, NA, NA, 530, NA, NA, NA, NA…
## $ prey.size.reference        <chr> NA, NA, NA, NA, NA, NA, "Brose U, et al. 20…
```

```r
names(homerange)
```

```
##  [1] "taxon"                      "common.name"               
##  [3] "class"                      "order"                     
##  [5] "family"                     "genus"                     
##  [7] "species"                    "primarymethod"             
##  [9] "N"                          "mean.mass.g"               
## [11] "log10.mass"                 "alternative.mass.reference"
## [13] "mean.hra.m2"                "log10.hra"                 
## [15] "hra.reference"              "realm"                     
## [17] "thermoregulation"           "locomotion"                
## [19] "trophic.guild"              "dimension"                 
## [21] "preymass"                   "log10.preymass"            
## [23] "PPMR"                       "prey.size.reference"
```


**3. Change the class of the variables `taxon` and `order` to factors and display their levels.** 

```r
homerange$taxon <- as.factor(homerange$taxon)
homerange$order <- as.factor(homerange$order)
```


```r
levels(homerange$taxon)
```

```
## [1] "birds"         "lake fishes"   "lizards"       "mammals"      
## [5] "marine fishes" "river fishes"  "snakes"        "tortoises"    
## [9] "turtles"
```


```r
levels(homerange$order)
```

```
##  [1] "accipitriformes"       "afrosoricida"          "anguilliformes"       
##  [4] "anseriformes"          "apterygiformes"        "artiodactyla"         
##  [7] "caprimulgiformes"      "carnivora"             "charadriiformes"      
## [10] "columbidormes"         "columbiformes"         "coraciiformes"        
## [13] "cuculiformes"          "cypriniformes"         "dasyuromorpha"        
## [16] "dasyuromorpia"         "didelphimorphia"       "diprodontia"          
## [19] "diprotodontia"         "erinaceomorpha"        "esociformes"          
## [22] "falconiformes"         "gadiformes"            "galliformes"          
## [25] "gruiformes"            "lagomorpha"            "macroscelidea"        
## [28] "monotrematae"          "passeriformes"         "pelecaniformes"       
## [31] "peramelemorphia"       "perciformes"           "perissodactyla"       
## [34] "piciformes"            "pilosa"                "proboscidea"          
## [37] "psittaciformes"        "rheiformes"            "roden"                
## [40] "rodentia"              "salmoniformes"         "scorpaeniformes"      
## [43] "siluriformes"          "soricomorpha"          "squamata"             
## [46] "strigiformes"          "struthioniformes"      "syngnathiformes"      
## [49] "testudines"            "tinamiformes"          "tetraodontiformes\xa0"
```


**4. What taxa are represented in the `homerange` data frame? Make a new data frame `taxa` that is restricted to taxon, common name, class, order, family, genus, species.**  

```r
names(homerange)
```

```
##  [1] "taxon"                      "common.name"               
##  [3] "class"                      "order"                     
##  [5] "family"                     "genus"                     
##  [7] "species"                    "primarymethod"             
##  [9] "N"                          "mean.mass.g"               
## [11] "log10.mass"                 "alternative.mass.reference"
## [13] "mean.hra.m2"                "log10.hra"                 
## [15] "hra.reference"              "realm"                     
## [17] "thermoregulation"           "locomotion"                
## [19] "trophic.guild"              "dimension"                 
## [21] "preymass"                   "log10.preymass"            
## [23] "PPMR"                       "prey.size.reference"
```

```r
taxa <- select(homerange,taxon:species)
taxa
```

```
## # A tibble: 569 × 7
##    taxon         common.name             class        order family genus species
##    <fct>         <chr>                   <chr>        <fct> <chr>  <chr> <chr>  
##  1 lake fishes   american eel            actinoptery… angu… angui… angu… rostra…
##  2 river fishes  blacktail redhorse      actinoptery… cypr… catos… moxo… poecil…
##  3 river fishes  central stoneroller     actinoptery… cypr… cypri… camp… anomal…
##  4 river fishes  rosyside dace           actinoptery… cypr… cypri… clin… fundul…
##  5 river fishes  longnose dace           actinoptery… cypr… cypri… rhin… catara…
##  6 river fishes  muskellunge             actinoptery… esoc… esoci… esox  masqui…
##  7 marine fishes pollack                 actinoptery… gadi… gadid… poll… pollac…
##  8 marine fishes saithe                  actinoptery… gadi… gadid… poll… virens 
##  9 marine fishes lined surgeonfish       actinoptery… perc… acant… acan… lineat…
## 10 marine fishes orangespine unicornfish actinoptery… perc… acant… naso  litura…
## # … with 559 more rows
```

**5. The variable `taxon` identifies the large, common name groups of the species represented in `homerange`. Make a table the shows the counts for each of these `taxon`.**  

```r
cbird <- sum(homerange[,1] == "birds")
clfish <- sum(homerange[,1] == "lake fishes")
clizards <- sum(homerange[,1] == "lizards")
cmammals <- sum(homerange[,1] == "mammals")
cmfish <- sum(homerange[,1] == "marine fishes")
crfish <- sum(homerange[,1] == "river fishes")
csnakes <- sum(homerange[,1] == "snakes")
ctortoises <- sum(homerange[,1] == "tortoises")
cturtles <- sum(homerange[,1] == "turtles")
count <- c(cbird,clfish,clizards,cmammals,cmfish,crfish,csnakes,ctortoises,cturtles)
taxon <- levels(homerange$taxon)
cbind(taxon,count)
```

```
##       taxon           count
##  [1,] "birds"         "140"
##  [2,] "lake fishes"   "9"  
##  [3,] "lizards"       "11" 
##  [4,] "mammals"       "238"
##  [5,] "marine fishes" "90" 
##  [6,] "river fishes"  "14" 
##  [7,] "snakes"        "41" 
##  [8,] "tortoises"     "12" 
##  [9,] "turtles"       "14"
```

**6. The species in `homerange` are also classified into trophic guilds. How many species are represented in each trophic guild?**  

```r
homerange$trophic.guild <- as.factor(homerange$trophic.guild)
trophic_guild <- levels(homerange$trophic.guild)
cherb <- sum(homerange[,19] == "herbivore")
ccarn <- sum(homerange[,19] == "carnivore")
amount <- c(cherb,ccarn)
tg_matrix <- cbind(trophic_guild,amount)
tg_matrix
```

```
##      trophic_guild amount
## [1,] "carnivore"   "227" 
## [2,] "herbivore"   "342"
```

**7. Make two new data frames, one which is restricted to carnivores and another that is restricted to herbivores.**

```r
herbivores <- filter(homerange,trophic.guild=="herbivore")
carnivores <- filter(homerange,trophic.guild=="carnivore")
herbivores
```

```
## # A tibble: 227 × 24
##    taxon  commo…¹ class order family genus species prima…² N     mean.…³ log10…⁴
##    <fct>  <chr>   <chr> <fct> <chr>  <chr> <chr>   <chr>   <chr>   <dbl>   <dbl>
##  1 marin… lined … acti… perc… acant… acan… lineat… direct… <NA>   109.     2.04 
##  2 marin… orange… acti… perc… acant… naso  litura… teleme… 8      772.     2.89 
##  3 marin… bluesp… acti… perc… acant… naso  unicor… teleme… 7      152.     2.18 
##  4 marin… redlip… acti… perc… blenn… ophi… atlant… direct… 20       6.2    0.792
##  5 marin… bermud… acti… perc… kypho… kyph… sectat… teleme… 11    1087.     3.04 
##  6 marin… cherub… acti… perc… pomac… cent… argi    direct… <NA>     2.5    0.398
##  7 marin… damsel… acti… perc… pomac… chro… chromis direct… <NA>    28.4    1.45 
##  8 marin… twinsp… acti… perc… pomac… chry… biocel… direct… 18       9.19   0.963
##  9 marin… wards … acti… perc… pomac… poma… wardi   direct… <NA>    10.5    1.02 
## 10 marin… austra… acti… perc… pomac… steg… apical… direct… <NA>    45.3    1.66 
## # … with 217 more rows, 13 more variables: alternative.mass.reference <chr>,
## #   mean.hra.m2 <dbl>, log10.hra <dbl>, hra.reference <chr>, realm <chr>,
## #   thermoregulation <chr>, locomotion <chr>, trophic.guild <fct>,
## #   dimension <dbl>, preymass <dbl>, log10.preymass <dbl>, PPMR <dbl>,
## #   prey.size.reference <chr>, and abbreviated variable names ¹​common.name,
## #   ²​primarymethod, ³​mean.mass.g, ⁴​log10.mass
```

```r
carnivores
```

```
## # A tibble: 342 × 24
##    taxon  commo…¹ class order family genus species prima…² N     mean.…³ log10…⁴
##    <fct>  <chr>   <chr> <fct> <chr>  <chr> <chr>   <chr>   <chr>   <dbl>   <dbl>
##  1 lake … americ… acti… angu… angui… angu… rostra… teleme… 16       887    2.95 
##  2 river… blackt… acti… cypr… catos… moxo… poecil… mark-r… <NA>     562    2.75 
##  3 river… centra… acti… cypr… cypri… camp… anomal… mark-r… 20        34    1.53 
##  4 river… rosysi… acti… cypr… cypri… clin… fundul… mark-r… 26         4    0.602
##  5 river… longno… acti… cypr… cypri… rhin… catara… mark-r… 17         4    0.602
##  6 river… muskel… acti… esoc… esoci… esox  masqui… teleme… 5       3525    3.55 
##  7 marin… pollack acti… gadi… gadid… poll… pollac… teleme… 2        737.   2.87 
##  8 marin… saithe  acti… gadi… gadid… poll… virens  teleme… 2        449.   2.65 
##  9 marin… giant … acti… perc… caran… cara… ignobi… teleme… 4        726.   2.86 
## 10 lake … rock b… acti… perc… centr… ambl… rupest… mark-r… 16       196    2.29 
## # … with 332 more rows, 13 more variables: alternative.mass.reference <chr>,
## #   mean.hra.m2 <dbl>, log10.hra <dbl>, hra.reference <chr>, realm <chr>,
## #   thermoregulation <chr>, locomotion <chr>, trophic.guild <fct>,
## #   dimension <dbl>, preymass <dbl>, log10.preymass <dbl>, PPMR <dbl>,
## #   prey.size.reference <chr>, and abbreviated variable names ¹​common.name,
## #   ²​primarymethod, ³​mean.mass.g, ⁴​log10.mass
```


**8. Do herbivores or carnivores have, on average, a larger `mean.hra.m2`? Remove any NAs from the data.**  

```r
herb_hra.m2 <- colMeans(herbivores[,13])
herb_hra.m2
```

```
## mean.hra.m2 
##    34137012
```

```r
carn_hra.m2 <- colMeans(carnivores[,13])
carn_hra.m2
```

```
## mean.hra.m2 
##    13039918
```

```r
herb_hra.m2 > carn_hra.m2
```

```
## mean.hra.m2 
##        TRUE
```
Herbivores have a higher mean.hra.m2 than carnivores.

**9. Make a new dataframe `deer` that is limited to the mean mass, log10 mass, family, genus, and species of deer in the database. The family for deer is cervidae. Arrange the data in descending order by log10 mass. Which is the largest deer? What is its common name?**  

```r
deer <- filter(select(homerange,mean.mass.g:log10.mass,family:species),family=="cervidae")
deer
```

```
## # A tibble: 12 × 5
##    mean.mass.g log10.mass family   genus      species    
##          <dbl>      <dbl> <chr>    <chr>      <chr>      
##  1     307227.       5.49 cervidae alces      alces      
##  2      62823.       4.80 cervidae axis       axis       
##  3      24050.       4.38 cervidae capreolus  capreolus  
##  4     234758.       5.37 cervidae cervus     elaphus    
##  5      29450.       4.47 cervidae cervus     nippon     
##  6      71450.       4.85 cervidae dama       dama       
##  7      13500.       4.13 cervidae muntiacus  reevesi    
##  8      53864.       4.73 cervidae odocoileus hemionus   
##  9      87884.       4.94 cervidae odocoileus virginianus
## 10      35000.       4.54 cervidae ozotoceros bezoarticus
## 11       7500.       3.88 cervidae pudu       puda       
## 12     102059.       5.01 cervidae rangifer   tarandus
```

```r
filter(deer,deer$mean.mass.g == max(deer$mean.mass.g))
```

```
## # A tibble: 1 × 5
##   mean.mass.g log10.mass family   genus species
##         <dbl>      <dbl> <chr>    <chr> <chr>  
## 1     307227.       5.49 cervidae alces alces
```
#STOPPED WORK HERE.

```r
filter(homerange,homerange$genus=="alces" & homerange$species=="alces")[,2]
```

```
## # A tibble: 1 × 1
##   common.name
##   <chr>      
## 1 moose
```

**10. As measured by the data, which snake species has the smallest homerange? Show all of your work, please. Look this species up online and tell me about it!** **Snake is found in taxon column**    

```r
snakes <- filter(homerange,homerange$taxon=="snakes")
filter(snakes,snakes$log10.hra==min(snakes[,14]))
```

```
## # A tibble: 1 × 24
##   taxon  common…¹ class order family genus species prima…² N     mean.…³ log10…⁴
##   <fct>  <chr>    <chr> <fct> <chr>  <chr> <chr>   <chr>   <chr>   <dbl>   <dbl>
## 1 snakes namaqua… rept… squa… viper… bitis schnei… teleme… 11       17.0    1.23
## # … with 13 more variables: alternative.mass.reference <chr>,
## #   mean.hra.m2 <dbl>, log10.hra <dbl>, hra.reference <chr>, realm <chr>,
## #   thermoregulation <chr>, locomotion <chr>, trophic.guild <fct>,
## #   dimension <dbl>, preymass <dbl>, log10.preymass <dbl>, PPMR <dbl>,
## #   prey.size.reference <chr>, and abbreviated variable names ¹​common.name,
## #   ²​primarymethod, ³​mean.mass.g, ⁴​log10.mass
```
The Namaqua Dwarf Adder is a small snake found in Southern Africa. Its bite is venomous, but its venom isn't strong enough to kill a full grown man. It is possibly one of the smallest vipers on Earth.

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
