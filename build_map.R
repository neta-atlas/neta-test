library(leaflet)
library(leaflet.providers)
library(sf)
library(htmltools)
library(viridisLite)
library(htmlwidgets)

sf = st_read('data/sample_simp.gpkg') |>
  st_transform(crs = 4326)

pal = colorNumeric(
  palette = rocket(256, direction = -1),
  domain = sf$vulnerability_normalised
)

map = leaflet(sf) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addPolygons(
    fillColor = ~pal(sf$vulnerability_normalised),
    fillOpacity = 0.7,
    color = '#333333',
    weight = 1,
    label = ~paste0('Region: ', sf$SA2_NAME21, " | Vulnerability: ", sf$vulnerability_normalised),
    highlightOptions = highlightOptions(
      weight = 3,
      color = '#000000',
      fillOpacity = 0.8,
      bringToFront = T
    )
  ) |>
  addLegend(
    pal = pal,
    values = ~sf$vulnerability_normalised[!is.na(sf$vulnerability_normalised)],
    title='Vulnerability index',
    position = 'bottomright'
  )

saveWidget(map, file = 'docs/map.html', selfcontained = T)

writeLines('<!DOCTYPE html>
           <html>
           <head>
           <style>
           body {
           font-family: Arial, sans-serif;
           }
           </style>
           </head>
           <body>
           <h1>NETA test page</h1>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc egestas lectus risus, id faucibus est interdum at. Donec id ultrices velit, et vehicula risus. Nullam ut laoreet magna. Morbi sapien lacus, laoreet in maximus ullamcorper, hendrerit ac erat. Sed eu luctus metus. Phasellus dapibus, ligula eu egestas posuere, diam augue convallis purus, quis consequat augue mauris quis purus. Praesent id ex ac dui suscipit suscipit sit amet quis ex. Etiam orci ex, tempor non diam sit amet, suscipit ultricies tortor. Aenean at odio eleifend, efficitur ligula non, finibus libero. Maecenas risus purus, egestas vel libero vel, dignissim posuere purus. Nunc laoreet vehicula dui vel interdum. Cras efficitur tincidunt maximus. Cras nec turpis nisl. Duis eget sem enim. Morbi non fringilla mi, ac volutpat lectus.</p>
           <iframe src="map.html" title="Test map" width="100%" height="600"></iframe>
           <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc egestas lectus risus, id faucibus est interdum at. Donec id ultrices velit, et vehicula risus. Nullam ut laoreet magna. Morbi sapien lacus, laoreet in maximus ullamcorper, hendrerit ac erat. Sed eu luctus metus. Phasellus dapibus, ligula eu egestas posuere, diam augue convallis purus, quis consequat augue mauris quis purus. Praesent id ex ac dui suscipit suscipit sit amet quis ex. Etiam orci ex, tempor non diam sit amet, suscipit ultricies tortor. Aenean at odio eleifend, efficitur ligula non, finibus libero. Maecenas risus purus, egestas vel libero vel, dignissim posuere purus. Nunc laoreet vehicula dui vel interdum. Cras efficitur tincidunt maximus. Cras nec turpis nisl. Duis eget sem enim. Morbi non fringilla mi, ac volutpat lectus.</p>
           </body>
           </html>', 'docs/index.html')
