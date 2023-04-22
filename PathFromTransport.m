function path = PathFromTransport(tmap,f0,f1,options)
% ComputeVFFromTransport computes the current v,f for the given the map
% We get v(x,t) by turning T(x) - x from flow coordinate to grid coordinate
% We get f(x,t) by first displacement interpolation along the flow, and 
%       then interpolate back to the grid coordinate
% Input: tmap, the transpoprt map between f0 and f1 from initialization
%        f0, f1 signals
%        options, all the parameters
% Output: path.f, the initialized f
%         path.v, the initialized v
%         path.z, the initialized z

nx = options.nx;
nt = options.nt;
dt = options.dt;
dx = options.dx;
x = options.x;
% initialize as zeros
v = zeros(nt,nx); f = v;

% compute velocity on the flow map coordinate
v0 = tmap - x;
tmapcell = floor(tmap*(nx-1))+1;


% displacement interpolation for given v0:
for i=1:nt
  x_flow = x + (i-1)*dt*v0; % compute the flow map
  f_flow =  (1 - (i-1)*dt )*f0 + (i-1)*dt*f1(tmapcell); 
  v(i,:) = interp1(x_flow, v0, x, 'linear');
  f(i,:) = interp1(x_flow, f_flow, x,'linear');
end

% direct computation of z given f and v,  
%             where z = \partial_t f + v* \partial_x f
Dx = spdiags([-ones(nx,1), ones(nx,1)],[0 1],nx,nx)/dx;  %for Dx for f
Dt = spdiags([-ones(nt,1), ones(nt,1)],[0 1],nt,nt)/dt;  %for Dt for f
z = Dt*f + v.*(Dx*f')'; 
z(end,:) = 0; % z(x,t=1) will not be used

path.z = z; path.v = v; path.f = f; 

end

