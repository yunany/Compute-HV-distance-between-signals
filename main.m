clear 
close all
% create a folder for this example
str = 'Test_Outputs'; mkdir(str);
diary (strcat(str,'/convergence_history.txt'))

%% This file gives an simple example of using the code
%  to compute the HV distance and the optimal path.

%% create an example
x= 0:2e-3:1; % set up grid for the x domain [0,1]
f0 = sin(5*x); f1 = sin(12*x+0.8);  % given signals f0, f1
%% set the parameters
%%% parameters kappa,lambda, epsilon in the action functional
%   these 3 parameters can be set based on Section 5.1 of the paper
kappa = 0.1; lambda = 0.02; epsilon = 0.01; % parameters in the HV distance

%% set the hyperparameters in the algorithm (see below for explanations)
%%% "options" is optional. Here are some explanations regarding entries:
% nx: spatial grid size, determined by length(f0)
% nt: time grid size, default to be round(2/3*nx)
% niter: total number of iterations in optimization, default as 101
% alpha: the initial damping parameter, default as 1 (no damping)

% oneside_diff: Ny default we use centered differences in f_x, which are 
%      2nd order, but that when discontinuities dominate, it is more stable
%      to use a lower order scheme. This option allows by setting it to 1.

% kmax: maximum number of peaks that are to be matched in prominenece 
%       matching based initialization; default 5
% minmatchKProm: if use prominenece of -f0, -f1 for initialization; 
%                default 0
% search1: use line search dampling parameter for f-->v,z step; default 1
% search2: use line search dampling parameter for v-->f,z step; default 1
% linesearch_max: the maximum number of line search; default 10
% show_alert: show alert that the algorithm is unstable; default 1
% plot_trajectory: whether to plot the flow map based on the optimal
%                  velocity v; default 1; if do not plot, set 0.
% plot_final_fvz: whether to plot the final optimizer, (f,v,z)
%                 default 1; if do not plot, set 0.

options = struct; % create an empty structure object
options.kmax = 2; % max # of prominenece to be matched in f0, f1
options.nt = 101; % define the time grid size
options.niter = 50; % define the maximum number of iterations
options.minmatchKProm = 1;
% Other hyperparameters, if not supplied, will be set by their default 
%       value in "HV.m" and "SetOptions.m".                   

%% set parameters for the initialization
% "init" in the HV function is optional, if not given, the program will 
% search for one; if given, it takes the following values:
% init = 0: use zero-velocity initialization
% init = k > 0: initializae by matching the k largest prominence 
%               between f0 and f1
% init = -k < 0: initializae by matching the k largest prominence 
%               between -f0 and -f1
% DO NOT SUPPLY "init" if one wants a search in k for the initialization

%% compute the distance based on the HV geometry
% Choose one of the two ways of calling HV:

% % For example, init is not given so that the program will search for one
[out,options] = HV(f0,f1, kappa,lambda, epsilon, options);

% For example, init is given and set as 1
% init = 1; [out,options] = HV(f0,f1,kappa,lambda, epsilon, options,init);

%% save and plot data
save(strcat(str,'/',str,'.mat'))
diary off
myplot(options,out.path,str)
