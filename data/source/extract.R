pacman::p_load("tidyverse")

# load WVS data, select only columns of interest
wvs <- read_csv(here::here("data", "source", "WVS_TimeSeries_1981_2020_ascii_v2_0.csv"))[ ,c('A170', 'C007', 'A190', 'X047')]
