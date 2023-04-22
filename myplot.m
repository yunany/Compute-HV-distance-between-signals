function myplot(options,path,str)
% plot the resulting optimal path
close all

if (nargin < 3), str = pwd; end
x = linspace(0,1,options.nx); t = linspace(0,1,options.nt); 
[X,T] = meshgrid(x,t); 
F = path.f; V = path.v; Z = path.z; 
%%
phi = flowmap(options.x,V,options.dt);
figure(1);set(gcf,'Position',[100 100 800 200]); 
hold off
h = floor(options.nx/50);
for i = 1:50
    plot(phi(:,h*i),options.t,'k','LineWidth',2); hold on;
end
xlim([0,1])
xlabel('x','Interpreter','latex'); 
ylabel('t','Interpreter','latex'); 
set(gca,'fontsize',18,'TickLabelInterpreter','latex')
set(gcf, 'Name', 'flow map for v(x,t)')
saveas(gcf,strcat(str,'/trajectories.png'))

%%
nt = options.nt;
figure(2);set(gcf,'Position',[100 100 800 400]);
hold on;
% plot(x,squeeze(Fall(ceil((nt+1)/8),:,iter)),'-.','LineWidth',2, 'Color',[0,0.5,0.8]);
plot(x,options.f0,'-','LineWidth',3, 'Color',[0,0.5,0.8]); 
plot(x,options.f1,'-','LineWidth',3, 'Color',[0.9,0.4,0]);
plot(x,squeeze(F(ceil((nt+1)/4),:)),':','LineWidth',2,'Color',[0.3,0.3,0.6]); 
plot(x,squeeze(F(ceil((nt+1)/2),:)),'-','LineWidth',2,'Color',[0.5,0.3,0.5]); 
plot(x,squeeze(F(ceil((nt+1)/4*3),:)),':','LineWidth',2,'Color',[0.75,0.4,0.25]); 

xlabel('$x$','Interpreter','latex'); 
ylabel('signal value','Interpreter','latex');
legend('$f_0$', '$f_1$','$f(\cdot,t=1/4)$','$f(\cdot,t=1/2)$',...
    '$f(\cdot,t=3/4)$','Location','best','Interpreter','latex')

% legend('$f_0$', '$f_1$', '$f(\cdot,t=1/8)$', '$f(\cdot,t=1/4)$','$f(\cdot,t=1/2)$','$f(\cdot,t=3/4)$','Location','best','Interpreter','latex')
set(gca,'fontsize',18,'TickLabelInterpreter','latex')
set(gcf, 'Name', 'geodesic')
saveas(gcf,strcat(str,'/slices-all.png'))


%% plot final z(x,t)
figure(4);set(gcf,'Position',[100 100 1200 250]);
mesh(X,T,Z); view([-1.2,40])
xlabel('$x$','Interpreter','latex');  ylabel('$t$','Interpreter','latex'); 
title('$z(x,t)$','Interpreter','latex'); 
set(gca,'fontsize',18,'TickLabelInterpreter','latex');set(gca,'ztick',[])
set(gcf, 'Name', 'z(x,t)')

%% plot final v(x,t)

figure(5);set(gcf,'Position',[100 100 1200 250]);
mesh(X,T,V); view([-1.2,40])
xlabel('$x$','Interpreter','latex');  ylabel('$t$','Interpreter','latex'); 
title('$v(x,t)$','Interpreter','latex'); 
set(gca,'fontsize',18,'TickLabelInterpreter','latex');set(gca,'ztick',[])
set(gcf, 'Name', 'v(x,t)')

%% plot final f(x,t)

figure(3);set(gcf,'Position',[100 100 1200 250]);
mesh(X,T,F); view([-1.2,40])
xlabel('$x$','Interpreter','latex');  ylabel('$t$','Interpreter','latex'); 
title('$f(x,t)$','Interpreter','latex'); 
set(gca,'fontsize',18,'TickLabelInterpreter','latex');set(gca,'ztick',[])
set(gcf, 'Name', 'f(x,t)')
end


