function mse = get_mse(V_equal,W_equal,H)
%compute mse or wmse

global Vn  Ns;

H_equal = W_equal' * H * V_equal;
E_matrix = H_equal * H_equal' - H_equal - H_equal' + eye(Ns) + Vn * W_equal'*W_equal;

mse = trace(E_matrix);