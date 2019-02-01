install.packages("mapr", dependencies = TRUE)
install.packages("spocc", dependencies = TRUE)
install.packages("curl", dependencies = TRUE)

setwd("")

library("spocc")
library("mapr")
library("dplyr")

#hacer una lista de las especies que se quieren descargar
splist <- c('Tillandsia matudae', 'Tillandsia filifolia', 'Tillandsia argentea', 'Tillandsia festucoides')

#para hacer la consutal en GBIF, recordar que entre m?s alto el limit mas tardado
dat <- occ(query = splist, from = 'gbif', has_coords = TRUE, limit = 1000)
occsData<-occ2df(dat$gbif)
map_leaflet(occsData)

####Cleaning duplicate records on a cell####
crs.wgs84 <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
sp::coordinates(occsData) <- c("longitude", "latitude")
sp::proj4string(occsData) <- crs.wgs84

occsData <- sp::remove.duplicates(occsData, zero=0.00833333333)
occsData.df<-cbind(occsData@data, coordinates(occsData))

names(occsData.df) #con este puede ver el nombre de las columnas. 

#en esta parte vamos a seleccionar de la base data.df solo los registros que estan 
#en Mexico y que son especimenes observados
data.df.f<-occsData.df%>%
  select("name","longitude","latitude","scientificName","order","country", "basisOfRecord")%>%
  filter(country == "Mexico")%>% #si no quieres hacer filtros solo borar desde los %>% de la linea de arriba
  filter(basisOfRecord =="PRESERVED_SPECIMEN")

map_leaflet(data.df.f) #con esta funcion puedes graficarlos en R. Si ves puntos fuera de Mx


