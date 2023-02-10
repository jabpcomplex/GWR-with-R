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

![image](https://user-images.githubusercontent.com/86539158/218214641-e46f7bbf-00f6-469c-acc1-99b4824e299e.png)

donde  𝑦_𝑖 es la i-ésima observación de la variable dependiente, 𝑥_𝑖𝑘 es la i-ésima observación de la k-ésima variable de respuesta, ε_𝑖 es el i-ésimo  término de error o perturbación (independientes normalmente distribuidos con media cero ) y los predictores β_𝑘 debe determinarse a partir de una muestra de 𝑛 observaciones.


GWR amplía el marco de regresión de la ec. (1) al permitir estimar el parámetro local en lugar del parámetro global, de modo que el modelo se reescribe como:

![image](https://user-images.githubusercontent.com/86539158/218214792-65fa0699-ebca-448b-b4e5-5893c497dca9.png)


donde (𝑢_𝑖,𝑣_𝑖) son las coordenadas del punto en el espacio y 𝛽_𝑘 (𝑢_𝑖,𝑣_𝑖) es la realización de la función continua 𝛽_𝑘 (𝑢,𝑣) en el punto 𝑖. 
La calibración de ec. (2) supone que los datos observados cerca de la ubicación 𝑖 podrían tener más influencia en la estimación de 𝛽_𝑘 (𝑢_𝑖,𝑣_𝑖).

Los mínimos cuadrados ponderados proporcionarán una comprensión básica de cómo funciona el GWR. En el método de mínimos cuadrados ponderados, se aplica un factor de ponderación a cada diferencia cuadrática antes de minimizar, de modo que la inexactitud de algunas predicciones conllevará una mayor penalización que otras. En GWR, una observación se pondera cerca de la ubicación 𝑖, de modo que la ponderación de una observación varía con 𝑖. Los datos obtenidos de observaciones cercanas a 𝑖 tienen más peso que los datos obtenidos de observaciones lejanas, es decir:


![image](https://user-images.githubusercontent.com/86539158/218215268-de7cafeb-fa66-42b9-a855-0b74fa3b83f7.png)

donde 𝜷̂ es una estimación de 𝜷 y 𝑾(𝑢_𝒊, 𝑣_𝒊) es una matriz de 𝑛 por 𝑛 cuyos elementos fuera de la diagonal son cero y cuyos elementos diagonales indican la ponderación geográfica de los datos observados para el punto 𝒊.

------------------------------------------------------------------------------------------------------------
Primero es necesario definir las unidades de análisis, que en este caso serán las Áreas Geoestadísticas Básicas (AGEB´s) de la ciudad de México (CDMX).

 
 ![image](https://user-images.githubusercontent.com/86539158/218216182-bc89475e-f3bc-4d5b-a7ba-d9bb62e533c9.png)


Después es necesario definir un tipo de ponderación entre los vecinos de las unidades de 
análisis. 

En el modelo de MCO ponderados o en el análisis de Moran la ponderación esta determinada por la distancia del punto i y su j-ésimo vecino. Y su matriz de ponderación es:

![image](https://user-images.githubusercontent.com/86539158/218216375-a491aee0-50d6-4b0a-b563-25a687ad9903.png)

donde 𝑑_𝑖𝑗 es la distancia ente i y j.

La ec. (3)  sufrirá problemas de discontinuidad a medida que 𝑖 varía alrededor del área de estudio. Para solucionar este problema GWR asocia una función continua como una forma de combatir el problema de la discontinuidad de los pesos.


![image](https://user-images.githubusercontent.com/86539158/218216575-9595291f-5ddd-4868-92c3-42aacbaf5f5a.png)

donde 𝑏 se denomina ancho de banda (bandwidth).

Otra función de ponderación alternativa  es:

![image](https://user-images.githubusercontent.com/86539158/218216740-549f2f12-e19c-4844-aa11-3f1e247c8930.png)




 
 
 
 
 
 
 
 
 
 
 
 
------------------------------------------------------------------------------------------------------------
Referencias

[1] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[2] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[3] Fotheringham, A. S., Charlton, M. E., & Brunsdon, C. (1998). Geographically weighted regression: a natural evolution of the expansion method for spatial data analysis. Environment and planning A, 30(11), 1905-1927.

[4] Agudelo Torres, J. E., Agudelo Torres, G. A., Franco Arbeláez, L. C., & Franco Ceballos, L. E. (2015). Efecto de un estadio deportivo en los precios de arrendamiento de viviendas: una aplicación de regresión ponderada geográficamente (GWR). Ecos de Economía, 19(40), 66-80.

[5] Li, S., Zhou, C., Wang, S., Gao, S., & Liu, Z. (2019). Spatial heterogeneity in the determinants of urban form: an analysis of Chinese cities with a GWR approach. Sustainability, 11(2), 479.

[6] Bivand, R. (2017). Geographically weighted regression. CRAN Task View: Analysis of Spatial Data.

