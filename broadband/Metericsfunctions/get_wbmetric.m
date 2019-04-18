function obj = get_wbmetric(obj)

%get_metric in WB case
%initialization
% the FD case
global Metric n Nk Nt Nr Ns;

V_equal = zeros(Nt,Ns,Nk);
W_equal = zeros(Nr,Ns,Nk);
if obj.V_RF == 0
    V_equal = obj.V_B;
    W_equal = obj.W_B;
    
else
    for k = 1:Nk
        V_equal(:,:,k) = obj.V_RF * obj.V_B(:,:,k);
        W_equal(:,:,k) = obj.W_RF * obj.W_B(:,:,k);
    end
end

if (Metric.rate)
    [obj.rate(n),obj.A(:,n)] = get_wbrate(V_equal, W_equal);  
end

if (Metric.mse)
    obj.mse(n) = get_wbmse(V_equal, W_equal);
end

if (Metric.ber)
    [obj.ber(n),obj.suberror(:,n)] = get_wbber(V_equal, W_equal);
end




if (Metric.qber)
    if (obj.V_RF ~= 0)
        for qbit = 1 : 5
            obj.qber(qbit,n) = get_wbqber(obj,qbit);
        end
    end
end



