# Bibliotheken laden
library(ggplot2)
library(dplyr)

# Daten einlesen
data <- read.csv("./merged_data.csv")

# Altersgruppen definieren
data$Altersgruppe <- cut(data$Alter,
                         breaks = c(18, 30, 39, 49, 59, 70),
                         labels = c("18 bis 30", "31 bis 39", "40 bis 49", "50 bis 59", "60 bis 70"),
                         include.lowest = TRUE)

# Daten filtern für Kalenderwochen von 1 bis 34
filtered_data <- data %>%
  filter(Kalenderwoche >= 1 & Kalenderwoche <= 34)

# Durchschnittliche Anzahl pro Kalenderwoche und Altersgruppe berechnen
average_data <- filtered_data %>%
  group_by(Altersgruppe, Kalenderwoche) %>%
  summarise(Durchschnitt = mean(Anzahl, na.rm = TRUE))

# Plot erstellen
p <- ggplot(average_data, aes(x = Kalenderwoche, y = Durchschnitt, color = Altersgruppe)) +
  geom_line() +  # Linienplot für Trends
  geom_point() +  # Punkte für jede Datenpunkt
  theme_minimal() +
  labs(title = "Durchschnittliche Anzahl pro Kalenderwoche nach Altersgruppen",
       x = "Kalenderwoche",
       y = "Durchschnittliche Anzahl",
       color = "Altersgruppe") +
  scale_x_continuous(breaks = seq(1, 34, 1))  # Kalenderwochen klar anzeigen

# Plot anzeigen
print(p)

# Plot speichern
ggsave("Altersgruppen_Analyse.png", plot = p)
