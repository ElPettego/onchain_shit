# install.packages("jsonlite")
# install.packages("hash")

library(jsonlite)
library(hash)

format <- "%Y-%m-%d"
tsv_format <- "%d.%m.%Y"
assetts <- c("btc", "eth")
data_dir <- "data/"
assetts_datasets <- hash()

start_date <- as.Date("2009-01-01")
end_date <- as.Date("2024-06-15")
date_range <- seq(start_date, end_date, by = "day")

ts_to_date <- function(x) as.POSIXct(x)
frmt_date <- function(x) strftime(x, format = format)
cnvrt_date <- function(x) as.Date(x, format = tsv_format)

for (assett in assetts) {
  assett_folder <- sprintf("%s%s", data_dir, assett)

  assett_dataset <- data.frame(Date = date_range)
  for (file in list.files(assett_folder)) {
    extension <- unlist(strsplit(file, split = "\\."))
    # https://stackoverflow.com/questions/10393508/how-to-use-the-switch-statement-in-r-functions
    switch(
      extension[length(extension)],

      json = {
        d <- fromJSON(sprintf("%s/%s", assett_folder, file))
        colnames(d) <- c("Date", "active_addr")
        d["Date"] <- lapply(d["Date"], ts_to_date)
        d["Date"] <- lapply(d["Date"], frmt_date)
        # print(head(d))
        assett_dataset <- merge(assett_dataset, d, by = "Date")
        # print(head(assett_dataset))
      },

      tsv = {
        # print("tsv trapp")
        d <- read.table(sprintf("%s/%s", assett_folder, file), header = TRUE, sep = "\t")
        d["Date"] <- lapply(d["Time"], cnvrt_date)
        d$Time <- NULL
        assett_dataset <- merge(assett_dataset, d, by = "Date")
        # print(head(assett_dataset))
      },

    )
  }
  print(tail(assett_dataset))
  write.csv(assett_dataset, file = sprintf("%s%s_datadet_dbg_r.csv", data_dir, assett), row.names = FALSE)
}
