function [r] = calculateAllWeakLearnerMargin( trainsample,weaklearner )
%% function [r] = calculateAllWeakLearnerMargin( trainsample,weaklearner )
%%calculates confidence values of all weak classifiers   
%%Input£º
%              trainsample    :     all train samples
%              weaklearner    £º    all weak classifiers
%%Output£º
%                        r    £º    confidence values

      e0 = -1./(2*weaklearner.sig0.*weaklearner.sig0 + eps);
      e1 = -1./(2*weaklearner.sig1.*weaklearner.sig1 + eps);
      n0 =  1./(weaklearner.sig0*sqrt(2*pi)  + eps);
      n1 =  1./(weaklearner.sig1*sqrt(2*pi)  + eps);
      for samplenum = 1:size( trainsample,2)
           p0 = n0.*exp( (trainsample(:,samplenum)-weaklearner.mu0).*(trainsample(:,samplenum)-weaklearner.mu0).*e0 );
           p1 = n1.*exp( (trainsample(:,samplenum)-weaklearner.mu1).*(trainsample(:,samplenum)-weaklearner.mu1).*e1 );
           r(:,samplenum)  =  (log(eps + p1)-log(eps + p0));
      end