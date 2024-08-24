# Load necessary libraries
library(dplyr)
library(ggplot2)

# Load the data
data <- read.csv("merged_data_sex.csv", sep = ";")

# Summarize the total count per gender and per calendar week
total_counts <- data %>%
  group_by(Geschlecht, Kalenderwoche) %>%
  summarize(Total_Count = sum(Anzahl))

# Calculate the number of unique individuals per gender
unique_individuals <- data %>%
  group_by(Geschlecht) %>%
  summarize(Unique_Individuals = n_distinct(ID))

# Merge total counts with the number of unique individuals
adjusted_data <- total_counts %>%
  left_join(unique_individuals, by = "Geschlecht") %>%
  mutate(Normalized_Count = Total_Count / Unique_Individuals)

# Define custom colors for genders
gender_colors <- c("männlich" = "blue", "weiblich" = "red")

# Summary of total counts per gender
total_summary <- total_counts %>%
  group_by(Geschlecht) %>%
  summarize(Average_Total_Count = mean(Total_Count))

# Summary of normalized counts per gender
normalized_summary <- adjusted_data %>%
  group_by(Geschlecht) %>%
  summarize(Average_Normalized_Count = mean(Normalized_Count))

# Add summaries as annotations
total_summary_text <- paste(
  "Durchschnittliche Gesamtanzahl (Männlich):", round(total_summary$Average_Total_Count[total_summary$Geschlecht == "männlich"], 2), "\n",
  "Durchschnittliche Gesamtanzahl (Weiblich):", round(total_summary$Average_Total_Count[total_summary$Geschlecht == "weiblich"], 2)
)

normalized_summary_text <- paste(
  "Durchschnittliche Normalisierte Anzahl (Männlich):", round(normalized_summary$Average_Normalized_Count[normalized_summary$Geschlecht == "männlich"], 2), "\n",
  "Durchschnittliche Normalisierte Anzahl (Weiblich):", round(normalized_summary$Average_Normalized_Count[normalized_summary$Geschlecht == "weiblich"], 2)
)

# Plot the total counts per gender as a line plot with specified colors
total_count_plot <- ggplot(total_counts, aes(x = Kalenderwoche, y = Total_Count, color = Geschlecht, group = Geschlecht)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = gender_colors) +
  labs(title = "Gesamtanzahl pro Woche nach Geschlecht",
       x = "Kalenderwoche",
       y = "Gesamtanzahl") +
  theme_minimal() +
  annotate("text", x = Inf, y = Inf, label = total_summary_text, hjust = 1.1, vjust = 1.5, size = 3.5)

# Plot the normalized counts per gender as a line plot with specified colors
normalized_count_plot <- ggplot(adjusted_data, aes(x = Kalenderwoche, y = Normalized_Count, color = Geschlecht, group = Geschlecht)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = gender_colors) +
  labs(title = "Normalisierte Anzahl pro Woche nach Geschlecht",
       x = "Kalenderwoche",
       y = "Normalisierte Anzahl") +
  theme_minimal() +
  annotate("text", x = Inf, y = Inf, label = normalized_summary_text, hjust = 1.1, vjust = 1.5, size = 3.5)

print(total_count_plot)
print(normalized_count_plot)

# Save the plots to files with the specified resolution of 1950x550
ggsave("total_per_week_per_sex.png", plot = total_count_plot, width = 1950, height = 550, units = "px")
ggsave("normalized_per_week_per_sex.png", plot = normalized_count_plot, width = 1950, height = 550, units = "px")

# Print the summaries to the console
print(total_summary)
print(normalized_summary)
