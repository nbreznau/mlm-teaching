pacman::p_load("tidyverse",
               "countrycode",
               "foreign")

# load WVS data, select only columns of interest (see README for variable labels)
wvs <- read_csv2(here::here("data", "source", "WVS_TimeSeries_1981_2022_Csv_v3_0.csv"))[ , c('COUNTRY_ALPHA', 'S020', 'A170', 'C006', 'A190', 'X047_WVS', 'X001', 'X003', 'X025R')]

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

# load adjusted income data from
# Donnelly, Michael J., and Grigore Pop-Eleches. 2018. “Income Measures in Cross-National Surveys: Problems and Solutions*.” Political Science Research and Methods 6(2):355–63. doi: 10.1017/psrm.2016.40.
wvs_inc <- read.dta(here::here("data","source","WVSincomeReplicationData.dta"))

wvs_inc_merge <- wvs_inc %>%
  group_by(conames, year, simpleInc) %>%
  summarise_all(mean, na.rm = T) %>%
  ungroup()

wvs_inc_merge <- wvs_inc_merge %>%
  mutate(iso3c = countrycode(conames, "country.name", "iso3c"),
         iso3c = ifelse(conames == "S Africa", "ZAF", iso3c),
         X047_WVS = simpleInc) %>%
  subset(!is.na(iso3c) & !is.na(impinc)) %>%
  select(iso3c, year, impinc, X047_WVS) %>%
  as.data.frame()

wvs <- left_join(wvs, wvs_inc_merge, by = c("iso3c", "year", "X047_WVS"))

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
