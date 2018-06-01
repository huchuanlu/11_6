function [ hst sz ] = rgbHistBlock( indexMap, blockSize, Bins )
%%function [ hst sz ] = rgbHistBlock( indexMap, BlockSize, Bins )
%%counts sub-block histogram of RGB
%%Input£º
%       indexMap£º   RGB quantification map
%      BlockSize£º   block size
%           Bins:    quantification bin number
%%Output£º
%            hst£º   sub-block histogram of RGB
%             sz£º   RGB feature dimension

regionH = blockSize(1);                
regionW = blockSize(2);                 
indexMapH = size(indexMap,1);           
indexMapW = size(indexMap,2);         

numberH = floor(indexMapH/regionH);     
numberW = floor(indexMapW/regionW);     

hst = [];
X = zeros(regionH,regionW);
for m = 1:numberH   
    for n = 1:numberW
        a1 = 1+(m-1)*regionH;                      
        a2 = m*regionH;
        b1 = 1+(n-1)*regionW;                    
        b2 = n*regionW;
        X =  indexMap(a1:a2,b1:b2);
        temp = sum(hist(X,1:Bins)'); 
        hst = [ hst temp ] ;
    end
end

hst = hst';
sz = size(hst,1);