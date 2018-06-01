% script: trackparam.m
%     loads data and initializes variables
%
% Copyright (C) Jongwoo Lim and David Ross.
% All rights reserved.

% DESCRIPTION OF OPTIONS:
%
% Following is a description of the options you can adjust for
% tracking, each proceeded by its default value.

%*************************************************************
% For a new sequence , you will certainly have to change p.
% To set the other options,
% first try using the values given for one of the demonstration
% sequences, and change parameters as necessary.
%*************************************************************

% p = [px, py, sx, sy, theta] 
% The location of the target in the first frame.
% 
% px and py are the coordinates of the centre of the box.
% sx and sy are the size of the box in the x (width) and y (height)
% dimensions before rotation.
% theta is the rotation angle of the box.

% opt is a structure.
%
% 'numsample',400   The number of samples used in the condensation
% algorithm/particle filter. Increasing this will likely improve the
% results, but make the tracker slower.
%
% 'condenssig',0.01 The standard deviation of the observation likelihood.
%
% 'ff',1	The forgetting factor, as described in the paper.  When
% doing the incremental update, 1 means remember all past data, and 0
% means remeber none of it.
%
% 'batchsize',5	How often to update the eigenbasis.  We've used this
% value (update every 5th frame) fairly consistently, so it most
% likely won't need to be changed.  A smaller batchsize means more
% frequent updates, making it quicker to model changes in appearance,
% but also a little more prone to drift, and require more computation.
%
% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%   'affsig'    :
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = rotation angle (radians, mean is 0)
%    affsig(4) = x scaling (pixels, mean is 1)
%    affsig(5) = y scaling (pixels, mean is 1)
%    affsig(6) = scaling angle (radians, mean is 0)

% OTHER OPTIONS THAT COULD BE SET HERE:
%
% 'tmplsize', [32,32]   The resolution at which the tracking window is
% sampled, in this case 32 pixels by 32 pixels.  If your initial
% window (given by p) is very large you may need to increase this.
%
% 'maxbasis', 16    The number of basis vectors to keep in the learned
% apperance model.

%*************************************************************
% Change 'title' to choose the sequence you wish to run.  If you set
% title to 'dudek', for example, then it expects to find a file called 
% dudek.mat in the current directory.
%
% Setting dump_frames to true will cause all of the tracking results
% to be written out as .png images in the subdirectory ./dump/.  Make
% sure this directory has already been created.
%*************************************************************

%   title = 'guo2';
%   title = 'sail';
    title = 'woman_sequence';
% 	title = 'ShopAssistant2cor';
%   title = 'face_fang';
%   title = 'camera1_1';
%   title = 'face_sequence';
%   title = 'Occluded Face';

dump_frames = true;

switch (title)
    case 'guo2';         
        p = [172,111,58,64,0.02];
        opt = struct('numsample',300, 'condenssig',0.2, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.005,.004,.001,.002]);  
    case 'sail';         
        p = [149,82,54,60,0.02];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[8,8,.008,.004,.004,.001]); 
    case 'woman_sequence';         
        p = [222,150,25,60,0.00];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.004,.004,.001,.000]);            
    case 'ShopAssistant2cor';         
        p = [154,67,18,62,0.00];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.004,.000,.000,.000]);   
    case 'face_fang';         
        p = [148,148,40,40,0.00];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.008,.006,.006,.001]);             
    case 'camera1_1';         
        p = [17,216,14,38,0.00];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.004,.004,.001,.001]); 
    case 'face_sequence';         
        p = [175,166,75,88,0.02];
        opt = struct('numsample',300, 'condenssig',0.25, 'ff',1, ...
                'batchsize',5, 'affsig',[4,4,.004,.004,.001,.001]);
    case 'Occluded Face';  
        p = [156,113,80,90,0.00];
        opt = struct('numsample',600, 'condenssig',0.25, 'ff',1, ...
                 'batchsize',5, 'affsig',[8,8,.000,.000,.000,.000]);
    otherwise;  
        error(['unknown title' title]);
end

%%***************************Load Data*****************************%%
dataPath = ['Data\' title '_BMP\']; 
%%***************************Load Data*****************************%%

%%*********************** initial affine parameters *********************%%
param0 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0];   
param0 = affparam2mat(param0);
%%*********************** initial affine parameters *********************%%

opt.dump = dump_frames;
if (opt.dump & exist('dump') ~= 7)
  error('dump directory does not exist.. turning dump option off..');
  opt.dump = 0;
end