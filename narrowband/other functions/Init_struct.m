function obj = Init_struct(name)
%just a zero initialization
global N_loop;
obj.Name = name;
obj.V_B = 0;
obj.W_B = 0;
obj.V_RF = 0;
obj.W_RF = 0;
obj.rate = zeros(N_loop,1);
obj.mse = zeros(N_loop,1);
obj.ber = zeros(N_loop,1);
obj.Rate = 0;
obj.Mse = 0;
obj.Ber = 0;
obj.iter = 0;
obj.qber = 0;
obj.runtime = 0;
obj.outer = 0;
obj.modmse = 0;