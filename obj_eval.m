function [obj] = obj_eval(V,Z,options)
% evaluate the action functional
dx = options.dx; dt = options.dt; nx = options.nx;
% build up the finite-difference stencils
Dx = spdiags([-ones(nx,1), ones(nx,1)],[0 1],nx,nx)/dx; 
Dx(end,end-1) = -1/dx; %because v_{end+1} = -v_{end-1} = 1/dx
DxV = V*Dx';% equiv to --> DxV = Dx*V'; DxV = DxV';

Dxx = spdiags(ones(nx,1)*[1, -2, 1] ,[-1 0 1],nx,nx)/dx^2; 
Dxx(1,:) = 0; Dxx(end,:) = 0; % V_xx = 0 on BC
DxxV = V*Dxx'; % equiv to --> DxxV = Dxx*V'; DxxV = DxxV';

obj=0.5*dx*dt*sum(options.epsilon*DxxV.^2 + ...
                  options.lambda*DxV.^2 + options.kappa*V.^2 + Z.^2,'all');
end
