function weakLearnerIndex = selectStrongLearner(instanceMarginSet,instanceTarget,instanceLabel,loopNum)
%% weakLearnerIndex = selectStrongLearner(instanceMarginSet,instanceTarget,instanceLabel, loopNum)
%%selects weak classifiers to form strong classifiers  
%%Input£º   
%        instanceMarginSet£º    confidence values of all weak classifiers
%           instanceTarget£º    bag label
%            instanceLabel£º    instance label
%                  loopNum:     number of selected weak classifiers   
%%Output£º  
%         weakLearnerIndex£º    index of selected weak classifiers 

weakLearnerIndex = [];
[weakLearnerNum instanceNum] = size(instanceMarginSet);
instanceMargin = zeros(1,instanceNum);
for i = 1:loopNum
    instanceMarginTemp = repmat(instanceMargin,weakLearnerNum,1) + instanceMarginSet;
    instanceConfidence = 1./(1+exp(-instanceMarginTemp/100));  
    [ bagConfidence bagLabel bagIndex ] = calculateBagConfidence(instanceConfidence, instanceTarget, instanceLabel);  
    weakLearnerConfidence = calculateWeakLearnerConfidence_LOG(bagConfidence, bagLabel);       
    weakLearnerConfidence(weakLearnerIndex ) = -inf;
    [ value index ] = max(weakLearnerConfidence); 
    instanceMargin = instanceMarginTemp(index,:);  
    weakLearnerIndex = [ weakLearnerIndex index ];                                              
end