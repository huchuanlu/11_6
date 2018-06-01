function [ indexMap binsIndex ] = rgbQuantification(image,bins,color)
%% function [ indexMap binsIndex ] = rgbQuantification(image,bins,color)
%%obtains RGB quantification map
%%Input£º
%      image£º      image matrix
%      bins£º       quantification bin number
%      color£º      if color==0£¬quantize gray image
%                   if color==1£¬quantize color image
%%Output£º       
%      indexMap£º   RGB quantification map
%      binsIndex£º  index range

sz = size(image);
indexMap = zeros(sz(1),sz(2));
if color == 0   
   for i = 1:sz(1)
       for j = 1:sz(2)
           indexMap(i,j) = floor(double(image(i,j))*bins/256) + 1;  
       end
   end
   binsIndex = [ 1: bins ];
end

if color == 1  
   for i = 1:sz(1)
       for j = 1:sz(2)
           rn = floor(double(image(i,j,1))*bins/256);           
           gn = floor(double(image(i,j,2))*bins/256);          
           bn = floor(double(image(i,j,3))*bins/256);           
           indexMap(i,j) = rn*bins*bins + gn*bins + bn + 1;   
       end
   end
   binsIndex = [ 1: bins*bins*bins ];
end