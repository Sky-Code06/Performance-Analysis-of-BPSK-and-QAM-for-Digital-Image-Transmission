function fig = plot_image_grid(orig_img, rx_imgs_bpsk, rx_imgs_qam, metrics_bpsk, metrics_qam, snr_levels)
% PLOT_IMAGE_GRID Generates a comparative visual matrix of received images.
%
% Syntax:
%   fig = plot_image_grid(orig_img, rx_imgs_bpsk, rx_imgs_qam, metrics_bpsk, metrics_qam, snr_levels)
%
% Displays:
%   - Original input image
%   - BPSK received images across selected SNR levels
%   - 16-QAM received images across the same SNR levels
%   - Annotations showing BER and PSNR for each case
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    num_snrs = length(snr_levels);
    total_cols = num_snrs + 1;

    fig = figure('Name', 'Visual Image Transmission Comparison (BPSK vs 16-QAM)', ...
                 'Color', 'w', 'Position', [80, 80, 1300, 680]);

    % Col 1: Original Image (spanning or top row)
    subplot(2, total_cols, 1);
    imshow(orig_img);
    title('Original Image', 'FontSize', 11, 'FontWeight', 'bold');
    xlabel(sprintf('%dx%d px', size(orig_img,1), size(orig_img,2)), 'FontSize', 9);

    subplot(2, total_cols, total_cols + 1);
    imshow(orig_img);
    title('Original Image (Ref)', 'FontSize', 11, 'FontWeight', 'bold');
    xlabel('Source Benchmark', 'FontSize', 9);

    % Columns 2 to total_cols: BPSK and 16-QAM at each SNR
    for i = 1:num_snrs
        snr_val = snr_levels(i);

        % --- Row 1: BPSK ---
        subplot(2, total_cols, i + 1);
        imshow(rx_imgs_bpsk{i});
        m_b = metrics_bpsk{i};
        title(sprintf('BPSK @ %d dB', snr_val), 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.1 0.2 0.6]);
        xlabel(sprintf('BER: %.1e\nPSNR: %.1f dB', m_b.BER, m_b.PSNR), 'FontSize', 9);

        % --- Row 2: 16-QAM ---
        subplot(2, total_cols, total_cols + i + 1);
        imshow(rx_imgs_qam{i});
        m_q = metrics_qam{i};
        title(sprintf('16-QAM @ %d dB', snr_val), 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0.7 0.2 0.1]);
        xlabel(sprintf('BER: %.1e\nPSNR: %.1f dB', m_q.BER, m_q.PSNR), 'FontSize', 9);
    end

    sgtitle('Comparative Digital Image Transmission: BPSK vs 16-QAM across AWGN Noise Levels', ...
            'FontSize', 13, 'FontWeight', 'bold');
end
