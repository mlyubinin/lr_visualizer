
LR Visualizer
=============

## What does it do?
LR visualizer helps see how linear regression performs on samples with different type of association between features (linear and non-linear) and what type of transformations help in which situation.

## How to use?
1. Pick a sample size (from 0 to 1000 cases)
2. Pick type of association between X and Y features of the sample
3. Pick a transformation to apply to the data prior to fitting a linear model
4. Explore the graphs:
* On Scatterplot you can see how well linear regression models the data, both on original sample and on transformed sample, and compare the fit to local regression (loess) fit.
* On other plots you can examine the residuals - scatterplot for patterns and heteroscedasticity, histogram, density plot and Q-Q plot for normality of residuals distribution, and boxplot because boxplots are fun

You can generate a new sample at any time by changing sample size or type. You can also change the transformation at any time to re-train the regression.