library(ggplot2)
library(scales)


data <- read.csv('TPM.tsv',
                 sep='\t', header=TRUE)

p1 <- ggplot(data, aes(x=Tissue, y=MYL4_TPM+1)) +
  geom_boxplot(outlier.colour = NA, width=.4, fill='white', color='black') +
  geom_dotplot(binaxis = 'y', binwidth=.07, stackdir = 'center', fill='gray10', color=NA) +
  scale_y_log10(breaks=10^(0:4), labels=trans_format('log10', math_format(10^.x))) +
  theme_classic() +
  xlab("") + ylab("MYL4 expression\n(TPM+1)") +
  theme(text = element_text(size = 20), axis.text = element_text(color='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p1
ggsave('TPM.pdf', width=4, height=4)

p2 <- ggplot(data, aes(x=Tissue, y=MYL4_RPM+1)) +
  geom_boxplot(outlier.colour = NA, width=.4, fill='white', color='black') +
  geom_dotplot(binaxis = 'y', binwidth=.07, stackdir = 'center', fill='darkorchid1', color=NA) +
  scale_y_log10(breaks=10^(0:4), labels=trans_format('log10', math_format(10^.x))) +
  theme_classic() +
  xlab("") + ylab("Exon 2 / 3 splicing\n(RPM+1)") +
  theme(text = element_text(size = 20), axis.text = element_text(color='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p2
ggsave('MYL4.pdf', width=4, height=4)

p3 <- ggplot(data, aes(x=Tissue, y=Lyosin_RPM+1)) +
  geom_boxplot(outlier.colour = NA, width=.4, fill='white', color='black') +
  geom_dotplot(binaxis = 'y', binwidth=.02, stackdir = 'center', fill='limegreen', color=NA) +
  scale_y_log10(breaks=10^(0:4), labels=trans_format('log10', math_format(10^.x)), limits = c(1, 10)) +
  theme_classic() +
  xlab("") + ylab("Exon L / 3 splicing\n(RPM+1)") +
  theme(text = element_text(size = 20), axis.text = element_text(color='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
  
p3
ggsave('Lyosin.pdf', width=4, height=4)

