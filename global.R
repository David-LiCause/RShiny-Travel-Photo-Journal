
n <- 5
filler <- matrix("-", nrow = n, ncol = n,
                 dimnames = list(NULL, paste0("V", seq_len(n))))

googlesheets::gs_auth(token = "shiny_app_token.rds")
sheet_key <- NA # string with google sheets key
ss <- googlesheets::gs_key(sheet_key)