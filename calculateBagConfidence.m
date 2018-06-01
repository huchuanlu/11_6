function [ bagConfidence bagLabel bagIndex ] = calculateBagConfidence(instanceConfidence, instanceTarget, instanceLabel)
%% function bagConfidence = calculateBagConfidence(instanceConfidence, instanceTarget)
%%calculates confidence values of bags
%%Input��
%      instanceConfidence�� confidence values of instances
%          instanceTarget�� bag labels
%%Output��
%           bagConfidence:  confidence values of bags
%                bagIndex:  bag index

[ weakLearnerNum instanceNum ] = size(instanceConfidence);
instanceConfidence = ones(weakLearnerNum,instanceNum) - instanceConfidence;
[ bagIndex labelIndex ] = unique(instanceTarget);
bagLabel = instanceLabel(labelIndex);
bagNum = size(bagIndex,2);
bagConfidence = ones(weakLearnerNum,bagNum);
for i = 1:weakLearnerNum
    for j = 1:bagNum
        bagConfidence(i,j) = 1 - prod(instanceConfidence(i,find(instanceTarget==j)));
    end
end