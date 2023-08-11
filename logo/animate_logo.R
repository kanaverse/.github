# Animate the logo with some sparkling effects. This requires a high-resolution
# PNG saved from the SVG file at 150 DPI.

library(png)
X <- as.array(readPNG("logo.png"))
unlink("sequence", recursive=TRUE)
dir.create("sequence")

set.seed(1000)
chunk <- 20
refdim <- ceiling(dim(X)[1:2] / chunk)
schedule <- matrix(runif(refdim[1] * refdim[2]), refdim[1], refdim[2]) * 2 * pi
schedule <- schedule[
    head(rep(seq_len(refdim[1]), each=chunk), dim(X)[1]),
    head(rep(seq_len(refdim[2]), each=chunk), dim(X)[2])
]

nsteps <- 50
imgs <- character(0)
radstep <- 2 * pi / nsteps
for (step in 1:nsteps) {
    schedule <- schedule + radstep
    state <- cos(schedule)

    # Applying the shading, though not too extreme.
    darken <- state < 0
    brighten <- state[!darken] * 0.4
    darkening <- 1 + state[darken] * 0.4

    copy <- X
    for (i in 1:3) {
        current <- copy[,,i]
        current[darken] <- current[darken] * sqrt(darkening)
        brightbase <- current[!darken]^2
        current[!darken] <- sqrt((1 - brightbase) * brighten + brightbase)
        copy[,,i] <- current
    }

    imgname <- file.path("sequence", paste0(step, ".png"))
    writePNG(copy, imgname, dpi=150)
    imgs <- c(imgs, imgname)
}

library(magick)
listed <- lapply(imgs, image_read)
joined <- image_join(listed)
animated <- image_animate(joined, delay = 10, optimize=TRUE)
image_write(image = animated, "logo.gif")
