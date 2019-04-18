% mmwave_ general simluation world
% for different algorithms, parameters, channels and metrics
% this one is for SC(single carrier) case.

clear all;  close all; clc;
disp(datestr(now));


%% range of SNR£º
% set up simulation parameters;
%this .m is for BER,MSE,rate v.s. SNR
SNR_dB = -16;

%% numbers of antennas, streams, RF chains, sub_carriers , channel realizations
global Nt Nr Ns Nrf Nk N_loop;   
Nt = 64;
Nr = 64;

Ns = 2;
Nrf = 2;
Nk = 64;
N_loop=100;

%% set the metric you want to get, now only support rate,mse and ber.
global Metric;
Metric.rate = 1;
Metric.mse = 1;
Metric.ber = 1;


%% state noise power and channel as global variables to avoid parameters passing
global Vn H H1 n;

%% Algorithms, 'Buzzi','FD','Li_17EVD','scMO'
Algorithms = {'Buzzi','FD','Li_17EVD'};

%% simulation results cell
total_datas = cell(length(SNR_dB),length(Algorithms));

for i = 1 : length(Algorithms)
    eval([Algorithms{i},'=Init_struct(Algorithms{i});']);
end

%% global initialization (optimal based on MMSE or rate)
global  V_mopt W_mopt V_ropt W_ropt ;
global manifold;
manifold = complexcirclefactory(Nt*Nrf);

fprintf('params: \n Nt = %d  Nr = %d  Ns = %d  N_loop = %d  Nrf = %d \n SNR: %d £º %d \n',...
    Nt,Nr,Ns,N_loop,Nrf,SNR_dB(1),SNR_dB(end));

%% Transforming the form of SNR from dB to multiple,P=1
for snr_index = 1 : length(SNR_dB)
    Vn = 1 / 10^(SNR_dB(snr_index)/10);   % Noise Power
    t1 = clock;
    for n = 1:N_loop
        % generate channel matrix, codebooks for OMP
        [H1 , H]  = Li_17(Nt,Nr);
        % run Algorithms
        for i = 1:length(Algorithms)
            eval([Algorithms{i},'=',Algorithms{i},'_method(',Algorithms{i},');']);
        end
        if (n==10)
            mytoc(t1);
        end
    end
    disp (['Now SNR = ', num2str(SNR_dB(snr_index))]);
    for i = 1:length(Algorithms)
        eval([Algorithms{i},'=Show(',Algorithms{i},');']);
        eval(['total_datas{snr_index,i}=',Algorithms{i},';']);
    end
    disp(datestr(now));
end

%% plot figures for different metrics
simulation_plot(total_datas,SNR_dB, Algorithms);

