library(ggthemes)
site_discharge <- sitedata("01567000", "1970-10-01", "1971-10-01")

s <- ggplot(data = site_discharge, aes(x = Date, y = mm_day))+
  geom_line(color = "blue")+
  theme_void()+
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank())+
  labs(y = "",
       x = "")

easyrbi_sticker <- sticker(s, package="easyrbi", p_size = 7, p_y = 1.5,
        s_x = 1, s_y = .85, s_width = 1.3,h_size = 1.5, s_height = 1,url = "github.com/amutaya/easyrbi", h_fill = "#E69F00", h_color = "brown",
        filename="data-raw/easyrbiHex.png")

save_sticker(
  here::here("data-raw", "easyrbiHex.png"),
  easyrbi_sticker
)
