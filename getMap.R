library(raster)

getMap <- function(n,seed,configuration){
  
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
  basePath <- r"(OneDrive-DrexelUniversity/bbland/bbland-github)"
  windowsPath<- file.path(windowsPath,basePath)
  
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
    
    ## initial map of "preserved" areas 
    rr_bin<- getLandscape(n,as.numeric(seed),1,NULL)
  }
  else{
  rr_bin<- getLandscape(n,as.numeric(seed),3,configuration)
  }
  writeRaster(rr_bin, file.path(iterPath,paste("binary",n,"_",seed,".asc",sep = "")), format="ascii", overwrite = T)
  convertASCtoPTC(wiPath,iterPath,"binary",n,seed)
  convertPTCtoPDY(wnPath, wiPath,iterPath,n,seed)
  
  getBatchFile(n,seed,wnPath,wiPath,iterPath)
}

getMap(n = 10,seed = 0,configuration = NULL)
