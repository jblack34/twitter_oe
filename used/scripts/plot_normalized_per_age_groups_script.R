# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("merged_data_sex.csv", sep=";")

# Define age groups
data$Altersgruppe <- cut(data$Alter, 
                         breaks = c(18, 30, 39, 49, 59, 70), 
                         labels = c("18 bis 30", "31 bis 39", "40 bis 49", "50 bis 59", "60 bis 70"),
                         right = TRUE)

# Summarize the total amount by age group
summarized_data <- data %>%
  group_by(Altersgruppe) %>%
  summarise(Total_Amount = sum(Anzahl, na.rm = TRUE))

# Plot the total amount by age group
ggplot(summarized_data, aes(x = Altersgruppe, y = Total_Amount, fill = Altersgruppe)) +
  geom_bar(stat = "identity") +
  labs(title = "Gesamtanzahl nach Altersgruppe",
       x = "Altersgruppe",
       y = "Gesamtanzahl") +
  theme_minimal()

# Summarize the total amount per week by age group
weekly_data <- data %>%
  group_by(Kalenderwoche, Altersgruppe) %>%
  summarise(Total_Amount = sum(Anzahl, na.rm = TRUE))

# Plot the weekly amount by age group
ggplot(weekly_data, aes(x = Kalenderwoche, y = Total_Amount, color = Altersgruppe, group = Altersgruppe)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Gesamtanzahl pro Woche nach Altersgruppe",
       x = "Kalenderwoche",
       y = "Gesamtanzahl") +
  theme_minimal()

# Calculate the average amount per week per person for each age group
normalized_data <- data %>%
  group_by(Kalenderwoche, Altersgruppe) %>%
  summarise(Avg_Amount = mean(Anzahl, na.rm = TRUE))

# Calculate the overall average per week for each age group
overall_avg <- normalized_data %>%
  group_by(Altersgruppe) %>%
  summarise(Overall_Avg_Amount = mean(Avg_Amount, na.rm = TRUE))

# Convert the overall averages to a named vector for labeling in the legend
overall_avg_labels <- setNames(paste0(levels(overall_avg$Altersgruppe), " (Durchschn.: ", round(overall_avg$Overall_Avg_Amount, 2), ")"),
                               levels(overall_avg$Altersgruppe))

# Plot the normalized amount per week by age group with the legend showing averages
ggplot(normalized_data, aes(x = Kalenderwoche, y = Avg_Amount, color = Altersgruppe, group = Altersgruppe)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Durchschnittliche Anzahl pro Woche nach Altersgruppe",
       x = "Kalenderwoche",
       y = "Durchschnittliche Anzahl") +
  scale_color_manual(values = scales::hue_pal()(length(overall_avg_labels)), labels = overall_avg_labels) +
  theme_minimal() +
  theme(legend.title = element_blank())  # Optionally remove the legend title
