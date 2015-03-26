
# Define UI for application that draws a histogram
shinyUI(fixedPage(
   # insert some CSS.  Down the track this would be stored in a separate file.
   tags$head(
      tags$style(HTML("
                      body {
         font-family: 'Lucida Sans Unicode', 'Lucida Grande', Verdana, Lucida, Helvetica, Arial, Calibri, sans-serif;
         color: rgb(0,0,0);
                      font-size: 12.1px;
                      line-height: 18.15px;
                      margin-bottom: 9.075px; 
                      list-style-image: url(http://www.mbie.govt.nz/bullet_double_green_8x8.png);
                      }
                      
                      h2 {
                      font-size:20px;
                      line-height: 24px;
                      color: rgb(0, 139, 198);
                      }
                      
                      
                      h3 {
                      font-size:15px;
                      line-height: 18px;
                      color: rgb(0, 139, 198);
                      }
                      
                      .selectize-dropdown, .selectize-input, label { 
            font-family: 'Lucida Sans Unicode', 'Lucida Grande', Verdana, Lucida, Helvetica, Arial, Calibri, sans-serif;
            font-size: 11px;
            font-weight: normal;   
                      }
                      
                      .floating-image{
                     left: 350px; top: 0px; position: absolute; 
                      }
                      
                      "
      ))
      
            
   ), # end of head
     h2("IVS example"),
     htmlOutput("TheText")
   

         
)
)
