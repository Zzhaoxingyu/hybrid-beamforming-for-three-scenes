function obj = Li_17EVD_method(obj)

global Nt Nr Ns Nrf Nk H Vn;
t1 = clock;
V_RF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf));
n = 1;
iter = 10; %iterations
H1 = zeros(Nt,Nrf,Nk);
H2 = zeros(Nr,Nrf,Nk);
W_D = zeros(Nrf,Ns,Nk);
while( n <=iter )
    for k = 1:Nk
        H2(:,:,k) = H(:,:,k)*V_RF;
    end
    W_RF = newana_EVD(H2);
    for k = 1:Nk
        H1(:,:,k) = H(:,:,k)'*W_RF;
    end
    V_RF = newana_EVD( H1 );
    n = n+1;
end

V_U = EVD(V_RF,W_RF);
V_D = sqrt(1/Nt/Ns)*V_U;

for k = 1:Nk
    B = W_RF'*H(:,:,k)*V_RF*V_D;
    W_D(:,:,k) = (B*B'+Vn*(W_RF')*W_RF)^(-1)*B;
end

t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj.iter = obj.iter + iter;
obj = get_metric(obj);
