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
plot(poly.k[,1], poly.k[,2], type="l", xlim=c(0, 120), ylim=c(-120, 0))

# Now define scatter centers and radii.
xrange <- range(poly.k[,1])
xmid <- mean(xrange)
yrange <- range(poly.k[,2])
ymid <- mean(yrange)

N <- 20000
xcoord <- runif(N, xrange[1], xrange[2])
ycoord <- rnorm(N, yrange[1], yrange[2])

points(xcoord, ycoord, pch=16, cex=0.5)
