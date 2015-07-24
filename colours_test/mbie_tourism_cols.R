#-------Tourism palette------------------------

# Create a vector of the Ministry of Tourism colours
Tourism.cols <- c(
	Forest = "#3D4721FF",
	Grass = "#A8B50AFF",
	Southerly="#5C788FFF",
	Volcano="#B09E0DFF",
	Koura="#D4470FFF",
	Merino="#C2C4A3FF",
	Moss= "#5E7803FF",
	Pohutukawa="#AD2624FF",
	Sunrise="#D48500FF",
	CityLights ="#EDBD3DFF",
	SouthernCross="#265787FF",
	WineCountry="#61384DFF",
	Flax="#708270FF",
	Ocean="#A8C4C4FF",
	RiverStone="#ADABA6FF",
	Waka="#826E59FF",
	CabbageTree="#A8AD70FF",
	Sky="#94B5E0FF")

# A function tourism.cols() for easy reference to the vector Tourism.cols 
tourism.cols <- function(x=c(1,2,3,5,12,6)){
	# function to return in vector format a subset of the Ministry of Tourism's 2007
	# palette of colors.  By default returns 6 colours that form a nice set
	# for most plots.  Note that normally the 4th colour (Volcano) is too similar
	# to the 2nd (Grass) for use in plots.
	if(x[1]=="Primary") x<-1:6
	if(x[1]=="Supporting") x<-7:18
	if(x[1]=="All") x <-1:18
	if(x[1]=="Pale")x <- 13:18
	if(x[1]=="Alternating") x <- rep(c(1,6,4,8,2,16,3,5,15,18,9,14,7,12,11,17,10,13),6)
	as.vector(Tourism.cols[x])
}



#------------------MBIE palette-------------------------

# Create a vector to store the colours
MBIE.cols <- c(
	Teal=rgb(0,98,114, maxColorValue=255),
	Green=rgb(151,215,0, maxColorValue=255),
	Blue=rgb(0,181,226, maxColorValue=255),
	Purple=rgb(117,59,189, maxColorValue=255),
	Pink=rgb(223,25,149, maxColorValue=255),
	Orange=rgb(255,105,0, maxColorValue=255),
	Yellow=rgb(251,225,34, maxColorValue=255)
)

# Create a function for easy reference to combinations of MBIE.cols
mbie.cols <- function(x=1:7){
	
  # function to return in vector format a subset of the MBIE 2013
	# palette of colors. Use in the form mbie.cols("Trio1") will give
	# one of the approved combinations of 2 or 3 colors

	if(x[1]=="Duo1") x<- 1:2
	if(x[1]=="Trio1") x<- 1:3
	if(x[1]=="Duo2") x <- 2:3
	if(x[1]=="Trio2")x <- 3:5
	if(x[1]=="Duo3")x <- 4:5
	if(x[1]=="Trio3") x <- c(4,6:7)
	if(x[1]=="Duo4") x <- 6:7
	if(x[1]=="Duo5") x <- c(4,7)

	as.vector(MBIE.cols[x])
}
