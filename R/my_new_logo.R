library(dplyr); library(ggplot2)

########

def = ggplot(mapping = aes(x, y, label = i)) + coord_fixed(expand = FALSE) + theme_void()

hex = tibble(r = rep(c(1, 6/7), 6), t = rep(pi*(0:5/3 - 1/6), each = 2)) %>%
   transmute(x = r*cos(t), y = r*sin(t), i = row_number())

#def + geom_path(data = hex[c(rep(c(-1, 0, -1), 6) + rep(2*1:6, each=3), 1, 2*1:6, 2), ])

hex = bind_rows(tibble(x = c(rep(.7423, 3), rep(.6186, 4)),
                       y = c(-.5714, 0, .5714, .5, .1237, -.1237, -.5)), hex)

hex = mutate(hex[1:11, ], x = hex$x[1]-x) %>% bind_rows(hex) %>% mutate(i = row_number())

hex$y[c(1, 3, 4, 7:11)] = .95*hex$y[c(1, 3, 4, 7:11)]

#def + geom_text(data = hex)

g = c(13,17,18,12,18,30,29,30,28,27,28,26,25,26,24,23,24,22,14,23,25,27,29,12,13,2,6,17)
h = c(22,15,16,5,4,3,10,8,1,7,6,17,18,12,19,21,14,12,13,17,13,16,13,2,6,2,5,2,3,1)

#def + geom_path(data = hex[h, ]) + geom_path(data = hex[g, ]) + xlim(c(-.9, .9))

hexo = mutate(hex[17 + 2*1:6, ], x = 1.05*x, y = 1.05*y)

let = c("a","í","r","e","l","a",".","La",".","e","x","a","g","o","n","a","l") %>%
   tibble(i = ., r = 3/5, t = pi*1:17/9) %>% mutate(x = r*cos(t), y = r*sin(t))

def + #geom_polygon(data = hexo, fill = "grey95") +
   #geom_text(data = let, family = "mono", col = "grey") +
   geom_polygon(data = hex[h[1:17], ], fill = "grey90") + #geom_path(data = hex[h, ]) +
   geom_polygon(data = hex[g, ], fill = "grey40") #+ geom_path(data = hex[g, ])

#ggsave("static/sticker.svg", width = sqrt(3), height = 2)
ggsave("static/favicon.png", bg = NA, width = 4/15, height = 4/15)

# claro ####

def + geom_polygon(data = hexo, fill = NA) +
   geom_polygon(data = hex[17 + 2*1:6, ], fill = "grey95") +
   geom_polygon(data = hex[c(13, 16, 15, 22), ], fill = "grey60") +
   geom_polygon(data = hex[c(1, 3, 10, 8), ], fill = "grey60") +
   geom_polygon(data = hex[c(12, 14, 21, 19), ], fill = "grey") +
   geom_polygon(data = hex[c(1, 2, 6, 7), ], fill = "grey") +
   geom_polygon(data = hex[c(2:5, 16, 13), ], fill = "grey80") +
   geom_polygon(data = hex[c(14, 22, 24, 23), ]) +
   geom_polygon(data = hex[c(23, 24, 26, 25), ], fill = "grey30") +
   geom_polygon(data = hex[c(25, 26, 28, 30, 29, 27), ], fill = "grey40") +
   geom_polygon(data = hex[c(29, 30, 18, 12), ], fill = "grey30") +
   geom_polygon(data = hex[c(17, 18, 12, 13, 2, 6), ]) +
   geom_text(data = let, col = "grey85", family = "mono") +
   geom_path(data = hex[h, ]) + geom_path(data = hex[g, ])

ggsave("static/logo.png", bg = NA, width = 26/15, height = 2)

# scuro ####

def + geom_polygon(data = hexo, fill = NA) +
   geom_polygon(data = hex[17 + 2*1:6, ], fill = "grey5") +
   geom_polygon(data = hex[c(2:5, 16, 13), ], fill = "grey25") +
   geom_polygon(data = hex[c(12, 14, 21, 19), ], fill = "grey25") +
   geom_polygon(data = hex[c(13, 16, 15, 22), ], fill = "grey15") +
   geom_polygon(data = hex[c(1, 3, 10, 8), ], fill = "grey15") +
   geom_polygon(data = hex[c(1, 2, 6, 7), ]) +
   geom_polygon(data = hex[c(14, 22, 24, 23), ], fill = "grey60") +
   geom_polygon(data = hex[c(23, 24, 26, 25), ], fill = "grey") +
   geom_polygon(data = hex[c(25, 26, 28, 30, 29, 27), ], fill = "grey85") +
   geom_polygon(data = hex[c(29, 30, 18, 12), ], fill = "grey") +
   geom_polygon(data = hex[c(17, 18, 12, 13, 2, 6), ], fill = "grey60") +
   geom_text(data = let, col = "grey20", family = "mono", size = 1) +
   geom_path(data = hex[h, ], col = "grey5") +
   geom_path(data = hex[g, ], col = "grey5")

#ggsave("static/logo2.png", type = "cairo-png", bg = NA, width = .35*sqrt(3), height = .7)
