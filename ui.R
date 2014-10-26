library(shiny)

shinyUI(fluidPage(

  titlePanel('Linear Regression Visualizer'),

  sidebarLayout(
    sidebarPanel(
      sliderInput('rows',
                  'Number of cases:',
                  min = 1,
                  max = 1000,
                  value = 100),
      radioButtons('relationship',
                   'Generate Sample',
                   c('Linear', 'Quadratic', 'Cubic', 'Exponential', 'Logarithmic'),
                   selected = 'Linear'
        ),
      radioButtons('transform',
                   'Pre-regression transformation',
                   c('None', '1/y', '1/y^2', '1/sqrt(y)', 'e^y', 'log(y)'),
                   selected = 'None'
      ),
      radioButtons('show',
                   'Visualization',
                   c('Scatterplot', 'Resid. Scatterplot', 'Resid. Histogram', 'Resid. Density', 'Resid. Boxplot', 'Resid. Q-Q'),
                   selected = 'Scatterplot'
        )
    ),

    mainPanel(
      plotOutput("selectedPlot"),
      wellPanel(uiOutput('scatterpoints')),
      wellPanel(uiOutput('options'))
    )
  )
))
