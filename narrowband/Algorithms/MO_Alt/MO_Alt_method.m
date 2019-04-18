function obj = MO_Alt_method(obj)

global  V_ropt W_ropt Nt  Nrf Nr;
t1 = clock;
y = [];
V_RF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf) );
W_RF = exp( 1i*unifrnd(0,2*pi,Nr,Nrf) );
while(isempty(y) || abs(y(1)-y(2))>1e-3)
    V_B = pinv(V_RF) * V_ropt;
    y(1) = norm(V_ropt - V_RF * V_B,'fro')^2;
    [V_RF, y(2)] = sig_manif(V_ropt, V_RF, V_B);
end

V_B = V_B / norm(V_RF * V_B,'fro');
y =[];

while(isempty(y) || abs(y(1)-y(2))>1e-3)
    W_B = pinv(W_RF) * W_ropt;
    y(1) = norm(W_ropt - W_RF * W_B,'fro')^2;
    [W_RF, y(2)] = sig_manif(W_ropt, W_RF, W_B);
end

t2 = clock;
runtime = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);
