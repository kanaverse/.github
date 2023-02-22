# Define a polygon for the letter "K".
 
position <- c(86.128264,90.944801)
poly.k <- list(position)

position[1] <- position[1] - 10.82223
poly.k <- c(poly.k, list(position))

position <- position + c(-24.8027,-27.918828)
poly.k <- c(poly.k, list(position))

position <- position + c(-6.232258,6.653356)
poly.k <- c(poly.k, list(position))

position[2] <- 90.944801
poly.k <- c(poly.k, list(position))

position[1] <- 35.933327
poly.k <- c(poly.k, list(position))

position[2] <- 28.243239
poly.k <- c(poly.k, list(position))

position[1] <- position[1] + 8.337749
poly.k <- c(poly.k, list(position))

position[2] <- 60.96259
poly.k <- c(poly.k, list(position))

position <- c(74.716496,28.243239)
poly.k <- c(poly.k, list(position))

position[1] <- 84.822859
poly.k <- c(poly.k, list(position))

position <- c(56.819811,57.720132)
poly.k <- c(poly.k, list(position))

poly.k <- do.call(rbind, poly.k)
poly.k[,2] <- -poly.k[,2]
poly.k[,1] <- (poly.k[,1] - min(poly.k[,1]))/diff(range(poly.k[,1]))
poly.k[,2] <- (poly.k[,2] - min(poly.k[,2]))/diff(range(poly.k[,2]))

# Now define scatter centers and radii.
set.seed(42)
center <- 0.5
radius <- center * sqrt(2) * 1.1
ext <- radius * 1.1
N <- 20000
xcoord <- runif(N, center - ext, center + ext)
ycoord <- runif(N, center - ext, center + ext)

filter <- sqrt((xcoord - center)^2 + (ycoord - center)^2) <= radius
keep <- filter | rbinom(N, 1, 0.01)

is.inside <- mgcv::in.out(poly.k, cbind(xcoord, ycoord))
keep <- keep & (!is.inside | rbinom(N, 1, 0.05))
xcoord <- xcoord[keep]
ycoord <- ycoord[keep]

# Choosing colors, with a nice gradient for some depth.
host.colors <- c("#C23B23", "#F39A27", "#976ED7", "#03C03C", "#579ABE", "#EADA52")
xpos <- c(0, 0, 0.5, 0.7, 0.7, 1)
ypos <- c(0, 1, 0.5, 0, 1, 0.5)

library(FNN)
closest <- get.knnx(query=cbind(xcoord, ycoord), data=cbind(xpos, ypos), k=2)
switch <- 0.5 * exp(-(closest$nn.dist[,2]/closest$nn.dist[,1])^2 / 1.5)
chosen <- ifelse(runif(nrow(closest$nn.index)) >= switch, closest$nn.index[,1], closest$nn.index[,2])
colors <- host.colors[chosen]

# Creating the raw logo for full use.
png("logo.png", width=3, height=3, units="in", res=180)
par(mar=c(0,0,0,0))
plot(poly.k[,1], poly.k[,2], type="n", xlim=c(center-radius, center+radius), ylim=c(center-radius, center+radius), axes=FALSE)
points(xcoord, ycoord, pch=16, cex=center, col=colors)
dev.off()

# Not sure how to actually produce a favicon directly here,
# keeps on complaining about the figure margins being too small.
# $ convert raw_favicon.png -resize 16x16 favicon.png
png("raw_favicon.png", width=3, height=3, units="in", bg="transparent", res=180)
par(mar=c(0,0,0,0))
plot(poly.k[,1], poly.k[,2], type="n", xlim=c(center-radius, center+radius), ylim=c(center-radius, center+radius), axes=FALSE)

sub <- sample(N, 5000) # use fewer, larger points so that the heterogeneity is more obvious in a favicon.
xsub <- xcoord[sub]
ysub <- ycoord[sub]
refilter <- sqrt((xsub - center)^2 + (ysub - center)^2) <= radius
points(xsub[refilter], ysub[refilter], pch=16, cex=1, col=colors[sub][refilter])
dev.off()

# Creating a GIF.
relstepsize <- rep(c(1, 0.5, 0.1, 0.05, 0.01), c(5, 5, 5, 5, 5))
relstepsize <- c(0, cumsum(relstepsize / sum(relstepsize)))
imgs <- character(0)
dir.create("sequence") 

for (forward in c(TRUE, FALSE)) {
    xrand <- rnorm(length(xcoord), mean=center + radius * 2 * if (forward) -1 else 1, sd=0.5) 
    yrand <- rnorm(length(ycoord), mean=center)

    xsteps <- xcoord - xrand 
    ysteps <- ycoord - yrand

    for (i in seq_along(relstepsize)) {
        if (!forward && i == 1) {
            next
        }

        frac <- if (forward) relstepsize[i] else relstepsize[length(relstepsize) - i + 1L]
        xprogress <- xrand + xsteps * frac 
        yprogress <- yrand + ysteps * frac 

        index <- if (forward) i else i + length(relstepsize)
        path <- paste0("sequence/", index, ".png")
        imgs <- c(imgs, path)

        png(path, width=3, height=3, units="in", res=90)
        par(mar=c(0,0,0,0))
        plot(poly.k[,1], poly.k[,2], type="n", xlim=c(center-radius, center+radius), ylim=c(center-radius, center+radius), axes=FALSE)
        points(xprogress, yprogress, pch=16, cex=center, col=colors)
        dev.off()
    }
}

library(magick)
listed <- lapply(imgs, image_read)
joined <- image_join(listed)
animated <- image_animate(joined, delay = 10, optimize=TRUE)
image_write(image = animated, "logo.gif")
