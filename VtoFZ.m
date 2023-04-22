function [z,f] = VtoFZ(v,options)    
% VtoFZ Computes optimizer of the convex sub-problem when v is fixed
% Input: v(x,t), the fixed velocity
%        options, the set of all hyperparameters
% Output: the optimal z(x,t) and f(x,t) at grid points

z = v*0; f = v*0;  f0 = options.f0;
nx = options.nx; nt = options.nt; dx = options.dx; dt = options.dt; x = options.x;
Dx = spdiags([-ones(nx,1), ones(nx,1)],[0 1],nx,nx)/dx; 
% Due to v_{xx} = 0 & v=0 at x = 1, thus v(:,nx+1) = - v(:,nx-1) 
Dx(end,end-1) = -1/dx; 
% compute \partial_x v
Vx = Dx*v'; Vx = Vx'; 
% compute flow map Phi(x,t)
phi = flowmap(x,v,dt);

% compute \int_0^t v_x(Phi(x,s),s) ds
INT = int_Vx(phi,x,Vx,dt);
%%% figure(2);surf(X,T,INT); xlabel('x'); ylabel('t');

% evaluate f_1(Phi(x,t=1))
f1_at_phi = interp1(x,options.f1,phi(end,:),'linear','extrap');

% compute \int_0^tau e^( - \int_0^t v_x(Phi(x,s),s) ds ) dt
J  = exp(-INT); 
% ignore the last entry, equiv to left-hand side Riemanns sum
nu_sum = cumsum(J(1:end-1,:),1)*dt; nu_sum = [zeros(1,nx); nu_sum]; 

de = nu_sum(end,:); % approximate \int_0^1 exp(-INT) dt
eta = nu_sum./de; % the weights eta is of size nt by nx

z(1,:) = (f1_at_phi-f0).*J(1,:)./de;
f(1,:) = f0.*(1-eta(1,:)) + f1_at_phi.*eta(1,:);

for j = 2:nt
    % find unique points in phi
    [nphi,index] = unique(phi(j,:));
    % interpolate Z
    z(j,:) = interp1(nphi, ...          
(f1_at_phi(index)-f0(index)).*J(j,index)./de(index), x,'linear','extrap');
    % interpolate F
    f(j,:)= interp1(nphi,...
f0(index).*(1-eta(j,index)) + f1_at_phi(index).*eta(j,index),x,'linear','extrap');
end

end