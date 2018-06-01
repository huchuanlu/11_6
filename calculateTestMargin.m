function [testMargin] = calculateTestMargin( Alltest,weaklearnerindex,weaklearner)
%% function [testMargin] = calculateTestMargin(Alltest,weaklearnerindex,weaklearner)
%%calculates confidence values of test samples
%%Input:
%    testsample       £ºall test samples
%    weaklearnerindex £ºindex of selected weak classifiers
%    weaklearner      : all weak classifiers
%%Output£º
%    testMargin       : confidence values of test samples

numsample = size( Alltest.RGB,2);

for i = 1:numsample
    testsample =  Alltest.RGB(:,i);
    mu1  = weaklearner.RGB.mu1 (weaklearnerindex.RGB);
    sig1 = weaklearner.RGB.sig1(weaklearnerindex.RGB);
    mu0  = weaklearner.RGB.mu0 (weaklearnerindex.RGB);
    sig0 = weaklearner.RGB.sig0(weaklearnerindex.RGB);
    e0 = -1./(2*sig0.*sig0 + eps);
    e1 = -1./(2*sig1.*sig1 + eps);
    n0 =  1./(sig0*sqrt(2*pi)  + eps);
    n1 =  1./(sig1*sqrt(2*pi)  + eps);
    p0 = n0.*exp( (testsample(weaklearnerindex.RGB,:)-mu0).*(testsample(weaklearnerindex.RGB)-mu0).*e0 );
    p1 = n1.*exp( (testsample(weaklearnerindex.RGB,:)-mu1).*(testsample(weaklearnerindex.RGB)-mu1).*e1 );
    testMarginRGB =sum((log(eps + p1)-log(eps + p0)));
    testMargin.RGB(i) = 1/(1+exp(-testMarginRGB));
    
    testsample =  Alltest.HOG(:,i);
    mu1  = weaklearner.HOG.mu1 (weaklearnerindex.HOG);
    sig1 = weaklearner.HOG.sig1(weaklearnerindex.HOG);
    mu0  = weaklearner.HOG.mu0 (weaklearnerindex.HOG);
    sig0 = weaklearner.HOG.sig0(weaklearnerindex.HOG);
    e0 = -1./(2*sig0.*sig0 + eps);
    e1 = -1./(2*sig1.*sig1 + eps);
    n0 =  1./(sig0*sqrt(2*pi)  + eps);
    n1 =  1./(sig1*sqrt(2*pi)  + eps);
    p0 = n0.*exp( (testsample(weaklearnerindex.HOG,:)-mu0).*(testsample(weaklearnerindex.HOG)-mu0).*e0 );
    p1 = n1.*exp( (testsample(weaklearnerindex.HOG,:)-mu1).*(testsample(weaklearnerindex.HOG)-mu1).*e1 );
    testMarginHOG =sum((log(eps + p1)-log(eps + p0)));
    testMargin.HOG(i) = 1/(1+exp(-testMarginHOG));
    
    testMargin.testMargin(i) = (testMargin.RGB(i)/(testMargin.RGB(i)+testMargin.HOG(i)))*testMargin.RGB(i)  + (testMargin.HOG(i)/(testMargin.RGB(i)+testMargin.HOG(i)))*testMargin.HOG(i);      
end