install.packages("rvest")
install.packages("dplyr")
library(rvest)
library(dplyr)

# Definiere die URL der Website
url <- "https://www.meineabgeordneten.at/Abgeordnete?gremien%5b%5d=1"

# Lese die HTML-Seite
page <- read_html(url)

# Extrahiere die Vornamen
first_names <- page %>%
  html_nodes(".col-9 .name span[itemprop='http://schema.org/givenName']") %>%
  html_text(trim = TRUE)

# Extrahiere die Nachnamen
last_names <- page %>%
  html_nodes(".col-9 .name span[itemprop='http://schema.org/familyName']") %>%
  html_text(trim = TRUE)

# Extrahiere das Alter
ages <- page %>%
  html_nodes(".col-9 a") %>%
  html_text(trim = TRUE)
ages <- sub(".*, (\\d+),.*", "\\1", ages) # Extrahiere nur die Altersangabe

# Extrahiere die Parteizugehörigkeit
parties <- page %>%
  html_nodes(".col-9 .partei") %>%
  html_text(trim = TRUE)

# Überprüfe die Anzahl der Zeilen in jedem Vektor
length(first_names)
length(last_names)
length(ages)
length(parties)

# Erstelle einen DataFrame mit den extrahierten Daten
if (length(first_names) == length(last_names) && length(last_names) == length(ages) && length(ages) == length(parties)) {
  age_data <- data.frame(
    Vorname = first_names,
    Nachname = last_names,
    Alter = ages,
    Partei = parties,
    stringsAsFactors = FALSE
  )
  
  # Zeige die extrahierten Daten an
  print(age_data)
  
  # Speichere den DataFrame als CSV-Datei
  write.csv(age_data, "age_data1.csv", row.names = FALSE)
} else {
  print("Die Anzahl der extrahierten Vornamen, Nachnamen, Alter und Parteizugehörigkeiten stimmt nicht überein.")
}

