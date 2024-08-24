# Bibliotheken laden
library(ggplot2)
library(dplyr)

# Daten einlesen
data <- read.csv("./merged_data.csv")

# Daten filtern für Kalenderwochen von 1 bis 34
filtered_data <- data %>%
  filter(Kalenderwoche >= 1 & Kalenderwoche <= 34)

# Durchschnittliche Anzahl pro Kalenderwoche für jede Partei berechnen
average_data <- filtered_data %>%
  group_by(Partei.x, Kalenderwoche) %>%
  summarise(Durchschnitt = mean(Anzahl, na.rm = TRUE))

# Einzelne Plots für jede Partei erstellen und speichern
parteien <- unique(average_data$Partei.x)

for(partei in parteien) {
  partei_data <- average_data %>%
    filter(Partei.x == partei)
  
  p <- ggplot(partei_data, aes(x = Kalenderwoche, y = Durchschnitt)) +
    geom_line() +  # Linie hinzugefügt für Trendvisualisierung
    geom_point() +  # Punkte anzeigen für jede Kalenderwoche
    theme_minimal() +
    labs(title = paste("Durchschnittliche Anzahl pro Kalenderwoche für", partei),
         x = "Kalenderwoche",
         y = "Durchschnittliche Anzahl") +
    scale_x_continuous(breaks = seq(1, 34, 1))  # Kalenderwochen klar anzeigen
  
  print(p)  # Plot anzeigen
  ggsave(paste0("plot_", partei, ".png"), plot = p)  # Plot speichern
}
