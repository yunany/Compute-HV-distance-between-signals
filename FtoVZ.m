function [v,z] = FtoVZ(f,options)
% FtoVZ solves the convex sub-problem with f fixed
% input: f(x,t), the fixed function f
%       options, all the parameters
% output: v,z, the optimizers of the sub-problem

[nt,nx] = size(f); dx = options.dx; dt = options.dt;

% finite difference stencils
Dt = spdiags([-ones(nt,1), ones(nt,1)],[0 1],nt,nt)/dt;  %for Dt for f
Dxx = spdiags(ones(nx,1)*[1, -2, 1] ,[-1 0 1],nx,nx)/dx^2; 
Dxxxx = spdiags(ones(nx,1)*[1, -4,6, -4 1] ,-2:2,nx,nx)/dx^4;
% assemble the linear system
Diff_Matrix = options.epsilon*Dxxxx-options.lambda*Dxx + options.kappa*speye(nx);
% enforce zero Dirichlet BC for v
Diff_Matrix([1,nx],:) = 0; Diff_Matrix(1,1) = 1; Diff_Matrix(end,end) = 1; 
% v_xx = 0 on BC + v=0 on BC ---> v_{-1} = -v_1, v_{nx-1} = -v_{nx+1}
Diff_Matrix(2,2) = Diff_Matrix(2,2) - 1/dx^4;
Diff_Matrix(end-1,end-1) = Diff_Matrix(end-1,end-1) - 1/dx^4;


DtF = Dt*f; 
% the time derivative in DtF is not accurate at nt due to the forward 
% difference, we use the value at nt-1 instead
DtF(nt,:) = DtF(nt-1,:); 

if (options.oneside_diff)
    % forward difference (first-order)
    Dx = spdiags([-ones(nx,1), ones(nx,1)],[0 1],nx,nx)/dx;  
    DxF = Dx*f'; % for discontinuous signal
else
    %central difference (second-order, symmetric)
    Dx2 = spdiags([-ones(nx,1), ones(nx,1)],[-1 1],nx,nx)/dx/2; 
    DxF = Dx2*f'; 
end
DxF([1,nx],:) = 0; 
RHS2 = - DtF'.*DxF; % size nx by nt

A = kron(speye(nt),Diff_Matrix) + spdiags(DxF(:).^2,0,nx*nt,nx*nt);
v = A\RHS2(:);
v = reshape(v,nx,nt); v = v';

% % the above 3 lines are faster ways of solving for V
% for j = 1:nt
%     DxF = Dx*F(j,:)'; DxF([1,2,nx-1,nx]) = 0;
%     RHS  = - DtF(j,:)'.*DxF; RHS([1,2,nx-1,nx]) = 0;
%     V(j,:) = (Diff_Matrix + diag([0;0;DxF(3:nx-2).^2;0;0]) )\RHS;
% end

z = DtF + v.*DxF';

end