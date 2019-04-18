function obj = MO_wbmethod(obj)

global  H  Vn W_mopt Nt  Nrf Nr Nk Ns ifVFD W_rand n;
t1 = clock;
j = 0;

w = zeros(Nk,1);
v = zeros(Nk,1);
%init
if (ifVFD)
    W_equal = W_mopt;
else
   W_equal = exp( 1i*unifrnd(0,2*pi,Nr,Ns,Nk) );
end
V_equal = zeros(Nt,Ns,Nk);
H_equal = zeros(Ns,Ns,Nk);
m_mse = zeros(Nk,1);
for i = 1:Nk
    w(i) = trace(W_equal(:,:,i)'*W_equal(:,:,i));
end
%random initialization
V_RF = exp( 1i*unifrnd(0,2*pi,Nt,Nrf));
W_RF = exp( 1i*unifrnd(0,2*pi,Nr,Nrf));
%iteration trigger, the normal initialization just for pass into functions

H1 = zeros(Nt,Ns,Nk);
H2 = zeros(Nr,Ns,Nk);
trigger = 1;
m_MSE_new = 100;

%limit the iterations number by i<10
while (trigger > 1e-5 && j<10)
    
    % precoding
    Vn1 = Vn * w;
    for i = 1: Nk
        H1(:,:,i) = H(:,:,i)'*W_equal(:,:,i);
    end
    [V_RF, V_U, iter] = mo_algorithm(V_RF, Vn1, H1);
    
    for i = 1:Nk
        V_equal(:,:,i) = V_RF * V_U(:,:,i);
        v(i) = trace(V_equal(:,:,i)'*V_equal(:,:,i));
        H2(:,:,i) = H(:,:,i)*V_equal(:,:,i);
    end
    
    %combining
    Vn2 = Vn * v;
    [W_RF, W_B] = mo_algorithm(W_RF, Vn2, H2);
    
    m_MSE_old = m_MSE_new;
    
    for k = 1:Nk
        W_equal(:,:,k) = W_RF * W_B(:,:,k);
        w(k) = trace(W_equal(:,:,k)'*W_equal(:,:,k));
        H_equal(:,:,k) = W_equal(:,:,k)'*H2(:,:,k);
        m_mse(k) = trace(H_equal(:,:,k) * H_equal(:,:,k)' - H_equal(:,:,k) - H_equal(:,:,k)')...
            + Vn * v(k) * w(k);
    end
    m_MSE_new = sum(m_mse)/Nk;
    trigger = m_MSE_old - m_MSE_new;
    j = j + 1;
    obj.modmse(j,n) = m_MSE_new + Ns;
end

for i = 1:Nk
    V_B(:,:,i)= V_U(:,:,i) /sqrt(v(i));
end
t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj.iter = obj.iter + iter;
obj = get_wbmetric(obj);
obj.outer  = obj.outer + j;



