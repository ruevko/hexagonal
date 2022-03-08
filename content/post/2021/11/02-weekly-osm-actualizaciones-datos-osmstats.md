---
title: 'Weekly OSM: actualizaciones de los datos OSMstats'
date: '2021-11-02'
slug: 02-weekly-osm-actualizaciones-datos-osmstats
categories:
  - OpenStreetMap
tags:
  - github actions
  - web scraping
source: 02-weekly-osm-actualizaciones-datos-osmstats.Rmd
output:
  blogdown::html_page:
    toc: true
    highlight: kate
    pandoc_args: ['--metadata', 'lang=en-GB']
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
semalmente y demostrarían la actividad en todos los países disponibles. Antes de explicar
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

Con respecto al primer paso, el repositorio es [Weekly OSM](https://github.com/ruevko/weekly-osm)
y tiene ese nombre porque se actualizará semanalmente.
