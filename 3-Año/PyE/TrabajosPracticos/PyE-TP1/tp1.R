library(ggplot2)
library(ggsci)
library(forcats)
library(dplyr)

datos <- read.table("base0.txt", header=T, sep="\t", encoding="UTF-8")
datos$ID <- NULL

N <- nrow(datos)

centrar <- theme(plot.title = element_text(hjust = 0.5, size = 15, face = "bold"))

summary(datos)

# frecuenciaCuantitativa <- function(tabla, cortes) {
#   frecAbs <- table(cut(tabla, cortes, right = F))
#   frecRel <- round(frecAbs / length(tabla), digits=2)
#   frecAbsAcum <- cumsum(frecAbs)
#   frecRelAcum <- round(frecAbsAcum / length(tabla), digits=2)

#   return (cbind(frecAbs, frecRel, frecAbsAcum, frecRelAcum))
# }

# frecuenciaCualitativa <- function(tabla) {
#   frecAbs <- table(tabla)
#   frecRel <- round(frecAbs/length(tabla), digits = 2)

#   return (cbind(frecAbs, frecRel))
# }

attach(datos)

######################### UNIVARIADO #########################

# Altura
cortesAltura = seq(0, 39, 3)
# frecuenciaCuantitativa(altura, cortesAltura)

# TODO: poligono acumulativo (para todos)

# ggplot(datos, aes(x=altura, y=cumsum(density))) +
#   stat_ecdf(breaks=cortesAltura, color="black", fill="lightskyblue2") +
#   theme_minimal()
#   scale_x_continuous(breaks = cortesAltura) +
#   scale_y_continuous(breaks = seq(0, 80, 10)) +
#   ggtitle("Distribución de la cantidad de árboles en relación a sus alturas \nBuenos Aires, año 2011") +
#   labs(y = "Cantidad de árboles", x = "Altura en metros (m)") +
#   centrar

ggplot(datos, aes(x=altura)) +
  geom_histogram(breaks=cortesAltura, color="black", fill="lightskyblue2") +
  theme_minimal() +
  scale_x_continuous(breaks = cortesAltura) +
  scale_y_continuous(breaks = seq(0, 100, 10)) +
  labs(y = "Cantidad de árboles", x = "Altura en metros (m)") +
  centrar

# Diámetro
cortesDiámetro = c(seq(0, 120, 10), 140, 160, 180, 200, 251)
# frecuenciaCuantitativa(diámetro, cortesDiámetro)

ggplot(datos, aes(x=diámetro)) +
  geom_histogram(breaks=cortesDiámetro, color="black", fill="lightskyblue2") +
  theme_minimal() +
  scale_x_continuous(breaks = cortesDiámetro) +
  scale_y_continuous(breaks = seq(0, 100, 10)) +
  labs(y = "Cantidad de árboles", x = "Diámetro en metros (m)") +
  centrar

# Inclinación
cortesInclinación = c(0, 3, 6, 9, 12, 15, 18, 21, 30, 45, 60)
# frecuenciaCuantitativa(inclinación, cortesInclinación)

ggplot(datos, aes(x=inclinación)) +
  geom_histogram(breaks=cortesInclinación, color="black", fill="lightskyblue2") +
  theme_minimal() +
  scale_x_continuous(breaks = cortesInclinación) +
  scale_y_continuous(breaks = seq(0, 260, 20)) +
  labs(y = "Cantidad de árboles", x = "Inclinación en grados (°)") +
  centrar

# Brotes
# (...)
ggplot(datos, aes(x=brotes)) +
  geom_bar(color="black", fill="lightskyblue2") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 8, 1)) +
  scale_y_continuous(breaks = seq(0, 140, 20)) +
  labs(y = "Cantidad de árboles", x = "Cantidad de brotes") +
  centrar

# Origen
datosPieOrigen <- datos %>%
                    group_by(origen) %>%
                    count() %>%
                    ungroup() %>%
                    mutate(per = `n`/sum(`n`)) %>%
                    arrange(desc(origen))
datosPieOrigen$label <- scales::percent(datosPieOrigen$per)

ggplot(datosPieOrigen) +
  geom_bar(aes(x="", y=per, fill=origen), stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void() +
  scale_fill_npg() +
  geom_text(aes(x=1, y = cumsum(per) - per / 2, label = label)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

# Especie
datosPieEspecie <- datos %>%
                    group_by(especie) %>%
                    count() %>%
                    ungroup() %>%
                    mutate(per = `n`/sum(`n`)) %>%
                    arrange(desc(especie))
datosPieEspecie$label <- scales::percent(datosPieEspecie$per)

ggplot(datosPieEspecie) +
  geom_bar(aes(x="", y=per, fill=especie), stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void() +
  scale_fill_npg() +
  geom_text(aes(x=1, y = cumsum(per) - per / 2, label = label), nudge_x = 0.2) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

######################### BIVARIADO #########################

# Especies Nativas/Autóctonas
datosPieEspeciesNativas <- datos[origen == "Nativo/Autóctono",] %>%
                            group_by(especie) %>%
                            count() %>%
                            ungroup() %>%
                            mutate(per = `n`/sum(`n`)) %>%
                            arrange(desc(especie))
datosPieEspeciesNativas$label <- scales::percent(datosPieEspeciesNativas$per)

ggplot(datosPieEspeciesNativas) +
  geom_bar(aes(x="", y=per, fill=especie), stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void() +
  scale_fill_npg() +
  geom_text(aes(x=1, y = cumsum(per) - per / 2, label = label), nudge_x = 0.65, size=4) +
  centrar

# Especies Exóticas
datosPieEspeciesExoticas <- datos[origen == "Exótico",] %>%
                            group_by(especie) %>%
                            count() %>%
                            ungroup() %>%
                            mutate(per = `n`/sum(`n`)) %>%
                            arrange(desc(especie))
datosPieEspeciesExoticas$label <- scales::percent(datosPieEspeciesExoticas$per)

ggplot(datosPieEspeciesExoticas) +
  geom_bar(aes(x="", y=per, fill=especie), stat="identity", width=1) +
  coord_polar("y", start=0) +
  theme_void() +
  scale_fill_npg() +
  geom_text(aes(x=1, y = cumsum(per) - per / 2, label = label), nudge_x = 0.65, size=4) +
  centrar

# Brotes según origen
ggplot(datos, aes(x=brotes, fill=origen)) +
  geom_bar(position="identity", color="black") +
  theme_minimal() +
  scale_fill_npg(alpha=0.6) +
  scale_x_continuous(breaks = seq(0, 8, 1)) +
  scale_y_continuous(breaks = seq(0, 120, 10)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

# Altura según especie
datos %>%
  mutate(especie = fct_reorder(especie, altura, .fun="mean")) %>%
  ggplot(aes(x=altura, y=especie, fill=origen)) +
  geom_boxplot() +
  theme_minimal() +
  scale_fill_npg() +
  scale_x_continuous(breaks = seq(0, 40, 5)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

# Diámetro según especie
datos %>%
  mutate(especie = fct_reorder(especie, diámetro, .fun="mean")) %>%
  ggplot(aes(x=diámetro, y=especie, fill=origen)) +
  geom_boxplot() +
  theme_minimal() +
  scale_fill_npg() +
  scale_x_continuous(breaks = seq(0, 250, 25)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

# Inclinación según especie
datos %>%
  mutate(especie = fct_reorder(especie, inclinación, .fun="mean")) %>%
  ggplot(aes(x=inclinación, y=especie, fill=origen)) +
  geom_boxplot() +
  theme_minimal() +
  scale_fill_npg() +
  scale_x_continuous(breaks = seq(0, 60, 5)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

# Brotes según especie
datos %>%
  mutate(especie = fct_reorder(especie, brotes, .fun="mean")) %>%
  ggplot(aes(x=brotes, y=especie, fill=origen)) +
  geom_boxplot() +
  theme_minimal() +
  scale_fill_npg() +
  scale_x_continuous(breaks = seq(0, 8, 1)) +
  labs(y = "TODO: completar", x = "TODO: completar") +
  centrar

