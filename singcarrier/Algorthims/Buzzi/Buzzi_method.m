function obj = Buzzi_method(obj)
global H1 H Nk Vn Ns Nrf 
t1 = clock;
W_D = zeros(Nrf,Ns,Nk);
n = size(H1,3);
h = zeros(1,n);
for i = 1:n
    h(i) = norm(H1(:,:,i),'fro');
end
[~,index] = max(h);
H1 = H1(:,:,index);
[U,~,V] = svd(H1);
V_RF = V(:,1:Ns);
V_RF = V_RF/norm(V_RF,'fro');
W = U(:,1:Ns);
%W_RF = W_RF/norm(W_RF,'fro');
%[ V_RF1,W_RF1,mse1] = MSEopt( H, Vn ,Ns);
[V_RF,V_D,~] = BCDSD(V_RF,Nrf);
[W_RF,wd,~] = BCDSD(W,Nrf);
W = W_RF*wd;
for k = 1:Nk
    W_D(:,:,k) = (W'*H(:,:,k)*V_RF*V_D*(V_D')*V_RF'*H(:,:,k)'*W+Vn*(W')*W)^(-1)*W'*H(:,:,k)*V_RF*V_D;
end

t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj.V_RF = V_RF;
obj.W_RF = W;
obj = get_metric(obj);