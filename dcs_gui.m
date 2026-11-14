function dcs_gui()
% DCS_GUI Interactive GUI for Digital Image Transmission Simulation
%
% Vellore Institute of Technology | School of Electronics (SENSE)
% Digital Communication Systems (DCS) Course Project
%
% Team Members:
%   Glenn Monteiro   (24BEC0474)
%   Sanskriti Sarkar (24BEC0183)
%   Aakash Nair      (24BEC0080)
%
% To launch:
%   >> dcs_gui

    addpath('core');

    % Create modern figure window
    fig = uifigure('Name', 'DCS BPSK & QAM Image Transmission Simulator', ...
                   'Position', [100, 80, 1200, 750], ...
                   'Color', [0.95, 0.96, 0.98]);

    % Global state storage
    state.current_img = imread(fullfile('images', 'peppers_256.png'));
    state.img_name = 'peppers_256.png';
    state.mod_scheme = '16-QAM';
    state.M = 16;
    state.snr_val = 6;

    %% Header Panel
    header_pnl = uipanel(fig, 'Position', [15, 675, 1170, 65], ...
                         'BackgroundColor', [0.12, 0.23, 0.45], 'BorderType', 'none');
    uilabel(header_pnl, 'Text', 'VELLORE INSTITUTE OF TECHNOLOGY | SCHOOL OF ELECTRONICS (SENSE)', ...
            'Position', [20, 36, 800, 22], 'FontSize', 12, 'FontColor', [0.85, 0.90, 1.0], 'FontWeight', 'bold');
    uilabel(header_pnl, 'Text', 'Performance Analysis of BPSK and QAM for Digital Image Transmission', ...
            'Position', [20, 10, 850, 24], 'FontSize', 14, 'FontColor', [1.0, 1.0, 1.0], 'FontWeight', 'bold');
    uilabel(header_pnl, 'Text', 'Team: Glenn (24BEC0474), Sanskriti (24BEC0183), Aakash (24BEC0080)', ...
            'Position', [720, 12, 430, 20], 'FontSize', 10, 'FontColor', [0.85, 0.92, 1.0], 'HorizontalAlignment', 'right');

    %% Left Control Panel
    ctrl_pnl = uipanel(fig, 'Title', 'TRANSMISSION CONTROLS', 'Position', [15, 20, 310, 645], ...
                       'FontSize', 11, 'FontWeight', 'bold', 'BackgroundColor', [1 1 1]);

    % Image Selection
    uilabel(ctrl_pnl, 'Text', '1. Source Image:', 'Position', [15, 580, 200, 22], 'FontWeight', 'bold');
    img_dropdown = uidropdown(ctrl_pnl, 'Position', [15, 552, 280, 28], ...
                              'Items', {'Peppers (Grayscale 256x256)', 'High-Contrast Test Pattern', 'Peppers (Color RGB 256x256)', 'Browse Custom Image...'}, ...
                              'Value', 'Peppers (Grayscale 256x256)');

    % Modulation Scheme Selection
    uilabel(ctrl_pnl, 'Text', '2. Modulation Scheme:', 'Position', [15, 510, 200, 22], 'FontWeight', 'bold');
    mod_dropdown = uidropdown(ctrl_pnl, 'Position', [15, 482, 280, 28], ...
                              'Items', {'BPSK (1 bit/sym - High Robustness)', ...
                                        '4-QAM / QPSK (2 bits/sym)', ...
                                        '16-QAM (4 bits/sym - Standard Test)', ...
                                        '64-QAM (6 bits/sym - Ultra Spectral Eff)'}, ...
                              'Value', '16-QAM (4 bits/sym - Standard Test)');

    % SNR Slider & Value Display
    uilabel(ctrl_pnl, 'Text', '3. Channel Eb/No (SNR):', 'Position', [15, 438, 200, 22], 'FontWeight', 'bold');
    snr_label = uilabel(ctrl_pnl, 'Text', '6 dB', 'Position', [220, 438, 75, 22], ...
                        'FontWeight', 'bold', 'FontSize', 13, 'FontColor', [0.1, 0.3, 0.8], 'HorizontalAlignment', 'right');
    snr_slider = uislider(ctrl_pnl, 'Position', [25, 415, 260, 3], ...
                          'Limits', [-2, 20], 'Value', 6, 'MajorTicks', -2:2:20);

    % Channel Model (AWGN)
    uilabel(ctrl_pnl, 'Text', '4. Channel Model: AWGN (Complex Baseband)', ...
            'Position', [15, 360, 280, 20], 'FontWeight', 'bold', 'FontColor', [0.3 0.3 0.3]);

    % Action Buttons
    run_btn = uibutton(ctrl_pnl, 'push', 'Text', 'TRANSMIT & RECONSTRUCT', ...
                       'Position', [15, 305, 280, 38], 'FontSize', 12, 'FontWeight', 'bold', ...
                       'BackgroundColor', [0.15, 0.55, 0.25], 'FontColor', 'w');

    compare_btn = uibutton(ctrl_pnl, 'push', 'Text', 'Run Full Benchmark (dcs.m)', ...
                           'Position', [15, 260, 280, 32], 'FontSize', 11, 'FontWeight', 'bold', ...
                           'BackgroundColor', [0.2, 0.4, 0.7], 'FontColor', 'w');

    % Metric Readout Panel
    metric_subpnl = uipanel(ctrl_pnl, 'Title', 'LIVE PERFORMANCE METRICS', 'Position', [10, 10, 290, 235], ...
                            'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.97, 0.98, 1.0]);

    lbl_ber   = uilabel(metric_subpnl, 'Text', 'Bit Error Rate (BER): -', 'Position', [10, 180, 270, 20], 'FontWeight', 'bold');
    lbl_errs  = uilabel(metric_subpnl, 'Text', 'Bit Flips: - / -', 'Position', [10, 155, 270, 20]);
    lbl_psnr  = uilabel(metric_subpnl, 'Text', 'PSNR: - dB', 'Position', [10, 130, 270, 20], 'FontWeight', 'bold');
    lbl_ssim  = uilabel(metric_subpnl, 'Text', 'SSIM: -', 'Position', [10, 105, 270, 20], 'FontWeight', 'bold');
    lbl_mse   = uilabel(metric_subpnl, 'Text', 'Pixel MSE: -', 'Position', [10, 80, 270, 20]);
    lbl_syms  = uilabel(metric_subpnl, 'Text', 'Symbols Transmitted: -', 'Position', [10, 55, 270, 20]);
    lbl_speed = uilabel(metric_subpnl, 'Text', 'Spectral Efficiency: - bps/Hz', 'Position', [10, 30, 270, 20]);
    lbl_time  = uilabel(metric_subpnl, 'Text', 'Processing Time: - ms', 'Position', [10, 5, 270, 20]);

    %% Right Display Grid (4 Quadrants)
    % Quadrant 1: Transmitted Image
    pnl_tx = uipanel(fig, 'Title', 'Transmitted Source Image', 'Position', [335, 355, 415, 310], ...
                     'FontWeight', 'bold', 'BackgroundColor', 'w');
    ax_tx = uiaxes(pnl_tx, 'Position', [10, 10, 395, 270]);
    imshow(state.current_img, 'Parent', ax_tx);
    axis(ax_tx, 'image', 'off');

    % Quadrant 2: Received Image
    pnl_rx = uipanel(fig, 'Title', 'Received Reconstructed Image', 'Position', [760, 355, 425, 310], ...
                     'FontWeight', 'bold', 'BackgroundColor', 'w');
    ax_rx = uiaxes(pnl_rx, 'Position', [10, 10, 405, 270]);
    imshow(state.current_img, 'Parent', ax_rx);
    axis(ax_rx, 'image', 'off');

    % Quadrant 3: Spatial Error Heatmap
    pnl_err = uipanel(fig, 'Title', 'Spatial Pixel Error Map (|I_{orig} - I_{rec}|)', 'Position', [335, 20, 415, 325], ...
                      'FontWeight', 'bold', 'BackgroundColor', 'w');
    ax_err = uiaxes(pnl_err, 'Position', [10, 10, 395, 285]);
    imagesc(zeros(size(state.current_img, 1), size(state.current_img, 2)), 'Parent', ax_err, [0 255]);
    colormap(ax_err, 'hot'); colorbar(ax_err);
    axis(ax_err, 'image', 'off');

    % Quadrant 4: Constellation Scatter Diagram
    pnl_const = uipanel(fig, 'Title', 'Live Received Constellation Diagram (I vs Q)', 'Position', [760, 20, 425, 325], ...
                        'FontWeight', 'bold', 'BackgroundColor', 'w');
    ax_const = uiaxes(pnl_const, 'Position', [40, 35, 370, 260]);
    grid(ax_const, 'on'); box(ax_const, 'on');
    xlabel(ax_const, 'In-Phase (I)'); ylabel(ax_const, 'Quadrature (Q)');

    %% Callback Bindings
    snr_slider.ValueChangedFcn = @(s, e) update_snr_label(e.Value);
    img_dropdown.ValueChangedFcn = @(s, e) change_image(e.Value);
    mod_dropdown.ValueChangedFcn = @(s, e) change_modulation(e.Value);
    run_btn.ButtonPushedFcn = @(s, e) execute_transmission();
    compare_btn.ButtonPushedFcn = @(s, e) run_full_benchmark();

    % Run initial simulation
    execute_transmission();

    %% Nested Helper Functions
    function update_snr_label(val)
        snr_label.Text = sprintf('%.1f dB', val);
        state.snr_val = val;
    end

    function change_image(val)
        if contains(val, 'Peppers (Grayscale')
            state.current_img = imread(fullfile('images', 'peppers_256.png'));
        elseif contains(val, 'High-Contrast')
            state.current_img = imread(fullfile('images', 'test_pattern.png'));
        elseif contains(val, 'Peppers (Color')
            state.current_img = imread(fullfile('images', 'peppers_rgb.png'));
        elseif contains(val, 'Browse')
            [file, path] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif', 'Image Files'});
            if isequal(file, 0)
                return;
            end
            state.current_img = imread(fullfile(path, file));
        end
        imshow(state.current_img, 'Parent', ax_tx);
        axis(ax_tx, 'image', 'off');
        execute_transmission();
    end

    function change_modulation(val)
        if contains(val, 'BPSK')
            state.mod_scheme = 'BPSK';
            state.M = 2;
        elseif contains(val, '4-QAM')
            state.mod_scheme = '4-QAM';
            state.M = 4;
        elseif contains(val, '16-QAM')
            state.mod_scheme = '16-QAM';
            state.M = 16;
        elseif contains(val, '64-QAM')
            state.mod_scheme = '64-QAM';
            state.M = 64;
        end
        execute_transmission();
    end

    function execute_transmission()
        t_start = tic;
        orig = state.current_img;
        snr_val = snr_slider.Value;

        % 1. Convert to bits
        [tx_bits, meta] = image_to_bits(orig);
        total_bits = meta.total_bits;

        % 2. Modulate
        switch state.mod_scheme
            case 'BPSK'
                [tx_syms, k] = modulate_bpsk(tx_bits);
                pad_len = 0;
            otherwise % QAM
                [tx_syms, k, pad_len] = modulate_qam(tx_bits, state.M);
        end

        % 3. AWGN Channel
        [rx_syms, ~, ~] = awgn_channel(tx_syms, snr_val, k, 'EbNo');

        % 4. Demodulate
        switch state.mod_scheme
            case 'BPSK'
                rx_bits = demodulate_bpsk(rx_syms);
            otherwise
                rx_bits = demodulate_qam(rx_syms, state.M, pad_len);
        end

        % 5. Reconstruct Image
        rx_img = bits_to_image(rx_bits, meta);

        % 6. Compute Metrics
        metrics = compute_metrics(orig, rx_img, tx_bits, rx_bits, tx_syms, rx_syms, k);
        t_elapsed = toc(t_start) * 1000;

        % 7. Update UI Displays
        imshow(rx_img, 'Parent', ax_rx);
        axis(ax_rx, 'image', 'off');
        pnl_rx.Title = sprintf('Received Image (%s @ %.1f dB, PSNR=%.1f dB)', state.mod_scheme, snr_val, metrics.PSNR);

        % Error Heatmap
        orig_d = double(orig);
        rx_d = double(rx_img);
        if ndims(orig) == 3
            err_map = mean(abs(orig_d - rx_d), 3);
        else
            err_map = abs(orig_d - rx_d);
        end
        imagesc(err_map, 'Parent', ax_err, [0 255]);
        colormap(ax_err, 'hot');
        axis(ax_err, 'image', 'off');

        % Constellation Scatter
        cla(ax_const);
        hold(ax_const, 'on'); grid(ax_const, 'on'); box(ax_const, 'on');
        pts_to_show = min(length(rx_syms), 1800);
        idx = randperm(length(rx_syms), pts_to_show);
        scatter(ax_const, real(rx_syms(idx)), imag(rx_syms(idx)), 10, [0.85 0.35 0.15], 'filled', 'MarkerFaceAlpha', 0.5);

        % Reference points
        if strcmp(state.mod_scheme, 'BPSK')
            plot(ax_const, [1 -1], [0 0], 'rp', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
            xlim(ax_const, [-2.2 2.2]); ylim(ax_const, [-1.8 1.8]);
        else
            L = sqrt(state.M);
            ideal_1d = -(L-1):2:(L-1);
            [GI, GQ] = meshgrid(ideal_1d, ideal_1d);
            norm_fact = 1 / sqrt(2 * (state.M - 1) / 3);
            ideal_syms = (GI(:) + 1j * GQ(:)) * norm_fact;
            plot(ax_const, real(ideal_syms), imag(ideal_syms), 'kp', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
            xlim(ax_const, [-1.8 1.8]); ylim(ax_const, [-1.8 1.8]);
        end
        xline(ax_const, 0, 'k--', 'Alpha', 0.4);
        yline(ax_const, 0, 'k--', 'Alpha', 0.4);
        title(ax_const, sprintf('%s Constellation @ %.1f dB', state.mod_scheme, snr_val));

        % 8. Update Metric Dashboard
        if metrics.BER == 0
            lbl_ber.Text = 'Bit Error Rate (BER): 0.00e+00 (Error-Free)';
            lbl_ber.FontColor = [0 0.5 0];
        else
            lbl_ber.Text = sprintf('Bit Error Rate (BER): %.3e', metrics.BER);
            if metrics.BER > 0.01
                lbl_ber.FontColor = [0.8 0 0];
            else
                lbl_ber.FontColor = [0.7 0.4 0];
            end
        end

        lbl_errs.Text  = sprintf('Bit Flips: %d / %d (%.2f%%)', metrics.num_bit_errs, metrics.total_bits, metrics.BER*100);
        lbl_psnr.Text  = sprintf('PSNR: %.2f dB', metrics.PSNR);
        lbl_ssim.Text  = sprintf('SSIM: %.4f', metrics.SSIM);
        lbl_mse.Text   = sprintf('Pixel MSE: %.2f', metrics.MSE);
        lbl_syms.Text  = sprintf('Channel Symbols: %d', length(tx_syms));
        lbl_speed.Text = sprintf('Spectral Efficiency: %d bps/Hz (%dx BPSK)', k, k);
        lbl_time.Text  = sprintf('Processing Latency: %.1f ms', t_elapsed);
    end

    function run_full_benchmark()
        run_btn.Enable = 'off';
        compare_btn.Text = 'Running dcs.m... Check MATLAB Console';
        drawnow;
        try
            evalin('base', 'dcs');
            uialert(fig, 'Full benchmark completed! Figures and metrics saved in results/ folder.', 'Benchmark Finished');
        catch ME
            uialert(fig, ME.message, 'Benchmark Error');
        end
        run_btn.Enable = 'on';
        compare_btn.Text = 'Run Full Benchmark (dcs.m)';
    end
end
