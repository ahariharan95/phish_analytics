---
layout: default
---

# Phanalytix: An Analysis of Phish

The main purpose of this project was to create and analyze a dataset compiling information about the shows and songs performed by the band Phish from 1983 to 2017.  Phish is an American rock band, founded in the University of Vermont in 1983 and known for musical improvisation, extended jams, and blending of genres.  With their huge and dedicated fan base, there are multiple websites that have been created, documenting their songs, shows, and tours.  Therefore, this project is based on the compilation of all of the information available, mainly from Phish.in and Phish.net, into one large dataset.  The three main resources for the creation of this dataset were Phish.in, Phish.net, and Google Maps' API.  Through web-scraping and data cleaning, phanalytix.csv was created, comprising of 31 variables and 30,883 observations.  In addition to the csv, a Shiny app, Phanylytix, was also created as a part of the project to allow users to interact with the data we found in a meaningful and direct way.  The app is a good tool to use for fans of the band as well as those who are new.  

The completion of this project involved the efforts of countless hours of research, hardwork, and troubleshooting by Aishwarya Hariharan and two more students from the STOR 390: Introduction to Data Science class at the Univeristy of North Carolina at Chapel Hill, along with the coursework/lectures and guidance from the course instructor, Iain Carmichael.

## Components of the Project

The main components of this project include the dataset and the shiny app.  The dataset we created comprises of 31 variables and 30,883 observations including data such as dates, shows, tours, locations, venues, ratings, tracks.  The shiny app has two parts, "Find a Show" and "Show Map", which allow users to create their own virtual concerts and to explore already occurred shows, locations, and venues.  


**Phanalytix: Shiny App**

Phanalytix is a tool to help new users explore the band or Phish fans to figure out what show to listen to next. The research and data collection that went into creating the app helped uncover some interesting information. There are many resources out there that archive phish shows and analyze trends, but Phanalytix seeks to create applications for all this data, making it interactive and insightful.

The "Find a Show" component allows users to create a virtual concert with the given inputs for song/show recommendations.  These inputs are dates, song length, rarity of songs, rating from Phish.net (Phish's website), number of covers, number of debuts, number of teases within the song, oddities, and a time frame for year.  Given these inputs, the app extracts a set of songs which fulfill the user's criteria. It also provides the link so that users can stream the songs, and some basic information about the show date, location, and venue. The "Show Map" component is another cool feature in the app. It's a map of the world with pinpoints that indicate locations Phish has performed at in the past. Upon clicking on the pins, users can see the venue name and the number of shows performed there. 

The [app](https://ahariharan.shinyapps.io/phanalytix_app/) is embedded below:  


<iframe src="https://ahariharan.shinyapps.io/phanalytix_app/" style=" border: 2px solid black;width:800px;height:650px;"></iframe>



**phanalytix.csv: Original Dataset**

The dataset we created is comprised of 31 variables and more than 30,000 observations.  We wrote more than 500 lines of code to gather, clean, and arrange the data in a neat and readable csv file.  The [dataset](https://github.com/ahariharan95/phish_analytics/blob/master/phanalytix.csv) is uploaded on the [github repository](https://github.com/ahariharan95/phish_analytics) for this page.  


## Blog

There is also a blog which goes into more detail regarding the project.  It includes information on the background of the band and our analysis, some interesting findings from the exploratory analysis results from our dataset, and a detailed explanation of the app.  The blog can be found [here](file:///C:/Users/Aishu/Desktop/Phanalytix_blog.html), as well as its html file on the repository.  

