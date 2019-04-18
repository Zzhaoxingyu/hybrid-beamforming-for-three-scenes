function obj = get_metric(obj)

global Metric Nk Nt Nr Ns n;

V_equal = zeros(Nt,Ns);
W_equal = zeros(Nr,Ns,Nk);

if obj.V_RF == 0
    V_equal = obj.V_B;
    W_equal = obj.W_B;
    
else
    for k = 1:Nk
        V_equal = obj.V_RF*obj.V_B;
        W_equal(:,:,k) = obj.W_RF*obj.W_B(:,:,k);
    end
end

if (Metric.rate)
    [obj.rate(n),obj.A(:,n)] = get_scrate(V_equal,W_equal);
end

if (Metric.mse)
    obj.mse(n)= get_scmse(V_equal,W_equal);
end

if (Metric.ber)
    [obj.ber(n),obj.suberror(:,n)] = get_scber(V_equal,W_equal);
end
    