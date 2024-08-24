# Laden der notwendigen Pakete
library(dplyr)
library(tidyr)
library(stringr)

# Lesen der Datensätze
data_1 <- read.csv("./2021_data_cleaned_ohne_titel.csv", sep=";", stringsAsFactors = FALSE)
data_2 <- read.csv("./age_data1.csv", stringsAsFactors = FALSE)

# Umwandeln der Spalte "Alter" in das Datenformat "Double"
data_2$Alter <- as.double(data_2$Alter)

# Bereinigen der Spaltennamen im ersten Datensatz
colnames(data_1) <- c("Partei", "Name", "ID", "Bezirk", "Kalenderwoche", "Anzahl")

# Entfernen von überflüssigen Leerzeichen aus den Spalten
data_1 <- data_1 %>%
  mutate(across(everything(), str_trim))

# Aufteilen der Spalte "Name" in "Titel", "Nachname" und "Vorname" in beiden Datensätzen
data_1 <- data_1 %>%
  separate(Name, into = c("Nachname", "Vorname"), sep = " ", extra = "merge", fill = "right")

data_2 <- data_2 %>%
  separate(Name, into = c("Titel", "VornameNachname"), sep = " ", extra = "merge", fill = "right") %>%
  separate(VornameNachname, into = c("Vorname", "Nachname"), sep = " ", extra = "merge", fill = "right")

# Zusammenführen der beiden Datensätze auf Basis von "Vorname" und "Nachname"
merged_data <- merge(data_1, data_2, by = c("Vorname", "Nachname"), all = TRUE)

# Entfernen aller Zeilen, die NA-Werte enthalten
merged_data <- merged_data %>%
  drop_na()

# Erstellen einer Liste mit einzigartigen Namen
unique_names <- merged_data %>%
  distinct(Name)

# Vorschau auf die zusammengeführten Daten
head(merged_data)

# Schreiben der zusammengeführten Daten in eine CSV-Datei
write.csv(merged_data, "./merged_data.csv", row.names = FALSE)
