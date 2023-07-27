getBaseMap <- function(n,step){
  library(raster)

  
  #### SETTING PATHS
  ## check machine 
  ## set working directory 
  basePath <- r"(C:/Users/cb3452/OneDrive - Drexel University/bbland/bbland-github)"
  setwd(basePath)
  
  ## changes each iteration 
  nPath <- file.path("data",file.path(paste("n",n,sep = "")))
  nPath <- file.path(basePath,nPath)

  ifelse(!dir.exists(nPath), dir.create(nPath), FALSE)

  ### LOADING FUNCTIONS 
  source("functions.R")
  if (step == 1){
    BASCFile <- file.path(nPath,paste("B",n,".asc",sep = ""))
    rr_B<- getLandscape(n,NULL)
    writeRaster(rr_B, BASCFile, format="ascii", overwrite = T)
    convertASCtoPTC(nPath,"B",n,NULL)
    getSpatBatFile(n,nPath)
  }
  else{
    convertPTCtoMP(nPath,n)
    getBBatchFile(n,nPath)
    #shell.exec(file.path(nPath,paste("batch",n,".BAT",sep = "")))
  }

  # cmd <- paste("batch",n,"_getSpatial",".BAT",sep = "")
  # shell.exec(file.path(nPath,cmd))
  
  
}

args = commandArgs(trailingOnly=TRUE)
print(args)
n = as.numeric(args[1])
step = as.numeric(args[2])
# n<-3
# step<-2
getBaseMap(n,step)
