# Exercise 1. Variance Decomposition

# Dependencies
pacman::p_load("tidyverse",
               "lme4")

# Load data
df <- as.data.frame(read_csv(here::here("data", "df.csv")))

# decompose variance at two levels

## Empty multilevel model
m1 <- lmer(A170 ~ (1|iso3c), data = df)

## extract variance components
m1sum <- as.data.frame(VarCorr(m1))

## calculate rho and make table

m1sum <- m1sum %>%
  select(grp, vcov)

m1sum[3,1] <- "ICC"
m1sum[3,2] <- m1sum$vcov[1]/(m1sum$vcov[1]+m1sum$vcov[2])

# count cases
m1sum$N <- c(length(unique(m1@frame[["iso3c"]])),length(m1@frame[["A170"]]), "")

m1sum$vcov <- round(m1sum$vcov, 3)

write.csv(m1sum, here::here("exercises","exercise1.csv"), row.names = F)
