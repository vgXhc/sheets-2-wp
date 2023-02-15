library(tidyverse)
library(googlesheets4)
library(here)
library(knitr)


# read responses
responses_mayor <- read_sheet("https://docs.google.com/spreadsheets/d/1T3hQ20IDetkjQ71qj5nZqRiZ8fZ8XHoKDCiUKaIPs9Y/")
responses_council <- read_sheet("https://docs.google.com/spreadsheets/d/1zMTl2BQzQ231SFjN8RRKvZm3PidXSoS2tVDFXSn5AwU/")

questions_council <- colnames(responses_council)

responses_council_long <- responses_council |>
  pivot_longer(cols = 4:ncol(responses_council), 
               names_to = "question", 
               values_to = "answer") |> 
  rename(name = `Your name`,
         district = `Which district are you running for?`) |> 
  mutate(topic = str_extract(question, "^(.*?)\\:"), # everything before the colon
         question = if_else(is.na(topic), question, str_remove(question, topic)))


str_extract(questions_council, "^(.*?)\\:")

questions <- tibble(
  q_label = c("time_stamp",
              "name",
              "last_bus",
              "last_bike",
              "get_around",
              "MABA_vision",
              "MABA_funding",
              "MABA_accessibility",
              "MIFP_preservation",
              "MIFP_affordability",
              "MIFP_zoning",
              "MB_network",
              "MB_climate",
              "MB_policies"),
  q_text = colnames(responses_mayor)
)

responses_mayor_long <- responses_mayor |> pivot_longer(cols = 3:ncol(responses_mayor), names_to = "question", values_to = "answer")

colnames(responses_mayor) <- c("time_stamp",
                               "name",
                               "last_bus",
                               "last_bike",
                               "get_around",
                               "MABA_vision",
                               "MABA_funding",
                               "MABA_accessibility",
                               "MIFP_preservation",
                               "MIFP_affordability",
                               "MIFP_zoning",
                               "MB_network",
                               "MB_climate",
                               "MB_policies")



## render markdown
rmarkdown::render(
  input = "output-template-mayor.Rmd",
  output_file = here("output", paste0(responses_mayor$name, ".html")),
  params = list(
    name = "test"
  ))

render_council <- function(name){
  responses <- responses_council_long |> 
    filter(name == name)
  district <- responses$district[[1]]
  if (!file.exists(here("output", district))){
    dir.create(here("output", district))
  }
  rmarkdown::render(
    input = "output-template-council.Rmd",
    output_file = here("output", district, paste0(name, ".html")),
    params = list(
      name = name,
      district = district
    ))
}

render_council(responses_council$`Your name`[2])

## could combine Rmd files as book chapters




# iterate over list of files
walk(files, write_attachments)


