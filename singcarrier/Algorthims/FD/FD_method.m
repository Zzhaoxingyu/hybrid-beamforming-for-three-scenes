function obj=FD_method(obj)

global Ns H1 H Nr Vn Nk
t1 = clock;
W_D = zeros(Nr,Ns,Nk);
h = zeros(1,Nk);
for i = 1:Nk
    h(i) = norm(H1(:,:,i),'fro');
end
[~,index] = max(h);
H1 = H1(:,:,index);
[U,~,V] = svd(H1);
V_D = V(:,1:Ns);
V_D = V_D/norm(V_D,'fro');
W_RF = U(:,1:Ns);
for k = 1:Nk
    W_D(:,:,k) = W_RF*(W_RF'*H(:,:,k)*V_D*(V_D')*H(:,:,k)'*W_RF+Vn*(W_RF')*W_RF)^(-1)*W_RF'*H(:,:,k)*V_D;
end

t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj = get_metric(obj);