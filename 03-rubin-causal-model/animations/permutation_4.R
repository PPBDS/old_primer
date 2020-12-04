library(gov.1005.data)
library(tidyverse)
library(gganimate)
library(magick)

## Fake Data. Expanded it to 8 since with only 5 data points, didn't result in that many permutations
dat <-

  ## Kinda complicated here, takes one iteration of 8 names and replicates it 100 times
  tibble(subject = rep(c("Joe", "Mary", "Sally", "Bob"),6),

         ## Takes one iteration of yend and replicates it 100 times
         yend = rep(c(13,11,10,12),6),

         ## Saves initial configuration of Treatment and Control, then randomly generates new configuration 99 times
         control = c(c("Treat", "Treat", "Control", "Control"), replicate(5,sample(c("Treat", "Treat", "Control", "Control")))),

         ## Trial will be the permutations we will animate through
         trial = rep(1:6, each=4),

         ## Order is our y-values, allows us to plot the names in the correct order
         order = rep(1:4,6))

## split data by permutation, into 100 tibbles
split_dats <- split(dat,dat$trial)

## Make empty list to store mean treatment effets
mean_effects <- list()

## Calculate mean effects for each permutation
for(i in dat$trial) {
  mean_effects[i] <- sum(split_dats[[i]][split_dats[[i]]$control=="Treat","yend"])/2-
    sum(split_dats[[i]][split_dats[[i]]$control=="Control","yend"])/2
}

## Put mean effects by permutation into data
dat <- dat %>%
  mutate(ef = rep(unlist(mean_effects), each = 4))

## Plot!
p <- ggplot(dat) +
  theme_classic() +

  ## Remove axes
  theme(axis.title.x = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y = element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +

  ## Columns to separate data
  geom_vline(xintercept = -1, linetype = 4) +
  geom_vline(xintercept = 1, linetype = 4) +
  geom_vline(xintercept = 3, linetype = 4) +
  geom_vline(xintercept = -3, linetype = 4) +

  ## Line separating column titles from column values
  geom_hline(yintercept = 4.5, linetype = 1) +

  ## Arbitrary coordinates, makes our plot the right size
  coord_cartesian(xlim = c(-6, 4)) +

  ## Plot subject names, in order, along y = -2
  geom_text(aes(-2, order, label = subject),position = position_dodge(width = 1)) +

  ## Plot Att_end values, in order, along  y = 0
  geom_text(aes(0, order, label = yend),position = position_dodge(width = 1)) +

  ## Plot Group (treat/control) in order, along y = 2
  geom_text(aes(2, order, label = control, colour = ifelse(control == "Control", "red", "green"))) +
  scale_color_manual(values = c("red", "blue")) +
  guides(color = FALSE) +

  ## Column titles
  geom_text(aes(-2,5, label = "Subject")) +
  geom_text(aes(0,5, label = "Att_end")) +
  geom_text(aes(2,5, label = "Group")) +

  ## In its own column, plot treatment effect by permuation
  geom_text(aes(-5,5, label = paste("Treatment Effect = ", ef))) +

  ## Animate along permuation, reduce transition_length to 0 since transitions dont occur here
  transition_manual(trial) +

  ## Make title, closest_state is a temp variable equal to the state we're currently in in our animation
  geom_text(aes(-5,6, label = paste("Permutation: ", trial)))

## animate first plot
plot1 <- animate(p, nframes = 6, fps = 0.3)

plot1


## make new data frame of mean treatment effects
ef <- data.frame(x = unlist(mean_effects)) %>%

  ## Index will be order we animate across
  mutate(index = seq(1:length(x)),

         ## Type allows us to differentiate between true data and permutations
         type = c("actual", rep("per", 5))) %>%

  ## y is literally y-value, puts points on top of each other
  group_by(x) %>%
  mutate(y = seq_along(x))

## plot again!
p2 <-
  ggplot(ef, aes(group = index, x, y, color = type)) +

  ## Scatterplot of points, where x is treatment effect and y is the assigned y
  geom_point(size = 5) +
  ## Animates through index, one dot at a time
  transition_reveal(index) +
  xlab("Treatment Effect") +
  ylab("") +
  scale_color_manual(values = c("red", "black")) +
  ## Remove y axis
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

## animate plot!
plot2 <- animate(p2, nframes = 6, fps = 0.3)

## saves temp gifs
anim_save("anim1.gif", plot1)
anim_save("anim2.gif", plot2)

## loads in temp gifs in right format
anim1 <- image_read("anim1.gif")
anim2 <- image_read("anim2.gif")

## puts gifs together
new_gif <- image_append(c(anim1[1], anim2[1]))
for(i in 2:6){
  combined <- image_append(c(anim1[i], anim2[i]))
  new_gif <- c(new_gif, combined)
}

new_gif
