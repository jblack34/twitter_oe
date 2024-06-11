# Benötigte Pakete laden
library(httr)
library(jsonlite)

# Definiere die URL
url <- "https://www.parlament.gv.at/Filter/api/json/post?jsMode=EVAL&FBEZ=WFW_002&listeId=10002&showAll=true"

# Definiere den Body der Anfrage als JSON
body <- toJSON(list(
  M = list("M"),
  W = list("W"),
  WK = list("F7")
), auto_unbox = TRUE)

# Sende die POST-Anfrage mit dem JSON-Body
response <- POST(url, body = body, encode = "json", content_type_json())

# Überprüfe den Statuscode der Antwort
if (status_code(response) == 200) {
  # Parse den Inhalt der Antwort als Text
  content <- content(response, "text", encoding = "UTF-8")
  
  # Ausgabe der Antwort
  print(content)
} else {
  print(paste("Fehler: ", status_code(response)))
  print(content(response, "text", encoding = "UTF-8"))
}

