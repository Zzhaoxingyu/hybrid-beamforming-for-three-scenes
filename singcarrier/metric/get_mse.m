function mse = get_mse(V_equal,W_equal,H)

global Vn Ns
G = W_equal'*H*V_equal;
mse = norm((eye(Ns)-G),'fro')^2+Vn*norm(W_equal,'fro')^2;

 