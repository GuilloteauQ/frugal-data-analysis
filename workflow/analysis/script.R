library(tidyverse)

args = commandArgs(trailingOnly=TRUE)
filename_sizes=args[1]
filename_expes=args[2]

df_sizes <- read_csv("data/all/sizes.csv", col_names = c("lang", "arch", "size")) %>%
  select(-arch)

df_expes <- read_csv("data/all/expes.csv", col_names = c("bench", "lang", "start", "end")) %>%
  mutate(duration = end - start) %>%
  select(-end, -start) %>%
  group_by(bench, lang) %>%
  summarize(mean_time = mean(duration), bar = 1.96 * sd(duration) / sqrt(n())) %>%
  left_join(df_sizes)

facets.labs <- c("Execution time [s]", "Environment size [byte]")
names(facets.labs) <- c("mean_time", "size")


p_bars <- df_expes %>%
  select(-bar) %>%
  pivot_longer(!c("bench", "lang")) %>%
  ggplot(aes(x = lang, y = value)) + 
  geom_col() +
  geom_errorbar(data = df_expes %>% mutate(name = "mean_time"), aes(y = mean_time, ymin = mean_time - bar, ymax = mean_time + bar)) +
  facet_grid(name~bench, scales="free_y", labeller=labeller(name = facets.labs)) +
  ylab("") + xlab("Languages / Libs") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), strip.background = element_blank())

ggsave(plot=p_bars, "plot_bars.pdf", width=6, height=5)
  
p_pareto <- df_expes %>%
  select(-bar) %>%
  ggplot(aes(x = size, y = mean_time, shape=lang)) + 
  geom_point(size=3)+
  theme_bw() +
  xlim(0, NA) +
  ylim(0, NA) +
  xlab("Environment size [byte]") +
  ylab("Mean execution time") +
  scale_shape_discrete("Language / Libs") +
  theme(strip.background = element_blank(), legend.position = "bottom")

ggsave(plot=p_pareto, "plot_pareto.pdf", width=7, height=4)
