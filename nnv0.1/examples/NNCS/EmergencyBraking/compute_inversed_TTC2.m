load reachSet2.mat;
n = length(S); % number of stars in the reachable set

B = [];
for i=1:n
    B = [B S(i).getBox]; % get box bounds the star set
end

% Estimate minimum value of the function g = v^2 + 2ad
g_min =  zeros(n,1);
g_max = zeros(n,1);

for i=1:n
    
    fun_min = @(x)x(2)^2 + 2*x(1)*x(3);
    fun_max = @(x)-x(2)^2 - 2*x(1)*x(3);
    lb = B(i).lb;
    ub = B(i).ub;
    x0 = lb;   
    [~,fval] = fmincon(fun_min,x0,[],[],[],[],lb,ub);
    g_min(i) = fval;
    [~,fval] = fmincon(fun_max,x0,[],[],[],[],lb,ub);
    g_max(i) = -fval;
end

% compute TTC^-1
inv_TTC_min = zeros(n,1);
inv_TTC_max = zeros(n,1);

for i=1:n
    
    if g_max(i) < 0
        
        inv_TTC_min(i) = 0;
        inv_TTC_max(i) = 0;
        
    elseif g_min(i) > 0
        
        fun_min = @(x)(-x(3)/(x(2) - sqrt(x(2)^2 + 2*x(1)*x(3))));
        fun_max = @(x)(x(3)/(x(2) - sqrt(x(2)^2 + 2*x(1)*x(3))));
        lb = B(i).lb;
        ub = B(i).ub;
        x0 = lb;   
        [~,fval] = fmincon(fun_min,x0,[],[],[],[],lb,ub);
        inv_TTC_min(i) = fval;
        [~,fval] = fmincon(fun_max,x0,[],[],[],[],lb,ub);
        inv_TTC_max(i) = -fval;

    elseif g_min(i) < 0 && g_max(i) > 0
        
        nonlcon = @feasiblecon;
        fun_max = @(x)(x(3)/(x(2) - sqrt(x(2)^2 + 2*x(1)*x(3))));
        lb = B(i).lb;
        ub = B(i).ub;
        x0 = lb;
        j = 0;
        while (j < 1000)
            for k=1:3
                    x0(k) = (ub(k) - lb(k)).*rand(1, 1) + lb(k);
            end
            x1 = fun_max(x0);
            if isreal(x1)
                break;
            end
        end
        [~,fval] = fmincon(fun_max,x0,[],[],[],[],lb,ub,nonlcon);
        inv_TTC_max(i) = -fval;
        inv_TTC_min(i) = 0;       
        
    end
    
end


% plot TTC^-1 reachable set
inv_TTC_acc = [];
inv_TTC_v = [];
for i=1:n
    lb = [inv_TTC_min(i); B(i).lb(3)];
    ub = [inv_TTC_max(i); B(i).ub(3)];
    inv_TTC_acc = [inv_TTC_acc Star(lb, ub)];
    lb = [inv_TTC_min(i); B(i).lb(2)];
    ub = [inv_TTC_max(i); B(i).ub(2)];
    inv_TTC_v = [inv_TTC_v Star(lb, ub)];
end

N = length(S);
times = 1:1:N;

subplot(3,1,1);
Star.plotBoxes_2D_noFill(inv_TTC_acc, 1, 2, 'b');
xlabel('$$TTC^{-1}$$', 'interpreter', 'latex');
ylabel('acceleration');
title('$$TTC^{-1}$$ vs. Acceleration', 'interpreter', 'latex');

subplot(3,1,2);
Star.plotBoxes_2D_noFill(inv_TTC_v, 1, 2, 'b');
xlabel('$$TTC^{-1}$$', 'interpreter', 'latex');
ylabel('velocity');
title('$$TTC^{-1}$$ vs. velocity', 'interpreter', 'latex');

subplot(3,1,3);
Star.plotRanges_2D(inv_TTC_acc, 1, times, 'b');
xlabel('time steps');
ylabel('$$TTC^{-1}$$', 'interpreter', 'latex');
title('$$TTC^{-1}$$ over time', 'interpreter', 'latex');
%saveas(gcf, 'inv_TTC_reachSet.pdf');


function [c, ceq] = feasiblecon(x)
    c = -x(2)^2 - 2*x(1)*x(3);
    ceq = [];
end
