%% =========================================================================
% VELLORE INSTITUTE OF TECHNOLOGY | SCHOOL OF ELECTRONICS (SENSE)
% Digital Communication Systems (DCS) Review - I
%
% ADVANCED EXTENSIONS (Further Improvements Demonstration):
%   1. Forward Error Correction (FEC) with (7,4) Hamming Coding
%   2. Multipath Rayleigh Fading Channel with MMSE Equalization
%   3. Adaptive Modulation and Coding (AMC) Dynamic Switching
%
% Team Members:
%   Glenn Monteiro   (24BEC0474)
%   Sanskriti Sarkar (24BEC0183)
%   Aakash Nair      (24BEC0080)
% =========================================================================

clear; close all; clc;
addpath('core');

fprintf('====================================================================\n');
fprintf('  DCS Review - I : Advanced Extensions (Further Improvements)       \n');
fprintf('  1. FEC Channel Coding  | 2. Rayleigh Fading  | 3. Adaptive AMC   \n');
fprintf('====================================================================\n\n');

results_dir = 'results';
if ~exist(results_dir, 'dir'), mkdir(results_dir); end

% Load test image
img_orig = imread(fullfile('images', 'peppers_256.png'));
[tx_bits, meta] = image_to_bits(img_orig);

%% 1. FEC (7,4) Hamming Code vs Uncoded Transmission
fprintf('[1/3] Evaluating Forward Error Correction (Hamming 7,4 Code) under AWGN...\n');
snr_fec = 4; % dB (moderate noise region)
[rx_bits_fec, ber_fec, ber_uncoded] = fec_hamming(tx_bits, snr_fec, 'BPSK');
img_fec = bits_to_image(rx_bits_fec, meta);
m_fec = compute_metrics(img_orig, img_fec, tx_bits, rx_bits_fec, [], [], 1);

[s_b, ~] = modulate_bpsk(tx_bits);
[r_b, ~, ~] = awgn_channel(s_b, snr_fec, 1, 'EbNo');
rx_b_uncoded = demodulate_bpsk(r_b);
img_uncoded = bits_to_image(rx_b_uncoded, meta);
m_uncoded = compute_metrics(img_orig, img_uncoded, tx_bits, rx_b_uncoded, [], [], 1);

fprintf('      At Eb/No = %d dB:\n', snr_fec);
fprintf('      Uncoded BPSK : BER = %.4e | PSNR = %.2f dB\n', ber_uncoded, m_uncoded.PSNR);
fprintf('      Coded (7,4)  : BER = %.4e | PSNR = %.2f dB (Coding Gain demonstrated!)\n\n', ber_fec, m_fec.PSNR);

%% 2. Rayleigh Fading Channel Simulation
fprintf('[2/3] Simulating Rayleigh Multipath Fading with MMSE Equalization...\n');
snr_rayleigh = 14; % dB
[s_qam, k_qam, pad_q] = modulate_qam(tx_bits, 16);
[rx_rayleigh, h_ch, ~] = channel_rayleigh(s_qam, snr_rayleigh, k_qam, 'MMSE');
rx_bits_ray = demodulate_qam(rx_rayleigh, 16, pad_q);
img_rayleigh = bits_to_image(rx_bits_ray, meta);
m_ray = compute_metrics(img_orig, img_rayleigh, tx_bits, rx_bits_ray, [], [], k_qam);

% Pure AWGN comparison at 14 dB
[rx_awgn, ~, ~] = awgn_channel(s_qam, snr_rayleigh, k_qam, 'EbNo');
rx_bits_awgn = demodulate_qam(rx_awgn, 16, pad_q);
img_awgn = bits_to_image(rx_bits_awgn, meta);
m_awgn = compute_metrics(img_orig, img_awgn, tx_bits, rx_bits_awgn, [], [], k_qam);

fprintf('      At Eb/No = %d dB for 16-QAM:\n', snr_rayleigh);
fprintf('      AWGN Channel     : BER = %.4e | PSNR = %.2f dB\n', m_awgn.BER, m_awgn.PSNR);
fprintf('      Rayleigh Fading  : BER = %.4e | PSNR = %.2f dB (Multipath degradation evident)\n\n', m_ray.BER, m_ray.PSNR);

%% 3. Adaptive Modulation and Coding (AMC) Demonstration
fprintf('[3/3] Simulating Adaptive Modulation and Coding (AMC)...\n');
% AMC Decision rule:
% If SNR < 10 dB: Channel is noise-limited -> Switch to BPSK (robust, 1 bps/Hz)
% If SNR >= 10 dB: Channel is clear -> Switch to 16-QAM (high rate, 4 bps/Hz)
test_snrs = [4, 12]; % Low SNR vs High SNR
amc_imgs = cell(1, 2);
amc_modes = cell(1, 2);
amc_metrics = cell(1, 2);

for i = 1:2
    snr_curr = test_snrs(i);
    if snr_curr < 10
        amc_modes{i} = 'BPSK';
        [s_tx, k_m] = modulate_bpsk(tx_bits);
        [s_rx, ~, ~] = awgn_channel(s_tx, snr_curr, k_m, 'EbNo');
        r_b = demodulate_bpsk(s_rx);
    else
        amc_modes{i} = '16-QAM';
        [s_tx, k_m, p_m] = modulate_qam(tx_bits, 16);
        [s_rx, ~, ~] = awgn_channel(s_tx, snr_curr, k_m, 'EbNo');
        r_b = demodulate_qam(s_rx, 16, p_m);
    end
    amc_imgs{i} = bits_to_image(r_b, meta);
    amc_metrics{i} = compute_metrics(img_orig, amc_imgs{i}, tx_bits, r_b, [], [], k_m);
    fprintf('      AMC @ %2d dB: Selected Mode = %-6s | BER = %.2e | Spectral Eff = %d bps/Hz\n', ...
            snr_curr, amc_modes{i}, amc_metrics{i}.BER, k_m);
end
fprintf('\n');

%% 4. Plot & Save Extension Comparison Figure
fig = figure('Name', 'Further Improvements: FEC, Rayleigh Fading, and AMC', ...
             'Color', 'w', 'Position', [100, 100, 1200, 680]);

% Row 1: FEC Comparison
subplot(2, 3, 1);
imshow(img_orig);
title('Original Image', 'FontSize', 11, 'FontWeight', 'bold');

subplot(2, 3, 2);
imshow(img_uncoded);
title(sprintf('Uncoded BPSK @ %d dB\nBER: %.3e | PSNR: %.1f dB', snr_fec, m_uncoded.BER, m_uncoded.PSNR), ...
      'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.7 0.2 0.1]);

subplot(2, 3, 3);
imshow(img_fec);
title(sprintf('(7,4) Hamming Coded BPSK @ %d dB\nBER: %.3e | PSNR: %.1f dB [FEC GAIN]', snr_fec, m_fec.BER, m_fec.PSNR), ...
      'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.1 0.5 0.2]);

% Row 2: Rayleigh Fading vs AMC
subplot(2, 3, 4);
imshow(img_rayleigh);
title(sprintf('Rayleigh Fading (16-QAM @ %d dB)\nBER: %.3e | PSNR: %.1f dB', snr_rayleigh, m_ray.BER, m_ray.PSNR), ...
      'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.5 0.1 0.5]);

subplot(2, 3, 5);
imshow(amc_imgs{1});
title(sprintf('AMC @ %d dB (Switched: %s)\nBER: %.3e | Eff: %d bps/Hz', ...
      test_snrs(1), amc_modes{1}, amc_metrics{1}.BER, amc_metrics{1}.spectral_eff), ...
      'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.1 0.3 0.7]);

subplot(2, 3, 6);
imshow(amc_imgs{2});
title(sprintf('AMC @ %d dB (Switched: %s)\nBER: %.3e | Eff: %d bps/Hz', ...
      test_snrs(2), amc_modes{2}, amc_metrics{2}.BER, amc_metrics{2}.spectral_eff), ...
      'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.1 0.3 0.7]);

sgtitle('Further Improvements Prototype: FEC Channel Coding, Fading Channels & AMC', ...
        'FontSize', 13, 'FontWeight', 'bold');

saveas(fig, fullfile(results_dir, '6_further_improvements_extensions.png'));
fprintf('Saved figure: %s\n', fullfile(results_dir, '6_further_improvements_extensions.png'));
fprintf('Extensions simulation completed successfully!\n');
