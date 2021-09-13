p = 6;
xmin=0.38;
xmax=0.5;
n=10000;
X = xmin + (xmax - xmin)*sum(rand(n,p),2)/p;
hist(X,50)