
library(tidyverse)
library(googlesheets4)
library(here)

# read responses
responses_mayor <- read_sheet("https://docs.google.com/spreadsheets/d/1T3hQ20IDetkjQ71qj5nZqRiZ8fZ8XHoKDCiUKaIPs9Y/")

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

rmarkdown::render(
  input = "output_template_mayor.Rmd",
  output_file = here("output", paste0(responses_mayor$name, ".html")),
  params = list(
    name = "test"
  ))

# extract and save attachments and return paths
write_msg_files <- function(msg_file){
  msg <- read_msg(paste0("data/All Files/", msg_file))
  dir_name <- paste0("output/", msg_file)
  dir.create(dir_name)
  save_attachments(msg_obj = msg, path = dir_name)
  #return path and file names for attachments
  attachment_names <- list.files(dir_name)
  attachment_paths <- paste0(msg_file, "/", attachment_names)
  # contents for output documents
  email <- data_frame(email = msg_file,
                      from = unlist(msg$headers$From),
                      to = unlist(msg$headers$To),
                      cc = unlist(msg$headers$CC),
                      subject = unlist(msg$headers$Subject),
                      date = unlist(msg$headers$Date),
                      body = paste(msg$body$text, collapse = "\n"),
                      attachments = list(attachment_paths))
  
  #render output document
  rmarkdown::render(
    input = "output_template.Rmd",
    output_file = here("output", paste0(msg_file, ".html"))
  )
}


# iterate over list of files
walk(files, write_attachments)

