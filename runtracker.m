% script: runtracker.m
% requires:
%   data(h,w,nf)
%   param0
%   opt.tmplsize [h,w]
%      .numsample
%      .affsig [6,1]
%      .condenssig

%% Copyright (C) Jongwoo Lim and David Ross.
%% All rights reserved.
clear all; close all; clc;
trackparam;
   
frame = double(data(:,:,1))/256;
    
if ~exist('opt','var')  opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end
if ~isfield(opt,'numsample')  opt.numsample = 400;  end
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end

if ~isfield(opt,'maxbasis')   opt.maxbasis = 16;  end
%if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end

if ~isfield(opt,'ff')         opt.ff = 1.0;  end
if ~isfield(opt,'minopt')
    opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
end
    
tmpl.mean = warpimg(frame, param0, opt.tmplsize);
wimgs = reshape(tmpl.mean,[1024,1]); %y 1024*1
tmpl.basis = rand(1024,16); %U
tmpl.eigval = tmpl.basis' * wimgs ; %v 16*1
tmpl.VVT = tmpl.eigval * tmpl.eigval';
tmpl.YVT = wimgs * tmpl.eigval';


tmpl.numsample = 0;
tmpl.reseig = 0;
sz = size(tmpl.mean);  N = sz(1)*sz(2);

param = [];
param.est = param0;
param.wimg = tmpl.mean;




pts = [];     %without truepts


% draw initial track window
drawopt = drawtrackresult([], 0, frame, tmpl, param, pts);

disp('resize the window as necessary, then press any key..'); pause;
drawopt.showcondens = 0;  drawopt.thcondens = 1/opt.numsample;



% track the sequence from frame 2 onward
duration = 0; tic;
if (exist('dispstr','var'))  dispstr='';  end
for f = 1:size(data,3)
	frame = double(data(:,:,f))/256;
  
% do tracking
    %param = estwarp_grad(frame, tmpl, param, opt);
    %paticle filter;
	param = estwarp_condens(frame, tmpl, param, opt);

  % do update
    wimgs = reshape(param.wimg,[1024,1]); %1024*1
    [tmpl.basis, tmpl.eigval, tmpl.VVT, tmpl.YVT] = ...
           conmf(wimgs,tmpl.basis,tmpl.eigval,tmpl.VVT,tmpl.YVT);
    duration = duration + toc;
  
% draw result
    drawopt = drawtrackresult(drawopt, f, frame, tmpl, param, pts);
end 
  
    
    
    

