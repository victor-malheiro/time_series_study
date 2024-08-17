# Study of the Carbon Dioxide Emissions From Energy Consumption in USA time series

## Table of Contents
1. [Project Statement](#project-statement)
2. [Data](#data)
3. [Time series description](#time-series-description)
4. [Smoothing Method](#smoothing-method)
5. [Decomposition Method](#decomposition-method)
6. [Modelling with a SARIMA model](#modelling-with-a-sarima-model)
7. [Conclusion](#conclusion)

## Project Statement
The objective of this assignment was to be able to make reliable forecasts of the last 12 months using different techniques and models.

First, I will analyze the time series checking for seasonality, trend and stationarity. After that, I will apply smoothing methods and decomposition methods to make forecasts.

In the end, I will try to fit the time series into SARIMA models that will allow me to make accurate forecasts.

## Data
This dataset represents the monthly Total U.S energy related CO2 emissions from January 1973 to January 2021 in million metric tons.

We can see a growing trend on the beginning until 2018 and then a decreasing trend from that year forward. In addition, we can see the seasonality that is present in the data.

The dataset it is divided into several types of emissions like the ones from Coal, Natural Gas and Petroleum but the data that I used is the total of all the types of emissions present on the dataset.

The dataset was downloaded from https://www.eia.gov/todayinenergy/detail.php?id=44837

![image](https://github.com/user-attachments/assets/3fa29207-c3ce-4548-afe1-c9cd9fc8715b)

![image](https://github.com/user-attachments/assets/3a27d3f8-9c13-4d0e-be77-eba00d22ed4f)

## Time series description

![image](https://github.com/user-attachments/assets/a2c3217c-04fd-427e-8e2d-d97216e049ee)

We can see different trends along the time, being the biggest one between 1983 and 2008, on the beginning of 2020 we can see a big drop that must be due to the beginning of the Covid-19 pandemic, 
so I decided to make the analysis without the last 12 months of observation. With this analysis, I can conclude that this time series is not stationary.

As can be seen before, the ACF not meaningful because the time series is not stationary.

The variance of the data seems to vary in some points of the time series, to stabilize it I used a Box-Cox transformation taking the log of the data that can also help to remove some non-linearity 
on the trend that exists. 

Below can be seen the time series with the log transformation and it does not appear to have a big impact on the time series. Using the Box-Cox function in R to see if it gave a better result 
than the log transformed data, I could see that no major difference was found.

![image](https://github.com/user-attachments/assets/2ea52580-7f00-4457-8c8a-2426b5e95430)

In addition, to see the seasonality that is present in the data, I computed the below two plots.

![image](https://github.com/user-attachments/assets/d24e9194-fddd-44ec-9802-a4ef43a2bae4)

![image](https://github.com/user-attachments/assets/1b670ec3-7817-4e2a-b4ab-917fbb7fe268)

Studying the monthly increases in the log transformed data and its ACF plot I can state that the monthly increases are stationary around zero and seasonal.

![image](https://github.com/user-attachments/assets/9e140a41-e7eb-458a-a3b0-3534b5148c1f)

![image](https://github.com/user-attachments/assets/2bf1ce38-311b-4824-8e3d-86dee3295046)

The annual increases looks approximately stationary around a mean, that is zero.

![image](https://github.com/user-attachments/assets/3dc4f511-696e-45ff-a193-4d7e6573c370)

![image](https://github.com/user-attachments/assets/59da3c41-70ba-4bb8-85f3-1fe18551e077)

## Smoothing Method
Because the seasonality does not have the same dimension every year and it seems to depend on the increasing or decreasing trend, I think the most adequate model is the Winter’s multiplicative model. 
Although the observed differences are not significant, I think the multiplicative model will be a bit better than the additive model.

Below we can see the results of the application of the model and after that, we can check the plot of the predictions with the observed data and we can see that the fit is generally good. 
The results of the forecast are below too.

![image](https://github.com/user-attachments/assets/66e93204-0814-412a-b0cb-fdcdd3d38439)

![image](https://github.com/user-attachments/assets/a6e7af00-06e8-4448-8928-6bc1b12ad665)

![image](https://github.com/user-attachments/assets/c4edce3d-9d7b-4730-a0da-039f3d3c7d34)

Checking the accuracy of the forecast, we can see that for the MAPE measure the accuracy of the test set is a bit more than 4,06%, which is a good value. Comparing with the accuracy of the 
application of the additive model, that is 3,99%. I get a slightly better forecast with the multiplicative model, as I was predicting on the beginning.

![image](https://github.com/user-attachments/assets/945884d2-f437-415c-a183-93b4768eed69)

## Decomposition Method
**Classical Method**

As I concluded before, the best model for this time series is the multiplicative model, so I’m going to make the decomposition of this time series. Below I show the graphical representation of the 
observed values, the trend (that has the cycle included), the seasonal component and the errors.

The values for each component for the last 5 years and the seasonally adjusted data are below, for the trend and error components, we can see that for the first six and last six months no value is 
available because they were computed through a 12 terms centered MA.

Seasonal component:
![image](https://github.com/user-attachments/assets/4aca560f-dafe-42a8-9812-9f1e85110dbe)

Trend component:
![image](https://github.com/user-attachments/assets/7a7aa4af-063d-4439-9605-d72c7633993f)

Random component:
![image](https://github.com/user-attachments/assets/42b5532d-80de-46d7-b803-6c5c11dc77d2)

Seasonally adjusted data:
![image](https://github.com/user-attachments/assets/0c4a6fc9-eae6-4679-bc0c-5a11e2d87b5f)

![image](https://github.com/user-attachments/assets/d4afd8f7-d96e-4d7c-9af6-8bfad0bebc30)

**Seasonal and Trend decomposition using Loess - STL method**

To compute this method in R I used the “stl” function with the log of the data to use the multiplicative model, with outer set to 20 and inner to 2. Below can be seen the plot of the entire components and the data.

![image](https://github.com/user-attachments/assets/ac7174a2-0f1d-4f16-8120-b8fad22e5816)

After making the exp of the data, because it was logged, I can get the values of the three components of the decomposition for the last 12 months.

![image](https://github.com/user-attachments/assets/239286e2-9c05-4c38-9155-6fc24de0a487)

With this information, I can compute the forecast for the data and then check the accuracy of the predictions. Below I have the values of the forecast that are the exp of the results of the forecast.

![image](https://github.com/user-attachments/assets/2ec4c617-d18f-431d-98bd-32296cf6e949)

And to compute the accuracy, I used these values against the original time series and got good results with 3,71% for the MAPE measure.

![image](https://github.com/user-attachments/assets/75fdb1b3-def8-4445-80e3-f3ceae50ee2c)

## Modelling with a SARIMA model
Because the time series has seasonality and trend, I had to consider a seasonal AR and/or MA component besides the regular AR and/or MA component. I divided the dataset into a train set and test set, 
with only the last 12 months of observations, and because the variance seems to change over time, I will consider the log of the data that is more stable.

![image](https://github.com/user-attachments/assets/bf84239d-9f99-44e3-900a-43f8f163ea2b)

To know the best SARIMA model, I will study the data, the ACF and PACF plots of the logged data, the differenced data, the annual differenced data and the annual difference of the differenced data.

![image](https://github.com/user-attachments/assets/b5f58f50-a8fa-455a-b5e1-f0595f78c03a)

Analyzing the plots and the output of functions ndiffs() and nsdiffs(), i could see that can be d=0 or d=1 and D=1.

Although the PACF and ACF plots indicate an AR model, it is not easy to clearly indicate a model for this time series. 

Starting with a large p and a small P, the first model that i called model1 is sarima(lcde,9,1,2,1,1,2,12). Despite the no correlation of the residuals, I could see that with this model a few parameters 
are not statistically significant, so I made them equal to zero and re-estimated the model.

![image](https://github.com/user-attachments/assets/9d610589-5554-4762-94cf-72ab0da32485)

![image](https://github.com/user-attachments/assets/b6d09770-0363-4b0f-a07b-0656d9582b66)

After the re-estimation, I had to recalculate the Lung-Box statistic and I could see that almost all the residuals are correlated.

![image](https://github.com/user-attachments/assets/4a76affc-e8fd-4c8f-98b8-035ed28c5acf)

After the analysis of model1 and model2, I can conclude that model1 can explain the serial correlation very well, although, some parameters are not statistically significant. However, model2 is not 
a very good option to explain the serial correlation.

![image](https://github.com/user-attachments/assets/936c6503-81cb-49cd-bf83-e713ea24121a)

![image](https://github.com/user-attachments/assets/a7cbea7a-90c2-4631-abc1-75d2b5b48baf)

Comparing the information criteria of both of them, we can see that model1 has lower information criteria and residuals are uncorrelated, so I will keep model1 to produce the forecasts.

| Model      | Order               | NPar | AIC      | AICc     | BIC      |
| ---------- |:-------------------:| :---:| :-------:| :-------:| :-------:|
| **model1** | (9,1,2)x(1,1,2)[12] | 14   | -2379.35 | -2378.44 | -2314.98 |
| **model2** | (9,1,2)x(1,1,2)[12] | 14-9 | -2165.8  | -2165.64 | -2140.05 |

I tried other values of the orders of the seasonal components of the model, but it did not produced better results. However, increasing the order of the MA component, lowering the order of the AR component and removing the differencing of the regular components, I was able to get a good model that I hope can produce good forecasts.

Using model3 as sarima(lcde,1,0,7,2,1,1,12), I could get good results, with almost all the residuals uncorrelated, but with some parameters being statistically not significant.

![image](https://github.com/user-attachments/assets/e1bbdf18-3e06-407b-acb9-33d3f90af902)

![image](https://github.com/user-attachments/assets/42231df4-b442-417b-b7fa-7f6f1b7192af)

After the re-estimation, I had to recalculate the Lung-Box statistic, as before, I could see that the residuals are almost all uncorrelated and all the parameters are statistically significant.

![image](https://github.com/user-attachments/assets/0ff3ae97-165d-4edc-b057-78050b7b40ff)

After analyzing these two models, I could see that model4 has a better AIC, so I will keep the model to produce forecasts.

![image](https://github.com/user-attachments/assets/e83473a4-c40e-465f-a114-4c3178c61f60)

![image](https://github.com/user-attachments/assets/59311d76-b53c-47bd-9c34-84d207ba6133)

| Model      | Order               | NPar | AIC      | AICc     | BIC      |
| ---------- |:-------------------:| :---:| :-------:| :-------:| :-------:|
| **model3** | (1,0,7)x(2,1,1)[12] | 11   | -2395.76 | -2395.16 | -2344.23 |
| **model4** | (1,0,7)x(2,1,1)[12] | 11-5 | -2397.25 | -2397.04 | -2367.2  |

After trying to tune the parameters of model3, I noticed that this one is the better one. Therefore, I will use model1, model3 and model4 to produce forecasts for this time series, with model4 being the one with lower information criteria.

The results for the forecast accuracy, for the training set and the test set, can be obtained, as can be seen below.

![image](https://github.com/user-attachments/assets/bfd26db6-744c-41c1-8fb4-c5c08f57c557)

For the training set, I got the following accuracy measures:

| Model      | RMSE   | MAE    | MAPE   | MASE   |
| ---------- |:------:| :-----:| :-----:| :-----:|
| **model1** | 0.0254 | 0.0193 | 0.3174 | 0.5869 |
| **model3** | 0.0253 | 0.0195 | 0.3217 | 0.5945 |
| **model4** | 0.0255 | 0.0197 | 0.3254 | 0.6013 |

All the models have a similar performance, with model4 being worse than the others on all measures, because information criteria penalizes models with the smallest number of parameters.

For the test set, the measures are the one below:

| Model      | RMSE   | MAE    | MAPE   | MASE   |
| ---------- |:------:| :-----:| :-----:| :-----:|
| **model1** | 0.0455 | 0.0382 | 0.6311 | 1.1623 |
| **model3** | 0.0440 | 0.0374 | 0.6188 | 1.1399 |
| **model4** | 0.0437 | 0.0371 | 0.6140 | 1.1311 |

However, in the test set is model4 with the better performance, that was the worst of the 3 models on the training set, with the best accuracy measures with MAPE of 0.614%.

Below I show the 95% confidence intervals in the forecasts for the best performing model, in the test set that is model4.

![image](https://github.com/user-attachments/assets/d60b3a5a-1be7-43dc-966d-97ee6ecef5e2)

Analyzing the plots of the forecasts with the confidence intervals and the observed values, I noticed that all the models performed similarly. With forecasts that overestimate the observed values in the last months, but in other months they achieved very good forecasts.

For a better visualization, I only set the plots for the period after 2019.

![image](https://github.com/user-attachments/assets/53f02aef-c4d7-45b0-ac8e-0aa01a300274)

![image](https://github.com/user-attachments/assets/52e0cb3a-e0ce-4821-bc49-70675ce8b713)

![image](https://github.com/user-attachments/assets/be1a4a30-c6c8-448b-8b4d-4456e1309d81)

In the Graphic below, we can see that the forecast was very good until after August, where the forecasting errors increased a lot.

![image](https://github.com/user-attachments/assets/76debfa7-f5d9-4e70-8c4a-80deec383ffb)

Finally, we can have the multistep ahead forecasts for the 3 models, as can be seen below.

![image](https://github.com/user-attachments/assets/f17dfafd-6df7-40c0-ad3d-a260f070e9c4)

![image](https://github.com/user-attachments/assets/56ad9873-fde0-4ca0-bd31-448e00ee1116)

![image](https://github.com/user-attachments/assets/a03e867f-f191-4649-90d8-96c2eda01178)

## Conclusion
After doing this analysis, I can conclude that the SARIMA models were very accurate on forecasting and that the most accurate forecasts can be modeled by several different models and finding the best one is difficult.

As I stated before, model4 is the best from all the models that I used, but the other ones can make good predictions too. Despite being the model with less parameters.

For future work, I would like to use multivariate time series analysis to the decomposed the data that I used.

## Copyright

© 2024 Victor Malheiro
