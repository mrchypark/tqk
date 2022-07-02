# remotes::install_github("mrchypark/hexSticker")
library(ggplot2)
library(hexSticker)

data <-
  data.frame(
    x = 1:18,
    y = c(3, 2, 2.2, 6, 5, 1.8, 3, 6.5, 8, 7, 8.5, 10, 8, 7.7, 6.5, 7, 6, 7.5)
  )
# line <- data.frame(x=1:18,y=0)

p <- ggplot(aes(x = x, y = y), data = data) +
  geom_line(color = "white", size = 1.3) +
  geom_point(size = 3.5,
             color = "#FFFFFF",
             data = data[c(5, 13), ]) +
  geom_point(size = 3.3,
             color = "#18BC9C",
             data = data[c(5, 13), ]) +
  # geom_line(aes(x=x,y=y),data=line, color = "white", size = 1.5) +
  theme_void()
p
# for windows
sticker(
  p,
  s_x = 1,
  s_y = 1.2,
  s_width = 1.9,
  s_height = 1,
  package = "tqk",
  p_size = 18,
  p_y = 0.5,
  filename = "man/figures/logo.png",
  h_fill = "#2C3E50",
  p_color = "#FFFFFF",
  h_color = "#18BC9C",
  url = "mrchypark.github.io/tqk",
  u_size = 5,
  u_color = "darkgray"
)
