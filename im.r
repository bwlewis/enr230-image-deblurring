library(jpeg)
library(Matrix)
z = tempfile()
download.file("https://raw.githubusercontent.com/bwlewis/enr230-image-deblurring/main/gc.jpeg", z)
x = readJPEG(z)

x = x[,,1] + x[,,2] + x[,,3]
x = x / max(x)
x = t(x[256:1,])

gblur = function(N, sigma) {
  z = exp(-((0:(N-1))^2) / (2 * sigma^2))
  sqrt(1 / (2 * pi * sigma^2)) * toeplitz(z)
}

K = gblur(dim(x)[1], 5)
B = K %*% x %*% t(K)


#Ki = solve(K)  # does not work
s = svd(K)
N = 190
Ki = s$u[,1:N] %*% diag(1/s$d[1:N]) %*% t(s$v[,1:N])

y = Ki %*% B %*% t(Ki)
y = y / max(abs(y))
image(abs(y), col=gray.colors(256))
