function [tx_symbols, k, pad_len] = modulate_qam(bits, M)
% MODULATE_QAM Multi-Level Quadrature Amplitude Modulation (M-QAM) Modulator
%
% Syntax:
%   [tx_symbols, k, pad_len] = modulate_qam(bits, M)
%
% Inputs:
%   bits - Binary vector of bits (0 or 1)
%   M    - Constellation order (default = 16, supports 4, 16, 64)
%
% Outputs:
%   tx_symbols - Complex baseband symbols normalized to unit average energy (Es = 1)
%   k          - Bits per symbol (k = log2(M))
%   pad_len    - Number of zero-padding bits added to align stream with symbol boundary
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Aakash Nair (24BEC0080), Sanskriti Sarkar (24BEC0183), Glenn Monteiro (24BEC0474)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 2 || isempty(M)
        M = 16;
    end

    % Verify M is a valid square constellation (4, 16, 64, ...)
    sqrt_M = round(sqrt(M));
    if sqrt_M^2 ~= M || mod(log2(M), 1) ~= 0
        error('modulate_qam:InvalidM', 'M must be a power of 2 with square constellation (e.g. 4, 16, 64).');
    end

    k = log2(M);
    bits_col = double(bits(:));

    % Zero-pad if total bits is not an exact multiple of k
    rem_bits = mod(length(bits_col), k);
    if rem_bits ~= 0
        pad_len = k - rem_bits;
        bits_col = [bits_col; zeros(pad_len, 1)];
    else
        pad_len = 0;
    end

    % Check if Communications Toolbox qammod is available
    if exist('qammod', 'file') == 2
        % Built-in Gray-coded QAM with Unit Average Power
        tx_symbols = qammod(bits_col, M, 'InputType', 'bit', 'UnitAveragePower', true, 'PlotConstellation', false);
    else
        % Self-contained analytical Gray-coded square QAM implementation
        tx_symbols = local_qammod_gray(bits_col, M, k, sqrt_M);
    end
end

function symbols = local_qammod_gray(bits, M, k, sqrt_M)
    % Analytical Gray-coded square QAM generator with Unit Average Power
    k_half = k / 2;
    num_symbols = length(bits) / k;
    bit_chunks = reshape(bits, k, num_symbols)';

    % Split bits into In-phase (I) and Quadrature (Q) bits
    bits_I = bit_chunks(:, 1:k_half);
    bits_Q = bit_chunks(:, (k_half+1):end);

    % Map to PAM levels with Gray code
    pam_I = local_pam_gray(bits_I, sqrt_M);
    pam_Q = local_pam_gray(bits_Q, sqrt_M);

    unnorm_symbols = pam_I + 1j * pam_Q;

    % Theoretical average symbol energy for M-QAM: Es = 2 * (M - 1) / 3
    avg_energy = 2 * (M - 1) / 3;
    norm_factor = 1 / sqrt(avg_energy);

    symbols = unnorm_symbols * norm_factor;
end

function levels = local_pam_gray(bits, L)
    % Gray code mapping for L-PAM: levels in {-(L-1), -(L-3), ..., +(L-1)}
    k = log2(L);
    powers = 2 .^ (k-1:-1:0);
    bin_int = bits * powers';

    % Convert binary integer to Gray integer
    gray_val = bitxor(bin_int, bitshift(bin_int, -1));

    % Find index of Gray values
    [~, gray_idx] = ismember(bin_int, bitxor(0:(L-1), bitshift(0:(L-1), -1)));
    levels = (2 * (gray_idx - 1) - (L - 1));
end
