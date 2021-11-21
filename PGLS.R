#walkthrough courtesy of https://lukejharmon.github.io/ilhabela/instruction/2015/07/03/PGLS/
#walthrough also courtesy of https://www.r-phylo.org/wiki/HowTo/PGLS
library(ape)
library(geiger)
library(nlme)
library(phytools)
library(ape)

OR_Data <- read.csv("OR_counts.csv", row.names = 1)
Tree <- read.nexus("TREE_new_pseudo_hsa_2.nex")
plot (Tree)

##################################
##########PIC (phytools)##########
##################################
#Extract columns
OR <- OR_Data[, "OR"]
Status <- OR_Data[, "Highalt"]

#Give them names
names(OR) <- names(Status) <- rownames(OR_Data)

# Calculate PICs
OR_Pic <- pic(OR, Tree)
S_Pic <- pic(Status, Tree)

# Make a model
picModel <- lm(OR_Pic ~ S_Pic - 1)

# Get summary stats
summary(picModel)

#plot results
plot(OR_Pic ~ S_Pic)
abline(a = 0, b = coef(picModel))
hist(OR)

###################################
##########PGLS (phytools)##########
###################################
pglsModel <- gls(OR ~ Status, correlation = corBrownian(phy = Tree),
                 data = OR_Data, method = "ML")
summary(pglsModel)

########################################
##########PGLS (ape, phytools)##########
########################################
Tree <- read.nexus("TREE_new_pseudo_hsa_2.nex")
#OR_Data <- read.csv("OR_counts.csv", row.names = 1)
OR_Data_2 <- read.csv("OR_counts_v2.csv", row.names = 1)
OR_counts<-OR_Data_2$OR
Alt_status<-OR_Data_2$Highalt
N50 <-OR_Data_2$ContigN50

DF.OR.pseudo <-data.frame(OR_counts,Alt_status,row.names=row.names(OR_Data))
DF.OR.pseudo <-  DF.OR.pseudo[Tree$tip.label, ]
DF.OR.pseudo

#for full OR_counts, need to prune leaves missing
Tree_2<-drop.tip(Tree,"hg38")
Tree_2<-drop.tip(Tree_2,"HLlepTim1")
Tree_2<-drop.tip(Tree_2,"HLoryCun3")
Tree_2<-drop.tip(Tree_2,"HLoryCunCun4")
Tree_2<-drop.tip(Tree_2,"HLpedCap1")
Tree_2<-drop.tip(Tree_2,"HLcavTsc1")
Tree_2<-drop.tip(Tree_2,"cavApe1")
Tree_2<-drop.tip(Tree_2,"HLdolPat1")
Tree_2<-drop.tip(Tree_2,"HLaplRuf1")
Tree_2<-drop.tip(Tree_2,"HLsciCar1")
Tree_2<-drop.tip(Tree_2,"HLsciVul1")
Tree_2<-drop.tip(Tree_2,"HLmarHim1")
Tree_2<-drop.tip(Tree_2,"HLmarMon2")
Tree_2<-drop.tip(Tree_2,"HLmarVan1")
Tree_2<-drop.tip(Tree_2,"HLmanSph1")
Tree_2<-drop.tip(Tree_2,"HLpapAnu5")
Tree_2<-drop.tip(Tree_2,"nasLar1")
Tree_2<-drop.tip(Tree_2,"HLpygNem1")
Tree_2<-drop.tip(Tree_2,"HLantMar1")
Tree_2<-drop.tip(Tree_2,"HLeudTho1")
Tree_2<-drop.tip(Tree_2,"HLlitWal1")
Tree_2<-drop.tip(Tree_2,"HLmadKir1")
Tree_2<-drop.tip(Tree_2,"HLnanGra1")
Tree_2<-drop.tip(Tree_2,"HLneoMos1")
Tree_2<-drop.tip(Tree_2,"HLneoPyg1")
Tree_2<-drop.tip(Tree_2,"HLoreOre1")
Tree_2<-drop.tip(Tree_2,"panHod1")
Tree_2<-drop.tip(Tree_2,"HLproPrz1")
Tree_2<-drop.tip(Tree_2,"HLbosFro1")
Tree_2<-drop.tip(Tree_2,"HLbosGau1")
Tree_2<-drop.tip(Tree_2,"HLsynCaf1")
Tree_2<-drop.tip(Tree_2,"HLcapIbe1")
Tree_2<-drop.tip(Tree_2,"HLcapAeg1")
Tree_2<-drop.tip(Tree_2,"HLcapSib1")
Tree_2<-drop.tip(Tree_2,"HLhemHyl1")
Tree_2<-drop.tip(Tree_2,"HLoreAme1")
Tree_2<-drop.tip(Tree_2,"HLoviCan2")
Tree_2<-drop.tip(Tree_2,"HLoviAmm1")
Tree_2<-drop.tip(Tree_2,"HLoviCan1")
Tree_2<-drop.tip(Tree_2,"HLlamGlaCha1")
Tree_2<-drop.tip(Tree_2,"HLlamGuaCac1")
Tree_2<-drop.tip(Tree_2,"HLvicPacHua3")
Tree_2<-drop.tip(Tree_2,"HLursAme1")
Tree_2<-drop.tip(Tree_2,"HLursThi1")
plot (Tree_2)

DF.OR.pseudo_2 <-data.frame(OR_counts,Alt_status,N50,row.names=row.names(OR_Data_2))
DF.OR.pseudo_2 <-  DF.OR.pseudo_2[Tree_2$tip.label, ]
DF.OR.pseudo_2

#Fitting a Brownian-Motion model in PGLS
bm.OR.pseudo<-corBrownian(phy=Tree)
bm.OR.gls<-gls(Alt_status~OR_counts,correlation=bm.OR.pseudo,data=DF.OR.pseudo)
summary(bm.OR.gls)

bm.OR.pseudo_2<-corBrownian(phy=Tree_2)
bm.OR.gls_2a<-gls(Alt_status~OR_counts,correlation=bm.OR.pseudo_2,data=DF.OR.pseudo_2)
summary(bm.OR.gls_2a)
bm.OR.gls_2b<-gls(Alt_status~N50,correlation=bm.OR.pseudo_2,data=DF.OR.pseudo_2)
summary(bm.OR.gls_2b)


#Fitting a Ornstein-Uhlenbeck Motion model in PGLS
ou.OR.pseudo<-corMartins(1,phy=Tree)
ou.OR.pseudogls<-gls(Alt_status~OR_counts,correlation=ou.OR.pseudo,data=DF.OR.pseudo)
summary(ou.OR.pseudogls)

ou.OR.pseudo_2<-corMartins(1,phy=Tree_2)
ou.OR.pseudogls_2a<-gls(Alt_status~OR_counts,correlation=ou.OR.pseudo_2,data=DF.OR.pseudo_2)
summary(ou.OR.pseudogls_2a)
ou.OR.pseudogls_2b<-gls(Alt_status~N50,correlation=ou.OR.pseudo_2,data=DF.OR.pseudo_2)
summary(ou.OR.pseudogls_2b)
ou.OR.pseudogls_2c<-gls(OR_counts~N50,correlation=ou.OR.pseudo_2,data=DF.OR.pseudo_2)
summary(ou.OR.pseudogls_2c)
