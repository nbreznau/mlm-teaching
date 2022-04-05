# Exercise X. Explaining Variance

pacman::p_load("tidyverse",
               "ggplot2",
               "ggpubr",
               "ragg",
               "lme4",
               "sjPlot",
               "insight")

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
         ),
         iso3c_wave = paste(iso3c,wave, sep = "_W"))

#create within and between versions of income
df <- df %>%
  group_by(iso3c_wave) %>%
  mutate(inc_real_b = mean(inc_real), # country-wave mean
         inc_real_w = inc_real - inc_real_b) %>% # mean-centered version
  ungroup()

# set up models
m0 <- lmer(A170 ~ (1 | iso3c), data = df)
m1 <- lmer(A170 ~ (1 | iso3c) + (1 | iso3c_wave), data = df)
m2 <- lmer(A170 ~ inc_real + (1 | iso3c) + (1 | iso3c_wave), data = df)
m3 <- lmer(A170 ~ inc_real_w + inc_real_b + (1 | iso3c) + (1 | iso3c_wave), data = df)
m4 <- lmer(A170 ~ inc_real_w + inc_real_b + (1 | iso3c) + (1 + inc_real_w | iso3c_wave), data = df)

tab_model(m0,m1,m2,m3,m4, show.ci = F, show.loglik = T,
          p.style = c("stars"), show.aic = T,
          file = here::here("results","Tbl_Regression_Second_Round.xls"))

# again, the only way to be able to reimport these results is to open Excel and save the file as Excel,
# otherwise it thinks it is a web file. The alternative is to save as html and then use the package 'webshot'
tab2 <- as.data.frame(readxl::read_xls(here::here("results","Tbl_Regression_Second_Round.xls")))


# make headings
colnames(tab2) <- c("Parameter", "M0", "M1", "M2", "M3", "M4")
tab2$Parameter <- c("Predictors","(Intercept)","Income, total",
                    "Income, within", "Income, between", "Random Components",
                    "Within_res_var", "Between_l2_res_var", "Between_l3_res_var",
                    "Random slope var", "Corr slope var", "ICC (unexplained)", "Country N",
                    "Wave N", "Individual N", "M R2 / C R2", "AIC", "LL",
                    "*p<0.05 **p<0.01 ***p<0.001")

# remove strings from columns
tab2$M0 <- gsub("iso3c", "", tab2$M0)
tab2$M1 <- gsub("iso3c", "", tab2$M1)
tab2$M1 <- gsub("_wave", "", tab2$M1)
tab2$M2 <- gsub("iso3c", "", tab2$M2)
tab2$M2 <- gsub("_wave", "", tab2$M2)
tab2$M3 <- gsub("iso3c", "", tab2$M3)
tab2$M3 <- gsub("_wave", "", tab2$M3)
tab2$M4 <- gsub("iso3c", "", tab2$M4)
tab2$M4 <- gsub("_wave", "", tab2$M4)

# the value for m0 is in the wrong row
tab2[9,2] <- tab2[8,2]
tab2[8,2] <- NA

# create row for df
tab2[nrow(tab2)+1, ] <- c("df", attr(logLik(m0), "df"), attr(logLik(m1), "df"), attr(logLik(m2), "df"), attr(logLik(m3), "df"), attr(logLik(m4), "df"))
# create within/between R2 (variance reduction)
tab2[nrow(tab2)+1, ] <- c("within r2", "0", (as.numeric(tab2[7,2]) - as.numeric(tab2[7,3]))/as.numeric(tab2[7,2]),
                          (as.numeric(tab2[7,2]) - as.numeric(tab2[7,4]))/as.numeric(tab2[7,2]),
                          (as.numeric(tab2[7,2]) - as.numeric(tab2[7,5]))/as.numeric(tab2[7,2]),
                          (as.numeric(tab2[7,2]) - as.numeric(tab2[7,6]))/as.numeric(tab2[7,2]))
tab2[nrow(tab2)+1, ] <- c("between iso3c r2", "0", (as.numeric(tab2[9,2]) - as.numeric(tab2[9,3]))/as.numeric(tab2[9,2]),
                          (as.numeric(tab2[9,2]) - as.numeric(tab2[9,4]))/as.numeric(tab2[9,2]),
                          (as.numeric(tab2[9,2]) - as.numeric(tab2[9,5]))/as.numeric(tab2[9,2]),
                          (as.numeric(tab2[9,2]) - as.numeric(tab2[9,6]))/as.numeric(tab2[9,2]))
tab2[nrow(tab2)+1, ] <- c("between iso3c_wave r2", NA, "0",
                          (as.numeric(tab2[8,3]) - as.numeric(tab2[8,4]))/as.numeric(tab2[8,3]),
                          (as.numeric(tab2[8,3]) - as.numeric(tab2[8,5]))/as.numeric(tab2[8,3]),
                          (as.numeric(tab2[8,3]) - as.numeric(tab2[8,6]))/as.numeric(tab2[8,3]))



# Save table
write.csv(tab2, here::here("results", "Tbl_Regression_Second_Round.csv"), row.names = F)
