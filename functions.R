

getLandscape <- function(n,configuration) {
  set.seed(0)
  r <- raster(xmn=0, xmx=n, ymn=0, ymx=n, ncol=n, nrow=n)
  p <- rasterToPolygons(r)
  if (is.null(configuration)){
    #random uniform values - continuous 
    # get base map B
    map <- runif(n*n,min=0,max=1)
  }
  else{
    #get Z from X configuration 
    set.seed(0)
    B <- runif(n*n,min=0,max=1)
    X<- configuration
    map<- X
    map[which(X==1)] <- B[which(X==1)]
  }
  values(r) <- map
  return(r)
} 
catn2 <- function(input) {
  line <- paste(input,"\n",sep = "")
  cat(line)
}

catn <- function(input) {
  if (is.character(input) == 0){
    input <- as.character(input)
  }
  line <- paste(input,"\n",sep = "")
  cat(line)
}

convertASCtoPTC <- function(path,landscapeType,n,iter)
{
  if (is.null(iter)){
    ascFile <- paste(landscapeType,n,".asc",sep = "")
    ptcFile <- file.path(path,paste(landscapeType,n,".ptc",sep = ""))
    inputMapName <- paste(landscapeType,n,sep = "")
    
  }else{
  ascFile <- paste(landscapeType,n,"_",iter,".asc",sep = "")
  ptcFile <- file.path(path,paste(landscapeType,n,"_",iter,".ptc",sep = ""))
  inputMapName <- paste(landscapeType,n,"_",iter,sep = "")
}
  
  genInfoTitle <- inputMapName
  cellLength <- "1.00000"
  
  HSF <- paste("[",inputMapName,"]",sep = "")
  HS_threshold <- "0.50000"
  #HS_threshold <- "0.95000" # higher threshold for larger n 
  neighborhoodDistance <- "1.00000"
  HSF_color <- "Blue"
  HSM_decimals <- 2
  # carryingCapacity <- "ahs*4"
  carryingCapacity <- "ahs*40"
  maxGrowthR <- 1.05
  initAbund <- "ahs*20"
  relFec <- "ahs*1.2"
  relSur <- "ahs*1.2"
  # relFec <- "ahs*2"
  # relSur <- "ahs*2"
  cat1prob <- 0
  cat1mult <- 1
  cat2prob <- 0
  cat2mult <- 1
  cat2mult <- 1
  distanceType <- "Edge to edge"
  
  pathToASCfile <- file.path(path,ascFile)
  pathToASCfile<- gsub("/", "\\\\", pathToASCfile)
  
  inputMap_color <- "Red"
  disp_a <- "0.50"
  disp_b <- "0.80"
  disp_c <- "1.00"
  disp_d <- "1.00"
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
  # file.show(ptcFile)
  
  closeAllConnections()
}



convertPTCtoPDY <- function(BPath, path,n,iter)
{

  
  title <- paste("Z",n,"_",iter,sep = "")
  pdyFile <- file.path(path,paste(title,".pdy",sep = ""))

  mpFile <- file.path(path,paste(title,".mp",sep = ""))
  mpFile<- gsub("/", "\\\\", mpFile)
  t1 <- 1
  t2 <- 10
  kFile<- "pop"
  fFile<- "pop"
  sFile<- "pop"
  XFile <- file.path(path,paste("X",n,"_",iter,".ptc",sep = ""))
  BFile <- file.path(BPath,paste("B",n,".ptc",sep = ""))
  
  XFile<- gsub("/", "\\\\", XFile)
  BFile<- gsub("/", "\\\\", BFile)
  #change1 <- "at mid-point"
  change1 <- "linear"
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
  catn(BFile)
  catn(t1)
  catn(change1)
  catn(change1)
  catn(change1)
  catn(XFile)
  catn(t2)
  catn(change2)
  catn(change2)
  catn(change2)
  sink()
  # file.show(pdyFile)
  closeAllConnections()
  
}


convertPTCtoMP <- function(nPath,n)
{
  library(stringr)
  title <- paste("B",n,sep = "")
  mpFile <- file.path(nPath,paste(title,".mp",sep = ""))
  mpFile<- gsub("/", "\\\\", mpFile)
  ptcFile <- file.path(nPath,paste("B",n,".ptc",sep = ""))
  ptcFile<- gsub("/", "\\\\", ptcFile)
  pt <- read.csv(ptcFile,sep = "\n",header = FALSE)
  pops <- lapply(pt, function (x) {str_extract(x, "Pop")})
  ind <- which(!is.na(pops$V1))
  
  migration_ind  <- lapply(pt, function (x) {str_extract(x, "Migration")})
  migration_ind<- which(!is.na(migration_ind$V1))
  
  reps <- 50
  duration <-100
  init = list()
  sink(mpFile)
  catn("Metapopulation input file (6.0) map=ˇ")
  catn(title)
  cat("\n\n\n\n")
  catn(reps)
  catn(duration)
  catn("TRUE")
  catn("1 FALSE")
  cat("\n\n")
  catn("Local")
  cat("\n")
  catn("not spread")
  catn("0.0000")
  catn("0.0000,0.0000,0.0000,0.0000")
  cat("\n\n")
  catn("Local")
  cat("\n")
  catn("not spread")
  catn("0.0000")
  catn("0.0000,0.0000,0.0000,0.0000")
  catn("False,Zero")
  catn("all vital rates")
  catn("Lognormal,0")
  catn("0.000000")
  catn("count in total")
  catn("1 (F, S, K correlated)")
  catn("No")
  catn("AllStages")
  catn("Yes")
  catn("EX")
  cat("\n\n")
  catn("years")
  catn("OnlyFemale")
  catn("1")
  catn("Monogamous")
  catn("2.0")
  catn("2.0")
  catn("0.0000")
  catn("0")
  for (i in 1:length(ind)){
    catn2(pt$V1[ind[i]])
    p = strsplit(pt$V1[ind[1]],",")
    init[i] = unlist(p)[4]
  }
  catn("Migration")
  catn("FALSE")
  catn(pt$V1[migration_ind+2])
  for (i in 1:length(ind)){
    catn2(strrep(" 0,",length(ind)))
  }
  catn("Correlation")
  catn("TRUE")
  catn2(pt$V1[migration_ind+5])
  catn("1 type(s) of stage matrix")
  catn("default")
  catn("1.000000")
  catn("1.000000")
  catn("0")
  catn("1.000000000")
  catn("1 type(s) of st.dev. matrix")
  catn("default")
  catn("0.000000000")
  catn("Constraints Matrix")
  catn("0.000000")
  catn("1.000000")
  catn("1.000000") 
  catn("1.000000")
  catn("1.000000")
  catn("1.000000")
  for(i in 1:length(ind)){
   catn2(init[i])
  }
  catn("Stage 1")
  catn("1.0")
  catn("FALSE")
  catn("TRUE")
  catn("1.0")
  catn("0 (pop mgmnt)")
  catn("0.0")
  catn("0.0")
  catn("1")
  catn("-End of file-")
  sink()
  # file.show(pdyFile)
  closeAllConnections()
  
}


getBatchFile <- function(n,iter,path)
{
  outPath <- file.path(path,"output")
  ifelse(!dir.exists(outPath), dir.create(outPath), FALSE)
  
  outMetaPath<- file.path(outPath,"metapop")
  ifelse(!dir.exists(outMetaPath), dir.create(outMetaPath), FALSE)

  path_meta <- file.path(path,"output","metapop")

  batFile <- paste("batch",n,"_",iter,".BAT",sep = "")
  batPath <- file.path(path,batFile)
  
  batFile2 <- paste("batch",n,"_",iter,"b.BAT",sep = "")
  batPath2 <- file.path(path,batFile2)
  
  XPTCFile <- paste("X",n,"_",iter,".ptc",sep = "")
  ZPDYfile <- paste("Z",n,"_",iter,".pdy",sep = "")
  
  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"
  RAMAS_hab <- r"("C:\Program Files\RAMAS Multispecies 6\Habdyn.exe")"
  RAMAS_files <- r"("C:\Users\cb3452\Documents\RAMAS Model Files\*.*")"
  line1<- paste('START /WAIT "title"',RAMAS_spatial,XPTCFile,'/RUN=YES /TEX')
  line2<- paste('START /WAIT "title"',RAMAS_hab,ZPDYfile,'/RUN=YES /TEX')

  sink(batPath)
  catn(line1)
  catn(line2)
  sink()
  closeAllConnections()
  
  ZMPfile <- paste("Z",n,"_",iter,".mp",sep = "")
  RAMAS_metapop <- r"("C:\Program Files\RAMAS Multispecies 6\Metapop.exe")"
  line3<- paste('START /WAIT "title"',RAMAS_metapop,ZMPfile,'/RUN=YES /TEX')
  path_meta<- gsub("/", "\\\\", path_meta)
  path_meta<- paste0("\"", path_meta, "\"")
  line4 <- paste("move",RAMAS_files,path_meta)
  
  #CREAT METAPOP 
  sink(batPath2)
  catn(line3)
  catn(line4)
  sink()
  closeAllConnections()
  
  
}

getBBatchFile <- function(n,nPath)
{
  batFile <- paste("batch",n,".BAT",sep = "")
  batPath <- file.path(nPath,batFile)
  mpFile <- paste("B",n,".mp",sep = "")
  RAMAS_metapop <- r"("C:\Program Files\RAMAS Multispecies 6\Metapop.exe")"
  line1<- paste('START /WAIT "title"',RAMAS_metapop,mpFile,'/RUN=YES','/TEX')
  RAMAS_files <- r"("C:\Users\cb3452\Documents\RAMAS Model Files\*.*")"
  nPath<- gsub("/", "\\\\", nPath)
  nPath<- paste0("\"", nPath, "\"")
  line2 <- paste("move",RAMAS_files,nPath)
  
  sink(batPath)
  catn(line1)
  catn(line2)
  sink()
  closeAllConnections()
}

getSpatBatFile <- function(n,path)
{
  batFile <- paste("batch",n,"_getSpatial.BAT",sep = "")
  batPath <- file.path(path,batFile)
  BPTCFile <- paste("B",n,".ptc",sep = "")
  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"
  line<- paste('START /WAIT "title"',RAMAS_spatial,BPTCFile,'/RUN=YES','/TEX')
  sink(batPath)
  catn(line)
  sink()
  closeAllConnections()
}