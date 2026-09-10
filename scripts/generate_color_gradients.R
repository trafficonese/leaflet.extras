
# https://colorbrewer2.org/?type=sequential&scheme=BuGn&n=9#type=sequential&scheme=YlGn&n=9

# Define the color vectors with corresponding gradient names
color_gradients <- list(
  "BuGn" = c('#f7fcfd','#e5f5f9','#ccece6','#99d8c9','#66c2a4','#41ae76','#238b45','#006d2c','#00441b'),
  "BuPu" = c('#f7fcfd','#e0ecf4','#bfd3e6','#9ebcda','#8c96c6','#8c6bb1','#88419d','#810f7c','#4d004b'),
  "GnBu" = c('#f7fcf0','#e0f3db','#ccebc5','#a8ddb5','#7bccc4','#4eb3d3','#2b8cbe','#0868ac','#084081'),
  "OrRd" = c('#fff7ec','#fee8c8','#fdd49e','#fdbb84','#fc8d59','#ef6548','#d7301f','#b30000','#7f0000'),
  "PuBu" = c('#fff7fb','#ece7f2','#d0d1e6','#a6bddb','#74a9cf','#3690c0','#0570b0','#045a8d','#023858'),
  "PuBuGn" = c('#fff7fb','#ece2f0','#d0d1e6','#a6bddb','#67a9cf','#3690c0','#02818a','#016c59','#014636'),
  "PuRd" = c('#f7f4f9','#e7e1ef','#d4b9da','#c994c7','#df65b0','#e7298a','#ce1256','#980043','#67001f'),
  "RdPu" = c('#fff7f3','#fde0dd','#fcc5c0','#fa9fb5','#f768a1','#dd3497','#ae017e','#7a0177','#49006a'),
  "YlGn" = c('#ffffe5','#f7fcb9','#d9f0a3','#addd8e','#78c679','#41ab5d','#238443','#006837','#004529'),
  "YlGnBu" = c('#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#253494','#081d58'),
  "YlOrBr" = c('#ffffe5','#fff7bc','#fee391','#fec44f','#fe9929','#ec7014','#cc4c02','#993404','#662506'),
  "YlOrRd" = c('#ffffcc','#ffeda0','#fed976','#feb24c','#fd8d3c','#fc4e2a','#e31a1c','#bd0026','#800026')
)
names(color_gradients)
#' Include the names in webGLHeatmap.R  `addWebGLHeatmap` and names + link to image `webGLHeatmapDependency`
dput(names(color_gradients))
cat(paste0('"', names(color_gradients), '" = "', paste0(names(color_gradients), '.png'), '",\n'))

generate_save_gradient <- function(colors, gradient_name) {
  # Create a gradient image
  gradient <- matrix(1:9, nrow=1)
  gradient <- t(gradient)

  # Set the filename
  filename <- paste0(gradient_name, ".png")

  ## Interpolate colors
  width <- 512
  height <- 10
  gradient <- matrix(NA, nrow = height, ncol = width)
  for (i in 1:width) {
    # Calculate the color index based on the position along the gradient
    color_index <- (length(colors) - 1) * (i - 1) / (width - 1) + 1

    # Calculate the fractional part for interpolation
    fraction <- color_index - floor(color_index)

    # Determine the indices of the neighboring colors
    lower_index <- floor(color_index)
    upper_index <- ceiling(color_index)

    # Interpolate between the neighboring colors for each color component
    interpolated_color <- sapply(1:3, function(component) {
      lower_color <- col2rgb(colors[lower_index])[component]
      upper_color <- col2rgb(colors[upper_index])[component]
      interpolated_component <- lower_color + fraction * (upper_color - lower_color)
      round(interpolated_component)
    })

    # Combine the interpolated color components into a single RGB color
    interpolated_color <- rgb(
      interpolated_color[1],
      interpolated_color[2],
      interpolated_color[3],
      maxColorValue = 255
    )

    # Store the interpolated color in the gradient matrix
    gradient[, i] <- rep(interpolated_color, height)
  }

  # Save the gradient image
  png(paste0("./inst/htmlwidgets/build/lfx-webgl-heatmap/",filename),
      width=width, height=height, units="px", res=72, type="cairo")
  par(mar=rep(0,4))
  image(t(matrix(1:width, nrow=1)), col=rev(gradient), axes=FALSE)
  dev.off()
}

# Generate and save color gradients
for (gradient_name in names(color_gradients)) {
  generate_save_gradient(color_gradients[[gradient_name]], gradient_name)
}



## Build the R-package and Test with the following Code Snippet
leaflet(quakes) %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addWebGLHeatmap(lng = ~long, lat = ~lat, size = 60000,
                  # gradientTexture = "deep-sea"
                  # gradientTexture = "skyline"
                  # gradientTexture = "BuGn"
                  # gradientTexture = "BuPu"
                  # gradientTexture = "GnBu"
                  # gradientTexture = "OrRd"
                  # gradientTexture = "PuBu"
                  # gradientTexture = "PuBuGn"
                  # gradientTexture = "PuRd"
                  # gradientTexture = "RdPu"
                  # gradientTexture = "YlGn"
                  # gradientTexture = "YlGnBu"
                  # gradientTexture = "YlOrBr"
                  # gradientTexture = "YlOrRd"
  )

