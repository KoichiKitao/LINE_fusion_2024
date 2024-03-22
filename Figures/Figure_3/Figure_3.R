library(ggplot2)
library(slider)

# Birds
data <- read.csv('Bird.tsv',
                 sep='\t', header=TRUE)

data$slide <- slider::slide_dbl(data$index, mean, .before = 2, .after = 2, .complete = TRUE)

p1 <- ggplot(data, aes(x=site, y=slide)) +
  annotate('rect', xmin=50, xmax=145, ymin=0.4, ymax=1, alpha=.3, fill='gray') +
  geom_line(colour='#945200', linewidth=1) +
  theme_classic() +
  xlab("Alignment position") + ylab("Conservation index") +
  theme(text = element_text(size = 20), 
        axis.text = element_text(colour='black'),
        axis.ticks = element_line(colour='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p1 

# Crocodiles
data <- read.csv('Crocodile.tsv',
                 sep='\t', header=TRUE)

data$slide <- slider::slide_dbl(data$index, mean, .before = 2, .after = 2, .complete = TRUE)

p2 <- ggplot(data, aes(x=site, y=slide)) +
  annotate('rect', xmin=50, xmax=145, ymin=0.4, ymax=1, alpha=.3, fill='gray') +
  geom_line(color='#5E8D28', linewidth=1) +
  theme_classic() +
  xlab("Alignment position") + ylab("Conservation index") +
  theme(text = element_text(size = 20), 
        axis.text = element_text(colour='black'),
        axis.ticks = element_line(colour='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p2

# Turtles
data <- read.csv('Turtle.tsv',
                 sep='\t', header=TRUE)

data$slide <- slider::slide_dbl(data$index, mean, .before = 2, .after = 2, .complete = TRUE)

p3 <- ggplot(data, aes(x=site, y=slide)) +
  annotate('rect', xmin=50, xmax=145, ymin=0.4, ymax=1, alpha=.3, fill='gray') +
  geom_line(color='#3E8D26', linewidth=1) +
  theme_classic() +
  xlab("Alignment position") + ylab("Conservation index") +
  theme(text = element_text(size = 20), 
        axis.text = element_text(colour='black'),
        axis.ticks = element_line(colour='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p3

# Squamata
data <- read.csv('Squamata.tsv',
                 sep='\t', header=TRUE)

data$slide <- slider::slide_dbl(data$index, mean, .before = 2, .after = 2, .complete = TRUE)

p4 <- ggplot(data, aes(x=site, y=slide)) +
  annotate('rect', xmin=50, xmax=140, ymin=0.2, ymax=1, alpha=.3, fill='gray') +
  geom_line(color='#3F8F92', linewidth=1) +
  theme_classic() +
  xlab("Alignment position") + ylab("Conservation index") +
  theme(text = element_text(size = 20), 
        axis.text = element_text(colour='black'),
        axis.ticks = element_line(colour='black'),
        axis.text.x = element_text(angle=30, hjust = 1, vjust = 1))
p4

# set drawing canvas
layout <- rbind(c(1,2,3,4), c(1,2,3,4))

# plot all bar charts
merge_bar <- grid.arrange(p1, p2, p3, p4, layout_matrix=layout)


# save
ggsave('Conservation_index_plot.pdf',
       merge_bar, width = 16, height = 4)
