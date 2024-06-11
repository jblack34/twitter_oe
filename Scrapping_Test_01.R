# Benötigte Pakete laden
library(rvest)
library(dplyr)

# Definiere die URL der Website
url <- "https://www.meineabgeordneten.at/Abgeordnete?gremien%5b%5d=1"

# Lese die HTML-Seite
page <- read_html(url)

# Extrahiere die relevanten Daten
raw_data <- page %>% html_nodes(".abgeordneter .name") %>% html_text(trim = TRUE)

# Extrahiere die Namen, Alter und Parteien aus dem Text
extract_details <- function(text) {
  # Name ist alles vor dem ersten Komma
  name <- sub(",.*", "", text)
  
  # Alter ist die Zahl nach dem letzten Komma
  age <- sub(".*, (\\d+),.*", "\\1", text)
  
  # Partei ist der Text nach dem letzten Komma
  party <- sub(".*, (\\d+),\\s+(\\S+)", "\\2", text)
  
  list(name = name, age = age, party = party)
}

# Anwenden der Extraktion auf alle Einträge
details <- lapply(raw_data, extract_details)

# Umwandeln in einen DataFrame
politicians <- do.call(rbind, lapply(details, as.data.frame))
politicians <- as.data.frame(politicians, stringsAsFactors = FALSE)

# Benennen der Spalten
colnames(politicians) <- c("Name", "Alter", "Partei")

# Ausgabe der extrahierten Daten
print(politicians)
