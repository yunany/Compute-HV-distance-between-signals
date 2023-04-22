function [f0new,f1new] = smoothing(f0,f1,level)

% Smoothing is carried out by level  steps of an explicit scheme for heat
% equation on the interval with Neumann BC

n=length(f0);
Dx = circshift( eye(n), -1) - eye(n);
A=Dx'*Dx;
A(1,1)=1; A(n,n)=1; A(n,1)=0; A(1,n)=0;
B = eye(n) - A/32;
S = B^level;
f0new = f0*S;
f1new= f1*S;
end
