# Libraries -----
library(ggplot2)
library(dplyr)
library(arrow)

# Data import ----
activity_df <- read_parquet("/Users/fabiothon/Desktop/Code/SBB_activity/passagierfrequenz.parquet")
# head(activity_df)
# print(activity_df, n = 50)
# nrow(activity_df)
# ncol(activity_df)
# colnames(activity_df)
# str(activity_df)

# Data transformation ----
df_2018 <- activity_df %>%
  filter(format(jahr_annee_anno, "%Y") == "2018") %>%
  arrange(desc(dtv_tjm_tgm)) %>%
  slice_head(n = 15) %>%
  mutate(year = "2018")

df_2022 <- activity_df %>%
  filter(format(jahr_annee_anno, "%Y") == "2022") %>%
  arrange(desc(dtv_tjm_tgm)) %>%
  slice_head(n = 15)%>%
  mutate(year = "2022")

df_2023 <- activity_df %>%
  filter(format(jahr_annee_anno, "%Y") == "2023") %>%
  arrange(desc(dtv_tjm_tgm)) %>%
  slice_head(n = 15) %>%
  mutate(year = "2023")

df_together <- bind_rows(df_2018, df_2022, df_2023)

# Visualisation ----
df_together %>%
  ggplot(aes(x = reorder(bahnhof_gare_stazione, dtv_tjm_tgm, decreasing = TRUE), y = dtv_tjm_tgm, fill = year)) +
  geom_bar(stat = "identity", position = "dodge") +
  ggtitle("Top 15 Swiss train stations based on boardings and alightings") +
  ylab("Average daily traffic") +
  xlab("Train stations") +
  scale_y_continuous(labels = scales::label_comma()) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
        