function [weaklearner, weakLearnerIndex] = inittrain(sampleStrong) 
%% function [weaklearner, weakLearnerIndex] = inittrain(sampleStrong) 
%%initializes RGB and HOG MIL
%%Input:
%       sampleStrong      :RGB and HOG features and labels of positives and negatives 
%%Output:
%       weaklearner       :all the weak classifiers
%       weakLearnerIndex  :index of selected weak classifiers
 
 loopNum = 10;   
 
 %%initialize RGB MIL
 RGBtrainsample    = [sampleStrong.posxRGB,sampleStrong.negxRGB];
 RGBftrnum         = size(sampleStrong.posxRGB,1);
 weaklearner.RGB.mu1         = zeros(RGBftrnum,1);
 weaklearner.RGB.sig1        = zeros(RGBftrnum,1);
 weaklearner.RGB.mu0         = zeros(RGBftrnum,1);
 weaklearner.RGB.sig0        = zeros(RGBftrnum,1);
 
 %%initialize HOG MIL
 HOGtrainsample = [sampleStrong.posxHOG,sampleStrong.negxHOG];
 HOGftrnum      = size(sampleStrong.posxHOG,1);
 weaklearner.HOG.mu1         = zeros(HOGftrnum,1);
 weaklearner.HOG.sig1        = zeros(HOGftrnum,1);
 weaklearner.HOG.mu0         = zeros(HOGftrnum,1);
 weaklearner.HOG.sig0        = zeros(HOGftrnum,1);
 
 %%RGB MIL
 weaklearner.RGB             = updateAllWeakLearner(sampleStrong.posxRGB,sampleStrong.negxRGB,weaklearner.RGB);
 RGBinstanceMarginSet        = calculateAllWeakLearnerMargin(RGBtrainsample,weaklearner.RGB);
 weakLearnerIndex.RGB        = selectStrongLearner(RGBinstanceMarginSet,sampleStrong.instanceTarget,sampleStrong.newSampleLabel,loopNum);
 
 %%HOG MIL
 weaklearner.HOG             = updateAllWeakLearner(sampleStrong.posxHOG,sampleStrong.negxHOG,weaklearner.HOG);
 HOGinstanceMarginSet        = calculateAllWeakLearnerMargin(HOGtrainsample,weaklearner.HOG);
 weakLearnerIndex.HOG        = selectStrongLearner(HOGinstanceMarginSet,sampleStrong.instanceTarget,sampleStrong.newSampleLabel,loopNum);