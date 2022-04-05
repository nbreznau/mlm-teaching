# Exercise 3. Likelihood-ratio Test and Model Comparisons

pacman::p_load("tidyverse",
               "lme4", # major multilevel package
               "sjPlot", # for tabulating and visualizing regression results
               "insight") # for exatracting variances



# Load data, and subset to waves 1- 5, because these are the only ones for which we have real income data
# Also remove any missing data & add wave variable back in
df <- as.data.frame(read_csv(here::here("data", "df.csv"))) %>%
  subset(year < 2010 & !is.na(A170) & !is.na(impinc)) %>%
  mutate(inc_real = as.numeric(impinc/1000),
         inc_real = ifelse(inc_real > 60, 60, inc_real),
         wave = case_when(
           year < 1988 ~ "1",
           year > 1987 & year < 1994 ~ "2",
           year > 1993 & year < 1999 ~ "3",
           year > 1998 & year < 2005 ~ "4",
           year > 2004 & year < 2010 ~ "5",
         ))

# Lets have a quick look at countries, years and cases
tab1 <- df %>%
  group_by(iso3c, wave) %>%
  mutate(n = n()) %>%
  select(n) %>%
  summarise_all(mean, na.rm = T) %>%
  ungroup()

# reshape so years are columns
tab1_w <- reshape(as.data.frame(tab1), idvar = "iso3c", timevar = "wave",
        times = c("1", "2", "3", "4", "5"),
        direction = "wide")

colnames(tab1_w) <- c("country (iso3c)", "W1", "W2", "W3", "W4", "W5")

# save as csv
write.csv(tab1_w, here::here("results","tbl_cases_by_country_wave.csv"), row.names = F)

# Set up models for comparison

## Model 1. OLS Regression
m1 <- lm(A170 ~ inc_real, data = df)

## Model 2. Random-Intercepts the Multilevel way
m2 <- lmer(A170 ~ inc_real + (1 | iso3c), data = df)

## Model 3. Random-Intercepts and Slopes
m3 <- lmer(A170 ~ inc_real + (1 + inc_real | iso3c), data = df)

## Model 4. Random-Intercepts the 'old fashioned' way
m4 <- lm(A170 ~ inc_real + factor(iso3c), data = df)

# make a table to compare four regressions
tab_model(m1,m2,m3,m4, show.ci = F, show.loglik = T,
          p.style = c("stars"), show.aic = T,
          file = here::here("results","Tbl_Compare_Regressions.xls"))

# note that you have to open Excel here and re-save the document because Excel and R think it is a webpage
# before proceeding

# extract degrees of freedom
## They are listed next to every coefficient, we only need them once in the table
tab1_out <- as.data.frame(readxl::read_xls(here::here("results", "Tbl_Compare_Regressions.xls")))

# make headings
colnames(tab1_out) <- c("Parameter", "M1 OLS", "M2 RI", "M3 RI RS", "M4 Old Way")


# create rows for df, chi-square and tests
## add df
tab1_out[nrow(tab1_out)+1, ] <- c("df", attr(logLik(m1), "df"), attr(logLik(m2), "df"), attr(logLik(m3), "df"), attr(logLik(m4), "df"))

## see text for chi-square test formula
## It is difference in df to comparison model with diff in LL (times -2) using chi-sq table

tab1_out[nrow(tab1_out)+1, ] <- c("test v m1", NA,
                                  round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 2]) -
                                               as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 3])),
                                         df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 3]) -
                                                 as.numeric(tab1_out[tab1_out$Parameter == "df", 2])), lower.tail = F), 3),
                                  round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 2]) -
                                                     as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 4])),
                                               df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 4]) -
                                                       as.numeric(tab1_out[tab1_out$Parameter == "df", 2])), lower.tail = F), 3),
                                        round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 2]) -
                                                           as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 5])),
                                                     df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 5]) -
                                                             as.numeric(tab1_out[tab1_out$Parameter == "df", 2])), lower.tail = F), 3))
tab1_out[nrow(tab1_out)+1, ] <- c("test v m2", NA, NA,
                                  round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 3]) -
                                                     as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 4])),
                                               df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 4]) -
                                                       as.numeric(tab1_out[tab1_out$Parameter == "df", 3])), lower.tail = F), 3),
                                  round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 3]) -
                                                     as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 5])),
                                               df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 5]) -
                                                       as.numeric(tab1_out[tab1_out$Parameter == "df", 3])), lower.tail = F), 3))
tab1_out[nrow(tab1_out)+1, ] <- c("test v m3", NA, NA, NA,
                                  round(pchisq(-2*(as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 4]) -
                                                     as.numeric(tab1_out[tab1_out$Parameter == "log-Likelihood", 5])),
                                               df = (as.numeric(tab1_out[tab1_out$Parameter == "df", 5]) -
                                                       as.numeric(tab1_out[tab1_out$Parameter == "df", 4])), lower.tail = F), 3))

## Move P-values back to the end of the table
tab1_out[nrow(tab1_out)+1, 1] <- "* p<0.05   ** p<0.01   *** p<0.001"


# remove unnecessary rows
tab1_out <- tab1_out[-96, ]
tab1_out <- tab1_out[2:nrow(tab1_out),]

tab1_out[is.na(tab1_out)] <- ""

# Save table
write.csv(tab1_out, here::here("results", "Tbl_Compare_Regressions.csv"), row.names = F)
