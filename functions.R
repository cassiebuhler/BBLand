### This file consists of all the functions used in getMap.R

# getLandscape: Converting the values into rasters to save as ASC
# Inputs: X (configuration), and nxn landscape size
# Output: B (base habitat) or Z (new habitat)
getLandscape <- function(n,X) {
  set.seed(0) 
  r <- raster(xmn=0, xmx=n, ymn=0, ymx=n, ncol=n, nrow=n) #generate blank raster
  B <- runif(n*n,min=0,max=1)  #get habitat values for B 
  if (is.null(X)){
    values(r) <- B #assign base habitat to raster 
  }
  else{#get Z from X configuration 
    Z<- X
    Z[which(X==1)] <- B[which(X==1)] #only preserving parcels denoted by X
    values(r) <- Z #assign new habitat to raster 
  }
  return(r) 
} 

#catn: Adding newline to a string 
# Input: A string or value. Doesn't matter, it's converted to a string
# Output: String with \n appended at end 
catn <- function(input) {
  if (is.character(input) == 0){ #convert inputs to characters 
    input <- as.character(input)
  }
  line <- paste(input,"\n",sep = "") #add a newline 
  cat(line)
}

# convertASCtoPTC - Converting text format ASC to RAMAS Spatial Data format PTC 
# RAMAS Spatial Data only allows very specific file formats. We opted with 
# ASC since it's a text file and is easy to generate
# Inputs: path: file path to save to, landscapeType: B or Z, n: landscape size, iter: iteration of configuration X
# Output: PTC files for B or Z
convertASCtoPTC <- function(path,landscapeType,n,iter)
{
  if (is.null(iter)){ # using B 
    ascFile <- paste(landscapeType,n,".asc",sep = "")
    ptcFile <- file.path(path,paste(landscapeType,n,".ptc",sep = ""))
    inputMapName <- paste(landscapeType,n,sep = "")
    
  }else{ # using Z
  ascFile <- paste(landscapeType,n,"_",iter,".asc",sep = "")
  ptcFile <- file.path(path,paste(landscapeType,n,"_",iter,".ptc",sep = ""))
  inputMapName <- paste(landscapeType,n,"_",iter,sep = "")
}
  
  
  # THIS IS WHERE YOU CAN SPECIFY POPULATION PARAMETERS. 
  genInfoTitle <- inputMapName
  cellLength <- "1.00000"
  
  HSF <- paste("[",inputMapName,"]",sep = "")
  HS_threshold <- "0.50000"
  
  neighborhoodDistance <- "1.00000"
  HSF_color <- "Blue"
  HSM_decimals <- 2
  maxGrowthR <- 1.5
  
  # ths = total habitat suitability 
  carryingCapacity <- "ths*4"
  initAbund <- "ths*2"
  relFec <- "max(1,ths*1.2)"
  relSur <- "max(1,ths*1.2)"

  #catastrophe probability
  cat1prob <- 0
  cat1mult <- 1
  cat2prob <- 0
  cat2mult <- 1
  cat2mult <- 1
  distanceType <- "Edge to edge"
  
  pathToASCfile <- file.path(path,ascFile)
  pathToASCfile<- gsub("/", "\\\\", pathToASCfile)
  
  inputMap_color <- "Red" 
  #Dispersal 
  disp_a <- "0.50"
  disp_b <- "0.80"
  disp_c <- "1.00"
  disp_d <- "1.00"
  #Correlation  
  cor_a <- "0.80"
  cor_b <- "2.00"
  cor_c <- "1.00"
  
  ####### printing to file 
  # the following lines are written to match the exact format of PTC
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
  # CE (CEILING) BH (CONTEST) LO (SCRAMBLE) # these are the different density types 
  #catn(",0.000,0.000,,CE,,,0.0,0.0,,0.0,1,0,TRUE,1,1,1,0.0,1,0,1,0,0,0,1.0,")
  catn(",0.000,0.000,,LO,,,0.0,0.0,,0.0,1,0,TRUE,1,1,1,0.0,1,0,1,0,0,0,1.0,")
  
  catn("Migration")
  catn("TRUE")
  catn(paste(disp_a, disp_b, disp_c, disp_d,sep = ","))
  catn("Correlation")
  catn("TRUE")
  catn(paste(cor_a, cor_b, cor_c,sep = ","))
  cat("-End of file-")
  sink()
  closeAllConnections()
}

# convertPTCtoPDY - Converting RAMAS Spatial Data to Habitat Dynamics 
# To call RAMAS from our code, we need to use batch mode instead of the GUI
# Thus converting RAMAS files (PTC -> PDY) needs to be done manually
# Inputs: BPath: path to B file, path: path to Z file, n: landscape size, iter: configuration iteration 
# Output: PDY file for Z
convertPTCtoPDY <- function(BPath, path,n,iter)
{

  title <- paste("Z",n,"_",iter,sep = "")
  pdyFile <- file.path(path,paste(title,".pdy",sep = ""))

  mpFile <- file.path(path,paste(title,".mp",sep = ""))
  mpFile<- gsub("/", "\\\\", mpFile)
  t1 <- 1
  t2 <- 10
  kFile<- "pop" #name for file prefix for carrying capacities for each population 
  fFile<- "pop" #fecundity rates 
  sFile<- "pop" # survival rates 
  XFile <- file.path(path,paste("X",n,"_",iter,".ptc",sep = ""))
  BFile <- file.path(BPath,paste("B",n,".ptc",sep = ""))
  
  XFile<- gsub("/", "\\\\", XFile)
  BFile<- gsub("/", "\\\\", BFile)
  #change1 <- "at mid-point"
  change1 <- "same until next"
  change2 <- "linear"


  line= character()
  line[1] <- "Habitat Dynamics (version 4.1)"
  line[2] <- paste(title,"\n\n\n\n",sep = "")
  line[3] <- mpFile
  line[4] <- kFile
  line[5] <- fFile
  line[6] <- sFile
  line[7] <- "2"
  line[8] <-BFile
  line[9] <-t1
  line[10] <-change1
  line[11] <-change1
  line[12] <-change1
  line[13] <-XFile
  line[14] <-t2
  line[15] <-change2
  line[16] <-change2
  line[17] <-change2
 
  writeLines(line,pdyFile)
  
}


# convertPTCtoPDY_base - Converting RAMAS Spatial Data to Habitat Dynamics 
# To call RAMAS from our code, we need to use batch mode instead of the GUI
# Thus converting RAMAS files (PTC -> PDY) needs to be done manually
# Inputs: path:path to B file, n: landscape size
# Output: PDY file for B
convertPTCtoPDY_base <- function(path,n)
{
  # It's really hard to convert PTC to MP, so even though the base case has no 
  # habitat to combine with, we combine it with itself to get around this.
  title <- paste("B",n,sep = "")
  pdyFile <- file.path(path,paste(title,".pdy",sep = ""))
  mpFile <- file.path(path,paste(title,".mp",sep = ""))
  mpFile<- gsub("/", "\\\\", mpFile)
  t1 <- 1
  t2 <- 100
  kFile<- "pop"
  fFile<- "pop"
  sFile<- "pop"
  BFile <- file.path(path,paste("B",n,".ptc",sep = ""))
  BFile<- gsub("/", "\\\\", BFile)
  change1 <- "same until next"
  change2 <- "linear"
  line= character()
  line[1] <- "Habitat Dynamics (version 4.1)"
  line[2] <- paste(title,"\n\n\n\n",sep = "")
  line[3] <- mpFile
  line[4] <- kFile
  line[5] <- fFile
  line[6] <- sFile
  line[7] <- "2"
  line[8] <-BFile
  line[9] <-t1
  line[10] <-change1
  line[11] <-change1
  line[12] <-change1
  line[13] <-BFile
  line[14] <-t2
  line[15] <-change2
  line[16] <-change2
  line[17] <-change2

  writeLines(line,pdyFile)
  
}
  

# getBatchFile - The executable that runs RAMAS for Z
# Inputs: n: size, iter: configuartion iteration, path: location of X and Z files 
# Output: BAT file that runs RAMAS Spatial Data, Habitat Dynamics, and Metapop 
getBatchFile <- function(n,iter,path)
{
  outPath <- file.path(path,"output")
  ifelse(!dir.exists(outPath), dir.create(outPath), FALSE)
 
  batFile <- paste("batch",n,"_",iter,".BAT",sep = "")
  batPath <- file.path(path,batFile)
  XPTCFile <- paste("X",n,"_",iter,".ptc",sep = "")
  ZPDYfile <- paste("Z",n,"_",iter,".pdy",sep = "")
  
  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"
  RAMAS_hab <- r"("C:\Program Files\RAMAS Multispecies 6\Habdyn.exe")"
  RAMAS_files <- r"("C:\Users\cb3452\Documents\RAMAS Model Files\*.*")"
  line1<- paste('START /WAIT "title"',RAMAS_spatial,XPTCFile,'/RUN=YES /TEX')
  line2<- paste('START /WAIT "title"',RAMAS_hab,ZPDYfile,'/RUN=YES /TEX')
  
  RAMAS_metapop <- r"("C:\Program Files\RAMAS Multispecies 6\Metapop.exe")"
  ZMPfile <- paste("Z",n,"_",iter,".mp",sep = "")
  line3<- paste('START /WAIT "title"',RAMAS_metapop,ZMPfile,'/RUN=YES /TEX')
  
  outPath<- gsub("/", "\\\\", outPath)
  outPath<- paste0("\"", outPath, "\"")
  line4 <- paste("move",RAMAS_files,outPath)

  writeLines(c(line1,line2,line3,line4),batPath)
}



# getBatchFile - The executable that runs RAMAS for B
# Inputs: n: size,  path: location of B
# Output: BAT file that runs RAMAS Spatial Data, Habitat Dynamics, and Metapop 
getBatchBaseFile <- function(n,path)
{

  batFile <- paste("batch",n,".BAT",sep = "")
  batPath <- file.path(path,batFile)
  BPTCFile <- paste("B",n,".ptc",sep = "")
  BPDYfile <- paste("B",n,".pdy",sep = "")
  BMPfile <- paste("B",n,".mp",sep = "")
  
  RAMAS_spatial <- r"("C:\Program Files\RAMAS Multispecies 6\SpatialData.exe")"
  RAMAS_hab <- r"("C:\Program Files\RAMAS Multispecies 6\Habdyn.exe")"
  RAMAS_files <- r"("C:\Users\cb3452\Documents\RAMAS Model Files\*.*")"
  line1<- paste('START /WAIT "title"',RAMAS_spatial,BPTCFile,'/RUN=YES /TEX')
  line2<- paste('START /WAIT "title"',RAMAS_hab,BPDYfile,'/RUN=YES /TEX')
  
  RAMAS_metapop <- r"("C:\Program Files\RAMAS Multispecies 6\Metapop.exe")"
  line3<- paste('START /WAIT "title"',RAMAS_metapop,BMPfile,'/RUN=YES /TEX')
  
  path<- gsub("/", "\\\\", path)
  path<- paste0("\"", path, "\"")
  line4 <- paste("move",RAMAS_files,path)
  
  writeLines(c(line1,line2,line3,line4),batPath)
}