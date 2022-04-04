# Exercise 2. Multilevel Plotting

# Dependencies
pacman::p_load("tidyverse",
               "ggplot2", # package for plotting
               "ggpubr",  # package for arranging plots
               "ragg")    # package for saving plots in hi-def


# Select Wave 5 of WVS
## It is best to compare real incomes in a cross-section because they grow over time
## Wave 5 has many countries and is the most recently available data

# Load data, and subset to wave 5, make sure impinc is numeric
df <- as.data.frame(read_csv(here::here("data", "df.csv"))) %>%
  subset(year > 2004 & year < 2010) %>%
  mutate(inc_real = as.numeric(impinc/1000),
         inc_real = ifelse(inc_real > 60, 60, inc_real)) # recode super high incomes and put in 1,000s

# Figure 3.1 Pooled Scatterplot
agg_png(here::here("figures","fig3.1.png"), res = 144, height = 600, width = 800)
df %>%
  ggplot(aes(y = A170, x = inc_real)) +
  geom_jitter(color = "grey", size = 1, height = 1, width = 1) + # introduce jitter for better visualization
  geom_smooth(method = "lm", se = F, color = "black") +
  stat_regline_equation(label.x=30, label.y = 2, size = 6) +
  labs(x = "Income in 2015 ($k)", y = "Life Satisfaction") +
  theme_classic()
dev.off()

# Figure 3.2 Three Country Comparison Germany, Spain and Zambia

## set up palette
colpal <- c("#482677FF", "#3CBB75FF", "#238A8DFF")

agg_png(here::here("figures","fig3.2.png"), res = 144, height = 800, width = 1000)
ggplot() +
  geom_jitter(data = subset(df, iso3c == "DEU" | iso3c == "ESP" | iso3c == "ZMB"),
              aes(color = iso3c, y = A170, x = inc_real),
              size = 1, height = 1, width = 1, alpha = 0.3, shape = 16) + # introduce jitter for better visualization
  scale_color_manual(values = colpal) +
  # plot Germany line
  geom_smooth(data = subset(df, iso3c == "DEU"), aes(y = A170, x = inc_real),
              color = colpal[1], method = "lm", se = T, size = 2) +
  stat_regline_equation(data = subset(df, iso3c == "DEU"),
                        aes(y = A170, x = inc_real), label.x=46, label.y = 3,
                        color = colpal[1], size = 5) +
  # plot Spain line
  geom_smooth(data = subset(df, iso3c == "ESP"), aes(y = A170, x = inc_real),
              color = colpal[2], method = "lm", se = T, size = 2) +
  stat_regline_equation(data = subset(df, iso3c == "ESP"),
                        aes(y = A170, x = inc_real), label.x=46, label.y = 2.2,
                        color = colpal[2], size = 5) +
  # plot Zambia line
  geom_smooth(data = subset(df, iso3c == "ZMB"), aes(y = A170, x = inc_real),
              color = colpal[3], method = "lm", se = T, size = 2) +
  stat_regline_equation(data = subset(df, iso3c == "ZMB"),
                        aes(y = A170, x = inc_real), label.x=46, label.y = 1.4,
                        color = colpal[3], size = 5) +

  labs(x = "Income in 2015 ($k)", y = "Life Satisfaction", color = "Country") +
  theme_classic() +
  guides(color = guide_legend(override.aes= list(alpha = 1, size = 4))) # override alpha and size for legend
dev.off()




