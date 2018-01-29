library(shiny)
library(tidyverse)
library(stringr)
library(leaflet)

phanalytix <- read.csv('phanalytix.csv', stringsAsFactors = FALSE)
#significance <- read.csv('significance.csv', stringsAsFactors = FALSE)

ui <- navbarPage('Select a Function:',
                 position = 'static-top',
        tabPanel("Find a Show",
                 class="tab-pane active",
                 h1("Phanalytix"),
                 h3("Virtual Concert Recommendation"),
                 h5("Input your preferences for a concert, and we'll recommend some shows you might enjoy!"),
        sidebarLayout(
            sidebarPanel(h4('Rank your preferences:'),
                         
                dateRangeInput(inputId = 'date_range',
                        label = "Only include dates from:",
                        start = min(phanalytix$date),
                        min = min(phanalytix$date),
                        end = max(phanalytix$date),
                        max = Sys.Date(),
                        format = 'yyyy-mm-dd'),
                
                sliderInput(inputId = 'length_val', 
                        label = "Song Length", 
                        min = 0, 
                        max = 5, 
                        value = 3),
                
                sliderInput(inputId = 'gap_val',
                        label = "Rarity of songs (aka Gap/Bustouts)",
                        min = 0,
                        max = 5,
                        value = 2),
    
                # sliderInput(inputId = 'rotationVal',
                #         label = "Rotation (How often a song is played, on average)",
                #         min = 0,
                #         max = 5,
                #         value = 2),
    
                sliderInput(inputId = 'rating_val',
                        label = "Show Rating from Phish.Net",
                        min = 0,
                        max = 5,
                        value = 5),
                
                sliderInput(inputId = 'cover_val',
                    label = "Covers",
                    min = 0,
                    max = 5,
                    value = 1),
                
                sliderInput(inputId = 'debut_val',
                    label = "Live Debuts",
                    min = 0,
                    max = 5,
                    value = 1),
                
                sliderInput(inputId = 'tease_val',
                    label = "Teases & Quotes",
                    min = 0,
                    max = 5,
                    value = 4),
                
                sliderInput(inputId = 'notes_val',
                    label = "Oddities: acoustic, a capella, musical guests",
                    min = 0,
                    max = 5,
                    value = 3),
                
                sliderInput(inputId = 'show_age_val',
                            label = "Year: Slide right for more recent shows, left for older shows",
                            min = -3,
                            max = 3,
                            value = 0)
                
            ),
            mainPanel(
             dataTableOutput("recommended")
            )
        )
    ),
    tabPanel("Show Map",
             h1("Phanalytix"),
             h3("Map of Concert Locations"),
             h5("Click on a point to see how many shows Phish has played at the venue!"),
             leafletOutput("map"),
             p ())

)

server <- function(input, output) {
    
    song_length <- tibble(minutes = str_extract_all(phanalytix$duration_song, "[0-9]+(?=:)"), 
                          seconds = str_extract_all(phanalytix$duration_song, "(?<=:)[0-9]+"))
    
    song_length <- song_length %>% 
        mutate(minutes = as.numeric(minutes), 
               seconds = as.numeric(seconds))
    
    significance <- mutate(phanalytix, song_seconds = (song_length$minutes*60+song_length$seconds))
    
    significance <-  significance %>% 
        mutate(#Length Rating
               length_rating = song_seconds/max(significance$song_seconds, na.rm = TRUE),
               #Gap Rating
               gap_rating = adj_gap/max(significance$adj_gap, na.rm = TRUE),
               #Rotation Rating
               #rotation_rating = 1 - rotation/max(significance$rotation, na.rm = TRUE),
               #Rating Rating
               rating_rating = ratings/max(significance$ratings, na.rm = TRUE),
               #Debut Rating
               date = parse_date(date),
               debut = parse_date(debut),
               #Show Age Preference
               show_age = ifelse(as.numeric(Sys.Date() - date) > 0, as.numeric(Sys.Date() - date), 0),
               show_age_rating = show_age/max(show_age, na.rm = TRUE),
               #Debut Dummy Bonus
               debut_dummy = as.numeric(grepl('debut|first known', notes)),
               #Tease Dummy Bonus
               tease_dummy = as.numeric(grepl('tease|quote', notes)),
               #Notes Bonus
               notes_dummy = as.numeric(grepl('[qwertyuiopasdfghjklzxcvbnm]', notes)) 
                            - debut_dummy - tease_dummy, 
               notes_dummy = ifelse(notes_dummy<0, 0, notes_dummy)
        ) %>% 
        select(-show_age)
    
    output$recommended <- renderDataTable({
        length_value <- input$length_val/10
        gap_value <- input$gap_val/10
        # rotationValue <- input$rotationVal/10
        rating_value <- input$rating_val/10
        show_age_value <- -input$show_age_val/10
        cover_bonus <- input$cover_val * 0.05
        debut_bonus <- input$debut_val * 0.05
        notes_bonus <- input$notes_val * 0.05
        tease_bonus <- input$tease_val * 0.05
        
        significance %>%
            mutate(significance_rating = length_rating*length_value +
                       gap_rating*gap_value +
                       #rotation_rating*rotationValue +
                       rating_rating*rating_value +
                       show_age_rating*show_age_value +
                       cover_dummy*cover_bonus +
                       debut_dummy*debut_bonus +
                       notes_dummy*notes_bonus +
                       tease_dummy*tease_bonus) %>% 
            group_by(date, location, venue_name) %>%
            summarise(avg_rating = mean(significance_rating, na.rm = TRUE)) %>%
            filter(as.Date(date) >= as.Date(input$date_range[1]) && as.Date(date) <= as.Date(input$date_range[2])) %>%
            arrange(desc(avg_rating)) %>%
            select(-avg_rating) %>% 
            mutate("Stream Link" = str_c("phish.in/", date))
    })
    
     
    phanalytix_map <- significance %>%  
        group_by(tour, venue_name, latitude, longitude, city, state, country) %>% 
        summarize(num_songs = n())
    
    phanalytix_map <- within(phanalytix_map, {
        count = ave(tour, venue_name, FUN = function(x) length(unique(x)))
    })
    
    phanalytix_map <- phanalytix_map %>% rename(num_tours = count)
    
    output$map <- renderLeaflet({
        leaflet(phanalytix_map) %>% addTiles() %>%
            addMarkers( ~longitude, ~latitude, popup = paste("Number of shows performed at: ", 
                                                             as.character(phanalytix_map$venue_name), 
                                                             "=",  
                                                             as.character(phanalytix_map$num_tours)))
                                                              #as.character(phanalytix_map$song)))
        
    })
}



shinyApp(ui = ui, server = server)
