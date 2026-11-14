function fig = plot_constellations(rx_bpsk_all, rx_qam_all, snr_levels, max_pts)
% PLOT_CONSTELLATIONS Plots comparative I/Q constellation scatter diagrams.
%
% Syntax:
%   fig = plot_constellations(rx_bpsk_all, rx_qam_all, snr_levels, max_pts)
%
% Inputs:
%   rx_bpsk_all - Cell array of received BPSK complex symbols at each SNR
%   rx_qam_all  - Cell array of received 16-QAM complex symbols at each SNR
%   snr_levels  - Vector of SNR values (dB)
%   max_pts     - Maximum points to scatter per subplot for rendering speed (default 2500)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Aakash Nair (24BEC0080), Sanskriti Sarkar (24BEC0183), Glenn Monteiro (24BEC0474)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 4 || isempty(max_pts)
        max_pts = 2500;
    end

    num_snrs = length(snr_levels);
    fig = figure('Name', 'Constellation Scatter Analysis (BPSK vs 16-QAM)', ...
                 'Color', 'w', 'Position', [100, 100, 1200, 650]);

    % Ideal constellation reference points
    ideal_bpsk = [1, -1];
    ideal_qam_raw = [-3, -1, 1, 3];
    [qi, qq] = meshgrid(ideal_qam_raw, ideal_qam_raw);
    ideal_16qam = (qi(:) + 1j * qq(:)) / sqrt(10); % Unit average power

    for s_idx = 1:num_snrs
        snr_val = snr_levels(s_idx);

        % --- Row 1: BPSK Constellation ---
        subplot(2, num_snrs, s_idx);
        hold on; box on; grid on;
        r_b = rx_bpsk_all{s_idx};
        if length(r_b) > max_pts
            r_b = r_b(randperm(length(r_b), max_pts));
        end

        % Scatter noisy points
        scatter(real(r_b), imag(r_b), 10, [0.15 0.45 0.85], 'filled', 'MarkerFaceAlpha', 0.45);
        % Plot ideal points
        plot(real(ideal_bpsk), imag(ideal_bpsk), 'rp', 'MarkerSize', 11, 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
        % Decision boundary
        xline(0, 'r--', 'LineWidth', 1.2, 'Alpha', 0.8);
        yline(0, 'k:', 'LineWidth', 0.8, 'Alpha', 0.5);

        xlim([-2.5 2.5]); ylim([-2 2]);
        xlabel('In-Phase (I)', 'FontSize', 10, 'FontWeight', 'bold');
        ylabel('Quadrature (Q)', 'FontSize', 10, 'FontWeight', 'bold');
        title(sprintf('BPSK @ %d dB', snr_val), 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.1 0.2 0.5]);
        if s_idx == 1
            text(-2.3, 1.6, 'BPSK (1 bps/Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.95 1]);
        end

        % --- Row 2: 16-QAM Constellation ---
        subplot(2, num_snrs, num_snrs + s_idx);
        hold on; box on; grid on;
        r_q = rx_qam_all{s_idx};
        if length(r_q) > max_pts
            r_q = r_q(randperm(length(r_q), max_pts));
        end

        scatter(real(r_q), imag(r_q), 10, [0.85 0.35 0.15], 'filled', 'MarkerFaceAlpha', 0.45);
        plot(real(ideal_16qam), imag(ideal_16qam), 'kp', 'MarkerSize', 9, 'MarkerFaceColor', 'g', 'LineWidth', 1.2);

        % Decision boundary grid lines (at PAM thresholds: -2/sqrt(10), 0, +2/sqrt(10))
        th = [-2, 0, 2] / sqrt(10);
        for b = 1:length(th)
            xline(th(b), 'k--', 'LineWidth', 0.8, 'Alpha', 0.6);
            yline(th(b), 'k--', 'LineWidth', 0.8, 'Alpha', 0.6);
        end

        xlim([-1.8 1.8]); ylim([-1.8 1.8]);
        xlabel('In-Phase (I)', 'FontSize', 10, 'FontWeight', 'bold');
        ylabel('Quadrature (Q)', 'FontSize', 10, 'FontWeight', 'bold');
        title(sprintf('16-QAM @ %d dB', snr_val), 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.6 0.2 0.1]);
        if s_idx == 1
            text(-1.65, 1.5, '16-QAM (4 bps/Hz)', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [1 0.95 0.9]);
        end
    end

    sgtitle('Comparative Signal Constellation Scattering: BPSK vs 16-QAM under AWGN Noise', ...
            'FontSize', 13, 'FontWeight', 'bold');
end
