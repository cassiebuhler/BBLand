library(ggplot2)
library(cowplot)
library(RColorBrewer)
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
    theme(plot.margin=grid::unit(c(2,0,2,0), "mm"))+
    theme(axis.title.x=element_text(size=10))+
    theme(axis.title.y=element_text(size=10))+
    theme(legend.title=element_text(size=10))+
    #theme(legend.spacing=grid::unit(c(0,0,0,0), "mm"))+
    theme(legend.margin=margin(t = 0,r=0,b=0,l=0, unit='cm'))+
    theme(legend.text =element_text(size=10))+
    theme(axis.text = element_text(size=10))+
    theme(legend.key.width = unit(2,"mm"))+
    theme(legend.position = "bottom")+
    theme(plot.title = element_text(hjust = 0.5,size = 10))+
    theme(legend.key=element_blank(),legend.title=element_blank())
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
    theme(legend.title=element_text(size=10))+
    theme(plot.margin=grid::unit(c(2,0,2,0), "mm"))+
    coord_equal()  +
    theme(plot.title = element_text(hjust = 0.5,size = 10))
  if(length(list(...)) ==0){
    new <-
      new+
      theme(panel.border = element_blank()) +
      geom_text(parse = TRUE, aes(label = sprintf("%.2f", layer)), size = 3, color = "black")
  }
  return(new)
}
iter <- 1
n<- 4
basePath <- r"(C:/Users/cb3452/OneDrive - Drexel University/bbland/bbland-github)"
setwd(basePath)

configPath <- file.path("data",file.path(paste("n",n,sep = "")),paste("iter",iter,sep = ""))
nPath<- file.path("data",file.path(paste("n",n,sep = "")))

set.seed(0)
baseMap <- runif(n*n,min=0,max=1)
B<- getRasterXY(n,baseMap)
B_ <- ggplot(B, aes(x, y, fill= layer)) + 
  geom_tile()+ 
  scale_fill_gradientn(colors = rev(terrain.colors(100)),limits = c(0,1),breaks=c(0,0.5,1))+
  guides(fill = guide_colourbar(title = "HS",barheight = 7,size = 3))+
  ggtitle("B")

B_ <- getRasterPlot(B_)
B_
f1<- file.path(nPath,paste("baseMap_",n,".png",sep = ""))
ggsave(f1,width = 3,height = 2, unit = "in",dpi = 300)




filePath <- file.path(configPath,paste("config",n,"_",iter,".txt",sep = ""))
config <- read.csv(filePath,header = FALSE)
config<- as.numeric(t(config))
baseMap<- as.numeric(t(baseMap))
s<- config
s[which(config==1)] <- baseMap[which(config==1)]
X<- getRasterXY(n,s)
X_ <- ggplot(X, aes(x, y, fill= layer)) + 
  geom_tile()+ 
  scale_fill_gradientn(colors = rev(terrain.colors(100)),limits = c(0,1),breaks=c(0,0.5,1))+
  guides(fill = guide_colourbar(title = "HS",barheight = 7,size = 3))+
  ggtitle("Z")
X_ <- getRasterPlot(X_)
X_
f2<- file.path(nPath,paste("config_",n,"_",iter,".png",sep = ""))
ggsave(f2,width = 3,height = 2, unit = "in",dpi = 300)



filePath <- file.path(configPath,paste("config",n,"_",iter,".txt",sep = ""))
config <- read.csv(filePath,header = FALSE)
config<- as.numeric(t(config))
mask<- getRasterXY(n,config)
mask_ <- ggplot(mask, aes(x, y, fill= as.factor(layer))) + 
  geom_tile()+ 
  scale_fill_manual(values = rev(terrain.colors(2)),breaks=c("0","1"))+
  labs(fill='Parcel\nStatus') +
  ggtitle("X")
mask_ <- getRasterPlot(mask_)
mask_
f3<- file.path(nPath,paste("mask_",n,"_",iter,".png",sep = ""))
ggsave(f3,width = 3,height = 2, unit = "in",dpi = 300)



baseMap<- as.numeric(t(baseMap))
base <- rep(0, n*n)
pop1_ind <- c(1,5,9,10,14)#just hard coding the patches in to number the populatiosn 
pop2_ind<- c(4,7,8)
pop3_ind <- c(16)
base[pop1_ind] <- rep(1,n*n)[pop1_ind]
base[pop2_ind] <- rep(2,n*n)[pop2_ind]
base[pop3_ind] <- rep(3,n*n)[pop3_ind]
col<- c("#FFFFFF","#1B9E77", "#D95F02", "#7570B3")
patchBase<- getRasterXY(n,base)
patchBase$layer <- c("1","","","2","1","","2","2","1","1","","","","1","","3")
patchBase$layer <- as.factor(patchBase$layer)
patchBase_<- ggplot(patchBase, aes(x, y)) + 
  geom_tile(aes(fill=layer))+ 
  scale_fill_manual("Pop",values = col,breaks=c("","1","2","3"))+
  geom_text(aes(label =  as.factor(layer)), size = 3, color = "black") +
  ggtitle("B - Patches")
 
patchBase_<- getRasterPlot(patchBase_,1)
#patchBase_<- patchBase_+ theme(legend.position = "bottom")
patchBase_
f4<- file.path(nPath,paste("baseMap_patches",n,".png",sep = ""))
ggsave(f4,width = 3,height = 2, unit = "in",dpi = 300)




basex <- rep(0, n*n)
pop1_ind <- c(5,9,10,14)#just hard coding the patches in to number the populatiosn 
pop2_ind<- c(7,8)
basex[pop1_ind] <- rep(1,n*n)[pop1_ind]
basex[pop2_ind] <- rep(2,n*n)[pop2_ind]
col<- c("#FFFFFF","#1B9E77", "#D95F02")
patchX<- getRasterXY(n,basex)
patchX$layer <- c("","","","","1","","2","2","1","1","","","","1","","")
patchX$layer <- as.factor(patchX$layer)

patchX_<- ggplot(patchX, aes(x, y)) + 
  geom_tile(aes(fill=layer))+ 
  scale_fill_manual("Pop",values = col,breaks=c("","1","2"))+
  geom_text(aes(label =  as.factor(layer)), size = 3, color = "black") +
  ggtitle("Z - Patches")
patchX_<-getRasterPlot(patchX_,1)
patchX_
f5<- file.path(nPath,paste("config_patches",n,"_",iter,".png",sep = ""))
ggsave(f5,width = 3,height = 2, unit = "in",dpi = 300)



outPath <- file.path(configPath,"output","metapop","TerExtRisk.txt")
output = read.csv(outPath)
risk = output[8:nrow(output),1]
risk.df <- clean.df(risk)
names(risk.df) <- c("Threshold","Probability","LowerCI","UpperCI")
risk.df
Term<-ggplot() +
  geom_line(data=risk.df, aes(x=Threshold, y=Probability,colour = "Probability"))+
  geom_line(data=risk.df, aes(x=Threshold, y=LowerCI,colour = "95% CI"), linetype = "dashed")+
  geom_line(data=risk.df, aes(x=Threshold, y=UpperCI),color = "red",linetype = "dashed")+
  scale_x_continuous(limits = c(0, 4),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 1),expand = c(0,0))+
  scale_color_manual(name = "Legend", values = c("Probability" = "darkblue", "95% CI" = "red"))+
  annotate(geom = "text",x=2.5, y=.70, label=paste("Extinction Risk:",risk.df$Probability[1],sep = " "),color = "black",size = 3)+
  ggtitle("Terminal Extinction Risk")
Term<-tightLayout(Term)
Term
f6<- file.path(nPath,paste("TerExtRisk",n,"_",iter,".png",sep = ""))
ggsave(f6,width = 2.8,height = 3, unit = "in",dpi = 300)


outPath <- file.path(configPath,"output","metapop","QuasiExt.txt")
output = read.csv(outPath)
risk = output[9:nrow(output),1]
risk.df <-clean.df(risk)
names(risk.df) <- c("Time","Probability","CDF","LowerCI","UpperCI")
risk.df
Quasi<-ggplot(risk.df,aes(Time)) +
  geom_bar(aes(y=Probability,fill = "PDF"),stat="identity")+
  geom_line(aes(y=CDF,color = "CDF"))+
  geom_line(aes(y=LowerCI,color = "95% CI"),linetype = "dashed")+
  geom_line(aes(y=UpperCI),color = "red",linetype = "dashed")+
  scale_x_continuous(limits = c(0, 200),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 1),expand = c(0,0))+
  scale_color_manual(" ", values = c("CDF" = "darkblue", "95% CI" = "red","PDF" = "darkgreen"))+
  scale_fill_manual("",values ="darkgreen")+
  annotate(geom = "text",x=120, y=0.25, label=paste(output[7,1],sep = " "),color = "black",size = 3)+
  ggtitle("Time to Quasi Extinction")
Quasi <- tightLayout(Quasi)
Quasi

f7<- file.path(nPath,paste("QuasiExt",n,"_",iter,".png",sep = ""))
ggsave(f7,width = 2.8,height = 3, unit = "in",dpi = 300)






outPath <- file.path(configPath,"output","metapop","IntExtRisk.txt")
output = read.csv(outPath)
risk = output[9:nrow(output),1]
risk.df<- clean.df(risk)
names(risk.df) <- c("Threshold","Probability","LowerCI","UpperCI")
risk.df
Int<- ggplot(risk.df,aes(Threshold)) +
  geom_line(aes(y=Probability,color = "Probability"))+
  geom_line(aes(y=LowerCI,color = "95% CI"),linetype = "dashed")+
  geom_line(aes(y=UpperCI),color = "red",linetype = "dashed")+
  scale_x_continuous(limits = c(0, 2),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 1),expand = c(0,0))+
  scale_color_manual(" ", values = c("Probability" = "darkblue", "95% CI" = "red"))+
  annotate(geom = "text",x=1.5, y=0.25, label=paste(output[7,1],sep = " "),color = "black",size = 3)+
  ggtitle("Interval Extinction Risk")
Int<-tightLayout(Int)
Int
f8<- file.path(nPath,paste("IntExtRisk",n,"_",iter,".png",sep = ""))
ggsave(f8,width = 2.8,height = 3, unit = "in",dpi = 300)



outPath <- file.path(configPath,"output","metapop","MetapopOcc.txt")
output = read.csv(outPath)
risk = output[9:nrow(output),1]
risk.df <- clean.df(risk)
names(risk.df) <- c("Time","Minimum","Lower_SD","Average","Upper_SD","Maximum")
risk.df
Occ<- ggplot(risk.df,aes(Time)) +
  geom_line(aes(y=Minimum,color = "Minimum"))+
  geom_line(aes(y=Maximum,color = "Maximum"))+
  geom_line(aes(y=Average,color = "Average"))+
  scale_x_continuous(limits = c(0, 200),expand = c(0,0))+
  scale_y_continuous(limits = c(0, 3),expand = c(0,0))+
  scale_color_manual(" ", values = c("Minimum" = "purple","Maximum" = "darkgreen","Average"="darkblue"))+
  annotate(geom = "text",x=150, y=2.25, label=paste("Expected minimum\nabundance =",risk.df$Average[nrow(risk.df)],sep = " "),color = "black",size = 3)+
  ggtitle("Metapopulation Occupancy")+
  ylab("Occupied Populations")
Occ<- tightLayout(Occ) 
Occ
f9<- file.path(nPath,paste("MetapopOcc",n,"_",iter,".png",sep = ""))
ggsave(f9,width = 2.8,height = 3, unit = "in",dpi = 300)




