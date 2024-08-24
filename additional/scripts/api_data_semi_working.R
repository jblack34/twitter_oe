library(jsonlite)
library(dplyr)
library(purrr)
library(stringr)

# Funktion zum Extrahieren der Daten aus einer JSON-Datei
extract_data <- function(file_path) {
  data <- tryCatch({
    fromJSON(file_path, flatten = TRUE)
  }, error = function(e) return(NULL))
  
  if (is.null(data)) return(tibble(
    FirstName = NA,
    LastName = NA,
    BirthDate = NA,
    Party = NA,
    MandatePeriods = NA
  ))
  
  # Extraktion von Vor- und Nachname
  full_name <- data$content$headingbox$title
  names <- if (!is.null(full_name)) strsplit(full_name, " ")[[1]] else c(NA, NA)
  first_name <- if (length(names) >= 1) names[1] else NA
  last_name <- if (length(names) > 1) names[length(names)] else NA
  
  # Extraktion des Geburtsdatums
  gebtext <- data$content$biografie$kurzbiografie$gebtext
  birth_date <- if (!is.null(gebtext)) str_extract(gebtext, "\\d{2}\\.\\d{2}\\.\\d{4}") else NA
  
  # Partei und Anzahl der Mandatsperioden
  if (!is.null(data$content$banner$mandate) && "wahlpartei_text" %in% names(data$content$banner$mandate[[1]])) {
    party <- data$content$banner$mandate[[1]]$wahlpartei_text
    mandate_periods <- length(data$content$banner$mandate)
  } else {
    party <- NA
    mandate_periods <- NA
  }
  
  # DataFrame zurückgeben
  tibble(
    FirstName = first_name,
    LastName = last_name,
    BirthDate = birth_date,
    Party = party,
    MandatePeriods = mandate_periods
  )
}

# Verzeichnis der JSON-Dateien
file_directory <- "./personendaten"
json_files <- list.files(file_directory, full.names = TRUE, pattern = "\\.json$")

# Daten aus allen Dateien extrahieren
person_data <- map_df(json_files, extract_data)

# DataFrame anzeigen
print(person_data)
