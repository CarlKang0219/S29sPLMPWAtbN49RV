% OFDM system
% No.of Carriers: 64
% coding used: Convolutional coding
% Single frame size: 96 bits
% Total no. of Frames: 100
% Modulation: 16-QAM
% No. of Pilots: 4
% Cylic Extension: 25%(16)

% close all
clear all
% clc


%% Generating Random Sequence of Data and Initiate Settings
indexFstBitCurFrame=1;
si=1; %for BER rows
max_nloop_main = 100; % number of experiments
SNRRange = 0:1:14;
nMultiplexSignal = 1;

config.isCoded = 1;
config.isInterleaved = 1;
config.nMultiplexSignal = nMultiplexSignal;

testSample = [0 1 0 1 0 1 0 1];
testSample2 = 1:100;
t_data = randi([0 1],19200,nMultiplexSignal)';

%% Assign codeRate
if config.isCoded
    config.codeRate = 2;
else
    config.codeRate = 1;
end

%% Main Loop : repeat # [max_nloop_main]
for d = 1:max_nloop_main
nBitInsert = 192 / config.codeRate;
data = t_data(:,indexFstBitCurFrame : indexFstBitCurFrame + nBitInsert - 1);
% data=testSample;
indexFstBitCurFrame = indexFstBitCurFrame + nBitInsert;

%% Convolutionally Encoding Data "DEPRECATED"
if config.isCoded
    constlen= 7;
    codegen = [171 133];    % Polynomial
    trellis = poly2trellis(constlen, codegen);
    codedata = convenc(data, trellis);
    config.trellis = trellis;
else
    codedata = data;
end

%% Interleaving Coded Data
nbitSymbol = 4;
nBitCodedData = size(codedata,2);
nSymbolFrame = nBitCodedData / nbitSymbol;
matrix = cell(nMultiplexSignal,1);
intlvddata = cell(nMultiplexSignal,1);
for i = 1:nMultiplexSignal
    matrix{i} = reshape(codedata(i,:), nSymbolFrame, nbitSymbol);
end

if config.isInterleaved % "DEPRECATED"
    intlvddata{1} = matintrlv(matrix{1}',2,2)'; % Interleave.
    intlvddata{1} = intlvddata{1}';
else
    for i = 1:nMultiplexSignal
        intlvddata{i} = matrix{i}';
    end
end

%% Binary to decimal conversion
dec = cell(nMultiplexSignal,1);
for i = 1:nMultiplexSignal
    dec{i} = bi2de(intlvddata{i}','left-msb');
end

%% 16-QAM Modulation
M = 2^nbitSymbol; % 16
symbols = cell(nMultiplexSignal, 1);
for i = 1:nMultiplexSignal
    symbols{i} = qammod(dec{i}, M, 0, 'gray');
end

%% Multiplex Signals 
alpha = 1;
% symbols = symbols{1}*(alpha^0.5) + symbols{2}*((1-alpha)^0.5);
symbols = symbols{1};

%% Pilot insertion
pilt = 3+3j;
nofpits = 4;

nSymbolFrame=length(symbols);
nSymbolPerPilot = 12;
config.nPilot = nSymbolFrame / nSymbolPerPilot;
sizeInput = 2^6;

pilt_data_tmp = zeros(1, 52);
pilt_data = zeros(1, sizeInput);
indexInsert = 1;
indexSymbols = 1;
for i = 1:config.nPilot
    pilt_data_tmp(indexInsert) = pilt;
    indexInsert = indexInsert + 1;
    pilt_data_tmp(indexInsert:indexInsert+nSymbolPerPilot-1)=symbols(indexSymbols:indexSymbols+nSymbolPerPilot-1);
    indexInsert = indexInsert + nSymbolPerPilot;
    indexSymbols = indexSymbols + nSymbolPerPilot;
end
pilt_data(1:6) = pilt_data_tmp(1:6);
pilt_data(7:7+52-1) = pilt_data_tmp(1:52);
pilt_data(7+52:64) = pilt_data_tmp(47:52);

%% IFFT
ifft_sig=ifft(pilt_data, sizeInput);

%% Adding Cyclic Extension
cext_data=zeros(80,1);
cext_data(1:16)=ifft_sig(49:64);
for i=1:64
    cext_data(i+16)=ifft_sig(i);
end


%% Channel SNR

indexSNR = 1;
for snr=SNRRange

%     ofdm_sig = cext_data;
    ofdm_sig = awgn(cext_data,snr,'measured'); % Adding white Gaussian Noise
    % figure;
    % index=1:80;
    % plot(index,cext_data,'b',index,ofdm_sig,'r'); %plot both signals
    % legend('Original Signal to be Transmitted','Signal with AWGN');

    rxed_data = cell(config.nMultiplexSignal, 1);
    for i = 1:config.nMultiplexSignal
        rcvd_data_tmp = sicReceiver(ofdm_sig, config, i);
        rxed_data{i} = rcvd_data_tmp(:)';
        c = xor(data(i,:),rxed_data{i});
        BER(si, indexSNR, i) = nnz(c) / length(data);
    end
    indexSNR = indexSNR + 1;

end % SNR loop ends here

si=si+1;
end % main data loop

ber = cell(config.nMultiplexSignal, 1);
for i = 1:config.nMultiplexSignal
    ber{i} = sum(BER(:,:,i)) / max_nloop_main;
end

% ber{1}
% ber{2}
% return

%% figure
i=SNRRange;
Eb_N0_dB = SNRRange;
QAM16_theory = (1/4)*3/2*erfc(sqrt(4*0.1*(10.^(Eb_N0_dB/10))));
semilogy(i,ber{1},'Color','r');
hold on
% semilogy(i,ber{2},'Color','b');
% hold on
semilogy(i,QAM16_theory,'Color','g');
title('BER vs SNR');
ylabel('BER');
xlabel('SNR (dB)');
grid on
hold on
