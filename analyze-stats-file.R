#!/usr/bin/env Rscript

library(ggplot2)

options(echo=FALSE)
args = commandArgs(trailingOnly = TRUE)
input = args[1]

d = read.csv(input)

print(sprintf("quantiles 0.1: %e 0.9: %e", quantile(d$runtime, 0.1), quantile(d$runtime,0.9)))
print(summary(d$runtime))

p = ggplot(d, aes(x=time,y=runtime)) + geom_point(alpha=.4, size=1) + xlab("time") + ylab("runtime") + scale_y_log10()
ggsave(sprintf("%s-timeline.pdf", input), plot=p, width=8, height=5)

p = ggplot(d, aes(x=runtime)) + geom_histogram(aes(y=..density..), binwidth=.5, colour="black", fill="white") + geom_density(alpha=.2, fill="#7777FF")  + scale_x_log10()
ggsave(sprintf("%s-density.pdf", input), plot=p, width=8, height=5)

p = ggplot(d, aes(x="", y=runtime, fill=runtime)) + xlab("") + geom_boxplot() + scale_y_log10()
ggsave(sprintf("%s-runtime.pdf", input), plot=p, width=8, height=5)

d = d[ order(d$runtime),]
d$pos = (1:nrow(d))/nrow(d)
p = ggplot(d, aes(x=pos, y=runtime)) + geom_point(alpha=.4, size=1) + xlab("fraction of measurements") + ylab("runtime") + scale_y_log10()
ggsave(sprintf("%s-waittimes.pdf", input), plot=p, width=8, height=5)
