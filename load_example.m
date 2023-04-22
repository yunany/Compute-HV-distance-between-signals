function [f0,f1] = load_example(C,n)
% n: the number of points in the signal
% C: the example index

switch C
        
    case 11 % Nonuniqueness of minimizing geodesics, transport match
        space=0.15; wid = 0.04; factor=2; 
        f0 = factor./(1 + (((1:n) / n +  space -0.5)./wid).^4)+(1/factor)./(1 + (((1:n) / n - space-0.5)./wid).^4);
        f1 = (1/factor)./(1 + (((1:n) / n +  space -0.5)./wid).^4) +factor./(1 + (((1:n) / n - space-0.5)./wid).^4);
    case 12 % Nonuniqueness of minimizing geodesics, verticle match
        space=0.15; wid = 0.04; factor=1.3; 
        f0 = factor./(1 + (((1:n) / n +  space -0.5)./wid).^4)+(1/factor)./(1 + (((1:n) / n - space-0.5)./wid).^4);
        f1 = (1/factor)./(1 + (((1:n) / n +  space -0.5)./wid).^4) +factor./(1 + (((1:n) / n - space-0.5)./wid).^4);
    case {13,14} % Nonuniqueness of minimizing geodesics, transport & verticle match are the same
        space=0.15; wid = 0.04; factor=1.517; % this factor is critical for both paths to have same action
        f0 = factor./(1 + (((1:n) / n +  space -0.5)./wid).^4)+(1/factor)./(1 + (((1:n) / n - space-0.5)./wid).^4);
        f1 = (1/factor)./(1 + (((1:n) / n +  space -0.5)./wid).^4) +factor./(1 + (((1:n) / n - space-0.5)./wid).^4);

    case 2 %Bumps with high frequency perturbations
        space=0.18; wid = 0.1; factor=1.15;
        f0 = factor./(1 + (((1:n) / n +  space -0.48)./wid).^4)+ ...
            (1/factor)./(1 + (((1:n) / n - space-0.48)./wid).^4) + ...
            0.14*sin((1:n) / n * 37* pi -4 );
        space=0.28; wid = 0.07; factor=1.2;
        f1 = (1/factor)./(1 + (((1:n) / n +  space -0.5)./wid).^4) ...
                +factor./(1 + (((1:n) / n - space-0.5)./wid).^4) + ...
                0.11*sin((1:n) / n * 46* pi );
    case 3 %Signal with discontinuities
        % box and bump
        f0 = heaviside((1:n)/n-0.3).*heaviside(0.6-(1:n)/n);
        f1 = (sin(((1:n) / n  -0.2)*pi )).^8;
    
    case 4 %Growth and expansion
        % Wide bump and triangle
        f00 = zeros( 1, n );
        delx=1/n;
        x=0:delx:0.999999;
        f1 = 3*exp(-64*(x-0.5).^4);
        f0 = 2*(0.4-2*abs(x-0.5));
        f0=max(f00,f0);
    
    case 5 % Bump with small negative part (used for project image)
        space=0.12;
        f0 = (sin(((1:n) / n  +space )*pi )).^90+(sin(((1:n) / n  +space -0.05)*pi )).^170;
        f1 = 1*( sin(  ((1:n) / n - space)  * pi )).^6 -0.4*(sin(((1:n) / n  -space +0.35)*pi )).^70 ;
    
    case 6 % Seismin example
        load('seismic.mat','f0','f1');
    
    case 7 % ECG example
        load('ECG.mat','f0','f1');

end

end