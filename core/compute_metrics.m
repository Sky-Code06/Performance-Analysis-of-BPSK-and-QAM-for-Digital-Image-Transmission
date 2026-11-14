function metrics = compute_metrics(orig_img, rx_img, tx_bits, rx_bits, tx_syms, rx_syms, k)
% COMPUTE_METRICS Evaluates bit-, symbol-, and perceptual image quality metrics.
%
% Syntax:
%   metrics = compute_metrics(orig_img, rx_img, tx_bits, rx_bits, tx_syms, rx_syms, k)
%
% Outputs:
%   metrics struct with fields:
%     .BER          - Bit Error Rate (fraction)
%     .num_bit_errs - Total bit errors
%     .total_bits   - Total bits transmitted
%     .SER          - Symbol Error Rate (fraction)
%     .MSE          - Pixel Mean Squared Error
%     .PSNR         - Peak Signal-to-Noise Ratio (dB)
%     .SSIM         - Structural Similarity Index (0 to 1)
%     .spectral_eff - Spectral efficiency in bps/Hz (= k)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 7 || isempty(k)
        k = 1;
    end

    % --- 1. Bit Error Rate (BER) ---
    L_bits = min(length(tx_bits), length(rx_bits));
    tx_b = tx_bits(1:L_bits);
    rx_b = rx_bits(1:L_bits);
    bit_errs = sum(tx_b ~= rx_b);
    ber = bit_errs / L_bits;

    % --- 2. Symbol Error Rate (SER) ---
    if nargin >= 6 && ~isempty(tx_syms) && ~isempty(rx_syms)
        L_syms = min(length(tx_syms), length(rx_syms));
        % Sliced / nearest-symbol decision error
        ser = mean(abs(tx_syms(1:L_syms) - rx_syms(1:L_syms)) > 1e-4);
    else
        ser = 1 - (1 - ber)^k;
    end

    % --- 3. Pixel MSE and PSNR ---
    orig_double = double(orig_img);
    rx_double = double(rx_img);

    mse = mean((orig_double(:) - rx_double(:)).^2);

    if mse == 0
        psnr_val = Inf;
    else
        psnr_val = 10 * log10((255^2) / mse);
    end

    % --- 4. Structural Similarity Index (SSIM) ---
    if exist('ssim', 'file') == 2
        try
            ssim_val = ssim(rx_img, orig_img);
        catch
            ssim_val = local_ssim(orig_double, rx_double);
        end
    else
        ssim_val = local_ssim(orig_double, rx_double);
    end

    % --- Pack into output structure ---
    metrics.BER = ber;
    metrics.num_bit_errs = bit_errs;
    metrics.total_bits = L_bits;
    metrics.SER = ser;
    metrics.MSE = mse;
    metrics.PSNR = psnr_val;
    metrics.SSIM = ssim_val;
    metrics.spectral_eff = k;
end

function ssim_val = local_ssim(img1, img2)
    % Native multi-channel SSIM calculation using 8x8 sliding blocks
    if ndims(img1) == 3
        vals = zeros(size(img1, 3), 1);
        for c = 1:size(img1, 3)
            vals(c) = local_ssim_2d(img1(:,:,c), img2(:,:,c));
        end
        ssim_val = mean(vals);
    else
        ssim_val = local_ssim_2d(img1, img2);
    end
end

function score = local_ssim_2d(A, B)
    % 2D SSIM with standard constants
    C1 = (0.01 * 255)^2;
    C2 = (0.03 * 255)^2;

    % Gaussian weighting kernel (11x11, sigma = 1.5)
    kernel_size = 11;
    sigma = 1.5;
    [X, Y] = meshgrid(-(kernel_size-1)/2:(kernel_size-1)/2);
    H = exp(-(X.^2 + Y.^2) / (2 * sigma^2));
    H = H / sum(H(:));

    % Local means
    mu1 = conv2(A, H, 'valid');
    mu2 = conv2(B, H, 'valid');

    mu1_sq = mu1 .^ 2;
    mu2_sq = mu2 .^ 2;
    mu1_mu2 = mu1 .* mu2;

    % Local variances and covariance
    sigma1_sq = conv2(A.^2, H, 'valid') - mu1_sq;
    sigma2_sq = conv2(B.^2, H, 'valid') - mu2_sq;
    sigma12 = conv2(A.*B, H, 'valid') - mu1_mu2;

    % SSIM map
    num = (2 * mu1_mu2 + C1) .* (2 * sigma12 + C2);
    den = (mu1_sq + mu2_sq + C1) .* (sigma1_sq + sigma2_sq + C2);
    ssim_map = num ./ den;

    score = mean(ssim_map(:));
end
