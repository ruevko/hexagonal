library(dplyr); library(ggplot2); theme_set(theme_void())

hex = tibble(r = rep(c(1, 5/6), 6), t = rep(pi*0:5/3 - pi/6, each = 2)) %>%
   transmute(x = r*cos(t), y = r*sin(t), i = row_number())

# hex[c(rep(c(-1, 0, -1), 6) + rep(2*1:6, each = 3), 1, 2*1:6, 2), ] %>%
#    ggplot(aes(x, y)) + coord_fixed(1) + geom_path()


hex = head(hex, 2) %>% mutate(y = hex$y[1] - y) %>% bind_rows(hex)

hex = hex[c(6, 1:14), ]; hex$y[1] = hex$y[6] - hex$y[7]

hex = head(hex, 7) %>% mutate(x = hex$x[1] - x) %>% bind_rows(hex) %>% mutate(i = 1:22)

hex$y[4:7] = 5/6*hex$y[4:7]; hex$x[1:7] = hex$x[1:7] - mean(hex$x[1:2])

# ggplot(hex, aes(x, y, label = i)) + coord_fixed(1) + geom_text()


way = c(1, 7, 6, 4, 5, 3, 10, 12, 22, 20, 18, 16, 14, 8, 9, 13, 14, 13, 15, 16,
        15, 17, 18, 17, 19, 20, 19, 21, 22, 21, 11, 12, 11, 9, 10, 9, 8, 1, 2, 3)

hex[c(way[1:16], 15, 17, 19, 21, 11, 9, 8), ] %>%
   ggplot(aes(x, y)) + coord_fixed(1) + geom_polygon()

ggsave("static/favicon.png", bg = NA, width = 8/15, height = 8/15)


let = c("a", "í", "r", "e", "l", "a", ".", "La", ".",
        "e", "x", "a", "g", "o", "n", "a", "l") %>%
   tibble(i = ., r = 3/5, t = pi*1:17/9) %>%
   mutate(x = r*cos(t), y = r*sin(t))

# ggplot(hex[way, ], aes(x, y)) + coord_fixed(1) + geom_path() +
#    geom_text(aes(label = i), let, family = "mono")
#
# ggsave("static/figure.png", bg = NA, width = 2, height = 2, dpi = "retina")


ggplot(mapping = aes(x, y)) + coord_fixed(1) +
   geom_polygon(data = hex[2*6:11, ], fill = "grey85") +
   geom_polygon(data = hex[c(8:9, 13:14), ], fill = "grey60") +
   geom_polygon(data = hex[c(4, 5, 7, 6), ], fill = "grey60") +
   geom_polygon(data = hex[c(1:3, 10:8), ], fill = "grey30") +
   geom_polygon(data = hex[c(1, 2, 9, 8), ], fill = "grey45") +
   geom_polygon(data = hex[c(9, 10, 12, 11), ], fill = "grey35") +
   geom_polygon(data = hex[c(21, 22, 12, 11), ], fill = "grey40") +
   geom_polygon(data = hex[c(19, 20, 22, 21), ], fill = "grey45") +
   geom_polygon(data = hex[c(17, 18, 20, 19), ], fill = "grey40") +
   geom_polygon(data = hex[c(15, 16, 18 ,17), ], fill = "grey35") +
   geom_polygon(data = hex[c(13, 14, 16, 15), ], fill = "grey30") +
   geom_text(aes(label = i), let, col = "white", family = "mono")

ggsave("static/logo.png", bg = NA, width = 2, height = 2, dpi = "retina")
