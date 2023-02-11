rm(list = ls())
library(knitr)
library(tidyverse)  # Modern data science workflow
library(sf)
library(sp,terra)
library(rgdal)
library(rgeos)
library(tmap)
library(tmaptools)
library(spgwr)  # GWR
library(gridExtra)
library(grid)

setwd("C:/Users/jabpcomplex/Documents/tu-ruta)/AGEB_BAR_GWR")

#dir.create("plots")
dir()
####################################################################################
# Cargamos el ''' shapefile = DAI_2022_AGEBS.shp'''  con las observaciones 
####################################################################################
shpf<-readOGR("C:/Users/jbautistap/Documents/R/C5/analisis lisa-moran/AGEB_BAR/DAI_2022_AGEBS/DAI_2022_AGEBS.shp",use_iconv = TRUE, encoding = "UTF-8") # encoding="latin1", use_iconv=FALSE)
#AGEB_df<-read_sf("C:/Users/jbautistap/Documents/R/C5/analisis lisa-moran/AGEB_BAR/AGEB_edit/AGEB_BAR.shp")

shpf@polygons
shpf@proj4string

#########################################################
# de que clase es el objeto ## "sf"   "data.frame"
class(shpf)
summary(shpf)

########################################
######### Clean DATA####################
########################################
colnames(shpf@data)
library(janitor)
shpf@data <-  shpf@data %>% clean_names()
colnames(shpf@data)
########################################
#imprimimos algunas columnas del dataframe
glimpse(shpf)
head(shpf@data,20)
head(shpf@data$danos_po_6,100)
############################################
#cambiamos los NA por 0?s
shpf@data[is.na(shpf@data)] <- 0
#Comprobamos que lo haya hecho
head(shpf@data$danos_po_6,100)
# guardamos en un objeto dataframe
shpf_data <- shpf@data ; class(shpf_data)

# Para obtener una comprensi?n inmediata de las variables, lo mejor es mapear las variables y obtener tablas de resumen. 
# Primero, veamos el resumen de las variables.

shpf_data %>% summary()

################################################################################
####### IDENTIFICamos cuales podrian ser las variables que deberiamos ocupar 
################################################################################
unique(shpf@data$cadaver_ho)

unique(shpf@data$denuncia_a)
max(shpf@data$homicidios)

unique(shpf@data$accidente)
head(shpf@data$accidente,20)

unique(shpf@data$agresion_p)
unique(shpf@data$agresion_v)

head(shpf@data$danos_sist,20)
unique(shpf@data$cadaver_ho)
head(shpf@data$danos_casa,20)
unique(shpf@data$danos_casa)

#Filtrado de datos del archivoshape
conteo<-shpf@data[shpf@data$danos_casa==10,]
#shpf@data[which((shpf@data$danos_casa)==10),]

#Conteo de valores unicos
shpf_data %>% count(disturbi_7, name = "total") -> conteo ;View(conteo)

#tipo de datos del shapefile
str(shpf@data)
# Convertimos el tipo de dato del shape, de caracter a numerica
#shpf$danos_casa<-as.numeric(shpf$danos_casa)


#############################################################################################################
# Mostramos la clase de las columnas del data frame
sapply(shpf@data,class)
# Identificamos las columnas con caracteres
indexChr<-sapply(shpf@data,is.character)
# Convertimos las columnas identificadas a numericas
shpf@data[ ,indexChr] <- as.data.frame(apply(shpf@data[ ,indexChr], 2, as.numeric))
# Mostramos la clase de las columnas del data frame
sapply(shpf@data, class)



##############################################################################################################
##############################################################################################################
#Guardar el archivo shapefile con la info limpia
writeOGR(obj=shpf, dsn = "./input", layer = "DAI_2022_AGEBS", driver = "ESRI Shapefile",overwrite_layer = TRUE)
##############################################################################################################
##############################################################################################################







################################################################################################
#### QUEREMOS SABER COMO SE DISTRIBUYEN LOS DATOS QUE VAMOS A UTILIZAR COMO PREDICTORES

hist(shpf@data$homicidios,xlab='',ylab='Frecuencia',col="blue",xlim=c(0,10),
     main = list("homicidios", cex = 1.5, col = "black", font = 2),freq=FALSE)

hist(shpf@data$danos_casa,xlab='',ylab='Frecuencia',col="blue",xlim=c(0,10),
     main = list("% de Da?os a casa", cex = 1.5, col = "black", font = 2),freq=FALSE)
unique(shpf@data$agresion_c)######################################
hist(shpf@data$agresion_c,xlab='',ylab='Frecuencia',col="blue",
     main = list("% de agresi?n a casa habitacion", cex = 1.5, col = "black", font = 2),freq=FALSE)
unique(shpf@data$agresion_n)
hist(shpf_data$agresion_n,xlab='',ylab='Frecuencia',col="blue",
     main = list("% de agresi?n a negocio", cex = 1.5, col = "black", font = 2),freq=FALSE)

hist(shpf_data$danos_prop,xlab='',ylab='Frecuencia',col="blue",
     main = list("% de Da?os a propiedad ajena", cex = 1.5, col = "black", font = 2),freq=FALSE)

hist(shpf_data$danos_nego,xlab='',ylab='Frecuencia',col="blue",
     main = list("% de Da?os a negocio", cex = 1.5, col = "black", font = 2),freq=FALSE)
#21
unique(shpf_data$accidente)
hist(shpf_data$danos_sist,xlab='',ylab='Frecuencia',col="blue",
     main = list("Accidente-Choque con Lesionados", cex = 1.5, col = "black", font = 2),freq=FALSE)
#49
hist(shpf@data$agresion_p,xlab='',ylab='Frecuencia',col="blue",
     main = list("agresion a personas", cex = 1.5, col = "black", font = 2),freq=FALSE)


#168
hist(shpf@data$disturbi_7,xlab='',ylab='Frecuencia',col="blue",
     main = list("Disturbio-Fiestas", cex = 1.5, col = "black", font = 2),freq=FALSE)



########################################################################################################################
# Ejecutamos un modelo lineal para comprender la relaci?n global entre nuestras variables en nuestra ?rea de estudio.
########################################################################################################################


################
#METODO 1
################
library("PerformanceAnalytics")

colmatriz <- shpf_data[, c(8,9,46,47,110,112,21,168,49)]
chart.Correlation(colmatriz, histogram=TRUE, pch=19)
####################################################################################################################################################################
################
#METODO 2
################
plotfuncLow <- function(data,mapping){
  p <- ggplot(data = data,mapping=mapping)+geom_point(shape=21,color="black",fill="grey50")+geom_smooth(method="lm",color="red4",fill="blue2",alpha=0.3)+theme_bw()
  p
}

plotfuncmid <- function(data,mapping){
  p <- ggplot(data = data,mapping=mapping)+geom_density(alpha=0.5,color="red",fill="blue")+theme_bw()
  p
}

library(GGally)

ggpairs(shpf@data,columns=c(8,9,46,47,110,112,21,168,49),lower=list(continuous=plotfuncLow),diag=list(continuous=plotfuncmid))
#la columna de en medio es un histograma
#hist(dataCalls$Calls,freq = FALSE)






##############################################################################################################
#                                                                                                            #
#                                                                                                            #
#                         Geographically weighted regression ( GWR )                                         #
#                         regresi?n ponderada geogr?ficamente                                                #
#                                                                                                            #
#                                                                                                            #
##############################################################################################################





###############################################################################################
#                             MODELO UNO 1
# La funci?n gwr.sel encuentra un ancho de banda  mediante la optimizaci?n de una funci?n seleccionada (CV, AIC, etc).
# Para la validaci?n cruzada, esto punt?a el error de predicci?n cuadr?tico medio de la ra?z para las GWR, eligiendo el ancho de banda que minimiza esta cantidad.
################################################################################################
                     t <- proc.time()   # Inicia el cron?metro para conocer el tiempo de ejecucion al ejecutar la funcion
###############################################################################################
#usa la validaci?n cruzada para encontrar el ancho de banda ?ptimo que usar? el kernel que genera el mejor modelo
GWRbandwidth <- gwr.sel(disturbi_7 ~ homicidios + narcomenud+ agresion_c + agresion_n+danos_casa+danos_nego+accidente+agresion_p, data = shpf, method = "cv",adapt = T,verbose = TRUE)
#GWRbandwidth <- gwr.sel(Calls ~ Pop + Jobs+ LowEduc + Dst2UrbCen, data = obsdataCalls, method = "AIC",adapt = T)

#La funci?n gwr implementa el enfoque b?sico de GWR para explorar la no estacionariedad espacial para un ancho de banda global dado y un esquema de ponderaci?n elegido.
gwr.model <- gwr(disturbi_7 ~ homicidios + narcomenud+ agresion_c + agresion_n+danos_casa+danos_nego+accidente+agresion_p, data = shpf,
                adapt=GWRbandwidth,hatmatrix=TRUE,se.fit=TRUE,gweight = gwr.Gauss)
################################################################################################
                      proc.time()-t    # Detiene el cron?metro  #42 minutos tiempo aproximado
#devuelve 3 resultados #user, system y elapsed:(user) se relaciona con la ejecuci?n del c?digo, 
#el tiempo del sistema (system) se relaciona con procesos del sistema tales como abrir y cerrar archivos, y 
#el tiempo transcurrido (elapsed) es la diferencia en tiempos desde que inici? la ejecuci?n hasta su finalizaci?n.
###############################################################################################
class(gwr.model)


summary(gwr.model)
#Print results
gwr.model
##############
gwr.model$SDF
#ancho de banda ?ptimo estimado
gwr.model$bandwidth

#la llamada de funci?n utilizada.
gwr.model$this.call

#
gwr.model$timings
  
#CREAR dataframe con los resultados
results_model1 <-as.data.frame(gwr.model$SDF)
names(results_model1)


####################################################
####       Creacion y Resultados del mapa 
####################################################

#Vincule los resultados al pol?gono shpf_data
gwr.map1 <- cbind(shpf, as.matrix(results_model1))
class(gwr.map1)
#Guardamos el shapefile con los resultado
writeOGR(gwr.map1, dsn="disturb_7_results_GWR.shp", driver="ESRI Shapefile",layer = "data")
#convertimos el foreign object a sf
shpf_gwr.map1 <- st_as_sf(gwr.map1)
#Los nombres de las variables seguidos del nombre de nuestro marco de datos "shpf" son los coeficientes del modelo.

####################################################
####       mapa R^2 Local
####################################################
#Checar los valores de R^2 locales

#valor de R2 promedio
mean(gwr.model$SDF$localR2)
#m?nimo R2?
min(gwr.model$SDF$localR2)
#m?ximo R2?
max(gwr.model$SDF$localR2)
#desvio est?ndar
sd(gwr.model$SDF$localR2)

qtm(gwr.map1, fill = "localR2")
library(RColorBrewer)
display.brewer.all()#colores para qtm

mapR2<-qtm(gwr.map1, fill = "localR2",fill.title = "r^2 Local",fill.style="fixed",fill.breaks=c(0.2,0.3,0.35,0.4,0.45,0.5,0.55,0.6),style = "beaver",
    fill.palette="YlOrBr",title.position = c("center","top"),borders = 1)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Local r^2 derivado de GWR",main.title.position = "top")

tm_shape(shpf_gwr.map1) + tm_fill("localR2", n = 9, style = "quantile",title = "LocalR2") + tm_borders(col = "black", lwd = 1, lty = "solid")+
  tm_layout(title="R^2 local", frame = TRUE,legend.text.size = 0.9,  legend.title.size = 0.9)
#La figura muestra la distribuci?n espacial del R^2 local derivado del modelos GWR.
#Como se indica en la Figura, los R^2 locales del modelo, en todas las ciudades fueron superiores a 0,82, lo que sugiere que los nueve factores influyentes explicaron m?s del 82% de la expansi?n urbana


#distribucion espacial de la variable dependiente
max(shpf@data$disturbi_7)
hist(shpf@data$disturbi_7,xlab='',ylab='Frecuencia',col="blue",main = list("distubio-fiestas", cex = 1.5, col = "black", font = 2),freq=FALSE)

qtm(shpf_gwr.map1,fill="disturbi_7",fill.title= "disturbio-fiestas",fill.style="fixed",fill.breaks=c(0,2,10,20,29),style = "beaver",
    fill.palette="YlOrBr",title="",title.position = c("center", "top"),frame = TRUE,legend.text.size = 0.9)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Disturbio-Fiestas",main.title.position =  c("center", "top"))




########################################################################################################
####       Distribucion espacial de las variables predictoras o dependientes utilizadas en GWR
gwr.model$this.call
########################################################################################################

#distribuvion espacail homicidios

map1 <- qtm(shpf_gwr.map1,fill="homicidios",fill.title= "homicidios",fill.style="fixed",fill.breaks=c(0,2,4,6,30),style = "beaver",
            fill.palette="YlOrBr",title="",title.position = c("center", "top"),
            frame = TRUE,legend.text.size = 0.9)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Homicidios",main.title.position = "top"); map1


max(shpf@data$narcomenud)######################################
hist(shpf@data$narcomenud,xlab='',ylab='Frecuencia',col="blue",
     main = list("narco", cex = 1.5, col = "black", font = 2),freq=FALSE)

map2 <- qtm(shpf_gwr.map1,fill="narcomenud",fill.title= "narcomenudeo",fill.style="fixed",fill.breaks=c(0,2,4,6,11),style = "beaver",
            fill.palette="YlOrBr",title="",title.position = c("center", "top"),
            frame = TRUE,legend.text.size = 0.9)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Narcomenudeo",main.title.position =  c("center", "top")); map2

max(shpf@data$agresion_c)
hist(shpf@data$agresion_c,xlab='',ylab='Frecuencia',col="blue",main = list("agresion_c", cex = 1.5, col = "black", font = 2),freq=FALSE)

map3 <- qtm(shpf_gwr.map1,fill="agresion_c",fill.title= "agresion_C",fill.style="fixed",fill.breaks=c(0,5,10,15,20,25,44),style = "beaver",
            fill.palette="YlOrBr",title="",title.position = c("center", "top"),
            frame = TRUE,legend.text.size = 0.9)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Agresi?n-Casa Habitaci?n",main.title.position =  c("center", "top")); map3

max(shpf@data$agresion_n)
hist(shpf@data$agresion_n,xlab='',ylab='Frecuencia',col="blue",main = list("agresion_n", cex = 1.5, col = "black", font = 2),freq=FALSE)

map4 <- qtm(shpf_gwr.map1,fill="agresion_n",fill.title= "agresion_C",fill.style="fixed",fill.breaks=c(0,5,10,15,20,27),style = "beaver",
            fill.palette="YlOrBr",title="",title.position = c("center", "top"),
            frame = TRUE,legend.text.size = 0.9)+
  tm_legend(legend.position = c("left", "bottom"),main.title = "Agresi?n-Negocio",main.title.position =  c("center", "top")); map4



## crea una nueva cuadricula (grid)
grid.newpage()

# asigna el tama?o de celda de la cuadricula, en este caso 2 por 2 pus
pushViewport(viewport(layout=grid.layout(2,2)))


map1<-qtm(gwr.map1, fill = "homicidios")+ tm_legend(main.title = "a",main.title.position =  c("center", "top")); map
map2<-qtm(gwr.map1, fill = "narcomenud") +tm_legend(main.title = "b",main.title.position =  c("center", "top")); map
map3<-qtm(gwr.map1, fill = "agresion_c")+ tm_legend(main.title = "c",main.title.position =  c("center", "top")); map
map4<-qtm(gwr.map1, fill = "agresion_n")+ tm_legend(main.title = "d",main.title.position =  c("center", "top")); map
# prints a map object into a defined cell   
print(map1, vp=viewport(layout.pos.col = 1, layout.pos.row =1))
print(map2, vp=viewport(layout.pos.col = 2, layout.pos.row =1))
print(map3, vp=viewport(layout.pos.col = 1, layout.pos.row =2))
print(map4, vp=viewport(layout.pos.col = 2, layout.pos.row =2))

#save_tmap(tm, "World_map.png", width=1920, height=1080)



###################################################################################
####     mapa de los coeficientes asociados a los predictores
####################################################
class(shpf_gwr.map1)

mapp1 <- tm_shape(shpf_gwr.map1) + tm_fill("homicidios.1", n = 5, style = "quantile", title = "Coefficientes homicidios") + tm_borders() +
  tm_layout(frame = TRUE, legend.text.size = 0.9, legend.title.size = 0.8) ; mapp1

#Coefficients asociado al predictor 
mapp2 <- tm_shape(shpf_gwr.map1) + tm_fill("narcomenud.1", n = 5, style = "quantile", title = "Coeficientes nacomenudeo") + tm_borders() +
  tm_layout(frame = FALSE, legend.text.size = 0.5, legend.title.size = 0.6); mapp2

mapp3 <- tm_shape(shpf_gwr.map1) + tm_fill("agresion_c.1", n = 5, style = "quantile", title = "Coeficientes agresion casa-hab") + tm_borders() +
  tm_layout(frame = FALSE, legend.text.size = 0.5, legend.title.size = 0.6); mapp3

mapp4 <- tm_shape(shpf_gwr.map1) + tm_fill("agresion_n.1", n = 5, style = "quantile", title = "Coeficientes agresion negocio") + tm_borders() +
  tm_layout(frame = FALSE, legend.text.size = 0.5, legend.title.size = 0.6); mapp4

## crea una nueva cuadricula (grid)
grid.newpage()

# asigna el tama?o de celda de la cuadricula, en este caso 2 por 2 pus
pushViewport(viewport(layout=grid.layout(2,2)))


mapp1<-qtm(gwr.map1, fill = "homicidios.1",legend.text.size = 0.5)+ tm_legend(main.title = "a",main.title.position =  c("center", "top")); mapp1
mapp2<-qtm(gwr.map1, fill = "narcomenud.1",legend.text.size = 0.5) +tm_legend(main.title = "b",main.title.position =  c("center", "top")); mapp2
mapp3<-qtm(gwr.map1, fill = "agresion_c.1",legend.text.size = 0.5)+ tm_legend(main.title = "c",main.title.position =  c("center", "top")); mapp3
mapp4<-qtm(gwr.map1, fill = "agresion_n.1",legend.text.size = 0.5)+ tm_legend(main.title = "d",main.title.position =  c("center", "top")); mapp4
# prints a map object into a defined cell   
print(mapp1, vp=viewport(layout.pos.col = 1, layout.pos.row =1))
print(mapp2, vp=viewport(layout.pos.col = 2, layout.pos.row =1))
print(mapp3, vp=viewport(layout.pos.col = 1, layout.pos.row =2))
print(mapp4, vp=viewport(layout.pos.col = 2, layout.pos.row =2))



