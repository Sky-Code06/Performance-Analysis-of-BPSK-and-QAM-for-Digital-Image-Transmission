function [rx_symbols, noise, sigma] = awgn_channel(tx_symbols, snr_dB, k, mode)
% AWGN_CHANNEL Simulates an Additive White Gaussian Noise (AWGN) channel.
%
% Syntax:
%   [rx_symbols, noise, sigma] = awgn_channel(tx_symbols, snr_dB, k, mode)
%
% Inputs:
%   tx_symbols - Transmitted baseband symbols (normalized to unit average energy Es = 1)
%   snr_dB     - Signal-to-Noise Ratio value in dB
%   k          - Number of bits per symbol (1 for BPSK, 2 for 4-QAM, 4 for 16-QAM, etc.)
%   mode       - 'EbNo' (default: snr_dB represents Eb/No in dB)
%                'EsNo' (snr_dB represents Es/No in dB)
%
% Outputs:
%   rx_symbols - Received noisy symbols: r = s + n
%   noise      - The zero-mean complex Gaussian noise vector added
%   sigma      - Standard deviation of noise per dimension (real and imag)
%
% Theoretical Foundation:
%   Es = k * Eb
%   For Es = 1, Eb = 1/k.
%   If mode is 'EbNo':
%     Es/No (linear) = k * (Eb/No) = k * 10^(snr_dB / 10)
%     Total noise power N0 = Es / (Es/No) = 1 / (k * 10^(snr_dB / 10))
%     Noise variance per dimension (I and Q): sigma^2 = N0 / 2
%     sigma = 1 / sqrt(2 * k * 10^(snr_dB / 10))
%   If mode is 'EsNo':
%     sigma = 1 / sqrt(2 * 10^(snr_dB / 10))
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 3 || isempty(k)
        k = 1;
    end
    if nargin < 4 || isempty(mode)
        mode = 'EbNo';
    end

    tx_symbols = tx_symbols(:);
    num_symbols = length(tx_symbols);

    % Compute linear scale SNR and per-dimension noise standard deviation (sigma)
    if strcmpi(mode, 'EbNo')
        % Eb/No in dB
        EbNo_lin = 10 ^ (snr_dB / 10);
        EsNo_lin = k * EbNo_lin;
        N0 = 1 / EsNo_lin;
        sigma = sqrt(N0 / 2);
    elseif strcmpi(mode, 'EsNo') || strcmpi(mode, 'SNR')
        % Es/No in dB
        EsNo_lin = 10 ^ (snr_dB / 10);
        N0 = 1 / EsNo_lin;
        sigma = sqrt(N0 / 2);
    else
        error('awgn_channel:InvalidMode', 'Mode must be either ''EbNo'' or ''EsNo''.');
    end

    % Generate circularly symmetric complex Gaussian noise
    % w = w_I + j * w_Q, where w_I, w_Q ~ N(0, sigma^2)
    noise_I = sigma * randn(num_symbols, 1);
    noise_Q = sigma * randn(num_symbols, 1);
    noise = complex(noise_I, noise_Q);

    % Received signal
    rx_symbols = tx_symbols + noise;
end
