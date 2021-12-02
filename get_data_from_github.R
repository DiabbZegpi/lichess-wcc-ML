library(tidyverse)
library(tidymodels)
library(bigchess)
library(httr)

req <- GET("https://api.github.com/repos/michael1241/wcc_analysis/git/trees/master?recursive=1")
stop_for_status(req)
file_list <- unlist(lapply(content(req)$tree, "[", "path"), use.names = FALSE)
file_list <- file_list[str_detect(file_list, "^analysed_pgns/")]

tabular_url <- "https://raw.githubusercontent.com/michael1241/wcc_analysis/master/analysis.csv"
wcc <- read_csv(url) %>% 
  select(-c(`...1`)) %>% 
  janitor::clean_names() 


game_results <- map_dfr(file_list, function(x) {
  paste0("https://raw.githubusercontent.com/michael1241/wcc_analysis/master/", x) %>% 
    read.pgn() %>% 
    select(result = as.character(Result), 
           white_player = as.character(White), 
           black_player = as.character(Black),
           game_number = as.character(Round)) %>% 
    mutate(event = str_remove(x, "^analysed_pgns/")) 
})


wcc %>% select(contains("acpl"))
read.pgn("https://raw.githubusercontent.com/michael1241/wcc_analysis/master/analysed_pgns/lichess_study_1886-world-championship-steinitz-zukertor_by_Lichess_2021.11.29.pgn",
                   stat.moves = FALSE, n.moves = FALSE, extract.moves = 0)
# Columns of interes: Date, Result, White, Black
