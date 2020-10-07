library(devtools)
install_github("nclark-lab/RERconverge")

library(RERconverge)

rerpath = find.package('RERconverge')
print(rerpath)

mamRERw_all = readRDS("mamm63nt.trees.updateders.rds")
#write.csv(mamRERw_all, file = 'rer_all.csv')

treefile = "mamm63nt.trees"
Trees=readTrees(paste(rerpath,"/extdata/",treefile,sep=""))
#length(Trees$trees)

#colnames(mamRERw_all)

hypoxia_extantforeground = c("Walrus","Seal","Killer_whale","Dolphin","Manatee","Cape_golden_mole","Star_nosed_mole","Naked_mole_rat","Blind_mole_rat", "Alpaca","Tibetan_antelope","Pika")
hypoxia2a = foreground2Tree(hypoxia_extantforeground, Trees, clade="ancestral")
hypoxia2b = foreground2Tree(hypoxia_extantforeground, Trees, clade="terminal")
hypoxia2c = foreground2Tree(hypoxia_extantforeground, Trees, clade="all")
hypoxia2d = foreground2Tree(hypoxia_extantforeground, Trees, clade="all", weighted = TRUE)

phenvHypoxia=tree2Paths(Trees$masterTree, Trees)
phenvHypoxia2=foreground2Paths(hypoxia_extantforeground, Trees, clade="all")
phenvHypoxia2b=tree2Paths(hypoxia2b, Trees)

corHypoxia=correlateWithBinaryPhenotype(mamRERw_all, phenvHypoxia2b, min.sp=10, min.pos=2, weighted="auto")

head(corHypoxia[order(corHypoxia$P),])
                 
#plotRers(mamRERw_all,"FAM194B",phenv=phenvHypoxia2b)

write.csv(corHypoxia, file = 'corHypoxia.csv')
saveRDS(corHypoxia, file = 'corHypoxia.rds')

hist(corHypoxia$P, breaks=15, xlab="Kendall P-value", 
     main="P-values for correlation between all genes and hypoxia environment")
