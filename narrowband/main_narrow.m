% mmwave_ general simluation world
% for different algorithms, parameters, channels and metrics
% this one is for narrow case.

clear all;  close all; clc;
disp(datestr(now));


%% range of SNR£º
% set up simulation parameters;
SNR_dB = -10:2:6;

%% numbers of antennas, streams, RF chains,  , channel realizations
global Nt Nr N_c N_ray Ns Nrf N_loop Nsym ;   
Nt = 64;
Nr = 16;
N_c = 5;
N_ray = 10;
Ns = 6;
Nrf = 6;
N_loop = 100;
Nsym = 64;

%% set the metric you want to get, now only support rate,mse and ber.
global Metric;
Metric.rate = 1;
Metric.mse = 1;
Metric.ber = 1;

%% state noise power and channel as global variables to avoid parameters passing
global Vn H Codebook_v Codebook_w n;

%% using QPSK modulation
global hMod hDemod;

hMod = comm.PSKModulator(4,'BitInput',true,'PhaseOffset',pi/4);
hDemod = comm.PSKDemodulator('ModulationOrder',4,'BitOutput',true,'PhaseOffset',pi/4);

%% Algorithms, 'MMSE','Mrate','GEVD','MO_Alt','OMP','SSP_OMP','MO','Yuwei'
Algorithms = {'MMSE','Mrate','SSP_OMP','Yuwei'};

%MMSE is the method of "Generalized linear precoder and decoder design for MIMO channels using the weighted mmse criterion"
%Mrate is the method of "Full-Digital based on max-rate"
%GEVD is the method of "Hybrid Beamforming for Millimeter Wave Systems Using the MMSE Criterion"
%MO is the method of "Hybrid Beamforming for Millimeter Wave Systems Using the MMSE Criterion"
%MO_Alt is the method of "Alternating Minimization Algorithms for Hybrid Precoding in Milliter Wave MIMO Systems"
%OMP is the method of "Hybrid MMSE precoding for mmWave multiuser MIMO systems"
%SSP_OMP is the method of "Spatially Sparse Precoding in Millimeter Wave MIMO Systems"
%Yuwei is the method of "Hybrid Digital and Analog Beamforming Design for Large-Scale Antenna Arrays"

%% simulation results cell
total_datas = cell(length(SNR_dB),length(Algorithms));

for i = 1 : length(Algorithms)
    eval([Algorithms{i},'=Init_struct(Algorithms{i});']);
end

%% global initialization (optimal based on MMSE or rate)
global  V_mopt W_mopt V_ropt W_ropt ;
global manifold;
manifold = complexcirclefactory(Nt*Nrf);

fprintf('params: \n Nt = %d  Nr = %d  Ns = %d  Nrf = %d  N_loop = %d  N_c = %d  N_ray = %d  Nsym = %d\n SNR: %d £º %d \n',...
    Nt,Nr,Ns,Nrf,N_loop,N_c,N_ray,Nsym,SNR_dB(1),SNR_dB(end));

%% Transforming the form of SNR from dB to multiple,P=1
for snr_index = 1 : length(SNR_dB)
    Vn = 1 / 10^(SNR_dB(snr_index)/10);   % Noise Power
    t1 = clock;
    for n = 1:N_loop
        % generate channel matrix, codebooks for OMP
        [H ,Codebook_v, Codebook_w]  = channel_generation(Nt,Nr);
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

