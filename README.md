For a new sequence, you will have to change the sequence title and adjust some options as described in "trackparam.m". Then you can run the main function "runtracker.m".
The file "runtracker.m" contains the following operators:
(1) Set up IVT model;
(2) Obtain train samples and train CoMIL classifier;
(3) Obtain test samples and apply CoMIL to locate target.
Following is a description of the other files:

File
Directions
estwarp_condens.m
Parameters sample and estimate the optimization
warpimg.m
Extract the target template
addwings.m
Obtain positives and negatives and add parameters
Updateaddwings.m
Update other parameters
hog.m
Obtain gradient map of magnitude and oriented gradient map
blockStatistic.m
Count block histogram
rgbQuantification.m
Obtain RGB quantification map
rgbHistBlock.m
Count sub-block histogram of RGB
getsample.m
Extract RGB and HOG features for positives and negatives
getallsample.m
Extract RGB and HOG features for all test samples
samplenegX.m
Random sample negatives
affparam2geom.m
Convert a 2x3 matrix to 6 affine parameters
affparam2mat.m
Convert 6 affine parameters to a 2x3 matrix
sklm.m
Incremental SVD algorithm
drawtrackresult.m
Draw track result
drawbox.m
Draw tracking box
inittrain.m
Initialize RGB and HOG MIL
calculateAllWeakLearnerMargin.m
Calculate confidence values of all weak classifiers
calculateBagConfidence.m
Calculate confidence values of bags
calculateTestMargin.m
Calculate confidence values of test samples
calculateWeakLearnerConfidence_LOG.m
Calculate confidence values of weak classifiers
selectStrongLearner.m
Select weak classifiers to form strong classifiers
updateMIL.m
Update RGB and HOG classifiers
updateAllWeakLearner.m
Update all the weak classifiers


dump
Result Folder: contains eight folders to save results
Data
Image Folder: contains eight sequences
