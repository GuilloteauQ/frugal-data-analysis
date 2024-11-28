library(tidyverse)

args = commandArgs(trailingOnly=TRUE)
filename_sizes=args[1]
filename_expes=args[2]

df_deps <- read_csv("data/all/sizes_details.csv", col_names = c("size", "dep", "lang"))

df_deps_empty <- df_deps %>% filter(lang == "empty") %>% unique() %>% pull(dep)

df_deps <- df_deps %>% filter(!(dep %in% df_deps_empty))

heavy_packages = df_deps %>% unique() %>% top_n(10, size)

p_deps = df_deps %>% mutate(
    pkg = ifelse(dep %in% heavy_packages$dep, dep, "other"),
    mb = size / 1e6
) %>%
  ggplot(aes(x = lang, y = mb, fill = pkg)) +
  geom_bar(position="stack", stat="identity") +
  theme_bw() +
  labs(x="Language/Libs", y="Dependencies size (Mbyte)") +
  scale_fill_discrete("") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), strip.background = element_blank(), legend.position = "bottom")

ggsave(plot=p_deps, "plot_deps.pdf", width=9, height=6)

df_sizes <- df_deps %>% group_by(lang) %>% summarize(size = sum(size) / 1e6)

df_expes <- read_csv("data/all/expes.csv", col_names = c("bench", "lang", "start", "end")) %>%
  mutate(duration = end - start) %>%
  select(-end, -start) %>%
  group_by(bench, lang) %>%
  summarize(mean_time = mean(duration), bar = 1.96 * sd(duration) / sqrt(n()))

facets.labs <- c("Execution time [s]", "Environment size [byte]")
names(facets.labs) <- c("mean_time", "size")

p_bars <- df_expes %>%
  select(-bar) %>%
  pivot_longer(!c("bench", "lang")) %>%
  ggplot(aes(x = lang, y = value)) + 
  geom_col() +
  geom_errorbar(data = df_expes %>% mutate(name = "mean_time"), aes(y = mean_time, ymin = mean_time - bar, ymax = mean_time + bar)) +
  #facet_grid(name~bench, scales="free_y", labeller=labeller(name = facets.labs)) +
  facet_wrap(~bench) +
  ylab("") + xlab("Languages / Libs") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), strip.background = element_blank())

ggsave(plot=p_bars, "plot_bars.pdf", width=6, height=5)
  
p_pareto <- df_expes %>%
  left_join(df_sizes) %>%
  select(-bar) %>%
  ggplot(aes(x = size, y = mean_time, shape=lang)) + 
  geom_point(size=3)+
  theme_bw() +
  xlim(0, NA) +
  ylim(0, NA) +
  xlab("Environment size [Mbyte]") +
  ylab("Mean execution time [s]") +
  scale_shape_manual("Language / Libs", values=seq(0,15)) +
  facet_wrap(~bench) +
  theme(strip.background = element_blank(), legend.position = "bottom")

ggsave(plot=p_pareto, "plot_pareto.pdf", width=7, height=4)

