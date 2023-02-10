# Regresión ponderada geográficamente (GWR) sobre delitos en la CDMX 2022 

## Introducción

En el análisis espacial, es importante identificar la naturaleza de la relación que existe entre las variables. Normalmente, se realiza estimando parámetros con observaciones que se toman de diferentes unidades espaciales que se encuentran en un área de estudio donde se supone que los parámetros son constantes en el espacio.


Sin embargo la mayoría de las veces no es así, esto se conoce como no estacionariedad. La no estacionariedad significa que la relación entre las variables objeto de estudio varía de un lugar a otro en función de factores físicos del entorno que se auto-correlacionan espacialmente, es decir,  la relación entre las variables dependientes e independientes cambia dependiendo de donde nos encontramos en el espacio.
La GWR  es una técnica que se aplica para medir la variación mediante la "calibración"(por calibrar nos referimos a un tipo de ponderación entre los vecinos de las unidades de  análisis) de un modelo de regresión múltiple, que permite que existan diferentes relaciones en diferentes puntos del espacio.
GWR teóricamente puede integrar la ubicación geográfica, la altitud y otros factores para las estimaciones de análisis espacial y refleja la relación espacial no estacionaria entre estas variables.


El método GWR se diseño específicamente para tratar problemas de no estacionariedad [2-3] y es una extensión de los Mínimos Cuadrados Ordinarios (MCO) o regresión lineal simple, para describir la relación entre variables en diferentes puntos del espacio, dar cuenta de la no estacionariedad espacial y finalmente se puede utilizar como modelo de predicción espacial.
GWR se utiliza para capturar la variación a través de la calibración de un modelo de regresión de mínimos cuadrados locales ponderados que permite que existan diferentes relaciones en diferentes puntos del espacio. 

## Método

La regresión lineal simple se usa con frecuencia como herramienta de modelado en el análisis geográfico en el que la variable dependiente se modela como una función lineal de un conjunto de variables independientes conocidas como variables predictoras [3]. Un modelo de regresión global se puede escribir como:

𝑦_𝑖= β_0+∑_(𝑘=1)^𝑛▒〖β_𝑘 𝑥_𝑖𝑘 〗+ε_𝑖               (1)
![image](https://user-images.githubusercontent.com/86539158/218214641-e46f7bbf-00f6-469c-acc1-99b4824e299e.png)


donde  𝑦_𝑖 es la i-ésima observación de la variable dependiente, 𝑥_𝑖𝑘 es la i-ésima observación de la k-ésima variable de respuesta, ε_𝑖 es el i-ésimo  término de error o perturbación (independientes normalmente distribuidos con media cero ) y los predictores β_𝑘 debe determinarse a partir de una muestra de 𝑛 observaciones.


------------------------------------------------------------------------------------------------------------
 

Referencias

[1] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[2] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[3] Fotheringham, A. S., Charlton, M. E., & Brunsdon, C. (1998). Geographically weighted regression: a natural evolution of the expansion method for spatial data analysis. Environment and planning A, 30(11), 1905-1927.

[4] Agudelo Torres, J. E., Agudelo Torres, G. A., Franco Arbeláez, L. C., & Franco Ceballos, L. E. (2015). Efecto de un estadio deportivo en los precios de arrendamiento de viviendas: una aplicación de regresión ponderada geográficamente (GWR). Ecos de Economía, 19(40), 66-80.

[5] Li, S., Zhou, C., Wang, S., Gao, S., & Liu, Z. (2019). Spatial heterogeneity in the determinants of urban form: an analysis of Chinese cities with a GWR approach. Sustainability, 11(2), 479.

[6] Bivand, R. (2017). Geographically weighted regression. CRAN Task View: Analysis of Spatial Data.

