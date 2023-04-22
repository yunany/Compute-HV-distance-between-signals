function [X] = flowmap(x,v,dt)
% flowmap computes the flow map d Phi(x,t)/ dt = v(Phi(x,t), t)
% input: x: the grid-based coordinate in space
%        v: the velocity evaluated at grid-based coodinate
%        dt: time spacing
% output X = Phi(x,t) for fixed x input. It is an nt-by-nx matrix

    X = v*0;
    X(1,:) = x; 
    for j = 2:size(v,1) % forward Euler
        X(j,:) = X(j-1,:) + dt*interp1(x,v(j-1,:), X(j-1,:),'linear','extrap');
    end
end
