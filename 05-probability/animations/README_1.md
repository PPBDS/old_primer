!!! to load rayshader you need to have xQuartz downloaded on mac see https://www.xquartz.org/ and https://github.com/tylermorganwall/rayshader/issues/5 etc. 

- Final_Visuals.Rmd makes all the visuals using hist3D

- rayshader.Rmd makes all the visuals using rayshader and plot_gg
  
  - the ray_gifs folder stores all of the gifs made in rayshader.Rmd
  - the ray_images folder stores all of the images/individual pngs made in rayshader.Rmd
  - note that the rayshader.Rmd has code that can take quite a while to run and may take 10-20 min to knit if you are creating all the images (check code chunks for eval = FALSE or add that to keep images from generating with each knit if that is desired to save time)
  
  
Notes on rayshader v. hist3D:
  
While the rayshader stuff was more aesthetically pleasing and was helpful in that it used ggplot stuff, it was a lot more difficult to work with for making this type of histogram visual (for example, much slower, can't manually set z-axis which means you can't control the scale of the plot, not built to make histograms). I would compare it to trying to trick something into doing what it's not supposed to do in order to get it to do what you want but also not totally being able to get it to do what you want. I'm not saying that it's impossible, but to make really nice animations with it would probably involve a longer project, so if someone wanted to try and take what I've done with plot3d and try to do something similar with rayshader, that could be a cool project.