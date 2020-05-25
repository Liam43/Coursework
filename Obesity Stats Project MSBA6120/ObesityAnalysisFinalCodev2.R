library(readxl)
library(dplyr)
library(tidyverse)

setwd("~/MSBA/Summer Semester/04 - Introduction to Statistics for Data Scientists - MSBA 6120/Project")
obesity1 <- read_excel('stats_data_new1.xlsx', col_names = TRUE)
obesity_south = filter(obesity, Region == "South")
obesity_west = filter(obesity, obesity$Region == 'West')
obesity_northeast = filter(obesity, obesity$Region == 'Northeast')
obesity_midwest = filter(obesity, obesity$Region == 'Midwest')

### Regional Analysis ###
boxplot(obesity$Obesity_Rate ~ obesity$Region)

# Region
fit <- aov(obesity$Obesity_Rate ~ obesity$Region)
summary(fit)
print(model.tables(fit, "means"))
tukey = TukeyHSD(fit, conf.level = .95)
tukey
plot(tukey)

# South Sub_Region
fit2 <- aov(obesity_south$Obesity_Rate ~ obesity_south$Sub_Region)
summary(fit2)
print(model.tables(fit2, "means"))
TukeyHSD(fit2, conf.level = .95)
tukey2 = TukeyHSD(fit2, conf.level = .95)
tukey2
plot(tukey2)

fit3 <- aov(obesity_west$Obesity_Rate ~ obesity_west$Sub_Region)
summary(fit3)
print(model.tables(fit3, "means"))
TukeyHSD(fit3, conf.level = .95)
tukey3 = TukeyHSD(fit3, conf.level = .95)
tukey3
plot(tukey3)


### State Regression Analysis ###

# Model Fitting
reg10 = lm(Obesity_Rate ~ Fast_Food_per_1000 + Full_Service_per_1000	+ Grocery_per_1000 + 
            Fitness_per_1000	+ Percent_Unemployed + Poverty_Rate	+ Median_Income + st, data = obesity1)
summary(reg10)

# Remove Poverty Rate - Highly correlated with Median Income (-.74)
reg20 = lm(Obesity_Rate ~ Fast_Food_per_1000 + Full_Service_per_1000	+ Grocery_per_1000 + 
             Fitness_per_1000	+ Percent_Unemployed + Median_Income + st, data = obesity1)
summary(reg20)

# Remove grocery (.69 pval) - BEST MODEL SO FAR
reg30 = lm(Obesity_Rate ~ Fast_Food_per_1000 + Full_Service_per_1000 + 
             Fitness_per_1000	+ Percent_Unemployed	+ Median_Income + st, data = obesity1)
summary(reg30)

# All P-vals significant, but colinearity concerns

# Remove Full Service and Fitness .69 and .65 cor with fast food (.69)
reg40 = lm(Obesity_Rate ~ Fast_Food_per_1000 + 
             Percent_Unemployed	+ Median_Income + st, data = obesity1)
summary(reg40)

# No colinearity concerns but lower r2 and higher s



### Residuals for State Model ###
reg.stres40 <- rstandard(reg40)

plot(reg40$fitted.values, reg.stres40, ylim = c(-4,4), xlim = c(20,37))
abline(0,0,  lty=   2,  col=   "blue")

hist(reg.stres40, xlim = c(-5,5))

qqnorm(reg.stres40, ylim = c(-5,5))
qqline(reg.stres40)

obesity1$stF <- factor(obesity1$st)
obesity1 <- within(obesity1, stF <- relevel(stF, ref = 'WV'))

reg30 = lm(Obesity_Rate ~ Fast_Food_per_1000 + Full_Service_per_1000 + 
             Fitness_per_1000	+ Percent_Unemployed	+ Median_Income + stF, data = obesity1)

summary(reg30)
