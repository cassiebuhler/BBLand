library(ggplot2)
library(RColorBrewer)
library(raster)
getRasterXY <- function(n,rast){
  r <- raster(xmn=0, xmx=n, ymn=0, ymx=n, ncol=n, nrow=n)
  p <- rasterToPolygons(r)
  values(r) <- rast
  dat <- raster::as.data.frame(r,xy=TRUE)
  return(dat)
}


tightLayout <- function(g){
  g_<-
    g+
    theme_minimal()+
    theme(aspect.ratio = 1) +
    theme(legend.key=element_blank(),legend.title=element_blank())+
    theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))+
    theme(legend.margin=margin(t = 0,r=,b=0,l=0, unit='mm'),
          legend.box.margin = margin(0, 0, 0, 0),
          legend.box.spacing = unit(1, "pt"),
          #legend.box.background = element_rect(fill="grey95",size = 0),
          plot.title = element_text(hjust = 0.5,size = 6))+ # The spacing between the plotting area and the legend box (unit)
    theme(legend.key.size = unit(.3, 'cm'))+
    theme(legend.spacing.x = unit(0.5,'mm'))+
    theme(text = element_text(size=7))
  return(g_)
}
clean.df <- function(df){
  df = strsplit(df, "'[^']*'(*SKIP)(*F)|\\s+", perl=TRUE)
  rm1 <- function(x) x[-1] 
  df <- sapply(df,rm1)
  size = dim(df)
  df <- as.numeric(df)
  dim(df) <- c(size[1], size[2])
  df <- as.data.frame(t(df))
  return(df)
}

getRasterPlot <- function(g,...){
  new <- g+
    theme_bw() + 
    theme(aspect.ratio = 1) +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
    theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
    # theme(legend.title=element_text(size=5))+
    theme(plot.margin=grid::unit(c(2,0,2,0), "mm"))+
    coord_equal()  +
    theme(plot.title = element_text(hjust = 0.5,size = 5))
  
  if(length(list(...)) ==0){
    new <-
      new+
      theme(panel.border = element_blank()) +
      geom_text(parse = TRUE, aes(label = sprintf("%.1f", layer)), size = 2.5, color = "black")
  }
  return(new)
}

getPops <- function(pops,base){
  for (i in 1:length(pops)){
    base[pops[[i]]] <- i
  }
  pop_label <- paste(base)
  pop_label[pop_label == "0"] <- ""
  out = list()
  out[[1]] = c(base)
  out[[2]] = c(pop_label)
  return(out)
}

# n = 5, con 
iter <- 503
n<- 10
#nPath<- file.path(paste("./n",n,"_con",sep = ""))

nPath <- "./iter503"
#1.########################### B
set.seed(0)
baseMap <- runif(n*n,min=0,max=1)
# baseMap[baseMap <0.5]<- 0
B<- getRasterXY(n,baseMap)
B_ <- ggplot(B, aes(x, y, fill= layer)) + 
  geom_tile()+ 
  scale_fill_gradientn(colors = rev(terrain.colors(100)),limits = c(0,1),breaks=c(0,0.5,1))+
  guides(fill = guide_colourbar(title = "HS",barheight = 9,size = 1.5))+
  ggtitle("B")
B_ <- getRasterPlot(B_)
B_<- B_+theme(legend.key.size = unit(.24, 'cm'),
              legend.box.spacing = unit(.2, 'cm'),
              legend.text = element_text(size=7),
              legend.spacing.y = unit(.2, 'cm'),
              legend.spacing.x = unit(.6, 'mm'),
              legend.margin = margin(0, 0, 0, 0),
              legend.title=element_text(size=8),
              plot.title = element_text(size=10))
B_
f1<- file.path(nPath,paste("B_",n,".png",sep = ""))
ggsave(f1,width = 3.2,height = 2.5, unit = "in",dpi = 300)



#2########################### X
filePath <- file.path(nPath,paste("X",n,"_",iter,".txt",sep = ""))
config <- read.csv(filePath,header = FALSE)
config<- as.numeric(t(config))
mask<- getRasterXY(n,config)

mask_ <- ggplot(mask, aes(x, y, fill= as.factor(layer))) + 
  geom_tile()+ 
  scale_fill_manual(values = rev(terrain.colors(2)),breaks=c("0","1"))+
  labs(fill='Parcel\nStatus') +
  ggtitle("X")
mask_ <- getRasterPlot(mask_)

mask_<- mask_+theme(legend.key.size = unit(.24, 'cm'),
                    legend.box.spacing = unit(.2, 'cm'),
                    legend.text = element_text(size=7),
                    legend.spacing.y = unit(.2, 'cm'),
                    legend.spacing.x = unit(.6, 'mm'),
                    legend.margin = margin(0, 0, 0, 0),
                    legend.title=element_text(size=8),
                    plot.title = element_text(size=10))
mask_
f2<- file.path(nPath,paste("X_",n,"_",iter,".png",sep = ""))
ggsave(f2,width = 3.2,height = 2.5, unit = "in",dpi = 300)


#3########################### Z
filePath <- file.path(nPath,paste("X",n,"_",iter,".txt",sep = ""))
config <- read.csv(filePath,header = FALSE)
config<- as.numeric(t(config))
baseMap<- as.numeric(t(baseMap))
s<- config
s[which(config==1)] <- baseMap[which(config==1)]
# s[which(s<0.5)] <- 0

# s[s<0.5] <- 0
X<- getRasterXY(n,s)
X_ <- ggplot(X, aes(x, y, fill= layer)) + 
  geom_tile()+ 
  scale_fill_gradientn(colors = rev(terrain.colors(100)),limits = c(0,1),breaks=c(0,0.5,1))+
  guides(fill = guide_colourbar(title = "HS",barheight = 7,size = 2))+
  ggtitle("Z")
X_ <- getRasterPlot(X_)
X_<- X_+theme(legend.key.size = unit(.24, 'cm'),
              legend.box.spacing = unit(.2, 'cm'),
              legend.text = element_text(size=7),
              legend.spacing.y = unit(.2, 'cm'),
              legend.spacing.x = unit(.6, 'mm'),
              legend.margin = margin(0, 0, 0, 0),
              legend.title=element_text(size=8),
              plot.title = element_text(size=10))
X_
f3<- file.path(nPath,paste("Z_",n,"_",iter,".png",sep = ""))
ggsave(f3,width = 3.2,height = 2.5, unit = "in",dpi = 300)




###4 ######################################
baseMap<- as.numeric(t(baseMap))
base <- rep(0, n*n)
pops <- list()
pops[[1]] = c(1)
pops[[2]] = c(7,8,9,10,18,19)
pops[[3]] = c(4,5,14,24)
pops[[4]] = c(16)
pops[[5]] = c(21,22)
pops[[6]] = c(30,40,50,59,60,69)
pops[[7]] = c(33,42,43,44,45,46,47,36,37,38,53)
pops[[8]] = c(51)
pops[[9]] = c(62)
pops[[10]] = c(66)
pops[[11]] = c(71,81)
pops[[12]] = c(73,83)
pops[[13]] = c(77,78,88)
pops[[14]] = c(80)
pops[[15]] = c(86,94,95,96,97)
pops[[16]] = c(100)

out <- getPops(pops,base)
base = out[[1]]
pop_label = out[[2]]
col<- c("#FFFFFF",brewer.pal(n = 8, name = "Dark2")[1:7],brewer.pal(n = 12, name = "Paired")[c(1:9,11:12)])
patchBase<- getRasterXY(n,base)
patchBase$layer <-pop_label
patchBase$layer <- as.factor(patchBase$layer)
patchBase_<- ggplot(patchBase, aes(x, y)) + 
  geom_tile(aes(fill=layer))+ 
  geom_tile(aes(fill=layer))+ 
  scale_fill_manual("",values = col,breaks=c("",c(1:length(pops))),guide="none")+
  geom_text(aes(label =  as.factor(layer)), size = 3, color = "black") +
  ggtitle("B - Patches")
patchBase_<- getRasterPlot(patchBase_,1)
patchBase_<- patchBase_+theme(plot.title = element_text(size=10))
patchBase_
f4 <- file.path(nPath,paste("B_patches_",n,".png",sep = ""))
ggsave(f4,width = 3.2,height = 2.5, unit = "in",dpi = 300)



###5 ######################################
baseMap<- as.numeric(t(baseMap))
base <- rep(0, n*n)
pops <- list()
pops[[1]] = c(7,8,9,10,19)
pops[[2]] = c(16)
pops[[3]] = c(21,22)
pops[[4]] = c(30,40,50,59,60,69)
pops[[5]] = c(42,43,44,45,46,47,53)
pops[[6]] = c(51)
pops[[7]] = c(66)
pops[[8]] = c(80)
pops[[9]] = c(77,78,88)
pops[[10]] = c(71,81)
pops[[11]] = c(83)
pops[[12]] = c(95)

out <- getPops(pops,base)
base = out[[1]]
pop_label = out[[2]]
col<- c("#FFFFFF",brewer.pal(n = 8, name = "Dark2")[1:7],brewer.pal(n = 12, name = "Paired")[c(1:9,11:12)])
patchBase<- getRasterXY(n,base)
patchBase$layer <-pop_label
patchBase$layer <- as.factor(patchBase$layer)
patchBase_<- ggplot(patchBase, aes(x, y)) + 
  geom_tile(aes(fill=layer))+ 
  scale_fill_manual("",values = col,breaks=c("",c(1:length(pops))),guide="none")+
  geom_text(aes(label =  as.factor(layer)), size = 3, color = "black") +
  ggtitle("Z - Patches")
patchBase_<- getRasterPlot(patchBase_,1)
patchBase_<- patchBase_+theme(plot.title = element_text(size=10))
patchBase_
f5<- file.path(nPath,paste("Z_patches_",n,"_",iter,".png",sep = ""))
ggsave(f5,width = 3.2,height = 2.5, unit = "in",dpi = 300)



#6#########################

outPathB <- file.path("Abund.txt")

outputB = read.csv(outPathB)
riskB = outputB[9:109,1]
riskB.df <- clean.df(riskB)
names(riskB.df) <- c("Time","Min","MinusSD","Abundance","PlusSD","Max")
riskB.df

outPathZ <- file.path("iter503","output","Abund.txt")
outputZ = read.csv(outPathZ)
riskZ = outputZ[9:109,1]
riskZ.df <- clean.df(riskZ)
names(riskZ.df) <- c("Time","Min","MinusSD","Abundance","PlusSD","Max")
riskZ.df


Term<-ggplot() +
  geom_line(data = riskB.df, aes(x=Time, y=Abundance,colour = "B"))+
  # geom_line(data = riskB.df, aes(x=Threshold, y=LowerCI,colour = "CI"), linetype = "dashed")+
  # geom_line(data = riskB.df, aes(x=Threshold, y=UpperCI),color = "red",linetype = "dashed")+
  # geom_line(data = riskZ.df, aes(x=Threshold, y=Probability,colour = "Prob"))+
  # geom_line(data = riskZ.df, aes(x=Threshold, y=LowerCI,colour = "CI"), linetype = "dashed")+
  geom_line(data = riskZ.df, aes(x=Time, y=Abundance,colour = "Z"), linetype = "dashed")+
  scale_x_continuous(limits = c(0, 100),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 125),expand = c(0,0))+
  scale_color_manual(name = "Legend", values = c("Z" = "darkblue", "B" = "darkgreen"))+
  #annotate(geom = "text",x=2.5, y=.70, label=paste("Extinction Risk:",risk.df$Probability[1],sep = " "),color = "black",size = 2)+
  ggtitle("Terminal Extinction Risk")
Term<-tightLayout(Term)
Term<- Term+theme(plot.title = element_text(size=10))
Term
f6<- file.path(paste("Abund",n,"_",iter,".png",sep = ""))
ggsave(f6,width = 2.5,height = 2.5, unit = "in",dpi = 300,bg = "white")

#7#########################
outPath <- file.path("iter503","output","IntExtRisk.txt")
output = read.csv(outPath)
risk = output[9:nrow(output),1]
risk.df<- clean.df(risk)
names(risk.df) <- c("Threshold","Probability","LowerCI","UpperCI")
risk.df
Int<- ggplot(risk.df,aes(Threshold)) +
  geom_line(aes(y=Probability,color = "Probability"))+
  geom_line(aes(y=LowerCI,color = "95% CI"),linetype = "dashed")+
  geom_line(aes(y=UpperCI),color = "red",linetype = "dashed")+
  #scale_x_continuous(limits = c(0, 2),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 1),expand = c(0,0))+
  scale_color_manual(" ", values = c("Probability" = "darkblue", "95% CI" = "red"))+
  annotate(geom = "text",x=23, y=0.9, label="Expected min\nabundance = 33.5",color = "black",size = 2.5)+
  # annotate(geom = "text",x=23, y=0.9, label=paste(output[7,1],sep = " "),color = "black",size = 1.8)+
  ggtitle("Interval Extinction Risk")
Int<-tightLayout(Int)
Int<- Int+theme(plot.title = element_text(size=9))
Int
f8<- file.path(paste("IntExtRisk",n,"_",iter,".png",sep = ""))
ggsave(f8,width = 2.8,height = 2.8, unit = "in",dpi = 300,bg= "white")

