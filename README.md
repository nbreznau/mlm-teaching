# Introduction to Multilevel Modeling
## Applications in R, Stata and SPSS

### Contents

#### Exercises



### Requirements

#### Software

The course is taught primarily using R, because it is free and open source. Code for all exercises provided in Stata and SPSS as well.

**R Software**. Ideally with the [R Studio IDE](https://www.rstudio.com/). 

**Stata**. Requires a paid license. Examples herein are provided using [Stata](https://www.stata.com/) version 15. 

**SPSS**. Requires a paid license. Current examples are from previous versions of this course, as I currently don't have a license.

#### Data

The following two sources provide the data for all examples in this study

**World Values Survey (WVS)**

Individual level data for many countries since 1981. Source file [WVS_TimeSeries_1981_2020_ascii_v2_0.csv](https://doi.org/10.14281/18241.15)

Haerpfer, C., Inglehart, R., Moreno, A., Welzel, C., Kizilova, K., Diez-Medrano J., M. Lagos, P. Norris, E. Ponarin & B. Puranen et al. (eds.). 2021. *World Values Survey Time-Series (1981-2020) Cross-National Data-Set*. Madrid, Spain  &  Vienna,  Austria:  JD  Systems  Institute  &  WVSA Secretariat. Data File Version 2.0.0

##### WVS Variables Used

| Variable | Label | Coding |
| -- | -- | -- |
| Life satisfaction | A170 | 1 = dissatisfied |
| Financial satisfaction (household) | C006 | 1 = dissatisfied |
| Important to be rich | A190 | 1 = very much like me |
| Income scale | X047_WVS | 1 = lowest |
| Sex | X001 | 1 = male |
| Age | X003 | In years |
| Education | X025R | 1 = lowest |



**Varieties of Democracy (V-Dem)**

Cross-sectional time-series for most countries of the world. Source file [V-Dem-CY-Full+Others-v12.csv](https://www.v-dem.net/vdemds.html)

Coppedge, Michael, John Gerring, Carl Henrik Knutsen, Staffan I. Lindberg, Jan Teorell, Nazifa Alizada, David Altman, Michael Bernhard, Agnes Cornell, M. Steven Fish, Lisa Gastaldi, Haakon Gjerløw, Adam Glynn, Sandra Grahn, Allen Hicken, Garry Hindle, Nina Ilchenko, Katrin Kinzelbach, Joshua Krusell, Kyle L. Marquardt, Kelly McMann, Valeriya Mechkova, Juraj Medzihorsky, Pamela Paxton, Daniel Pemstein, Josefine Pernes, Oskar Ryd´en, Johannes von Römer, Brigitte Seim, Rachel Sigman, Svend-Erik Skaaning, Jeffrey Staton, Aksel Sundström, Eitan Tzelgov, Yi-ting Wang, Tore Wig, Steven Wilson and Daniel Ziblatt. 2022. *"VDem
[Country–Year/Country–Date] Dataset v12" Varieties of Democracy ([V-Dem](https://doi.org/10.23696/vdemds22)) Project*.

#### Preparation

Both files 'WVS_TimeSeries_1981_2020_ascii_v2_0.csv' and 'V-Dem-CY-Full+Others-v12.csv' are too large to synchronize with GitHub, therefore they need to be downloaded and placed into the folder ../data/source. Then the R code [extract.R](../data/source/extract.R) produces the reduced files 'wvs.csv' and 'vdem.csv'.

These two files are merged with the code [merge_wvs_vdem.R](../data/merge_wvs_vdem.R), and saved as the file [df.csv](../data/df.csv)
