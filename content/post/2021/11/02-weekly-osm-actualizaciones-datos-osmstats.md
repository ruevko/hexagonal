---
title: 'Weekly OSM: actualizaciones de los datos OSMstats'
date: '2021-11-02'
slug: 02-weekly-osm-actualizaciones-datos-osmstats
categories:
  - OpenStreetMap
tags:
  - github actions
  - web scraping
source: 02-weekly-osm-actualizaciones-datos-osmstats.md
summary: Recientemente el sitio OSMstats alcanzó la cifra de diez años de datos; para celebrarlo (y para aplicar nuevos métodos) estoy desarrollando un repositorio que recoge esos datos, y actualiza su propia base de datos.
---

Cuando inicié este blog, decidí hacerlo compartiendo cómo ejecuté mi primer proyecto
de análisis de datos: obtener información sobre OpenStreetMap (OSM), a través de *web
scraping* en [OSMstats](https://osmstats.neis-one.org), un sitio desarrollado por
[Pascal Neis](https://neis-one.org/about). Desde entonces ---he aprendido más sobre
R y cómo se programa adecuadamente--- he descubierto nuevos métodos que permitirían
ejecutar el mismo proyecto, pero de forma más concisa y reproducible.

Por eso, actualmente estoy desarrollando un repositorio en GitHub con este propósito:
mantener una base de datos con información resumida de OSMstats. Los datos se obtendrían
semanalmente y demostrarían la actividad en todos los países disponibles. Antes de explicar
el procedimiento, debo mencionar que OpenStreetMap ---así como cualquier cosa derivada del
mismo--- es *open data*, es propiedad de sus contribuidores (© OpenStreetMap contributors),
y posee una licencia [ODC Open Database License](https://www.openstreetmap.org/copyright).
La base de datos que estoy generando, por lo tanto, posee la misma licencia.

A breves rasgos, el procedimiento que estoy realizando es:

1. Crear el repositorio en GitHub y clonarlo vía `git clone`
2. Transformarlo en proyecto de RStudio, con un ambiente privado de `renv`
3. Programar :smirk_cat:
4. Crear la base de datos, con datos desde el inicio de OSMstats hasta el presente
5. Actualizar el repositorio y la base de datos vía `git push`
6. Crear el mecanismo para que, en adelante, el repositorio se actualice por sí solo

Con respecto al primer paso, el repositorio [Weekly OSM](https://github.com/ruevko/weekly-osm)
ya se encuentra en línea; escogí ese nombre para reflejar el hecho de se actualizará una vez a
la semana. Esta frecuencia presenta dos ventajas: reducir la granularidad de las observaciones,
y mantener un *cache* ---que el servicio GitHub Actions conserva una semana como máximo--- de
los paquetes necesarios.

Después de clonar el repo, el segundo paso fue abrir RStudio y asociar el directorio `Weekly-OSM`
con un nuevo proyecto. Una vez creado el proyecto, los primeros comandos que ejecuté fueron:

```
install.packages("renv")
renv::init(bare = TRUE)
```

El propósito de [`renv`](https://rstudio.github.io/renv) es generar un ambiente de
trabajo reproducible. Lo que esto significa es que, durante su desarrollo, mi proyecto
tendrá su propia librería de paquetes del lenguaje R, aislada de otros proyectos que
desarrolle en la misma computadora. También significa que puedo reproducir fácilmente
el ambiente de trabajo en otra computadora, lo cual es crucial, pues permitirá ejecutar
*scripts* del proyecto en un *workflow* de GitHub Actions.

El tercer paso es, precisamente, escribir esos *scripts*. En este artículo
no explicaré cómo funciona Weekly OSM; esa información se encuentra en el
[README](https://github.com/ruevko/Weekly-OSM/blob/main/readme.md) y en cada uno de
los *scripts*, con sus respectivos comentarios. Lo que sí explicaré es que, después
de programar, uno debería utilizar `renv::snapshot()` para crear `renv.lock`, un
archivo que registra los paquetes que han sido utilizados ---`dplyr` y `rvest` en
mi caso---, así como sus dependencias. Así luce un registro:

```
    "magrittr": {
      "Package": "magrittr",
      "Version": "2.0.1",
      "Source": "Repository",
      "Repository": "CRAN",
      "Hash": "41287f1ac7d28a92f0a286ed507928d3"
    }
```

Para cumplir el cuarto paso escribí el *script*
[`main_yearly.R`](https://github.com/ruevko/Weekly-OSM/blob/main/R/main_yearly.R); al
ejecutarlo, obtiene de OSMstats todas las observaciones de determinado año, i.e. de todos
los días y de todos los países que tuvieron actividad esos días. A continuación, calcula
un resumen semanal de las observaciones ---utilizando funciones como `sum()` y `max()`---
y escribe los resultados en archivos `.csv`; por lo tanto, cada año contendrá 52 o 53
archivos. Después de ejecutar el *script* desde 2011 hasta 2021, añadí todos los archivos
al repositorio en línea, cumpliendo así el quinto paso.

Finalmente, el sexto paso consistió en escribir
[`main.yaml`](https://github.com/ruevko/Weekly-OSM/blob/main/.github/workflows/main.yaml),
un *workflow* que se ejecutará cada lunes a las 03:13 UTC aproximadamente, a través de
GitHub Actions. No explicaré la sintaxis del *workflow*, pero sí demostraré algunos de
sus pasos; por ejemplo, el que se encuentra a continuación sirve para crear un *cache* con
los paquetes instalados. Si bien la primera ejecución del *workflow* demoró varios minutos,
gracias al *cache* las ejecuciones posteriores han demorado menos de un minuto. Además,
mientras no cambie `renv.lock`, el *cache* seguirá siendo válido.

```
    # create/restore cache
    - name: Cache packages
      uses: actions/cache@v2
      with:
        path: ${{ env.RENV_PATHS_ROOT }}
        key: renv-${{ hashFiles('renv.lock') }}
```

En el siguiente paso se ejecuta `renv::restore()`, una función que ordena la instalación
(o, si ya existe un *cache*, la restauración) de los paquetes registrados en `renv.lock`.
Y en el último paso de los que aquí demuestro se ejecuta el *script* [`main.R`](https://github.com/ruevko/Weekly-OSM/blob/main/R/main.R), que contiene
todas las operaciones que deben realizarse semanalmente en el repositorio.

```
    # install/restore packages
    - name: Restore packages
      run: Rscript -e 'renv::restore()'
    # source main script
    - name: Obtain weekly data
      run: Rscript R/main.R
```

Eso es todo lo que puedo contar sobre Weekly OSM hasta ahora. Desde que añadí `main.yaml` la
base de datos se ha actualizado con normalidad; solo debo recordar que el *workflow* debe ser
renovado cada cierto tiempo, porque de lo contrario GitHub Actions lo desactivará :joy_cat:.
Este artículo tendrá una continuación, donde demostraré cómo utilizar la base de datos.
