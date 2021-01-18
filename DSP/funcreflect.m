%% Show function and its translation
g = @(x) (5-abs(x)).*(x>=0 & x<=5); %Triangular function
tau = -10:.1:10;
figure;
subplot(2,1,1);
plot(tau,g(tau))
hold on
plot(tau,g(tau-1))
plot(tau,g(tau-2))
legend({'g(\tau)','g(\tau-1)','g(\tau-2)'},'Interpreter','tex','FontSize',14);
grid on
xlabel('\tau','FontSize',14);
ylabel('g(\tau-t)','FontSize',14);

subplot(2,1,2);
hold on;
plot(tau,g(-tau))
plot(tau,g(1-tau));
plot(tau,g(2-tau));
legend({'g(-\tau)','g(1-\tau)','g(2-\tau)'},'Interpreter','tex','FontSize',14);
grid on
xlabel('\tau','FontSize',14);
ylabel('g(t-\tau)','FontSize',14);