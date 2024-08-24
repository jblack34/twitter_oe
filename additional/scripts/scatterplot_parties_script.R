# Bibliotheken laden
library(ggplot2)
library(dplyr)

# Daten einlesen
data <- read.csv("./merged_data.csv")

# Daten filtern für Kalenderwochen von 1 bis 34
filtered_data <- data %>%
  filter(Kalenderwoche >= 1 & Kalenderwoche <= 34)

# Einzelne Plots für jede Partei erstellen
parteien <- unique(filtered_data$Partei.x)

for(partei in parteien) {
  partei_data <- filtered_data %>%
    filter(Partei.x == partei)
  
  p <- ggplot(partei_data, aes(x = Kalenderwoche, y = Anzahl)) +
    geom_point() +
    theme_minimal() +
    labs(title = paste("Scatterplot für", partei),
         x = "Kalenderwoche",
         y = "Anzahl")
  
  print(p)  # Plot anzeigen
  # Optional: Speichern der Plots
  ggsave(paste0("plot_", partei, ".png"), plot = p)
}

