function fig = plot_error_map(orig_img, rx_bpsk, rx_qam, snr_eval)
% PLOT_ERROR_MAP Generates spatial pixel error maps comparing BPSK and 16-QAM.
%
% Syntax:
%   fig = plot_error_map(orig_img, rx_bpsk, rx_qam, snr_eval)
%
% Displays:
%   - Original benchmark image
%   - BPSK received image & absolute spatial pixel error heatmap
%   - 16-QAM received image & absolute spatial pixel error heatmap
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    fig = figure('Name', sprintf('Spatial Error Mapping @ %d dB SNR', snr_eval), ...
                 'Color', 'w', 'Position', [120, 120, 1100, 580]);

    orig_d = double(orig_img);
    rx_b_d = double(rx_bpsk);
    rx_q_d = double(rx_qam);

    if ndims(orig_d) == 3
        err_bpsk = mean(abs(orig_d - rx_b_d), 3);
        err_qam  = mean(abs(orig_d - rx_q_d), 3);
    else
        err_bpsk = abs(orig_d - rx_b_d);
        err_qam  = abs(orig_d - rx_q_d);
    end

    % 1. Original
    subplot(2, 3, 1);
    imshow(orig_img);
    title('Original Image', 'FontSize', 11, 'FontWeight', 'bold');

    % 2. BPSK Received
    subplot(2, 3, 2);
    imshow(rx_bpsk);
    title(sprintf('BPSK Received @ %d dB', snr_eval), 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.2 0.6]);

    % 3. BPSK Spatial Error Map
    subplot(2, 3, 3);
    imagesc(err_bpsk, [0, 255]);
    colormap(gca, 'hot'); colorbar; axis image off;
    title(sprintf('BPSK Pixel Error Map (|I_{orig} - I_{rec}|)\nMean Abs Error: %.2f', mean(err_bpsk(:))), ...
          'FontSize', 10, 'FontWeight', 'bold');

    % 4. Blank / Reference
    subplot(2, 3, 4);
    imshow(orig_img);
    title('Original Benchmark', 'FontSize', 11, 'FontWeight', 'bold');

    % 5. 16-QAM Received
    subplot(2, 3, 5);
    imshow(rx_qam);
    title(sprintf('16-QAM Received @ %d dB', snr_eval), 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.7 0.2 0.1]);

    % 6. 16-QAM Spatial Error Map
    subplot(2, 3, 6);
    imagesc(err_qam, [0, 255]);
    colormap(gca, 'hot'); colorbar; axis image off;
    title(sprintf('16-QAM Pixel Error Map (|I_{orig} - I_{rec}|)\nMean Abs Error: %.2f', mean(err_qam(:))), ...
          'FontSize', 10, 'FontWeight', 'bold');

    sgtitle(sprintf('Spatial Image Error Distribution: BPSK vs 16-QAM @ E_b/N_0 = %d dB', snr_eval), ...
            'FontSize', 13, 'FontWeight', 'bold');
end
