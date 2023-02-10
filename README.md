# Regresión ponderada geográficamente (GWR) sobre delitos en la CDMX 2022 

## Introducción

En el análisis espacial, es importante identificar la naturaleza de la relación que existe entre las variables. Normalmente, se realiza estimando parámetros con observaciones que se toman de diferentes unidades espaciales que se encuentran en un área de estudio donde se supone que los parámetros son constantes en el espacio.


Sin embargo la mayoría de las veces no es así, esto se conoce como no estacionariedad. La no estacionariedad significa que la relación entre las variables objeto de estudio varía de un lugar a otro en función de factores físicos del entorno que se auto-correlacionan espacialmente, es decir,  la relación entre las variables dependientes e independientes cambia dependiendo de donde nos encontramos en el espacio.
La GWR  es una técnica que se aplica para medir la variación mediante la 〖"calibración" 〗^𝟏 de un modelo de regresión múltiple, que permite que existan diferentes relaciones en diferentes puntos del espacio.
GWR teóricamente puede integrar la ubicación geográfica, la altitud y otros factores para las estimaciones de análisis espacial y refleja la relación espacial no estacionaria entre estas variables.

------------------------------------------------------------------------------------------------------------
1. Definir un tipo de ponderación entre los vecinos de las unidades de  análisis. 

