function [rx_equalized, h_channel, noise] = channel_rayleigh(tx_symbols, snr_dB, k, eq_type)
% CHANNEL_RAYLEIGH Simulates a Flat Rayleigh Fading Channel with AWGN & Equalization.
%
% Syntax:
%   [rx_equalized, h_channel, noise] = channel_rayleigh(tx_symbols, snr_dB, k, eq_type)
%
% Inputs:
%   tx_symbols - Transmitted complex baseband symbols
%   snr_dB     - Eb/No in dB
%   k          - Bits per symbol
%   eq_type    - 'ZF' (Zero Forcing) or 'MMSE' (Minimum Mean Squared Error, default)
%
% Theoretical Foundation:
%   r = h * s + n
%   h ~ CN(0, 1): h_I, h_Q ~ N(0, 0.5)
%   ZF Equalizer:   s_hat = r / h
%   MMSE Equalizer: s_hat = (conj(h) / (|h|^2 + 1/SNR)) * r
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 3 || isempty(k)
        k = 1;
    end
    if nargin < 4 || isempty(eq_type)
        eq_type = 'MMSE';
    end

    tx_symbols = tx_symbols(:);
    num_symbols = length(tx_symbols);

    % Rayleigh channel coefficients (quasi-static or block fading)
    % Coherence time assumed to span blocks or symbols
    h_I = randn(num_symbols, 1) / sqrt(2);
    h_Q = randn(num_symbols, 1) / sqrt(2);
    h_channel = complex(h_I, h_Q);

    % Calculate noise standard deviation for target Eb/No
    EbNo_lin = 10 ^ (snr_dB / 10);
    EsNo_lin = k * EbNo_lin;
    N0 = 1 / EsNo_lin;
    sigma = sqrt(N0 / 2);

    noise = complex(sigma * randn(num_symbols, 1), sigma * randn(num_symbols, 1));

    % Faded received signal
    rx_raw = h_channel .* tx_symbols + noise;

    % Coherent Receiver Equalization
    switch upper(eq_type)
        case 'ZF'
            % Zero-Forcing (inverts channel, may enhance noise on deep fades)
            rx_equalized = rx_raw ./ h_channel;
        case 'MMSE'
            % MMSE Equalizer: balances channel inversion with noise power
            snr_lin = EsNo_lin;
            w_mmse = conj(h_channel) ./ (abs(h_channel).^2 + (1 / snr_lin));
            rx_equalized = w_mmse .* rx_raw;
    end
end
