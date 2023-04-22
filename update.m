function [path,obj_new,options] = update(path,options)
% update --- One fixed-point iteration of the algorithm
%
% Inputs:
% path: previous path of F, V, Z
% options: all the hyper-parameters

% Outputs:
% options: all the updated hyper-parameters
% path: new path of F, V, Z
% obj_new: the new objective function

obj_old = options.min;


%%%%%% First: F to VZ
V_old = path.v; Z_old = path.z;
[V,Z] = FtoVZ(path.f,options); % give a potential new V

% figure(2);surf(X,T,Vx); xlabel('x'); ylabel('t');


fct = @(alpha) obj_eval((1-alpha)*V_old + alpha*V,...
                        (1-alpha)*Z_old + alpha*Z, options);
alpha0 = options.alpha; % initial alpha guess
obj_new = fct(alpha0) ;
% disp('F2VZ:');disp(obj_new);

if options.search1
    iter = 0;
    while obj_new > options.min 
        alpha0 = alpha0*0.5;
        obj_new = fct(alpha0);
        iter = iter + 1;
        if (iter > options.linesearch_max)
            options.flag = 1; % converged
            alpha0 = 0; % take the old one
            obj_new = fct(alpha0);
            break
        end
    end
    options.s1 = iter;
end



if abs(obj_new - options.min) < options.tol
    options.flag = 1;
end


options.min = obj_new; 
V = (1-alpha0)*V_old + alpha0*V;
Z = (1-alpha0)*Z_old + alpha0*Z;

phi = flowmap(options.x,V,options.dt);

if (max(diff(phi(end,:)))> 5*options.dx)
    fprintf('The flow map interpolation may fail! \n');
    fprintf('Suggest increasing epsilon.\n')
    pause(0.1)
end

%%%%% Second: V to FZ %%%%%%%%%%%%%%%
F_old = path.f; Z_old = Z;
[Z,F] = VtoFZ(V,options); % give a potential new V

fct = @(alpha) obj_eval(V,(1-alpha)*Z_old + alpha*Z, options); 
alpha0 = options.alpha; % initial alpha guess
obj_new = fct(alpha0); 
% disp('V2FZ:');disp(obj_new);

if options.search2
    iter = 0;
    while obj_new > options.min
        alpha0 = alpha0*0.5;
        obj_new = fct(alpha0);
        iter = iter + 1;
        if (iter > options.linesearch_max)
            options.flag = 1; % converged
            alpha0 = 0; % take the old one
            obj_new = options.min;
            break
        end
    end
    options.s2 = iter;
end

if obj_new > obj_old - options.tol
    options.flag = 1;
end

options.min = obj_new; 

Z = (1-alpha0)*Z_old + alpha0*Z;
F = (1-alpha0)*F_old + alpha0*F;

if (options.show_alert)
    if(norm(F(end,:)-options.f1,inf) > ...
                    1e-1*max([abs(options.f0); abs(options.f1)]))
        fprintf('Unstable: f(x,t=1) does not match f1!\n');
        fprintf('Suggest changing parameters or initialization \n')
        pause
    end
end

figure(3);plot(options.x,F(end,:),options.x,options.f1,'LineWidth',3);
xlabel('$x$','Interpreter','latex'); 
ylabel('signal value','Interpreter','latex');
legend('$f(1,x)$', '$f_1(x)$','Interpreter','latex')
set(gca,'fontsize',18,'TickLabelInterpreter','latex')
set(gcf, 'Name', 'check if f(1,x) = f_1(x)'); pause(0.01)

%%
path.v = V; path.z = Z; path.f = F; 

end






