library(shiny)
library(markdown)

shinyUI(navbarPage('',
 tabPanel('LR Visualizer',
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
                   c('None', 'y^2', 'sqrt(y)', 'log(y)', '-1/y', '-1/sqrt(y)'),
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
 ),
 tabPanel('Help', includeMarkdown('README.md'))
))