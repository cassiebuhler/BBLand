

getMap <- function(n,iter,configFile){
  library(raster)
  
  #### SETTING PATHS
  ## check machine 
  ## set working directory 
  basePath <- r"(C:/Users/cb3452/OneDrive - Drexel University/bbland/bbland-github)"
  setwd(basePath)
  
  ## changes each iteration 
  nPath <- file.path("data",file.path(paste("n",n,sep = "")))
  nPath <- file.path(basePath,nPath)
  iterPath <- file.path(nPath,paste("iter",iter,sep = ""))
  
  ifelse(!dir.exists(iterPath), dir.create(iterPath), FALSE)
  
  ### LOADING FUNCTIONS 
  source("functions.R")

  ## map of "preserved" areas 
  configFile <- file.path(iterPath,configFile)
  s<- read.csv(configFile,header = FALSE)
  configuration<- as.numeric(t(s))
  rr_X<- getLandscape(n,configuration)
  
  writeRaster(rr_X, file.path(iterPath,paste("X",n,"_",iter,".asc",sep = "")), format="ascii", overwrite = T)
  convertASCtoPTC(iterPath,"X",n,iter)
  convertPTCtoPDY(nPath, iterPath,n,iter)
  
  getBatchFile(n,iter,iterPath)
}


args = commandArgs(trailingOnly=TRUE)
print(args)
n = as.numeric(args[1])
iter = as.numeric(args[2])
configFile = args[3]

# print(n)
# print(iter)
# print(configFile)
# 
# 
# n = 3
# iter = 1
# configFile = "config3_1.txt"
# n = 4
# iter = "h12m56s34" 
# configFile = "config4_h12m56s34.txt"
# n = 20
# iter = 0
# configFile = "NULL"
getMap(n,iter,configFile)
