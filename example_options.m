% a dedicated file to keep track of various options and configurations
% while running the numerical scheme

function [options,init] = example_options(C)
    options = struct; init = struct;
    options.niter = 100; % maximum number of iteration 
    options.alpha = 1; % initial damping guess
    % whether to use line search 
    options.search1 = 1;  % F --> V Z
    options.search2 = 1;  % V --> F Z
    options.linesearch_max = 10; % maximum number of line search
    options.s1 = 0; options.s2 = 0; % line search iteration numner
    options.oneside_diff = 0; % default is to use central difference on f
    
    switch C
        case {11,13}
            options.kappa=0.02;
            options.lambda=0.001;
            options.epsilon=0.002;
            options.nx = 301;
            options.nt = 291;
            init  = 1; 

        case {12,14}
            options.kappa=0.02;
            options.lambda=0.001;
            options.epsilon=0.002;
            options.nx = 301;
            options.nt = 291;
            init  = 0; 
            
        case 2
            options.kappa = 1e-3;
            options.lambda = 5e-5;
            options.epsilon = 2.5e-5;
            options.nx = 301;
            options.nt = 291;
            options.tol = 1/(options.nx-1)^2/(options.nt-1)^2; 
            init  = 2;
            
        case 3
            options.kappa=0.02;
            options.lambda=0.001;
            options.epsilon=0.002;
            options.nx = 301;
            options.nt = 291;
            options.oneside_diff = 1;
            init  = 1;

        case 4
            options.kappa=0.2;
            options.lambda=0.01;
            options.epsilon=0.02;
            options.nx = 301;
            options.nt = 291;
            init  = 1;

        case 5
            L = 0.3; W = 0.4; H = 0.4;
            options.kappa=0.01*H^2/L^2;
            options.lambda=0.02*H^2;
            options.epsilon=0.2*H^2*W^2;
            options.nx = 301;
            options.nt = 291;
            init= 1;

        case 6  
            H = 2; L = 0.1; W=0.02;
            options.kappa=0.01*H^2/L^2;
            options.lambda=0.02*H^2;
            options.epsilon=0.2*H^2*W^2;
            options.nx = 601;
            options.nt = 101;    
            init = -4;  
            
        case 7
            H=300; W=0.1; L=0.1; 
            options.kappa=0.01*H^2/L^2;
            options.lambda=0.02*H^2;
            options.epsilon=0.2*H^2*W^2;
            options.nx = 601;
            options.nt = 151;
            init = 2;
    end


end