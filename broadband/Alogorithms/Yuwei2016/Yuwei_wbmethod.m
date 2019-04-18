function obj  = Yuwei_wbmethod(obj)

global Nk H Ns Vn n;
t1 = clock;
V_RF = yuweiA1();
Q = (V_RF'*V_RF); 
T = Q^(-0.5);

for k = 1:Nk
    L = H(:,:,k)*V_RF*T;
    [~,D,V] = svd(L);
    [~,IX] = sort(diag(D),'descend');
    M = V(:,IX);
    U = M(:,1:Ns);
    V_D(:,:,k) = T*U;
    V_D(:,:,k) = V_D(:,:,k)/norm(V_RF*V_D(:,:,k),'fro');
end

W_RF  = yuweiA2(V_D,V_RF);

for k = 1:Nk
    J = W_RF'*H(:,:,k)*V_RF*V_D(:,:,k)*V_D(:,:,k)'*V_RF'*H(:,:,k)'*W_RF+Vn*W_RF'*W_RF;
    W_D(:,:,k) = J^(-1)*W_RF'*H(:,:,k)*V_RF*V_D(:,:,k);
end

t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_wbmetric(obj);
% if (obj.ber(n)>30)
%     save H 
%     pause
% end
   a= 1;
    