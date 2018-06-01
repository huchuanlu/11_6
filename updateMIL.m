function [weaklearner,weakLearnerIndex] = updateMIL(sampleStrong,weaklearner)  
%% function [weaklearner,weakLearnerIndex] = updateMIL(sampleStrong,weaklearner)
%%updates RGB and HOG classifiers
%%Input:
%       sampleStrong      : RGB and HOG features and labels for positives and negatives
%       weaklearner       : original weak classifiers
%%Output:
%       weaklearner       : updated weak classifiers
%       weakLearnerIndex  : index of selected weak classifiers

 loopNum =10;
 
 RGBtrainsample    = [sampleStrong.posxRGB,sampleStrong.negxRGB];
 RGBftrnum         = size(sampleStrong.posxRGB,1);
 
 HOGtrainsample = [sampleStrong.posxHOG,sampleStrong.negxHOG];
 HOGftrnum      = size(sampleStrong.posxHOG);
 
 %%**************************** update MIL ******************************%%
 fprintf('Update MIL Classifiers.\n');
 
 weaklearner.RGB             = updateAllWeakLearner(sampleStrong.posxRGB,sampleStrong.negxRGB,weaklearner.RGB);
 RGBinstanceMarginSet        = calculateAllWeakLearnerMargin(RGBtrainsample,weaklearner.RGB);
 weakLearnerIndex.RGB        = selectStrongLearner(RGBinstanceMarginSet,sampleStrong.instanceTarget,sampleStrong.newSampleLabel,loopNum);

 weaklearner.HOG             = updateAllWeakLearner(sampleStrong.posxHOG,sampleStrong.negxHOG,weaklearner.HOG);
 HOGinstanceMarginSet        = calculateAllWeakLearnerMargin(HOGtrainsample,weaklearner.HOG);
 weakLearnerIndex.HOG        = selectStrongLearner(HOGinstanceMarginSet,sampleStrong.instanceTarget,sampleStrong.newSampleLabel,loopNum);