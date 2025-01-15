###This is the Rscript to plot the paired boxplot for human rRNA and scatterplot for mRNA of test files.

ratio_rRNA <- read.table(file="./Human_rRNA.ratio.txt",header=F,row.names = 1)

siCTRL_rep1 <-  ratio_rRNA$V7
siFBL_rep1 <-  ratio_rRNA$V12
my_data <- data.frame(
  group = rep(c("siCTRL", "siFBL"), each = 105),
  Nm_ratio = c(siCTRL_rep1,  siFBL_rep1)
)
dim(siCTRL_rep1)
dim(ratio_rRNA)
my_data <- data.frame(
  group = rep(c("siCTRL", "siFBL"), each = 106),
  Nm_ratio = c(siCTRL_rep1,  siFBL_rep1)
)
my_data
my_data <- data.frame(  group = rep(c("siCTRL", "siFBL"), each = 106),
                        Nm_ratio = c(siCTRL_rep1,  siFBL_rep1)
)

pdf(file="~/Desktop/rRNA.ratio.example.Nm.pdf",width=3,height=4)
ggpaired(my_data, x = "group", y = "Nm_ratio",ylab="Nm ratio",xlab="",
         color = "group", line.color = "gray", line.size = 0.4,
         palette = c("blue", "red"))+stat_compare_means(paired = TRUE,label.x = 1.2,
                                                        label.y = 1.05)
dev.off()


# Load the data
data <- read.table(file="./Human_mRNA.ratio.txt", header=F)

# Assign column names for clarity
colnames(data) <- c("chr_pos_gene", "Column3", "siCTRL", "Column4", "Column5", "Column6", 
                    "Column7", "siFBL", "Column9", "Column10", "Column11")

# Calculate the difference (siFBL - siCTRL)
data$diff <- data$siFBL - data$siCTRL

# Define color categories based on the difference
color1 <- c("#DC0000", "#0072B5", "#808180") # Red, Blue, Grey
data$color <- color1[3] # Default color: Grey
data$color[data$diff > 0.1] <- color1[2]  # Blue for up-regulated
data$color[data$diff < -0.1] <- color1[1] # Red for down-regulated

# Subset data for different categories
no_change <- subset(data, color == color1[3])
down_reg <- subset(data, color == color1[1])
up_reg <- subset(data, color == color1[2])

# Define the positions and corresponding genes for annotation
annotations <- data.frame(
  chr_pos_gene = c( "chr20_24963616", "chr7_151081555", "chr10_28677643", 
                    "chr13_44434716", "chr1_1328574", "chr4_101023678", 
                    "chr5_151105299", "chr11_61349241", "chr2_15620365", "chr3_9974471", 
                    "chr1_201465892", "chr15_40418252"),
  
  gene = c( "APMAP", "TMUB1", "BAMBI", "TSC22D1", "CPTP",  "PPP3CA", 
            "ANXA6", "CYB561A3", "DDX1", "PSENEN", "PHLDA3",  "IVD")
  
)

# Merge annotations with the main data
annotated_data <- merge(data, annotations, by="chr_pos_gene", all.x=TRUE)

# Create the plot
pdf(file="~/Desktop/Figure.diff.siFBL_Nm.ratio1_cov20.small.pdf",width=7,height=7.8)
par(bty = "l") # Remove the box around the plot

# Plot the main data
plot(data$siCTRL, data$siFBL, xlim=c(0,1), ylim=c(0,1), pch=20, 
     xlab="siCTRL Nm levels", ylab="siFBL Nm levels", 
     cex=0.5, col=data$color)

# Add points for each category
points(no_change$siCTRL, no_change$siFBL, pch=20, cex=0.8, col=no_change$color)
points(down_reg$siCTRL, down_reg$siFBL, pch=20, cex=1, col=down_reg$color)
points(up_reg$siCTRL, up_reg$siFBL, pch=20, cex=1, col=up_reg$color)

abline(0,1,col = "black", lty = 3)
# Add text annotations for specified positions
with(annotated_data[!is.na(annotated_data$gene),], 
     text(siCTRL, siFBL, labels=gene, pos=4, cex=0.8, col="black"))

# Add a legend at the bottom right
legend(x=0.2,y=0.9, 
       legend=c(paste("Hypo =", nrow(down_reg)), 
                paste("Hyper =", nrow(up_reg)), 
                paste("No change =", nrow(no_change))),bty="n",
       cex=0.7, col=c(color1[1], color1[2], color1[3]), pch=20)

# Close the PDF device
dev.off()
