function weakLearnerIndex = selectStrongLearner(instanceMarginSet,instanceTarget,instanceLabel,loopNum)
%% weakLearnerIndex = selectStrongLearner(instanceMarginSet,instanceTarget,instanceLabel, loopNum)
%%selects weak classifiers to form strong classifiers  
%%Input��   
%        instanceMarginSet��    confidence values of all weak classifiers
%           instanceTarget��    bag label
%            instanceLabel��    instance label
%                  loopNum:     number of selected weak classifiers   
%%Output��  
%         weakLearnerIndex��    index of selected weak classifiers 

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