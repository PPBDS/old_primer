# To load and use rayshader, you need to have xQuartz installed
# on your Mac (see https://www.xquartz.org/). For general infos on
# rayshader and some tutorials, have a look at https://www.rayshader.com/
# and https://wcmbishop.github.io/rayshader-demo/. Note that in any case,
# 3D ggplots with rayshader can only be created if a plot contains a color
# or fill aesthetic.

library(rayshader)
library(tidyverse)
library(rgl)
library(av)



# PLOT 1 - ROLLING DICE ---------------------------------------------------------------

## Step 1: Create any required objects

mydata <- tibble(die.1 = sample(1:6, size = 1000, prob =
                                  c(0.1,0.1,0.1,0.1,0.1,0.5), replace = TRUE),
                 die.2 = sample(1:6, size = 1000, prob =
                                  c(0.1,0.1,0.1,0.1,0.5,0.1), replace = TRUE)) %>%
          group_by(die.1, die.2) %>%
          summarize(total = n())

die1_factor <- as.factor(mydata$die.1)
die2_factor <- as.factor(mydata$die.2)


## Step 2: Create a ggplot object.

mtplot <-  ggplot(mydata) +
              geom_point(aes(x = die1_factor, y = die2_factor, color = total)) +
              scale_color_continuous(limits = c(0,100)) +
              labs(x = "Die 1", y = "Die 2") +
              theme(legend.position = "none")


## Step 3: Turn it into a 3D plot. This takes a bit of time and
## will open an interactive "RGL Device" window with the plot.

plot_gg(mtplot,
        width = 3.5, # Plot width
        zoom = 0.70, # How close camera should be, smaller is closer
        sunangle = 225, # Angle of sunshine for shadows
        soliddepth = -50, # Thickness of pane
        reduce_size = TRUE) # Reduces file size


## Step 4: Tilt the 3D plot in the desired position and run
## the below command to save an image of the current 3D view.

render_snapshot("05-probability/images/dice.png")


## Step 5: Close the "RGL Device" window by running this command. Do
## this EVERY time before you try to create a new 3D plot.

rgl.close()



# PLOT 2 - TEST RESULTS ------------------------------------------------------------------

## Step 1: Create any required objects

set.seed(123)

sims <- 100000

jd_disease <- tibble(ID = 1:sims) %>%
                mutate(have_disease = map_int(ID, ~ rbinom(n = 1,
                                                           size = 1,
                                                           prob = 0.01))) %>%

                mutate(test_positive = map_int(have_disease, ~ ifelse(rbinom(n = 1,
                                                                             size = 1,
                                                                             prob = 0.95),
                                                                      ., ! .)))

jd_sum <- jd_disease %>%
            group_by(test_positive, have_disease) %>%
            summarize(total = n())


## Step 2: Create a ggplot object.

gg <- jd_sum %>%
        ggplot(aes(x = as.factor(test_positive),
                   y = as.factor(have_disease),
                   color = total)) +
        geom_point(size = 5) +
        scale_x_discrete(breaks = c(0, 1),
                         labels = c("Negative", "Positive")) +
        scale_y_discrete(breaks = c(0, 1),
                         labels = c("Negative", "Positive")) +
        labs(x = "Test Result",
             y = "Disease Status",
             title = "Unnormalized Distribution of Test Results and Disease Status",
             subtitle = "Rare diseases have many false positives",
             color = "Cases") +
        theme_classic()


## Step 3: Turn it into a 3D plot.

plot_gg(gg,
        width = 7,
        height = 5,
        zoom = 0.60,
        scale = 250,
        sunangle = 225,
        soliddepth = -50,
        reduce_size = TRUE)


## Step 4: Tilt the 3D plot in the preferred position and run
## the below command to save an image of the current 3D view.

render_snapshot(filename = "05-probability/images/disease.png")


## Step 5: Close the "RGL Device" window.

rgl.close()



# PLOT 3 - BLACK AND WHITE MARBLES --------------------------------------------------------

## Step 1: Create any required objects

x <- tibble(p = rep(seq(0, 1, 0.5), 1000)) %>%
       mutate(white_marbles = map_int(p, ~ rbinom(n = 1, size = 3, p = .))) %>%
       group_by(p,white_marbles) %>%
       summarize(total = n())

p_factor <- as.factor(x$p)
x_factor <- as.factor(x$white_marbles)


## Step 2: Create a ggplot object.

mtplot <-  ggplot(x, aes(x_factor, p_factor, color = total)) +
              geom_point() +
              scale_color_continuous() +
              labs(x = "White Marbles Selected",
                   y = "White Marbles in the Bag",
                   title = "Black and White Marbles",
                   subtitle = "More white marbles in bag mean more white marbles selected",
                   color = "Count")


## Step 3: Turn it into a 3D plot.

plot_gg(mtplot,
        height = 4,
        width = 5,
        zoom = 0.70,
        sunangle = 225,
        soliddepth = -50,
        reduce_size = TRUE)


## Step 4: Tilt the 3D plot in the preferred position and run
## the below command to save an image of the current 3D view.

render_snapshot("05-probability/images/marbles.png")


## Step 5: Close the "RGL Device" window.

rgl.close()



# PLOT 4 - COIN TOSS ----------------------------------------------------------------------

## Step 1: Create any required objects

set.seed(10)

x <- tibble(p = rep(seq(0, 1, 0.1), 1000)) %>%
        mutate(heads = map_int(p, ~ rbinom(n = 1, size = 20, p = .))) %>%
        group_by(p,heads) %>%
        summarize(total = n())

p_factor <- as.factor(x$p)
x_factor <- as.factor(x$heads)


## Step 2: Create a ggplot object.

mtplot = ggplot(x) +
  geom_point(aes(x = x_factor, y = p_factor, color = total)) +
  theme(legend.position = "none") +
  labs(x = "Number of Heads out of 20 Tosses",
       y = expression(rho[h]),
       title = "Empirical Distribution of Number of Heads",
       subtitle = expression(paste("Based on simulations with various values of ", rho[h]))) +
  theme(title = element_text(size = 9),
        axis.text.x = element_text(size = 7),
        axis.title.y = element_text(size = 7))


## Step 3: Turn it into a 3D plot.

plot_gg(mtplot,
        width = 3.5,
        zoom = 0.7,
        sunangle = 225,
        soliddepth = -50,
        reduce_size = TRUE)


## Step 4: Tilt the 3D plot in the preferred position and run
## the below command to save an image of the current 3D view.

render_snapshot(filename = "05-probability/images/coins.png")


## Step 5: Close the "RGL Device" window.

rgl.close()



# PLOT 5 - ANIMATON ---------------------------------------------------------------

## Will add soon



