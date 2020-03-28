# Extracting the content from a pdf file
# 1) Install Xpdf
# 2) Test the "pdftotext.exe" installation in a terminal mode
# 3) Run terminal mode command "pdftotext.exe" from R 
# 3.1) Use R to implement terminal mode command

# 4) Use R to extract 

rm(list=ls()); cat("\014") # Clear Workspace and Console

### --- Example 1: Convert to text single pdf files that is contained in a single folder. ----
exe.loc <- Sys.which("pdftotext") # location of "pdftotext.exe"
pdf.loc <- file.path(getwd(),"XPDF Files") # folder "PDF Files" with PDFs
myPDFfiles <- normalizePath(list.files(path = pdf.loc, pattern = "pdf",  full.names = TRUE)) # Get the path (chr-vector) of PDF file names

# Using terminal window system comand: 
# Convert single pdf file to text by placing "" around the chr-vector with PDF file names. Note: how ' is used as escape character arround " 
system(paste(exe.loc, paste0('"', myPDFfiles[1], '"')), wait=FALSE)

### --- Example 3: # Convert to text several pdf files that are contained in a single folder.
# by calling the terminal window system comand:
# 
# Use lapply with in line function to convert each PDF file indexed by "i" into a text file 
lapply(myPDFfiles, function(i) system(paste(exe.loc, paste0('"', i, '"')), wait = FALSE))


