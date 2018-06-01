
%% initialize tracking parameters
trackparam;		

%% load information of sequence
rand('state',0);  randn('state',0);
temp = importdata([dataPath 'datainfo.txt']);
LoopNum = temp(3);
frame = imread([dataPath '1.bmp']);
framegray = double(rgb2gray(frame))/256;

%% set other options
if ~exist('opt','var')        opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end                  
if ~isfield(opt,'numsample')  opt.numsample = 400;  end                    
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end    
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end                   
if ~isfield(opt,'maxbasis')   opt.maxbasis = 16;  end                       
if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end                      
if ~isfield(opt,'errfunc')    opt.errfunc = 'L2';  end                      
if ~isfield(opt,'ff')         opt.ff = 1.0;  end                            
if ~isfield(opt,'minopt')
    opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
end

%% extract the target template and set up IVT model                                                                                                                                          )
tmpl.mean = warpimg(framegray, param0, opt.tmplsize);    %mean
tmpl.basis = [];                                         %basis vector
tmpl.eigval = [];                                        %eigenvalue
tmpl.numsample = 0;                                      %sample number
tmpl.reseig = 0;                                         %rest eigenvalue

%% set sample parameters
param = [];
param.Flag = 0;                 %flag
param.est = param0;             %affine parameters 
param.wimg = tmpl.mean;         %target template
param.combinemaxidx = [];       %index of maximal combined confidence value 
param.positive = [];            %positive samples                      
param.negative = [];            %negative samples                       

%% draw initial track window   
drawopt = drawtrackresult([], 0, frame, tmpl, param);
drawopt.showcondens = 0;  drawopt.thcondens = 1/opt.numsample; 
if (isfield(opt,'dump') && opt.dump > 0)       
    imwrite(frame2im(getframe(gcf)),sprintf('dump/%s/%s.0000.bmp',title,title));
    save(sprintf('dump/opt.%s.mat',title),'opt');
end

%% ******************** track the sequence ******************* %%
duration = 0; 
co_param = [];
weaklearner = [];
weakLearnerIndex = [];
wimgs = [];
for f = 1:LoopNum
  
    f
    tic;
  
    frame = imread([dataPath int2str(f) '.bmp']);
    framegray = double(rgb2gray(frame))/256;
    
    %%parameters sample and obtain positives
    [tempwimgs,param] = estwarp_condens(framegray, tmpl, param, opt); 
 	param = addwings( tempwimgs, param );   
    
    %%randomly sample negatives
    locationCenter = [param.est(1,1),param.est(2,1)];
    targetWindowSize = [40,40];
    rows = temp(2); 
    cols = temp(1); 
    nSampleCenter =samplenegX(locationCenter,targetWindowSize,rows,cols);
    param.negative(1,:) = nSampleCenter(1,:);
    param.negative(2,:) = nSampleCenter(2,:);
    
    %%extract RGB and HOG features for positives and negatives
    sampleStrong = getsample( frame,param,opt );
    
    param.combineest = param.est;
    param.Flag = 0;
    
    %% ************************ CoMIL ************************* %%
    if f==1 
        %%initial training of RGB and HOG MIL       
        [weaklearner, weakLearnerIndex] = inittrain(sampleStrong);
    else
        if param.maxprob < 0.8
            %%apply RGB and HOG MIL
            Alltest = getallsample ( frame,param,opt);
            testMargin = calculateTestMargin( Alltest,weakLearnerIndex,weaklearner );
            [value,tempIndex] = sort(testMargin.testMargin,'descend');
            max5 = param.param(:,tempIndex(1:5));
            meancenter = mean(max5(1:2,:),2);
            allcenter = param.param(1:2,:);
            distance=[];
            for col=1:opt.numsample
                distance =[distance norm(meancenter-allcenter(:,col))];
            end
            param.combinemaxidx = find(distance==min(distance));
            param.Flag = 1;
            param = Updateaddwings(tempwimgs, param, testMargin);
        else
            %%update RGB and HOG MIL
            wimgs = [wimgs, param.wimg(:)]; 
            [weaklearner, weakLearnerIndex] = updateMIL(sampleStrong,weaklearner);
        end
    end
    co_param = [co_param;param.combineest'];

    %% ******************* update IVT template **************** %%
    if (size(wimgs,2) >= opt.batchsize)     
        if (isfield(param,'coef'))
            ncoef = size(param.coef,2);
            recon = repmat(tmpl.mean(:),[1,ncoef]) + tmpl.basis * param.coef;
            [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
                sklm(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);                               
            param.coef = tmpl.basis'*(recon - repmat(tmpl.mean(:),[1,ncoef]));
        else
            [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
                sklm(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);  
        end
        wimgs = [];    
        if (size(tmpl.basis,2) > opt.maxbasis)         
            tmpl.reseig = opt.ff * tmpl.reseig + sum(tmpl.eigval(opt.maxbasis+1:end));                                                   
            tmpl.basis  = tmpl.basis(:,1:opt.maxbasis);   
            tmpl.eigval = tmpl.eigval(1:opt.maxbasis);    
            if (isfield(param,'coef'))
                param.coef = param.coef(1:opt.maxbasis,:);  
            end
        end
    end

    %% draw track window
    drawopt = drawtrackresult(drawopt, f, frame, tmpl, param); 
    if (isfield(opt,'dump') && opt.dump > 0)         
        imwrite(frame2im(getframe(gcf)),sprintf('dump/%s/%s.%04d.bmp',title,title,f));
    end
    
    toc;
    duration = duration + toc;
end

%% save results and compute time
save (sprintf('dump/%s.mat',title),'co_param');
fprintf('%d frames took %.3f seconds : %.3fps\n',f,duration,f/duration);