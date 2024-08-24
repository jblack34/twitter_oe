# Load necessary libraries
library(dplyr)
library(ggplot2)

# Load the data
data <- read.csv("merged_data_sex.csv", sep = ";")

# Summarize the total count per calendar week and party
total_counts <- data %>%
  group_by(Kalenderwoche, Partei.x) %>%
  summarize(Total_Count = sum(Anzahl))

# Calculate the number of unique individuals per party
unique_individuals <- data %>%
  group_by(Partei.x) %>%
  summarize(Unique_Individuals = n_distinct(ID))

# Merge total counts with the number of unique individuals per party
adjusted_data <- total_counts %>%
  left_join(unique_individuals, by = "Partei.x") %>%
  mutate(Normalized_Count = Total_Count / Unique_Individuals)

# Define custom colors for the parties
party_colors <- c("ÖVP" = "black", "FPÖ" = "blue", "NEOS" = "pink", "SPÖ" = "red", "GRÜNE" = "green")

# Summary of total counts per party
total_summary <- total_counts %>%
  group_by(Partei.x) %>%
  summarize(Average_Total_Count = mean(Total_Count))

# Summary of normalized counts per party
normalized_summary <- adjusted_data %>%
  group_by(Partei.x) %>%
  summarize(Average_Normalized_Count = mean(Normalized_Count))

# Add summaries as annotations
total_summary_text <- paste(
  "Durchschnittliche Gesamtanzahl pro Partei:", 
  paste(unique(total_summary$Partei.x), 
        round(total_summary$Average_Total_Count, 2), 
        sep = ": ", 
        collapse = "\n")
)

normalized_summary_text <- paste(
  "Durchschnittliche Normalisierte Anzahl pro Partei:", 
  paste(unique(normalized_summary$Partei.x), 
        round(normalized_summary$Average_Normalized_Count, 2), 
        sep = ": ", 
        collapse = "\n")
)

# Plot the total counts per party as a line plot
total_count_plot <- ggplot(total_counts, aes(x = Kalenderwoche, y = Total_Count, color = Partei.x, group = Partei.x)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = party_colors) +
  labs(title = "Gesamtanzahl pro Woche nach Partei",
       x = "Kalenderwoche",
       y = "Gesamtanzahl") +
  theme_minimal() +
  annotate("text", x = Inf, y = Inf, label = total_summary_text, hjust = 1.1, vjust = 1.5, size = 3.5)

# Plot the normalized counts per party as a line plot
normalized_count_plot <- ggplot(adjusted_data, aes(x = Kalenderwoche, y = Normalized_Count, color = Partei.x, group = Partei.x)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = party_colors) +
  labs(title = "Normalisierte Anzahl pro Woche nach Partei",
       x = "Kalenderwoche",
       y = "Normalisierte Anzahl") +
  theme_minimal() +
  annotate("text", x = Inf, y = Inf, label = normalized_summary_text, hjust = 1.1, vjust = 1.5, size = 3.5)

print(total_count_plot)
print(normalized_count_plot)

# Save the plots to files with the specified resolution of 1950x550
ggsave("total_per_week_per_party.png", plot = total_count_plot, width = 1950, height = 550, units = "px")
ggsave("normalized_per_week_per_party.png", plot = normalized_count_plot, width = 1950, height = 550, units = "px")

# Print the summaries to the console
print(total_summary)
print(normalized_summary)
