install.packages("rvest")
install.packages("dplyr")
library(rvest)
library(dplyr)

# Definiere die URL der Website
url <- "https://www.meineabgeordneten.at/Abgeordnete?gremien%5b%5d=1"

# Lese die HTML-Seite
page <- read_html(url)

# Extrahiere die Namen
names <- page %>% html_nodes(".col-9 .name") %>% html_text(trim = TRUE)

# Extrahiere das Alter
ages <- page %>% html_nodes(".col-9 a") %>% html_text(trim = TRUE)
ages <- sub(".*, (\\d+),.*", "\\1", ages) # Extrahiere nur die Altersangabe

# Extrahiere die Parteizugehörigkeit
parties <- page %>% html_nodes(".col-9 .partei") %>% html_text(trim = TRUE)

# Erstelle einen DataFrame mit den extrahierten Daten
politicians1 <- data.frame(
  Name = names,
  Alter = ages,
  Partei = parties,
  stringsAsFactors = FALSE
)

# Zeige die extrahierten Daten an
print(politicians1)

# Speichere den DataFrame als CSV-Datei
write.csv(politicians1, "politicians1.csv", row.names = FALSE)