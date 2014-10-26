library(shiny)
library(ggplot2)
library(caret)

shinyServer(function(input, output) {

  df = reactive({
    x = runif(input$rows, min = -50, max = 50)
    if (input$relationship == 'Linear'){
      y = runif(1, min=5, max=10) + runif(1, min=-3, max=3) * x + rnorm(input$rows, mean = 0, sd=20)
    }
    else if (input$relationship == 'Quadratic'){
      y = runif(1, min=5, max=10) + runif(1, min=-3, max=3) * x + runif(1, min=-3, max=3) * x^2 + rnorm(input$rows, mean = 0, sd=20^2)
    }
    else if (input$relationship == 'Cubic'){
      y = runif(1, min=5, max=10) + runif(1, min=-3, max=3) * x + runif(1, min=-3, max=3) * x^2 + runif(1, min=-3, max=3) * x^3 + rnorm(input$rows, mean = 0, sd=25^3)
    }
    else if (input$relationship == 'Exponential'){
      y = runif(1, min=5, max=10) + runif(1, min=-3, max=3) * exp(x/20) + rnorm(input$rows, mean = 0, sd=3)
    }
    else if (input$relationship == 'Logarithmic'){
      y = runif(1, min=5, max=10) + runif(1, min=-3, max=3) * log(x+51) + rnorm(input$rows, mean = 0, sd=.5)
    }
    data.frame(x=x, y=y)[order(x),]
  })
  
  transformed_df = reactive({
    if (input$transform == 'None'){
      df()
    }
    else if (input$transform == '1/y'){
      data.frame(x=df()$x, y=1/df()$y)
    }
    else if (input$transform == '1/y^2'){
      data.frame(x=df()$x, y = 1/(df()$y)^2)
    }
    else if (input$transform == '1/sqrt(y)'){
      data.frame(x=df()$x, y = 1/sqrt(df()$y))
    }  
    else if (input$transform == 'e^y'){
      data.frame(x=df()$x, y = exp(df()$y))
    }    
    else if (input$transform == 'log(y)'){
      data.frame(x=df()$x, y = log(df()$y))
    }  
  })
  
  model = reactive({
    train(y ~ x, data = transformed_df(), method = 'lm')
  })
  
  yhat = reactive({
    yhat_transformed = predict(model(), newdata = transformed_df())
    if (input$transform == 'None'){
      data.frame(x=df()$x, yhat = yhat_transformed)
    }
    else if (input$transform == '1/y'){
      data.frame(x=df()$x, yhat = 1/yhat_transformed)      
    }
    else if (input$transform == '1/y^2'){
      data.frame(x=df()$x, yhat = 1/sqrt(yhat_transformed))
    }    
    else if (input$transform == '1/sqrt(y)'){
      data.frame(x=df()$x, yhat = 1/yhat_transformed^2)
    }    
    else if (input$transform == 'e^y'){
      data.frame(x=df()$x, yhat = log(yhat_transformed))
    }  
    else if (input$transform == 'log(y)'){
      data.frame(x=df()$x, yhat = exp(yhat_transformed))
    }
  })
  
  resid = reactive({
    data.frame(x=df()$x, resid = df()$y - yhat()$yhat)
  })
  
  g = reactive({
    if (input$show == 'Scatterplot'){
      if (input$scatterpoints == 'Original values'){
        g = ggplot(df(), aes(x=x, y=y)) + geom_point()        
      }
      else {
        g = ggplot(transformed_df(), aes(x=x, y=y)) + geom_point()
      }
      if ('Line' %in% input$options){
        if (input$scatterpoints == 'Original values' & input$transform != 'None'){
          g = g + geom_point(data=yhat(), aes(x=x, y=yhat), fill='red', shape=23, size=3)
        }
        else {
        g = g + geom_abline(intercept=model()$finalModel$coefficients[1], slope=model()$finalModel$coefficients[2],
                            color='red', size=1)
        }
      }
      if ('Loess fit' %in% input$options){
        g = g + geom_smooth()
      }
      g
    }
    else if (input$show == 'Resid. Scatterplot'){
      g = ggplot(resid(), aes(x=x, y=resid)) + geom_point() + geom_hline(aes(yintercept=0)) + ylab('residuals')
      g
    }
    else if (input$show == 'Resid. Histogram'){
      g = ggplot(resid(), aes(x=resid)) + geom_histogram() + xlab('residuals') + ylab('count')
      g
    }
        else if (input$show == 'Resid. Density'){
      g = ggplot(resid(), aes(x=resid)) + geom_density() + xlab('residuals')
      g
    }
    else if (input$show == 'Resid. Boxplot'){
      g = ggplot(resid(), aes(x=factor(0), y=resid)) + geom_boxplot() + xlab('') + ylab('residuals')
      if ('Jitter' %in% input$options){
        g = g + geom_jitter(color='blue', alpha=.5)
      }
      g = g + coord_flip()
      g
    }
    else if (input$show == 'Resid. Q-Q'){
      qqnorm(resid()$resid)
      qqline(resid()$resid)
    }
  })
  
  output$selectedPlot <- renderPlot({
    g()
  })
  
  observe({
    if (input$show == 'Scatterplot'){
      output$scatterpoints = renderUI({
        radioButtons('scatterpoints',
                     '',
                     c('Original values', 'Transformed values'),
                     selected = 'Original values', inline = T
          )
      })
      output$options = renderUI({    
        checkboxGroupInput('options',
                           'Show',
                           c('Line', 'Loess fit'),
                           selected='Points', inline = T)
      })
    }
    else if (input$show == 'Resid. Boxplot'){
      output$options = renderUI({
        checkboxGroupInput('options',
                           'Show',
                           c('Jitter'),
                           selected='Jitter')
      })
      output$scatterpoints = renderUI({br()})
    }
    else {
      output$options = renderUI({br()})
      output$scatterpoints = renderUI({br()})  
    }
  })
})
