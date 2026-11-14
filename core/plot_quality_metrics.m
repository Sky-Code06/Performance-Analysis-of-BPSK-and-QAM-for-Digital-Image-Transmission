function fig = plot_quality_metrics(snr_range, psnr_bpsk, psnr_qam, ssim_bpsk, ssim_qam)
% PLOT_QUALITY_METRICS Plots PSNR and SSIM curves vs. SNR for BPSK and 16-QAM.
%
% Syntax:
%   fig = plot_quality_metrics(snr_range, psnr_bpsk, psnr_qam, ssim_bpsk, ssim_qam)
%
% Visualizes:
%   Subplot 1: Peak Signal-to-Noise Ratio (PSNR in dB) vs SNR
%   Subplot 2: Structural Similarity Index (SSIM) vs SNR
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    fig = figure('Name', 'Perceptual Image Quality Metrics (PSNR & SSIM vs SNR)', ...
                 'Color', 'w', 'Position', [180, 180, 1050, 480]);

    % Replace Inf values (zero error) with a cap for clean plotting
    clean_psnr_bpsk = psnr_bpsk;
    clean_psnr_qam = psnr_qam;
    max_cap = 60; % dB
    clean_psnr_bpsk(isinf(clean_psnr_bpsk) | clean_psnr_bpsk > max_cap) = max_cap;
    clean_psnr_qam(isinf(clean_psnr_qam) | clean_psnr_qam > max_cap) = max_cap;

    % --- Subplot 1: PSNR vs SNR ---
    subplot(1, 2, 1);
    hold on; box on; grid on;
    plot(snr_range, clean_psnr_bpsk, 'b-o', 'LineWidth', 2.0, 'MarkerFaceColor', 'b', ...
         'DisplayName', 'BPSK Image PSNR');
    plot(snr_range, clean_psnr_qam, 'r-s', 'LineWidth', 2.0, 'MarkerFaceColor', 'r', ...
         'DisplayName', '16-QAM Image PSNR');

    % Quality threshold references
    yline(30, 'k--', 'Acceptable Quality (30 dB)', 'LineWidth', 1.0, 'LabelHorizontalAlignment', 'left');
    yline(40, 'g--', 'Excellent Quality (40 dB)', 'LineWidth', 1.0, 'LabelHorizontalAlignment', 'left');

    xlabel('E_b / N_0 (dB)', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel('PSNR (dB)', 'FontSize', 11, 'FontWeight', 'bold');
    title('Peak Signal-to-Noise Ratio (PSNR)', 'FontSize', 12, 'FontWeight', 'bold');
    legend('Location', 'southeast', 'FontSize', 10);
    ylim([5, 65]);

    % --- Subplot 2: SSIM vs SNR ---
    subplot(1, 2, 2);
    hold on; box on; grid on;
    plot(snr_range, ssim_bpsk, 'b-o', 'LineWidth', 2.0, 'MarkerFaceColor', 'b', ...
         'DisplayName', 'BPSK Image SSIM');
    plot(snr_range, ssim_qam, 'r-s', 'LineWidth', 2.0, 'MarkerFaceColor', 'r', ...
         'DisplayName', '16-QAM Image SSIM');

    yline(0.9, 'k--', 'Perceptual Transparency (> 0.90)', 'LineWidth', 1.0, 'LabelHorizontalAlignment', 'left');

    xlabel('E_b / N_0 (dB)', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel('Structural Similarity (SSIM)', 'FontSize', 11, 'FontWeight', 'bold');
    title('Structural Similarity Index (SSIM)', 'FontSize', 12, 'FontWeight', 'bold');
    legend('Location', 'southeast', 'FontSize', 10);
    ylim([0, 1.05]);

    sgtitle('Comparative Perceptual Image Quality Analysis: BPSK vs 16-QAM', ...
            'FontSize', 13, 'FontWeight', 'bold');
end
