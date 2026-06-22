library(leaflet)
library(leaflet.providers)
library(sf)
library(htmltools)
library(viridisLite)
library(htmlwidgets)

sf = st_read('data/sample_simp.gpkg') |>
  st_transform(crs = 4326)

pal = colorNumeric(
  palette = rocket(256),
  domain = sf$vulnerability_normalised
)

map = leaflet(sf) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addPolygons(
    fillColor = ~pal(sf$vulnerability_normalised),
    fillOpacity = 0.7,
    color = '#333333',
    weight = 1
  ) |>
  addLegend(
    pal = pal,
    values = ~sf$vulnerability_normalised,
    position = 'bottomright'
  )

saveWidget(map, file = 'docs/map.html', selfcontained = T)

writeLines('<!DOCTYPE html>
           <html>
           <body>
           <h1>NETA test page</h1>
           <iframe src="map.html" title="Test map" width="100%" height="600"></iframe>
           </body>
           </html>', 'docs/index.html')
