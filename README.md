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

![image|30](https://user-images.githubusercontent.com/86539158/218214641-e46f7bbf-00f6-469c-acc1-99b4824e299e.png)

donde  𝑦_𝑖 es la i-ésima observación de la variable dependiente, $x_{ij}$ es la i-ésima observación de la k-ésima variable de respuesta, $\varepsilon_i$ es el i-ésimo  término de error o perturbación (independientes normalmente distribuidos con media cero ) y los predictores β_𝑘 debe determinarse a partir de una muestra de 𝑛 observaciones.


GWR amplía el marco de regresión de la ec. (1) al permitir estimar el parámetro local en lugar del parámetro global, de modo que el modelo se reescribe como:

![image|30](https://user-images.githubusercontent.com/86539158/218214792-65fa0699-ebca-448b-b4e5-5893c497dca9.png)


donde $(u_i,v_i)$ son las coordenadas del punto en el espacio y $\beta_k(u_i,v_i)$  es la realización de la función continua $\beta_k(u,v)$ en el punto $i$. 
La calibración de ec. (2) supone que los datos observados cerca de la ubicación 𝑖 podrían tener más influencia en la estimación de $\beta_k(u_i,v_i)$.

Los mínimos cuadrados ponderados proporcionarán una comprensión básica de cómo funciona el GWR. En el método de mínimos cuadrados ponderados, se aplica un factor de ponderación a cada diferencia cuadrática antes de minimizar, de modo que la inexactitud de algunas predicciones conllevará una mayor penalización que otras. En GWR, una observación se pondera cerca de la ubicación 𝑖, de modo que la ponderación de una observación varía con 𝑖. Los datos obtenidos de observaciones cercanas a 𝑖 tienen más peso que los datos obtenidos de observaciones lejanas, es decir:


![image|30](https://user-images.githubusercontent.com/86539158/218215268-de7cafeb-fa66-42b9-a855-0b74fa3b83f7.png)

donde $\hat{\beta}$ es una estimación de $\beta$ y $W(u_i, v_i)$ es una matriz de $nxn$ cuyos elementos fuera de la diagonal son cero y cuyos elementos diagonales indican la ponderación geográfica de los datos observados para el punto $i$.

------------------------------------------------------------------------------------------------------------
Primero es necesario definir las unidades de análisis, que en este caso serán las Áreas Geoestadísticas Básicas (AGEB´s) de la ciudad de México (CDMX).

 
 ![image|30](https://user-images.githubusercontent.com/86539158/218216182-bc89475e-f3bc-4d5b-a7ba-d9bb62e533c9.png)


Después es necesario definir un tipo de ponderación entre los vecinos de las unidades de 
análisis. 

En el modelo de MCO ponderados o en el análisis de Moran la ponderación esta determinada por la distancia del punto i y su j-ésimo vecino. Y su matriz de ponderación es:

![image|30](https://user-images.githubusercontent.com/86539158/218219116-0df2e5d6-310e-43cf-a5be-684b98569d36.png)

donde $d_{ij}$ es la distancia ente i y j.



La ec. (3)  sufrirá problemas de discontinuidad a medida que 𝑖 varía alrededor del área de estudio. Para solucionar este problema GWR asocia una función continua como una forma de combatir el problema de la discontinuidad de los pesos.


![image|30](https://user-images.githubusercontent.com/86539158/218216575-9595291f-5ddd-4868-92c3-42aacbaf5f5a.png)

donde 𝑏 se denomina ancho de banda (bandwidth).

Otra función de ponderación alternativa  es:

![image|30](https://user-images.githubusercontent.com/86539158/218216740-549f2f12-e19c-4844-aa11-3f1e247c8930.png)

𝐾(𝑑_𝑖𝑗) se conoce como  función Kernel vecina más cercana bicuadrada. 
Existen diferentes du funciones de ponderación que se pueden utilizar dependiendo de la forma en la que se distribuyen los datos en el espacio geográfico. La función en ec.(4 ) se conoce como  función Kernel de Gauss. 

En otras palabras si la distancia entre el sitio 𝑖 y el sitio 𝑗 es menor que el ancho de banda 𝑏, se asocia un numero de ponderación y se contabiliza en el modelo dado por la ec.(2)

Funciones de ponderación:

![image|30](https://user-images.githubusercontent.com/86539158/218217928-6c23019e-109e-409e-910c-dbf0721255e1.png)


Se han propuesto varios criterios para seleccionar un ancho de banda optimo.  Por ejemplo:

El enfoque de validación cruzada (VC)
El criterio de información de Akaike (AIC
Es importante mencionar que para seleccionar las variables predictoras que introduciremos como parámetros en las llamadas de las funciones, se investigó la correlación entre algunas de las observaciones de la base y utilizamos las que mostraron mayor correlación.

FUNCIONES:

La función gwr.sel(parámetros) de la librería spgwr en R [6]  encuentra un ancho de banda  mediante la optimización de una función seleccionada (CV, AIC, etc).


La función gwr(parámetros) implementa el enfoque básico de GWR para explorar la no estacionariedad espacial para un ancho de banda dado y un esquema de ponderación elegido.
 
 
De la base de datos DAI_2022_AGEBS   usamos las siguientes variables como predictores:
1.homicidios    5. danos_casa
2.narcomenud    6. danos_nego
3. resion_c    7. agresion_n 
4. Accidente     8. agresion_p

Para predecir la variable disturbi_7(Disturbio-Fiesta), es decir, la cantidad de disturbios en fiestas asociada a cada AGEB. 
Usamos la validación cruzada (cv) para encontrar el ancho de banda óptimo (GWRbandwidth) que usará el kernel que genera el mejor modelo

GWRbandwidth <- gwr.sel(disturbi_7 ~ homicidios + narcomenud+ agresion_c + agresion_n + danos_casa + danos_nego + accidente + agresion_p, data = shpf, method = "cv",adapt = T,verbose = TRUE)

La función gwr implementa el enfoque básico de GWR para explorar la no estacionariedad espacial para un ancho de banda dado y un esquema de ponderación elegido (función Kernel).

gwr(formula = disturbi_7 ~ homicidios + narcomenud + agresion_c + agresion_n + danos_casa + danos_nego + accidente + agresion_p, data = shpf, gweight = gwr.Gauss, adapt = GWRbandwidth, hatmatrix = TRUE, se.fit = TRUE)


El llamado de gwr()  aplica la función de ponderación a su vez a cada una de las observaciones, o puntos de ajuste si se dan, calculando una regresión ponderada para cada punto. Los resultados pueden explorarse para ver si los valores de los coeficientes varían en el espacio. 

En las imágen se muestra un panorama general de los resultados. 


La figura muestra la distribución espacial de la variable dependiente disturbi_7(Disturbio-Fiestas) en la CDMX a nivel de AGEB’s para el año 2022.

![image|30](https://user-images.githubusercontent.com/86539158/218218395-477d6b82-4cc2-4601-bb61-d31c25f9c7f8.png)

La siguiente figura muestra la distribución espacial de los coeficientes de regresión para los primeros 4 factores de influencia:

(a) homidicios; 
(b) narcomenud; 
(c) agresion_c  (Agresión-Casa Habitación); 
(d) agresion_n (Agresión-negocio);

 derivados de los modelos GWR, siendo disturb_7 la variable dependiente.
 
 ![image|30](https://user-images.githubusercontent.com/86539158/218218646-7f7bd423-4df1-4ab7-87b9-9baaef53ede8.png)

 La figura muestra la variación geográfica del R^2 local del modelo representado por la ec.(2), que oscila entre 0.2 y 0.6

Dado que el R^2 es muy bajo para la mayoría de las unidades de análisis no tendremos una buena predicción de la variable de respuesta disturbi_7

Por lo tanto las conclusiones que pudramos obtener de los coeficientes de predicción serán equivocadas.

![image|30](https://user-images.githubusercontent.com/86539158/218218830-cad7d9e7-0d2e-4b7f-8d95-d48e18c880f9.png)

 
 Para probar la significancia estadística y la dirección de los coeficientes de regresión para las variables independientes, se podrían realizar pseudo pruebas-t como lo hicieron en [5]. De esta manera obtener las correlaciones significativas entre los ocho factores influyentes  derivado del modelo GWR.

 
 
 
 
 
 
 
 
------------------------------------------------------------------------------------------------------------
# Referencias

[1] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[2] Brunsdon, C., Fotheringham, A. S., & Charlton, M. E. (1996). Geographically weighted regression: a method for exploring spatial nonstationarity. Geographical analysis, 28(4), 281-298.

[3] Fotheringham, A. S., Charlton, M. E., & Brunsdon, C. (1998). Geographically weighted regression: a natural evolution of the expansion method for spatial data analysis. Environment and planning A, 30(11), 1905-1927.

[4] Agudelo Torres, J. E., Agudelo Torres, G. A., Franco Arbeláez, L. C., & Franco Ceballos, L. E. (2015). Efecto de un estadio deportivo en los precios de arrendamiento de viviendas: una aplicación de regresión ponderada geográficamente (GWR). Ecos de Economía, 19(40), 66-80.

[5] Li, S., Zhou, C., Wang, S., Gao, S., & Liu, Z. (2019). Spatial heterogeneity in the determinants of urban form: an analysis of Chinese cities with a GWR approach. Sustainability, 11(2), 479.

[6] Bivand, R. (2017). Geographically weighted regression. CRAN Task View: Analysis of Spatial Data.

### En mi perfil de GitHub tienes más información; pulsa el siguiente icono

<img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" width="300px">
