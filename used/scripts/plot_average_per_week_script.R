library(ggplot2)
library(dplyr)

# Daten einlesen
daten <- read.csv("merged_data.csv")

# Durchschnittliche Anzahl pro Kalenderwoche berechnen
daten_aggregiert <- daten %>%
  group_by(Kalenderwoche) %>%
  summarise(Durchschnittliche_Anzahl = mean(Anzahl))

# Plot erstellen
ggplot(daten_aggregiert, aes(x = Kalenderwoche, y = Durchschnittliche_Anzahl)) +
  geom_line() +  # Linie für die visuelle Verbindung der Datenpunkte
  scale_x_continuous(breaks = 1:34, limits = c(1, 34)) +  # X-Achse auf Kalenderwochen von 1 bis 34 beschränken
  labs(x = "Kalenderwoche", y = "Durchschnittliche Anzahl", title = "Durchschnittliche Anzahl an Tweets pro Kalenderwoche") +
  theme_minimal()  # Ein minimalistisches Thema für den Plot
