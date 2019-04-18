function V_RF = newana_EVD( H )
global Nk Nr Vn Nt Ns Nrf
[N, ~,N_k] = size(H);
X = zeros(N,N,Nk);
for k = 1:N_k
    X(:,:,k) = (eye(N)+ 1/Vn/Nr/Nt/Ns*H(:,:,k)*H(:,:,k)')^(-1);
end
M =sum(X,3);
[V,D] = eig(M);
[~,IX] = sort(diag(D));
eig_Vector = V(:,IX);
V_RF = eig_Vector(:,1:Nrf);
V_RF = exp(1i*angle(V_RF));