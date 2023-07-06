library(raster)

getMap <- function(n,seed,configFile){
  
  
  #### SETTING PATHS
  ## check machine 
  platform <- .Platform$OS.type
  if (platform == "unix"){
    OS <- r"(/Users/cassiebuhler/Library/CloudStorage)"
  } else {
    OS <- r"(C:/Users/cb3452)"
  }
  
  #RAMAS is on windows so I'll always use it for those functions 
  windowsPath <- r"(C:/Users/cb3452)"
  
  ## set working directory 
  baseWindowsPath <- r"(OneDrive - Drexel University/bbland/bbland-github)"
  windowsPath<- file.path(windowsPath,baseWindowsPath)
  basePath <- r"(OneDrive-DrexelUniversity/bbland/bbland-github)"
  
  #base path - the machine I'm on 
  basePath <- file.path(OS,basePath)
  setwd(basePath)
  
  ## changes each iteration 
  nPath <- file.path("data",file.path(paste("n",n,sep = "")))
  wnPath <- file.path(windowsPath,nPath)
  wiPath <- file.path(wnPath,paste("iter",seed,sep = ""))
  nPath <- file.path(basePath,nPath)
  iterPath <- file.path(nPath,paste("iter",seed,sep = ""))
  
  ifelse(!dir.exists(nPath), dir.create(nPath), FALSE)
  ifelse(!dir.exists(iterPath), dir.create(iterPath), FALSE)
  
  ### LOADING FUNCTIONS 
  source("functions.R")
  
  
  if (seed == 0){
    ## the initial landscape - values are continuous 
    rr_cont<- getLandscape(n,as.numeric(seed),0,NULL)
    writeRaster(rr_cont, file.path(nPath,paste("cont",n,"_",seed,".asc",sep = "")), format="ascii", overwrite = T)
    convertASCtoPTC(wnPath, nPath,"cont",n,seed)
    getContBatchFile(n,seed,nPath)
    
    
    ## initial map of "preserved" areas 
    rr_bin<- getLandscape(n,as.numeric(seed),1,NULL)
  }
  else{
  configFile <- file.path(iterPath,configFile)
  s<- read.csv(configFile,header = FALSE)
  configuration<- as.numeric(t(s))
  rr_bin<- getLandscape(n,as.numeric(seed),3,configuration)
  }
  writeRaster(rr_bin, file.path(iterPath,paste("binary",n,"_",seed,".asc",sep = "")), format="ascii", overwrite = T)
  convertASCtoPTC(wiPath,iterPath,"binary",n,seed)
  convertPTCtoPDY(wnPath, wiPath,iterPath,n,seed)
  
  getBatchFile(n,seed,iterPath,wiPath)
}


args = commandArgs(trailingOnly=TRUE)
print(args)
n = as.numeric(args[1])
seed = as.numeric(args[2])
configFile = args[3]

getMap(n,seed,configFile)
