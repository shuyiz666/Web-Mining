# Extracting the content from a pdf file
rm(list=ls()); cat("\014") # Clear Workspace and Console
library(pdftools)

pdf.loc <- file.path(getwd(),"PDF Files") # folder "PDF Files" with PDFs
myPDFfiles <- normalizePath(list.files(path = pdf.loc, pattern = "pdf",  full.names = TRUE)) # Get the path (chr-vector) of PDF file names

my.text <- pdf_text(myPDFfiles[1]) # Get the text content from the PDF file
write.table(my.text, file=paste0(pdf.loc,"/text.txt"), quote = FALSE, row.names = FALSE, col.names = FALSE, eol = " " ) # Save as txt file


# Convert to text several pdf files that are contained in a single folder.
convert.PDF <- function(myPDFfiles) {
  for (ff in 1:length(myPDFfiles)) {
    pdf.file <- myPDFfiles[ff]
    my.text <- pdf_text(pdf.file) # Get the text content from the PDF file
    File.Name <- sub(".pdf",".txt",pdf.file)
    write.table(my.text, file=File.Name, quote = FALSE, row.names = FALSE, col.names = FALSE, eol = " " ) # Save as txt file
  }
}

convert.PDF(myPDFfiles)

# Use lapply with in line function to convert each PDF file indexed by "i" into a text file 
lapply(1:length(myPDFfiles),
       function(ff, myPDFfiles)
         {my.text = pdf_text(myPDFfiles[ff]); write.table(my.text, file=sub(".pdf",".txt",myPDFfiles[ff]), 
                                                          quote = FALSE, row.names = FALSE, col.names = FALSE, eol = " " )},
       myPDFfiles)


