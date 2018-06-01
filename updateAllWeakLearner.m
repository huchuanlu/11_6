function [weaklearner]=updateAllWeakLearner(posx,negx,weaklearner);
%% function [weaklearner]=updateAllWeakLearner(posx,negx,weaklearner);
%%updates all the weak classifiers  
%%Input£º   
%           posx     £º   positives
%           negx     £º   negatives          
%        weaklearner :    original weak classifiers
%%Output£º  
%        weaklearner £º   updated weak classifiers 

posmu = 0;
negmu = 0;
lRate = 0.85;

posmu   = mean(posx,2);
negmu   = mean(negx,2);
for i  = 1:size(posx,1)
  weaklearner.mu1(i)	= ( lRate*weaklearner.mu1(i)  +  (1-lRate)*posmu(i) );
  weaklearner.sig1(i)  =  lRate*weaklearner.sig1(i)  +  (1-lRate)* sqrt(mean((posx(i,:)-weaklearner.mu1(i)).*(posx(i,:)-weaklearner.mu1(i))));
  weaklearner.mu0(i)   = ( lRate*weaklearner.mu0(i)  +  (1-lRate)*negmu(i) );
  weaklearner.sig0(i)  =  lRate*weaklearner.sig0(i)  +  (1-lRate)* sqrt(mean((negx(i,:)-weaklearner.mu0(i)).*(negx(i,:)-weaklearner.mu0(i))));
end