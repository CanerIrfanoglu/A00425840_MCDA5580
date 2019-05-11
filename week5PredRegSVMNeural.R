x=data.frame(array(runif(300,0.3,0.8),dim=c(100,3)))
xt=data.frame(array(runif(150,0.3,0.8),dim=c(50,3)))
y=4.5*x[,1]^2+9.8*x[,2]*x[,3]+99.45*x[,3]^3+runif(1,1:34)
yt=4.5*xt[,1]^2+9.8*xt[,2]*xt[,3]+99.45*xt[,3]^3+runif(1,1:34)
yn=y/max(y)
ytn=yt/max(yt)
xy=data.frame(cbind(x,y))
xyt=data.frame(cbind(xt,yt))
xyn=data.frame(cbind(x,yn))
xytn=data.frame(cbind(xt,ytn))

View(x)
View(xt)
summary(y)
summary(yn)
summary(yt)
summary(ytn)
View(y)
View(xy)

rg=lm(y~.,xy)
rg$fit
rg$coeff
mean(100*abs(y-rg$fit)/y)
ytp=predict(rg,xt)
mean(100*abs(yt-ytp)/yt)

library(e1071)
svr=svm(x,y)
yp=predict(svr,x)
mean(100*abs(y-yp)/y)
ytp=predict(svr,xt)
mean(100*abs(yt-ytp)/yt)
svr=svm(x,y,kernel="radial")
yp=predict(svr,x)
mean(100*abs(y-yp)/y)
ytp=predict(svr,xt)
mean(100*abs(yt-ytp)/yt)
svr=svm(x,y,kernel="polynomial",degree="3")
yp=predict(svr,x)
mean(100*abs(y-yp)/y)
svr=svm(x,yn,kernel="sigmoid")
ynp=predict(svr,x)
mean(100*abs(yn-ynp)/yn)

library(neuralnet)
nn=neuralnet(yn~X1+X2+X3,data=xyn,hidden=10,
             act.fct="logistic",linear.out=F,
             algorithm="backprop",learningrate=0.01)
nn$net.result[1]
mean(100*abs(nn$net.result[[1]]-yn)/yn)
nnp=compute(nn,covariate=xt)
mean(100*abs(array(nnp$net.result)-ytn)/ytn)

# Try with three hidden layers
nn=neuralnet(yn~X1+X2+X3,data=xyn,hidden=c(5,5,5),
             act.fct="logistic",linear.out=F,
             algorithm="backprop",learningrate=0.01)
nn$net.result[1]
mean(100*abs(nn$net.result[[1]]-yn)/yn)
nntp=compute(nn,covariate=xt)
mean(100*abs(array(nntp$net.result)-ytn)/ytn)

library(randomForest)
rf=randomForest(x,y)
rfp=predict(rf,x)
mean(100*abs(y-rfp)/y)
rftp=predict(rf,xt)
mean(100*abs(yt-rftp)/yt)