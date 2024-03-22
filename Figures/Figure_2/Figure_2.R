library(ggtree)

# Bird
info <- read.csv("Bird.tsv", sep="\t", header=TRUE)
all_tree <- read.tree("Bird.nwk")

p <- ggtree(all_tree, size=0.1) %<+% info
p

Type <- data.frame("Type" = info[,c("Type")])
rownames(Type) <- info$ID

# X:No blat hit, Y:Blat hit but no exon L, Z:Exon L exists
h <-  gheatmap(p, Type, 
                offset = 0,
                width = 0.03, 
                color=NULL, 
                colnames = FALSE)+
  scale_fill_manual(name = "Type",
                    values = c("#f0f0f0", "#7fcdbb", "#2c7fb8"),
                    breaks = c("X", "Y", "Z"),
                    labels = c("X", "Y", "Z"))

h
