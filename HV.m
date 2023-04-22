function [out,options] = HV(f0,f1, kappa,lambda, epsilon,options,init)
%%% HV function computes the HV distance between signed signals f0, f1
%   Inputs: f0, f1: signals to be matched
%           kappa: the scalar coefficient in front of |v|^2
%           lambda: the scalar coefficient in front of |v_x|^2
%           epsilon: the scalar coefficient in front of |v_xx|^2
%           options: hyper-parameters in optimization and initialization
%           init: initialization parameters
%   Outputs: out.d_HV: the square root of the minimum action functional 
%                      (i.e., the d_HV distance)
%            out.path: the optimal path (path.f, path.v, path.z),
%                      all 3 variables are nt-by-nx matrices where nt, nx
%                      are grid sizes in time and space, repsectively.

%% "options" is optional. Here are some explanations regarding entries:
%   nx: spatial grid size, determined by length(f0)
%   nt: time grid size, default to be round(2/3*nx)
%   niter: total number of iterations in optimization, default as 101
%   alpha: the initial damping parameter, default as 1 (no damping)
%   oneside_diff: default 0; if the signals are discontinuous, set 1
%   kmax: maximum number of peaks that are to be matched in prominenece 
%         matching based initialization; default 5
%   minmatchKProm: if use prominenece of -f0, -f1 for initialization; 
%                  default 0
%   search1: use line search dampling parameter for f-->v,z step; default 1
%   search2: use line search dampling parameter for v-->f,z step; default 1
%   linesearch_max: the maximum number of line search; default 10
%   show_alert: show alert that the algorithm is unstable; default 1
%   plot_trajectory: whether to plot the flow map based on the optimal
%                   velocity v; default 0; if plot, set 1.
%   plot_final_fvz: whether to plot the final optimizer, (f,v,z)
%                   default 0; if plot, set 1.

%%% "init" is optional, if not given, the program will search for one
%   init = 0: use zero-velocity initialization
%   init = k > 0: match the k largest prominence between f0 and f1
%   init = -k < 0: match the k largest prominence between -f0 and -f1

% Set Parameters
% "nargin" below represents the number of supplied inputs when using HV. 
% The minimum number of inputs is 5. That is, one must supply the first 
% 5 variables: f0,f1, kappa,lambda, and epsilon.

% If options is not given, we set it as an empty structure object
if nargin < 6, options = struct; end

% We set the output as an empty structure object
out = struct;

% If signals do not have equal size, perform interpolation
nx = length(f0);
if (length(f1)~= nx) 
    f1 = interp1(linspace(0,1,length(f1)), f1, linspace(0,1,nx));
end

% Set up all the parameters; if several options are not supplied by the 
% user, we set them by the default value determined in the algorithm

options = SetOptions(options,'nx',nx,'nt',round(2*nx/3),'alpha',1,...
          'niter',101,'kmax',5,'minmatchKProm',0,'oneside_diff',0,...
          'kappa',kappa,'lambda',lambda,'epsilon',epsilon,...
          'search1',1,'search2',1,'linesearch_max',10,'show_alert',1,...
          'plot_trajectory',1,'plot_final_fvz',1);
options.f0 = f0; options.f1 = f1;  initstructure = struct;

% Perform path initialization 
if (nargin < 7) % there is no given pre-selected initialization
    % the maximum of prominence we aim to match
    K = options.kmax; 
    % an indicator if we match the least prominence
    match_min = options.minmatchKProm; 
    % search zero-velocity & prominence-matching initializations
    total_search = (match_min+1)*K+1;
    all_action = zeros(1,total_search);
    path_all = cell(1,total_search);
    for k = 1:total_search
        if k == total_search % we use zero-velocity initialization
            fprintf('Zero-velocity initialization\n');
            
            path = initialPath(f0,f1,'linear',initstructure,options);
            
        elseif (k < K+1) % perform matching the prominence of f0, f1
            initstructure.k = k;
            fprintf('Initialization by matching k=%2d prominences of f_0,f_1 \n',...
                initstructure.k);
            path = initialPath(f0,f1, 'maxmatchKProm',initstructure,options);
            
        elseif (k > K+1) % perform matching the prominence of -f0, -f1
            initstructure.k = k - K;
            fprintf('Initialization by matching k=%2d prominences of -f_0,-f_1 \n',...
                initstructure.k);
            path = initialPath(f0,f1, 'minmatchKProm',initstructure,options);
        end
        % Run the algorithm
        [~,path_all{k},obj_all]=Fixed_Point_Solver(options,path);
        all_action(k) = obj_all(end);
    end

    %
    [~, indmini] = min(all_action);
    if indmini == total_search % we use zero-velocity initialization
       fprintf('The minimum action is achieved with zero-velocity initialization \n');
    elseif (indmini < K+1) % perform matching the prominence of f0, f1
       fprintf('The minimum action is achieved with initialization using k=%2d maximum prominence of f0, f1 \n', indmini);
    elseif (indmini > K+1) % perform matching the prominence of -f0, -f1
       fprintf('The minimum action is achieved with initialization using k=%2d maximum prominence of -f0, -f1 \n', indmini-K);
    end

    out.path = path_all{indmini};
    out.d_HV = sqrt(all_action(indmini));
    
else % there is pre-defined intialization
    if (init==0)
        fprintf('Zero-velocity initialization\n');
        path = initialPath(f0,f1,'linear',initstructure,options);
    elseif (init > 0)
        initstructure.k = init;
        fprintf('Initialization by matching k=%2d max prominences of f_0,f_1 \n',...
                initstructure.k);
        path = initialPath(f0,f1, 'maxmatchKProm',initstructure,options);
    else
        initstructure.k = -init;
        fprintf('Initialization by matching k=%2d max prominences of -f_0,-f_1 \n',...
                initstructure.k);
        path = initialPath(f0,f1, 'minmatchKProm',initstructure,options);
    end
    [options,out.path,obj_all]=Fixed_Point_Solver(options,path);
    out.d_HV = sqrt(obj_all(end));
end

fprintf('The HV distance between f0, f1 is %4e\n', out.d_HV);
            
end