function [V_ropt, W_ropt] = Mrate_method(k)
% traditional SVD algorithm for rate maximization

global Ns H ;
[U,~,V] = svd(H(:,:,k));
V_ropt = V(:,1:Ns);
%power constraint
V_ropt = V_ropt / norm(V_ropt,'fro');
W_ropt = U(:,1:Ns);
