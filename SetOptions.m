function [options] = SetOptions(options,varargin)
% To set missing options from the user-defined hyperparameters
%%% Here are some explanations regarding remaining entries:
%   x: grid in x domain [0,1]
%   t: grid in t domain [0,1]
%   dt: grid spacing in x domain [0,1]
%   dx: grid spacing in t domain [0,1]
%   tol: the tolerance in the objective function to stop the iteration;
%        default value: dx*dt
%   s1: the counter for linear search in f -> v,z step
%   s2: the counter for linear search in v -> f,z step
%   flag: "0" means not converged while "1" means converged; default "0"

for i = 1:2:length(varargin)
    if ~isfield(options,varargin{i})
        options = setfield(options,varargin{i},varargin{i+1}); 
    end
end

% Set addtional parameters for optimization
options.flag = 0; % indicate no convergence

if options.search1, options.s1 = 0; end % line search in F -> VZ
if options.search2, options.s2 = 0; end % line search in V -> FZ

% set up grid for the finite-difference method
options.x = linspace(0,1,options.nx); 
options.t = linspace(0,1,options.nt); 
options.dx = options.x(2)-options.x(1);  
options.dt =  options.t(2)-options.t(1);

% error tolerance for stopping the iteration
options.tol = (options.dx*options.dt);  


end

