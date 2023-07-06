#mapTypes
# 0: initial landscape map
# 1: initial preservation map
# 2: current preservation map
getLandscape <- function(n,seed,mapType,configuration) {
  set.seed(seed)
  r <- raster(xmn=0, xmx=n, ymn=0, ymx=n, ncol=n, nrow=n)
  p <- rasterToPolygons(r)
  if (mapType == 0){
    #random uniform values
    s <- runif(n*n,min=0,max=1)
  }
  else if (mapType == 1){
    #random integers, binary map 
    s <- sample(c(0, 1), n*n, replace=TRUE)
  }
  else{
    s<- configuration
  }
  values(r) <- s
  plot(r, main = "Landscape", legend=FALSE, axes=FALSE, box=FALSE)
  print(r@data@values[1:5]) #sanity check 
  return(r)
} 


catn <- function(input) {
  if (is.character(input) == 0){
    input <- as.character(input)
  }
  line <- paste(input,"\n",sep = "")
  cat(line)
}

convertASCtoPTC <- function(windowsPath, path,landscapeType,n,seed)
{
  ascFile <- paste(landscapeType,n,"_",seed,".asc",sep = "")
  ptcFile <- file.path(path,paste(landscapeType,n,"_",seed,".ptc",sep = ""))
  inputMapName <- paste(landscapeType,n,"_",seed,sep = "")

  
  genInfoTitle <- inputMapName
  cellLength <- "1.00000"
  
  HSF <- paste("[",inputMapName,"]",sep = "")
  HS_threshold <- "0.50000"
  neighborhoodDistance <- "1.00000"
  HSF_color <- "Blue"
  HSM_decimals <- 2
  carryingCapacity <- "ths/25"
  maxGrowthR <- 1.03
  initAbund <- "20*ahs"
  relFec <- 1
  relSur <- 1
  cat1prob <- 0
  cat1mult <- 1
  cat2prob <- 0
  cat2mult <- 1
  cat2mult <- 1
  distanceType <- "Edge to edge"
  
  pathToASCfile <- file.path(windowsPath,ascFile)
  inputMap_color <- "Red"
  disp_a <- "0.50"
  disp_b <- "0.80"
  disp_c <- "1.00"
  disp_d <- "5.00"
  cor_a <- "0.80"
  cor_b <- "2.00"
  cor_c <- "1.00"
  
  ####### printing to file 
  sink(ptcFile)
  catn("Landscape input file (4.1) map=ˇ")
  catn(genInfoTitle)
  cat("\n\n\n\n")
  catn(cellLength)
  catn(HSF)
  cat("\n")
  catn(HS_threshold)
  catn(neighborhoodDistance)
  catn(paste(HSF_color,"False",sep = ","))
  catn(HSM_decimals)
  catn(carryingCapacity)
  catn(maxGrowthR)
  catn(initAbund)
  catn(relFec)
  catn(relSur)
  cat("\n\n")
  catn(cat1prob)
  catn(cat1mult)
  catn(cat2prob)
  catn(cat2mult)
  catn("No")
  cat("\n")
  catn(distanceType)
  catn(1)
  catn(inputMapName)
  catn(pathToASCfile)
  catn("ARC/INFO,ConstantMap")
  catn(inputMap_color)
  catn(n)
  # CE (CEILING) BH (CONTEST) LO (SCRAMBLE)
  catn(",0.000,0.000,,CE,,,0.0,0.0,,0.0,1,0,TRUE,1,1,1,0.0,1,0,1,0,0,0,1.0,")
  catn("Migration")
  catn("TRUE")
  catn(paste(disp_a, disp_b, disp_c, disp_d,sep = ","))
  catn("Correlation")
  catn("TRUE")
  catn(paste(cor_a, cor_b, cor_c,sep = ","))
  cat("-End of file-")
  sink()
  file.show(ptcFile)
  
  closeAllConnections()
}



convertPTCtoPDY <- function(wcontPath,wpath, path,n,seed)
{
  title <- paste("both",n,"_",seed,sep = "")
  pdyFile <- file.path(path,paste(title,".pdy",sep = ""))

  mpFile <- file.path(wpath,paste(title,".mp",sep = ""))
  t1 <- 1
  t2 <- 100
  kFile<- "pop"
  fFile<- "pop"
  sFile<- "pop"
  binFile <- file.path(wpath,paste("binary",n,"_",seed,".ptc",sep = ""))
  contFile <- file.path(wcontPath,paste("cont",n,"_",seed,".ptc",sep = ""))
  change1 <- "same until next"
  change2<- "linear"
  
  sink(pdyFile)
  catn("Habitat Dynamics (version 4.1)")
  catn(title)
  cat("\n\n\n\n")
  catn(mpFile)
  catn(kFile)
  catn(fFile)
  catn(sFile)
  catn("2")
  catn(contFile)
  catn(t1)
  catn(change1)
  catn(change1)
  catn(change1)
  catn(binFile)
  catn(t2)
  catn(change2)
  catn(change2)
  catn(change2)
  sink()
  file.show(pdyFile)
  closeAllConnections()
  
}


getBatchFile <- function(n,seed,path)
{
  
  batFile <- paste("batch",n,"_",seed,".BAT",sep = "")
  batPath <- file.path(path,batFile)
  binPTCFile <- paste("binary",n,"_",seed,".ptc",sep = "")
  bothPDYfile <- paste("both",n,"_",seed,".pdy",sep = "")
  bothMPfile <- paste("both",n,"_",seed,".mp",sep = "")
  
  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"
  RAMAS_hab <- r"("C:\Program Files\RAMAS Multispecies 6\Habdyn.exe")"
  RAMAS_metapop <- r"("C:\Program Files\RAMAS Multispecies 6\Metapop.exe")"
  
  line1<- paste('START /WAIT "title"',RAMAS_spatial,binPTCFile,'/RUN=YES /TEX')
  line2<- paste('START /WAIT "title"',RAMAS_hab,bothPDYfile,'/RUN=YES /TEX')
  line3<- paste('START /WAIT "title"',RAMAS_spatial,bothMPfile,'/RUN=YES /TEX')
  
  sink(batPath)
  catn(line1)
  catn(line2)
  catn(line3)
  sink()
  file.show(batPath)
  closeAllConnections()
}

getContBatchFile <- function(n,seed,path)
{
  batFile <- paste("batch",n,".BAT",sep = "")
  batPath <- file.path(path,batFile)
  contPTCFile <- paste("cont",n,"_",seed,".ptc",sep = "")

  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"

  line<- paste('START /WAIT "title"',RAMAS_spatial,contPTCFile,'/RUN=YES','/TEX')

  sink(batPath)
  catn(line)
  sink()
  file.show(batPath)
  closeAllConnections()
}