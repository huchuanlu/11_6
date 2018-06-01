function weakLearnerConfidence = calculateWeakLearnerConfidence_LOG(bagConfidence, bagLabel)
%% function weakLearnerConfidence = calculateWeakLearnerConfidence_LOG(bagConfidence, bagLabel)
%%calculates confidence values of weak classifiers 
%%Input��
%           bagConfidence�� confidence values of bags
%                bagLabel�� bag labels
%%Output��
%  weakLearnerConfidence :  confidence values of weak classifiers

[ weakLearnerNum bagNum ] = size(bagConfidence);
positiveNum = size(find(bagLabel==1),2);
negativeNum = size(find(bagLabel==-1),2);

weakLearnerConfidence = zeros(1,weakLearnerNum);
for i = 1:weakLearnerNum
    weakLearnerConfidence(i) = sum(log(bagConfidence(i,find(bagLabel==1))+eps))/positiveNum...
                               + sum(log(1-bagConfidence(i,find(bagLabel==-1))+eps))/negativeNum;
end