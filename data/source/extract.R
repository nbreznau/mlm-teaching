pacman::p_load("tidyverse",
               "countrycode")

# load WVS data, select only columns of interest (see README for variable labels)
wvs <- read_csv(here::here("data", "source", "WVS_TimeSeries_1981_2020_ascii_v2_0.csv"))[ ,c('COUNTRY_ALPHA', 'S020', 'A170', 'C006', 'A190', 'X047_WVS', 'X001', 'X003', 'X025R')]

# recode negative values to NA
wvs[wvs < 0] <- NA

# drop if life satisfaction is NA
wvs <- subset(wvs, !is.na(A170))

# rename country and year variables for consistency
wvs <- wvs %>%
  mutate(iso3c = COUNTRY_ALPHA,
         year = S020) %>%
  select(iso3c, year, everything()) %>%
  select(-c(COUNTRY_ALPHA, S020))

# save reduced size file
write_csv(wvs, here::here("data", "wvs.csv"))

# load VDem data, select only columns of interest
vdem <- read_csv(here::here("data", "source", "V-Dem-CY-Full+Others-v12.csv"))[ , c('COWcode', 'year', 'e_gdppc')]

# drop years before 1980, recode COW codes into iso3c
vdem <- vdem %>%
  subset(year > 1979) %>%
  mutate(iso3c = countrycode(COWcode, 'cown', 'iso3c')) %>%
  select(iso3c, year, e_gdppc)

# save reduced size file
write_csv(vdem, here::here("data", "vdem.csv"))
