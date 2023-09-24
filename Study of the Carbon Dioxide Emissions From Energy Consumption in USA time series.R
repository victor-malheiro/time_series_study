install.packages('forecast', dependencies = TRUE)
install.packages("ggplot2")
install.packages("astsa")
install.packages("xts")
install.packages("fpp")
library(forecast)
library(ggplot2)
library(astsa)
library(xts)
library(fpp)


#first i imported the excel file "Carbon_Dioxide_Emissions_From_Energy_Consumption"

cde <- Carbon_Dioxide_Emissions_From_Energy_Consumption[,2]

tscde <- ts(cde,start=c(1973,1),frequency = 12)
plot(tscde)
acf2(tscde)

lcde <- log(tscde)
plot(lcde, main="Monthly log carbon dioxide emissions")
acf2(lcde)

#Using the Box Cox function to see if i get a better result
lam = BoxCox.lambda(tscde)
lam.tscde = BoxCox(tscde,lam)
ts.plot(lam.tscde)



#Dividing the timeseries into train and test sets
tscde.train <- window(tscde, start=c(1973,1), end=c(2019,1), frequency = 12)
tscde.test <- window(tscde, start=c(2019,2), frequency = 12)

par(mfrow = c(2, 1))
plot(tscde.train, main = expression(tscde.train))
plot(log(tscde.train), main = expression(log(tscde.train)))



#plots to study the logged data
ltrain <- log(tscde.train)
dltrain <- diff(ltrain)
dltrain12 <- diff(ltrain,12)
ddltrain12 <- diff(diff(ltrain),12)

maxlag <- 48
par(mfrow=c(3,4), mar=c(2,2,3,2))

plot(ltrain, main = expression("log(tscde.train)"))
plot(dltrain, main = expression(paste(Delta, "log(tscde.train)")))
plot(dltrain12, main = expression(paste(Delta[12], "log(tscde.train)")))
plot(ddltrain12, main = expression(paste(Delta, Delta[12], "log(tscde.train)")))

Acf(ltrain, type='correlation', lag=maxlag, ylab="", main=expression(paste("ACF for log(tscde.train)")))
Acf(dltrain, type='correlation', lag=maxlag, ylab="", main=expression(paste("ACF for ", Delta,"log(tscde.train)")))
Acf(dltrain12, type='correlation', lag=maxlag, ylab="", main=expression(paste("ACF for ", Delta[12], "log(tscde.train)")))
Acf(ddltrain12, type='correlation', lag=maxlag, ylab="", main=expression(paste("ACF for ", Delta, Delta[12], "log(tscde.train)")))

Acf(ltrain, type='partial', lag=maxlag, ylab="", main=expression(paste("PACF for log(tscde.train)")))
Acf(dltrain, type='partial', lag=maxlag, ylab="", main=expression(paste("PACF for ", Delta, "log(tscde.train)")))
Acf(dltrain12, type='partial', lag=maxlag, ylab="", main=expression(paste("PACF for ", Delta[12], "log(tscde.train)")))
Acf(ddltrain12, type='partial', lag=maxlag, ylab="", main=expression(paste("PACF for ", Delta,Delta[12], "log(tscde.train)")))


nsdiffs(ltrain)
ndiffs(ltrain)
ndiffs(diff(ltrain,12))
ndiffs(diff(diff(ltrain,12)))



#Models
  #model 1
sarima(ltrain,9,1,2,1,1,2,12)
  #model 2
sarima(ltrain,1,0,7,2,1,1,12)


model1 <-  Arima(ltrain, order = c(9,1,2), seasonal=list(order=c(1,1,2), period=12))
model2 <-  Arima(ltrain, order = c(9,1,2), seasonal=list(order=c(1,1,2), period=12), fixed=c(0, NA, 0, NA, 0, 0, NA, 0, 0, NA, NA, 0, 0, 0))
model3 <-  Arima(ltrain, order = c(1,0,7), seasonal=list(order=c(2,1,1), period=12))
model4 <-  Arima(ltrain, order = c(1,0,7), seasonal=list(order=c(2,1,1), period=12), fixed=c(NA, NA, NA, 0, 0, 0, 0, NA, 0, NA, NA))


#re-calculation of the Lung-Box statistic
myLB= function(x.fit){
  res=NULL
  npar= dim(x.fit$var.coef)[1]
  for (i in (npar+1):40){
    q=Box.test(x.fit$residuals,lag=i,type="Ljung-Box",fitdf=npar)
    res[i]=q$p.value}
  return(res)}

  #for model2
par(mfrow=c(2,2), mar=c(3,3,4,2))
Acf(model2$residuals, type='correlation', lag=maxlag, na.action=na.omit, ylab="", main=expression(paste("ACF for Residuals")))
Acf(model2$residuals, type='partial', lag=maxlag, na.action=na.omit, ylab="", main=expression(paste("PACF Residuals")))
plot(myLB(model2),ylim=c(0,1))
abline(h=0.05,col="blue",lty=2)

  #for model4
par(mfrow=c(2,2), mar=c(3,3,4,2))
Acf(model4$residuals, type='correlation', lag=maxlag, na.action=na.omit, ylab="", main=expression(paste("ACF for Residuals")))
Acf(model4$residuals, type='partial', lag=maxlag, na.action=na.omit, ylab="", main=expression(paste("PACF Residuals")))
plot(myLB(model4),ylim=c(0,1))
abline(h=0.05,col="blue",lty=2)



#forecasts
model1.f12 <- forecast(model1, 12)
model3.f12 <- forecast(model3, 12)
model4.f12 <- forecast(model4, 12)



#accuracy
ltest <- log(tscde.test)

model1.f12.acc <- accuracy(model1.f12, ltest)
model3.f12.acc <- accuracy(model3.f12, ltest)
model4.f12.acc <- accuracy(model4.f12, ltest)



#95% confidence intervals
model1.f12$lower[1:12,2]
model1.f12$upper[,2]
model3.f12$lower[1:12,2]
model3.f12$upper[,2]
model4.f12$lower[1:12,2]
model4.f12$upper[,2]



#forecast plot
plot(model1.f12, xlim=c(2009,2019))
lines(log(window(tscde, start=c(2009,1), frequency = 12)))
plot(model3.f12, xlim=c(2009,2019))
lines(log(window(tscde, start=c(2009,1), frequency = 12)))
plot(model3.f12, xlim=c(2009,2019))
lines(log(window(tscde, start=c(2009,1), frequency = 12)))



#errors plot
error.model1= abs(as.vector(ltest)-model1.f12$mean)/model1.f12$mean*100
error.model3= abs(as.vector(ltest)-model3.f12$mean)/model3.f12$mean*100
error.model4= abs(as.vector(ltest)-model4.f12$mean)/model4.f12$mean*100
plot(error.model1, ylab="error")
lines(error.model3,col="green")
lines(error.model4,col="blue")
legend("topleft", legend=c("model1","model3","model4"),lty=c(1,1,1), text.col=c("black","green","blue"), col=c("black","green","blue"))



#plot of multistep ahead forecasts
plot(model1.f12, pch=20, xlim=c(2016,2020), ylim=c(5.8, 6.3), main=" model1 Multistep Ahead Forecasts")
lines(model1.f12$mean, type="p", pch=20, lty="dashed", col="blue")
lines(log(tscde), type="o", pch=20, lty="dashed")

plot(model3.f12, pch=20, xlim=c(2016,2020), ylim=c(5.8, 6.3), main=" model3 Multistep Ahead Forecasts")
lines(model3.f12$mean, type="p", pch=20, lty="dashed", col="blue")
lines(log(tscde), type="o", pch=20, lty="dashed")

plot(model4.f12, pch=20, xlim=c(2016,2020), ylim=c(5.8, 6.3), main=" model4 Multistep Ahead Forecasts")
lines(model4.f12$mean, type="p", pch=20, lty="dashed", col="blue")
lines(log(tscde), type="o", pch=20, lty="dashed")



#Smoothing method
xhw <- HoltWinters(tscde.train,seasonal = "m")
plot(xhw)
xhw.f <- forecast(xhw,h=12)
xhw.f.acc <- accuracy(xhw.f, tscde)

  # testing with the aditive model
xhwa <- HoltWinters(tscde.train,seasonal = "a")
plot(xhwa)
xhwa.f <- forecast(xhwa,h=12)
xhwa.f.acc <- accuracy(xhwa.f, tscde)

#Decomposition method
  #classical method
d <- decompose(tscde,type="m")
plot(d)
x <- tscde - d$seasonal
plot(x)
d.f.s <- forecast(d$seasonal,h=12)

  #STL method
stltscde <- stl(log(tscde.train[,1]), "periodic", robust = T, outer = 20, inner = 2)
plot(stltscde)

stltscde.f <- forecast(stltscde,h=12)
v <- exp(stltscde.f[[2]])
stltscde.f.acc <- accuracy(v, tscde)
stltscde.f.acc2 <- accuracy(stltscde.f, log(tscde))
