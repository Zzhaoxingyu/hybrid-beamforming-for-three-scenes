function rate = get_rate(V_equal, W_equal)
%get the rate (SE) for equivalent V and W
global Vn Ns H;
rate = log2(det(eye(Ns) + 1/Vn * pinv(W_equal) * H * V_equal * (V_equal') * H' *W_equal));

