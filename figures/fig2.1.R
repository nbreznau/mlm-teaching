# Figure 1.2
# Life-satisfaction and income, five countries, fixed v random intercepts

pacman::p_load("tidyverse",
               "ggplot2",
               "ggpubr",
               "ragg",
               "viridis")

df <- as.data.frame(read_csv(here::here("data", "df.csv")))

# create a subset of 5 countries

df_sub <- df %>%
  subset(iso3c %in% c("DEU", "KOR", "IDN", "MEX") & year < 2016)

# regressions for plots
reg <- lm(A170 ~ X047_WVS + factor(iso3c), data = df_sub)
reg2 <- lm(A170 ~ X047_WVS*factor(iso3c), data = df_sub)
reg3 <- lm(A170 ~ X047_WVS + X047_WVS:factor(iso3c), data = df_sub)
reg4 <- lm(A170 ~ X047_WVS, data = df_sub)

colpal <- c("#482677FF", "#3CBB75FF", "#238A8DFF", "#39568CFF")

a <- df_sub %>%
  ggplot(aes(X047_WVS, A170)) +
  geom_jitter(color = "grey", size = 0.8, width = 1, height = 1) +
  geom_abline(intercept = reg4[["coefficients"]][["(Intercept)"]],
              slope = reg4[["coefficients"]][["X047_WVS"]], color = "black", size = 2) +
  labs(title = "A. Fixed-Intercept, Fixed-Coefficient", x = "Income Category", y = "Life Satisfaction") +
  theme_classic()

b <- df_sub %>%
  ggplot(aes(x = X047_WVS, y = A170, color = iso3c)) +
  geom_jitter(color = "grey", size = 0.8, width = 1, height = 1) +
  geom_abline(intercept = c(reg[["coefficients"]][["(Intercept)"]],
                            reg[["coefficients"]][["(Intercept)"]]+reg[["coefficients"]][["factor(iso3c)IDN"]]-.15, # add some space to distinguish the lines
                            reg[["coefficients"]][["(Intercept)"]]+reg[["coefficients"]][["factor(iso3c)KOR"]],
                            reg[["coefficients"]][["(Intercept)"]]+reg[["coefficients"]][["factor(iso3c)MEX"]]),
              slope = reg[["coefficients"]][["X047_WVS"]], color = colpal, size = 2) +
  labs(title = "B. Random-Intercept, Fixed-Coefficient", x = "Income Category", y = "Life Satisfaction", color = "Country") +
  theme_classic()

c <- df_sub %>%
  ggplot(aes(x = X047_WVS, y = A170, color = iso3c)) +
  geom_jitter(color = "grey", size = 0.8, width = 1, height = 1) +
  geom_abline(intercept = reg3[["coefficients"]][["(Intercept)"]],
              slope = c(reg3[["coefficients"]][["X047_WVS"]],
                        reg3[["coefficients"]][["X047_WVS"]]+reg3[["coefficients"]][["X047_WVS:factor(iso3c)IDN"]],
                        reg3[["coefficients"]][["X047_WVS"]]+reg3[["coefficients"]][["X047_WVS:factor(iso3c)KOR"]],
                        reg3[["coefficients"]][["X047_WVS"]]+reg3[["coefficients"]][["X047_WVS:factor(iso3c)MEX"]]), color = colpal, size = 2) +
  labs(title = "C. Fixed-Intercept, Random-Coefficient", x = "Income Category", y = "Life Satisfaction", color = "Country") +
  theme_classic()

d <- df_sub %>%
  ggplot(aes(x = X047_WVS, y = A170, color = iso3c)) +
  geom_jitter(color = "grey", size = 0.8, width = 1, height = 1) +
  geom_abline(intercept = c(reg2[["coefficients"]][["(Intercept)"]],
                            reg2[["coefficients"]][["(Intercept)"]]+reg2[["coefficients"]][["factor(iso3c)IDN"]]-.15, # add some space to distinguish the lines
                            reg2[["coefficients"]][["(Intercept)"]]+reg2[["coefficients"]][["factor(iso3c)KOR"]],
                            reg2[["coefficients"]][["(Intercept)"]]+reg2[["coefficients"]][["factor(iso3c)MEX"]]),
              slope = c(reg2[["coefficients"]][["X047_WVS"]],
                        reg2[["coefficients"]][["X047_WVS"]]+reg2[["coefficients"]][["X047_WVS:factor(iso3c)IDN"]],
                        reg2[["coefficients"]][["X047_WVS"]]+reg2[["coefficients"]][["X047_WVS:factor(iso3c)KOR"]],
                        reg2[["coefficients"]][["X047_WVS"]]+reg2[["coefficients"]][["X047_WVS:factor(iso3c)MEX"]]), color = colpal, size = 2) +
  labs(title = "D. Random-Intercept, Random-Coefficient", x = "Income Category", y = "Life Satisfaction", color = "Country") +
  annotate("rect", ymin = 1, ymax = 4.1, xmin = 7.5, xmax = 10.5, color = "black", fill = "white") +
  annotate("rect", ymin = c(3,2.5,2,1.5), ymax = c(3.2,2.7,2.2,1.7), xmin = c(8,8,8,8), xmax = c(8.2,8.2,8.2,8.2), color = colpal, fill = colpal) +
  annotate("text", y = c(3.7,3.1,2.6,2.1,1.6), x = c(8,8.4,8.4,8.4,8.4), color = c("black",colpal), label = c("Countries", "DEU","IDN", "KOR", "MEX"), hjust = 0) +
  theme_classic()


agg_png(here::here("figures","fig2.1.png"), res = 144, height = 1200, width = 1200)
ggarrange(a,b,c,d, nrow = 2, ncol = 2)
dev.off()
