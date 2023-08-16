

getMap <- function(n,iter,configFile){
  library(raster)

  #### SETTING PATHS
  ## set working directory 
  basePath <- r"(C:/Users/cb3452/OneDrive - Drexel University/bbland/bbland-github)"
  setwd(basePath)
  ### LOADING FUNCTIONS 
  source("functions.R")

  nPath <- file.path("data",file.path(paste("n",n,sep = "")))
  nPath <- file.path(basePath,nPath)
  if (iter ==0){  # basecase B
    ifelse(!dir.exists(nPath), dir.create(nPath), FALSE)
    BASCFile <- file.path(nPath,paste("B",n,".asc",sep = ""))
    rr_B<- getLandscape(n,NULL) # get B
    writeRaster(rr_B, BASCFile, format="ascii", overwrite = T)# save B as ASC file 
    convertASCtoPTC(nPath,"B",n,NULL) # get PTC
    convertPTCtoPDY_base(nPath,n)# get PDY
    getBatchBaseFile(n,nPath)# get BAT
    
  }
  else{ # for Z
  iterPath <- file.path(nPath,paste("iter",iter,sep = ""))
  ifelse(!dir.exists(iterPath), dir.create(iterPath), FALSE)

  configFile <- file.path(iterPath,configFile)
  ## read in configuration solution X
  X<- read.csv(configFile,header = FALSE) 
  configuration<- as.numeric(t(X))
  rr_X<- getLandscape(n,configuration) 
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

## call this file from Python code 
getMap(n,iter,configFile)
