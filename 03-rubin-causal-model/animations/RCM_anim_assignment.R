library(gov.1005.data)
library(tidyverse)
library(gganimate)

platforms <- data.frame(lev = c(5,6,7,8,9,10,11,12,13,14,15,16), group = c(rep("L",6), rep("C", 6)))

tester <- data.frame(y = seq(0,7.5, length.out = 10), x = seq(10.5,7.5, length.out = 10))

fake_data_100 <- data.frame(x = c(jitter(rep(7.5,10)), jitter(rep(13.5,10))), y = c(rep(1,10), rep(0,10)))
## -6, p < 0.05
fake_data_90 <- data.frame(x = c(jitter(rep(7.5,100)), jitter(rep(13.5,100))), y = c(rep(1,90), rep(0,100), rep(1,10)))
## -4.8, p < 0.05
fake_data_80 <- data.frame(x = c(jitter(rep(7.5,100)), jitter(rep(13.5,100))), y = c(rep(1,80), rep(0,100), rep(1,20)))
## - 3.6, p < 0.05
fake_data_70 <- data.frame(x = c(jitter(rep(7.5,100)), jitter(rep(13.5,100))), y = c(rep(1,70), rep(0,100), rep(1,30)))
## - 2.4, p < 0.05
fake_data_60 <- data.frame(x = c(jitter(rep(7.5,100)), jitter(rep(13.5,100))), y = c(rep(1,60), rep(0,100), rep(1,40)))
## -1.2, p < 0.05

ggplot(tester, aes(x = x, y = y)) +
  geom_boxplot(data = platforms, aes(x = lev, y = lev, color = group)) +
  geom_point(size = 2) +
  transition_reveal(y) +
  labs(title = "Tester chooses friendlier platform 10/10 times", subtitle = "Result: Coefficient Estimate of -6, p < 0.05")

