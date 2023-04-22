function [X] = int_Vx(phi,x,Vx,dt)
% int_Vx computes  \int_0^t v_x (\Phi(x,s),s) ds
% input x = \Phi(x,0), the grid-based coordinate
%       phi, where phi(j,:)  = \Phi(x,t_j) for given x and t_j = j*dt
%       V_x: \partial_x v(x,t) 
%       dt: time spacing
% output: the integration at t_j = j*dt for at given x
    X = Vx*0;
    for j = 2:size(Vx,1) % forward Euler
        X(j,:) = X(j-1,:) + dt*interp1(x,Vx(j-1,:), phi(j-1,:),'linear','extrap');
    end
end