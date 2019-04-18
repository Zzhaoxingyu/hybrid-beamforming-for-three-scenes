function obj = JZMO_wbmethod(obj)

global V_ropt W_ropt Nk Nrf Ns n Vn H;
t1 = clock;
[V_RF, V_U] =  MO_AltMinWB(V_ropt);
[W_RF, W_B] =  MO_AltMinWB(W_ropt);
%W_B = W_B/20;
v = zeros(Nk,1);
V_B = zeros(Nrf,Ns,Nk);
for i = 1:Nk
    v(i) = trace(V_U(:,:,i)'*V_RF'*V_RF*V_U(:,:,i));
    V_B(:,:,i)= V_U(:,:,i) /sqrt(v(i));
end
for k = 1:Nk
    newH(:,:,k) = W_B(:,:,k)'*W_RF'*H(:,:,k)*V_RF*V_B(:,:,k);
    W_X(:,:,k) = inv(newH(:,:,k)*newH(:,:,k)' +  Vn * v(k) *W_B(:,:,k)'*(W_RF)'*W_RF*W_B(:,:,k))*newH(:,:,k);
    newnewH(:,:,k) = W_X(:,:,k)'*newH(:,:,k);
    W_B(:,:,k) = W_B(:,:,k) * W_X(:,:,k) ;
end
t2 = clock;
runtime  = etime(t2,t1);
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj.runtime = obj.runtime + runtime;
obj = get_wbmetric(obj);
% if (obj.ber(n)>30)
%     save H 
%     pause
% end
a = 1;

