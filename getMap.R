### getMap - wrapper code to functions.R and writes the RAMAS files
# Called using runR.BAT from getRAMAS.py 
# Inputs: n (landscape size) iter (iteration of X) configFile (file for X)

getMap <- function(n,iter,configFile,basePath){
  setwd(basePath)
  # Load functions and libraries 
  source("functions.R")
  library(raster)

  # n file is the location to save basemap B
  nPath <- file.path("data",file.path(paste("n",n,sep = "")))
  nPath <- file.path(basePath,nPath)
  print("hur")
  # the first iteration is going to be obtaining B
  if (iter ==0){  
    print("here")
    ifelse(!dir.exists(nPath), dir.create(nPath), FALSE) 
    BASCFile <- file.path(nPath,paste("B",n,".asc",sep = ""))
    rr_B<- getLandscape(n,NULL) # get B
    writeRaster(rr_B, BASCFile, format="ascii", overwrite = T)# save B as ASC file 
    convertASCtoPTC(nPath,"B",n,NULL) # get PTC
    convertPTCtoPDY_base(nPath,n)# get PDY
    getBatchBaseFile(n,nPath)# get BAT
    
  }
  else{ # for Z
    #iteration path is for each Z/X map and is nested in the B directory
    iterPath <- file.path(nPath,paste("iter",iter,sep = ""))
    ifelse(!dir.exists(iterPath), dir.create(iterPath), FALSE)
    configFile <- file.path(iterPath,configFile)
    
    X<- read.csv(configFile,header = FALSE)   ## configuration solution X
    configuration<- as.numeric(t(X))
    rr_X<- getLandscape(n,configuration) # get X/Z
    writeRaster(rr_X, file.path(iterPath,paste("X",n,"_",iter,".asc",sep = "")), format="ascii", overwrite = T)
    convertASCtoPTC(iterPath,"X",n,iter)
    convertPTCtoPDY(nPath, iterPath,n,iter)
    getBatchFile(n,iter,iterPath)
  }
}

args = commandArgs(trailingOnly=TRUE)
print(args)
n = as.numeric(args[1])
iter = as.numeric(args[2])
configFile = args[3]
basePath = paste(args[4:length(args)],sep = " ",collapse = " ")

## call this file from Python code 
getMap(n,iter,configFile,basePath)
