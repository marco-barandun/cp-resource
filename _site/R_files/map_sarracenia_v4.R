library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DT)
library(scales)
library(tidyverse)
library(sf)

setwd("/Users/marco/GitHub/cp-resource/R_files/")

### Reading in the world shapefile
world_adm <- rgdal::readOGR("./data/ADM_2.shp")
l2 <- sf::st_read("./data/ADM_2.shp")

#------------------------------------------------------------------------------
### Importing and cleaning Sarracenia distriburion data
get_counties <- function(occurrences_df,
                         world_shapefile) {
  
  # Remove points that are located in the ocean
  occs_to_clean <- sp::SpatialPointsDataFrame(coords = occurrences_df %>% dplyr::select(decimalLongitude, decimalLatitude), 
                                              data = occurrences_df) ##check columns for long/lat

  raster::crs(occs_to_clean) <- raster::crs(world_shapefile)
  ovr <- sp::over(occs_to_clean, world_shapefile) %>%###overlay world and points
    dplyr::select("COUNTRY", "NAME_1", "NAME_2", "TYPE_2", "ENGTYPE_2")

  cleaned_ds <- cbind(occurrences_df, ovr) %>%
    dplyr::select(genus, species, subspecies, county, NAME_2, state, NAME_1, country, COUNTRY, everything()) %>%
    mutate(NAME_2 = ifelse(is.na(NAME_2), county, NAME_2)) %>%
    mutate(NAME_1 = ifelse(is.na(NAME_1), state, NAME_1)) %>%
    mutate(COUNTRY = ifelse(is.na(COUNTRY), country, COUNTRY)) %>%
    arrange(genus, species, subspecies, NAME_2, NAME_1, COUNTRY, elevation, elevationAccuracy, .keep_all = TRUE) %>%
    distinct(genus, species, subspecies, NAME_2, NAME_1, COUNTRY, .keep_all = TRUE) %>%
    dplyr::select(-county, -state, -country) %>%
    rename(county = NAME_2) %>%
    rename(state = NAME_1) %>%
    rename(country = COUNTRY)
  
  return(cleaned_ds)
}

# Importing information about the native Sarracenia counties
native <- read_csv("./plant_lists/sarracenia_native.csv") %>%
  filter(!str_detect(taxon_name, "×")) %>%
  mutate(taxon_name = gsub(" subsp.", "", taxon_name))

# sarracenia is a dataset including the native Sarracenia counties
sarracenia <- read.csv("./plant_lists/sarracenia_withCounties.csv") %>%
  mutate(sciname = verbatimScientificName) %>%
  mutate(verbatimScientificName = as.character(paste(verbatimScientificName))) %>%
  rename(subspecies = infraspecificEpithet) %>%
  merge(., native, by.x = c("sciname", "state"), by.y = c("taxon_name", "area")) %>%
  filter(!is.na(county)) %>%
  dplyr::select("gbifID", "verbatimScientificName", "county", "state", "country", "elevation", "elevationAccuracy",
         "decimalLatitude", "decimalLongitude", "coordinateUncertaintyInMeters", "year", "scientificName") %>%
  filter(!verbatimScientificName == "Sarracenia") %>%
  mutate(source = "3_distribution") %>%
  mutate(county = str_remove_all(county, pattern = " County")) %>%
  separate(verbatimScientificName, c("genus", "species", "subspecies")) %>%
  mutate(subspecies = ifelse(scientificName == "Sarracenia rubra Walter", "rubra", subspecies)) %>%
  mutate(subspecies = ifelse(scientificName == "Sarracenia purpurea L.", "purpurea", subspecies)) %>%
  mutate(subspecies = ifelse(scientificName == "Sarracenia alabamensis F.W. & R.B.Case", "alabamensis", subspecies)) %>%
  mutate(subspecies = ifelse(scientificName == "Sarracenia jonesii Wherry", "jonesii", subspecies)) %>%
  mutate(species = ifelse(scientificName == "Sarracenia jonesii Wherry", "rubra", species)) %>%
  mutate(species = ifelse(scientificName == "Sarracenia alabamensis F.W. & R.B.Case", "rubra", species)) %>%
  mutate(species = ifelse(scientificName == "Sarracenia alabamensis subsp. wherryi Case & Case", "rubra", species)) %>%
  get_counties(occurrences_df = .,
               world_shapefile = world_adm)

# Importing the Sarracenia I already have
my_plants <- read_csv("./plant_lists/Sarracenia_list.csv") %>% mutate(source = "1_mine")

# Importing the Sarracenia I know where to get
to_acquire <- read_csv("./plant_lists/to_acquire.csv")

# Merging the datasets
sarracenia_all_df <- my_plants %>%
  bind_rows(., to_acquire) %>%
  bind_rows(., sarracenia) %>%
  mutate(species = gsub("leucopyhlla", "leucophylla", species)) %>%
  filter(species != "x moorei") %>%
  arrange(genus, species, subspecies, country, state, county, source) %>%
  dplyr::select(genus, species, subspecies, country, state, county, source, everything()) %>%
  mutate(scientificName = paste(genus, species)) %>%
  mutate(link_county = paste("https://marco-barandun.github.io/cp-resource/sarracenia/assets/profiles/Sarracenia", species, subspecies, country, state, county, sep = "_") %>%
           gsub("_NA", "", .) %>%
           gsub(" ", "-", .)
         ) %>%
  mutate(link_clone = paste("https://marco-barandun.github.io/cp-resource/sarracenia/assets/profiles/", code, sep = "")
         ) %>%
  mutate(link_species = paste("https://marco-barandun.github.io/cp-resource/sarracenia/assets/profiles/", code, sep = "")
  ) %>%
  mutate(img_url = paste0(paste("https://marco-barandun.github.io/cp-resource/sarracenia/assets/maps/img/Sarracenia", species, subspecies, country, state, county, sep = "_"), ".png") %>%
           gsub("_NA", "", .) %>%
           gsub(" ", "-", .)
         ) %>%
  mutate(cloneNameLink = ifelse(source == "1_mine", paste0(paste('<a target="_parent" href=', .$link_clone, '>', paste(.$code, sep = ""), ' </a>', sep = ""), sep = ""), "")
         ) %>%
  mutate(sciNameLink = ifelse(paste0(paste('<a target="_parent" href=', .$link_species, '>', paste(.$scientificName, sep = ""), ' </a>', sep = ""), sep = ""), "")
  )

sarracenia_df <- sarracenia_all_df %>%
  arrange(genus, species, subspecies, country, state, county, source) %>%
  distinct(genus, species, subspecies, country, state, county, .keep_all = TRUE) %>%
  filter(!is.na(county))

# You can find more info about the cool DT::datatable under "https://rstudio.github.io/DT/"
(t <- DT::datatable(sarracenia_all_df %>% 
                     dplyr::select(cloneNameLink, scientificName, subspecies, variety, county, state, country, source, year, old_code, pot1_code, pot2_code, comment, supplyer) %>% 
                     filter(source != "3_distribution") %>%
                     mutate(comment = iconv(.$comment, "UTF-8", "UTF-8", sub='')),
                   class = "display nowrap",
                   escape = F,
                   colnames = c('code' = 'cloneNameLink'),
                   rownames = FALSE))

htmltools::save_html(t, file="species2.html")



map_sarracenia <- function(species_list,
                           subspecies = NA,
                           df,
                           l2_global,
                           export = FALSE) {
  
  #browser()
  
  for (species in species_list) {
    
jsCode <- paste0('
 function(el, x, data) {
  var marker = document.getElementsByClassName("leaflet-interactive");
  for(var i=0; i < marker.length; i++){
    (function(){
      var v = data.win_url[i];
      marker[i].addEventListener("click", function() { window.open(v);}, false);
  }()); 
  }
 }
')
    

    p <- l2_global %>%
      filter(paste(.$COUNTRY, .$NAME_1, .$NAME_2, sep = "_") %in% unique(paste(df$country, df$state, gsub("* County", "", df$county), sep = "_"))) %>%
      merge(., df %>% filter(scientificName == UQ(species)) %>%
              arrange(source) %>%
              distinct(country, state, county, .keep_all = TRUE) %>%
              filter(!is.na(county)), by.x = c("COUNTRY", "NAME_1", "NAME_2"), by.y = c("country", "state", "county"), all.x = TRUE, all.y = FALSE) %>%
      mutate(popup = paste0("<img src =", .$img_url,  " height='100%' width='100%' >",
                            paste("\n", '<a target="_parent" href=', .$link_county, '>', paste(.$NAME_2, .$NAME_1, sep = ", "), ' </a>', sep = ""), sep = ""), sep = "") %>%
      mutate(win_url = link) %>% 
      filter(scientificName == UQ(species)) %>%
      mutate(popup = ifelse(source == "1_mine", popup, paste(.$NAME_2, .$NAME_1, sep = ", "))) %>%
      mutate(label = paste(.$NAME_2, .$NAME_1, sep = ", "))
    
    #if(is.na(subspecies)) {p <- p[unique()]}
    if(!is.na(subspecies)) {p <- p[p$subspecies == subspecies,]}
    
    pal <- colorFactor(
      palette = c('darkgreen', 'orange', 'grey30'),
      domain = substring(p$source, 1, 1)
    )
    
    (m <- leaflet(p, width = '100%') %>% 
      addMapPane(name = "polygons", zIndex = 410) %>% 
      addMapPane(name = "maplabels", zIndex = 420) %>% 
      addProviderTiles("CartoDB.PositronNoLabels") %>%
      addProviderTiles("CartoDB.PositronOnlyLabels", 
                       options = leafletOptions(pane = "maplabels"),
                       group = "map labels") %>%
      addPolygons(
        #data = p,
        #group = "label1",
        popup = ~popup,
        label = ~label,
        fillOpacity = 0.5, 
        color = ~pal(substring(source, 1, 1)), 
        stroke = TRUE, 
        weight = 1, 
        opacity = .5, 
        highlightOptions = highlightOptions(
          color = "#ff4a4a", 
          weight = 5,
          bringToFront = TRUE
        )) %>%
        addScaleBar(position = "bottomleft") #%>%
        #htmlwidgets::onRender(jsCode, data=p)
      )

      
    print(paste("Mapped:", species, if(!is.na(subspecies)) {subspecies}))
    
    if (export == TRUE) {
      if (is.na(subspecies)) {saveWidget(m, file=paste("./maps/", gsub(" ", "_", species), ".html", sep = ""), rownames = FALSE)}
      if (!is.na(subspecies)) {saveWidget(m, file=paste("./maps/", gsub(" ", "_", species), "_", subspecies, ".html", sep = ""), rownames = FALSE)}
      }
  
  }
  
  return(m)
}

map_sarracenia(species_list = "Sarracenia oreophila",
               #subspecies = "rubra",
               df = sarracenia_df,
               l2_global = l2,
               export = TRUE)
