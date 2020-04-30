# Analyze MLD GS Language Detection
rm(list=ls()); cat("\014") # Clear Workspace and Console
library("cld2"); library("cld3")
library("readr"); library("magrittr")

# 1) Your Code HERE: Load the file names that need to be processed into "files.txt"
files.txt <- c("sentence_ar.txt",
"sentence_cs.txt",
"sentence_da.txt",
"sentence_de.txt",
"sentence_el.txt",
"sentence_en.txt",
"sentence_es.txt",
"sentence_fa.txt",
"sentence_fi.txt",
"sentence_fr.txt",
"sentence_he.txt",
"sentence_hi.txt",
"sentence_hr.txt",
"sentence_hu.txt",
"sentence_id.txt",
"sentence_it.txt",
"sentence_ja.txt",
"sentence_ko.txt",
"sentence_ms.txt",
"sentence_nl.txt",
"sentence_no.txt",
"sentence_pl.txt",
"sentence_pt.txt",
"sentence_ro.txt",
"sentence_ru.txt",
"sentence_sk.txt",
"sentence_sv.txt",
"sentence_th.txt",
"sentence_tr.txt",
"sentence_zh.txt")

fn <- files.txt[1]
Result.DF <- data.frame()
for (ff in 1:length(files.txt)) { 
  fn <- files.txt[ff]
  txt.data <- read_tsv(paste('Data', fn, sep = "/"))
  Lg.Data.Code <- cld2::detect_language(txt.data[[1]]) # Get Language Code
  Lg.Data.Lg <- cld2::detect_language(txt.data[[1]], lang_code = FALSE) # Get Language
  Lg.Data.Code <- Lg.Data.Code[!is.na(Lg.Data.Code)]; Lg.Data.Lg <- Lg.Data.Lg[!is.na(Lg.Data.Lg)]  # Remove NA From Language Code & Language
  
  Predicted.Lg.Code <- names(sort(table(Lg.Data.Code), decreasing=TRUE)[1]) # Find Dominant Language Code 
  Predicted.Lg <- names(sort(table(Lg.Data.Lg), decreasing=TRUE)[1]) # Find Dominant Language 
  
  # 2) Your Code HERE: Extract the language 2 letter code from the file name ()
  GT.Lg <- substr(fn,10,11) # Extract the ground truth Language code from the file name (i.e. get "ar" from "sentence_ar.txt")
  Correct <- GT.Lg == Predicted.Lg.Code
  
  temp1 <- data.frame(GS_Lg_Code=GT.Lg, Pred_Lg_Code=Predicted.Lg.Code, Correct=Correct, Pred_Lg=Predicted.Lg, stringsAsFactors = FALSE)
  Result.DF <- rbind(Result.DF, temp1)
}

knitr::kable(Result.DF) # Display result of Language Detection



