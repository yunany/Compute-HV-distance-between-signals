clear 
close all
%% This file reproduce examples in the paper

% Example number in the paper
% % 
% C = 11 corresponds to Example 5.1, Figure 2a
% C = 12 corresponds to Example 5.1, Figure 2b
% C = 13 corresponds to Example 5.1, Figure 2c
% C = 14 corresponds to Example 5.1, Figure 2d
% C = 2 corresponds to Example 5.2, Figure 3
% C = 3 corresponds to Example 5.3, Figure 4
% C = 4 corresponds to Example 5.4, Figure 5
% C = 5 corresponds to Example 5.5, Figure 6
% C = 6 corresponds to Example 5.6, Figure 7
% C = 7 corresponds to Example 5.7, Figure 8

%%% load examples
C = 7;
% create a folder for this example
str = strcat('Example_',num2str(C)); mkdir(str);
diary (strcat(str,'/convergence_history.txt'))

%%
%%%%% compute the HV distance and the optimal path
%%% parameters kappa,lambda, epsilon in the action functional
%   these 3 parameters can be set based on Section 5.1 of the paper

%%% "options" is optional. Here are some explanations regarding entries:
% nx: spatial grid size, determined by length(f0)
% nt: time grid size, default to be round(2/3*nx)
% niter: total number of iterations in optimization, default as 101
% alpha: the initial damping parameter, default as 1 (no damping)
% oneside_diff: default 0; if the signals are discontinuous, set 1
% kmax: maximum number of peaks that are to be matched in prominenece 
%       matching based initialization; default 5
% minmatchKProm: if use prominenece of -f0, -f1 for initialization; 
%                default 0
% search1: use line search dampling parameter for f-->v,z step; default 1
% search2: use line search dampling parameter for v-->f,z step; default 1
% linesearch_max: the maximum number of line search; default 10
% show_alert: show alert that the algorithm is unstable; default 1
%
%%% "init" is optional, if not given, the program will search for one
% init = 0: use zero-velocity initialization
% init = k > 0: match the k largest prominence between f0 and f1
% init = -k < 0: match the k largest prominence between -f0 and -f1

%%% read the pre-set options and initialization for this example
[options,init] = example_options(C); 

%%% load the signals in this example
[f0,f1] = load_example(C,options.nx); % read the test cases
kappa = options.kappa; lambda = options.lambda; epsilon = options.epsilon;

%%% compute the distance based on the HV geometry
[out,options] = HV(f0,f1, kappa,lambda, epsilon, options, init);

%%% save and plot data
save(strcat(str,'/',str,'.mat'))
diary off
%%
myplot(options,out.path,str)
