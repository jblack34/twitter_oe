# install and load packages
install.packages("httr")
library(httr)

# URL der API
url <- "https://www.parlament.gv.at/Filter/api/json/post?jsMode=EVAL&FBEZ=WFW_002&listeId=10002&showAll=true

# Senden der GET-Anfrage
response <- GET(url)

# Überprüfen des Statuscodes der Antwort
status_code(response)

# Auslesen des Inhalts der Antwort
content(response, "text")
