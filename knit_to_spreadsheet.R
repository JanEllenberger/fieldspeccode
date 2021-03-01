#PATH FOR WRITETABLE HAS TO BE SET BEFORE RUNNING THE CODE
#NOTE: All FieldSpec raw data has to be exported as ASCII files WITH header. 
#The "skip = 40" command will terminate correct data import into R, if the header is missing.
#Calculated Indices: NDVI, ARI, WI, NDWI, PSSRa, PSSRb, SIPI, ChlNDI, mSR, mND, NDopt, [to be continued]


files <- list.files(#path = "C:/Users/XYZ/",
                    full.names = TRUE, pattern = "Example")
#path: The folder where the FS raw-data is stored (not used here, as we want to use the example files from this repository)
#pattern: Part of the filename; files without the pattern will be ignored 
#(useful to select a subset e.g. data from one day only)

for (i in seq_along(files)) {
  
  assign(paste("T",i-1,sep=""), read.table(files[i], header = TRUE, sep = "\t", skip = 40))
  
}

#Adds FieldSpec raw data to R environment

COMBWITHWAVELENGTH <- T0

for(i in 1:(length(files)-1)){
  
  COMBWITHWAVELENGTH <-  cbind(COMBWITHWAVELENGTH,get(paste("T",i,sep="")))
  
}

COMBONOWAVELENGTH <- COMBWITHWAVELENGTH[,c(2*1:(length(files)))]
#delete every second column, so that all the useless wavelength information gets lost
#length(files) is the number of files
row.names(COMBONOWAVELENGTH) <- 350:2500
#re-add wavelength (once!) as row names
ARI <- ((1/COMBONOWAVELENGTH["550",])-(1/COMBONOWAVELENGTH["700",]))
#calculate the AR Index
row.names(ARI) <- "ARI"
#label the AR Index
NDVI <- ((COMBONOWAVELENGTH["800",]-COMBONOWAVELENGTH["670",])/(COMBONOWAVELENGTH["800",]+COMBONOWAVELENGTH["670",]))
#calculate the NDV Index...
row.names(NDVI) <- "NDVI"
#...and label it
#keep adding and labeling all kind of indices in the same way as ARI and NDVI 
NDWI <- ((COMBONOWAVELENGTH["857",]-COMBONOWAVELENGTH["1241",])/(COMBONOWAVELENGTH["857",]+COMBONOWAVELENGTH["1241",]))
row.names(NDWI) <- "NDWI"
PSSRa <- (COMBONOWAVELENGTH["800",]/COMBONOWAVELENGTH["680",])
row.names(PSSRa) <- "PSSRa"
PSSRb <- (COMBONOWAVELENGTH["800",]/COMBONOWAVELENGTH["635",])
row.names(PSSRb) <- "PSSRb"
WI <- (COMBONOWAVELENGTH["900",]/COMBONOWAVELENGTH["970",])
row.names(WI) <- "WI"
SIPI <- ((COMBONOWAVELENGTH["800",]-COMBONOWAVELENGTH["445",])/(COMBONOWAVELENGTH["800",]-COMBONOWAVELENGTH["680",]))
row.names(SIPI) <- "SIPI"
ChlNDI <- ((COMBONOWAVELENGTH["750",]-COMBONOWAVELENGTH["705",])/(COMBONOWAVELENGTH["750",]+COMBONOWAVELENGTH["705",]))
row.names(ChlNDI) <- "ChlNDI"
mSR <- ((COMBONOWAVELENGTH["728",]-COMBONOWAVELENGTH["434",])/(COMBONOWAVELENGTH["720",]-COMBONOWAVELENGTH["434",]))
row.names(mSR) <- "mSR"
mND <- ((COMBONOWAVELENGTH["728",]-COMBONOWAVELENGTH["720",])/(COMBONOWAVELENGTH["728",]+COMBONOWAVELENGTH["720",]-2*COMBONOWAVELENGTH["434",]))
row.names(mND) <- "mND"
NDopt <- ((COMBONOWAVELENGTH["780",]-COMBONOWAVELENGTH["712",])/(COMBONOWAVELENGTH["780",]+COMBONOWAVELENGTH["712",]))
row.names(NDopt) <- "NDopt"
NDLI <- ((log10(1/COMBONOWAVELENGTH["1754",])-log10(1/COMBONOWAVELENGTH["1680",]))/
           ((log10(1/COMBONOWAVELENGTH["1754",])+log10(1/COMBONOWAVELENGTH["1680",]))))
row.names(NDLI) <- "NDLI"
CAI <- (.5*(COMBONOWAVELENGTH["2000",]+COMBONOWAVELENGTH["2200",])-COMBONOWAVELENGTH["2100",])
row.names(CAI) <- "CAI"
FLV <- ((1-COMBONOWAVELENGTH["420",])-(1-COMBONOWAVELENGTH["710",]))
row.names(FLV) <- "FLV"
AssignColumn <- c(0:(length(files)-1))

FINALTABLE <- t(rbind(files,AssignColumn,NDVI,ARI,WI,NDWI,PSSRa,PSSRb,SIPI,ChlNDI,mSR,mND,NDopt,NDLI,CAI,FLV,COMBONOWAVELENGTH))
#cbinds all the indices with each other and with the raw reflection and transponds the whole dataset

write.table(FINALTABLE, 
            #file = "C:/Users/XYZ/table.txt", 
            sep = "\t", row.names = FALSE, col.names = TRUE)
#writes the table with a column for data assignment, several columns with indices and all the raw reflection data as .txt file

#file: The folder where the new .txt file is stored (not used here, has to be set to save the file on your computer).

