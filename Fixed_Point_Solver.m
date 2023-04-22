function [options,path,obj_all] = Fixed_Point_Solver(options,path)
% Inputs:
% path: initial path of F, V, Z
% options: all the hyper-parameters

% Outputs:
% options: all the updated hyper-parameters
% path: final path of F, V, Z
% obj_all: the convergence history of the objective function value

obj_all = zeros(options.niter+1,1);
obj_all(1) = obj_eval(path.v,path.z,options); %+ norm(F(end,:)-G.f1)^2;
options.min = obj_all(1);
%%
fprintf('%10s %15s %5s %5s \n','iteration #',...
          'objective function', 'line search #1','line search #2');
fprintf('%10d %15.5e \n',0, obj_all(1));

for jj = 1:options.niter
    if (~options.flag)
        [path,obj_all(jj+1),options] = update(path,options);
        fprintf('%10d %15.5e %10d %10d \n',jj,...
              obj_all(jj+1), options.s1, options.s2);
    else
        break
    end
end

obj_all = obj_all(1:jj);
end