pacman::p_load("tidyverse")

wvs <- as.data.frame(read_csv(here::here("data", "wvs.csv")))
vdem <- as.data.frame(read_csv(here::here("data", "vdem.csv")))

df <- left_join(wvs, vdem, by = c("iso3c", "year"))

write_csv(df, here::here("data", "df.csv"))
