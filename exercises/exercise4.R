# Exercise 4. Understanding Multilevel Components


## RANDOM - INTERCEPTS

pacman::p_load("tidyverse",
               "ggplot2",
               "ggpubr",
               "ragg",
               "lme4", # major multilevel package
               "sjPlot", # for tabulating and visualizing regression results
               "insight") # for extracting variances

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

# Again run m2 and m4 from exercise 2

## Model 2. Random-Intercepts the Multilevel way
m2 <- lmer(A170 ~ inc_real + (1 | iso3c), data = df)

## Model 4. Random-Intercepts the 'old fashioned' way
m4 <- lm(A170 ~ inc_real + factor(iso3c), data = df)

## Tabulate random-intercepts (m2) and dummy-intercepts (m4)
m2_ri <- ranef(m2)

# combine into a dataframe
m2_slopes <- as.data.frame(matrix(nrow = 82, ncol = 3))
colnames(m2_slopes) <- c("iso3c", "intercept", "slope")

# add random-intercepts
m2_slopes[,2] <- as.data.frame(m2_ri[["iso3c"]])

# adjust by the grand-mean intercept
m2_slopes[,2] <- m2_slopes[,2] + summary(m2)[["coefficients"]][1,1]

# add country names
m2_slopes[,1] <- rownames(as.data.frame(m2_ri[["iso3c"]]))

# add slope (same for all)
m2_slopes$slope <- as.numeric(summary(m2)[["coefficients"]][2,1])



# combine into a dataframe
m4_slopes <- as.data.frame(matrix(nrow = 82, ncol = 3))
colnames(m4_slopes) <- c("iso3c", "intercept", "slope")

m4_di <- as.data.frame(summary(m4)[["coefficients"]])

# add reference intercept
m4_slopes[1,2] <- m4_di$Estimate[1]

# add dummy intercepts plus ref
m4_slopes[2:82,2] <- m4_di$Estimate[3:83] + m4_di$Estimate[1]

# add iso3c (close enough)
m4_slopes$iso3c[1] <- "Ref"
m4_slopes$iso3c[2:82] <- rownames(m4_di)[3:83]

# add slope (same for all)
m4_slopes$slope <- m4_di$Estimate[2]


# Plot two versions of random-intercept models
agg_png(here::here("figures","fig3.1a.png"), res = 144, height = 400, width = 1000)
ggplot(m2_slopes) +
  geom_abline(aes(intercept = intercept,
              slope = slope,
              color = factor(iso3c))) +
  xlim(0,60) +
  ylim(0,10) +
  labs(y = "Life Satisfaction", title = "M2. Random-Intercept Multilevel Model") +
  theme_classic() +
  theme(legend.position = "none")
dev.off()

agg_png(here::here("figures","fig3.1b.png"), res = 144, height = 400, width = 1000)
ggplot(m4_slopes) +
  geom_abline(aes(intercept = intercept,
                  slope = slope,
                  color = factor(iso3c))) +
  xlim(0,60) +
  ylim(0,10) +
  labs(y = "Life Satisfaction", x = "Income in 2015 Intl $k", title = "M4. Dummy-Variable OLS Model") +
  theme_classic() +
  theme(legend.position = "none")
dev.off()


## RANDOM-SLOPES

## m3 Random-slopes
m3 <- lmer(A170 ~ inc_real + (1 + inc_real | iso3c), data = df)
m3_re <- ranef(m3)
m3_re1 <- as.data.frame(m3_re[["iso3c"]])
m3_re1$iso3c <- rownames(m3_re1)
colnames(m3_re1) <- c("intercept","inc_slope","iso3c")
m3_re1$intercept <- m3_re1$intercept + summary(m3)[["coefficients"]][1,1]
m3_re1$inc_slope <- m3_re1$inc_slope + summary(m3)[["coefficients"]][2,1]

# add grand-mean regression line to plot
m3_re1[nrow(m3_re1)+1,1:3] <- c(summary(m3)[["coefficients"]][1,1],
                                summary(m3)[["coefficients"]][1,2],
                                "Grand Mean")


m3_re1$intercept <- as.numeric(m3_re1$intercept)
m3_re1$inc_slope <- as.numeric(m3_re1$inc_slope)


## Plot
agg_png(here::here("figures","fig33.png"), res = 144, width = 1000, height = 800)
ggplot() +
  geom_jitter(aes(y = A170, x = inc_real), data = df, size = 0.6, color = "grey", width = 1, height = 1) +
  geom_abline(aes(intercept = intercept, slope = inc_slope, color = iso3c), data = m3_re1) +
  scale_color_viridis_d() +
  geom_abline(intercept = as.numeric(m3_re1$intercept[83]), slope = as.numeric(m3_re1$inc_slope[83]), color = "black", size = 2) +
  labs(y = "Life Satisfaction", x = "Income in 2015 Intl $k") +
  theme_classic() +
  annotate("text", x = 20, y = 4, label = "Grand Mean", fontface= "bold") +
  geom_segment(aes(x = 17, y = 4.2, xend = 14.5, yend = 7.3), arrow = arrow(length = unit(2,'mm'), type = "closed"), size = 1.2) +
  xlim(0,60) +
  ylim(0,10) +
  theme(legend.position = "none")
dev.off()
