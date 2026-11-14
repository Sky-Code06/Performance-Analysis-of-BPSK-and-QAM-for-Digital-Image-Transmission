function rx_bits = demodulate_qam(rx_symbols, M, pad_len)
% DEMODULATE_QAM Multi-Level Quadrature Amplitude Modulation Demodulator
%
% Syntax:
%   rx_bits = demodulate_qam(rx_symbols, M, pad_len)
%
% Inputs:
%   rx_symbols - Complex baseband received symbols
%   M          - Constellation order (default = 16)
%   pad_len    - Number of padded bits to discard from tail (default = 0)
%
% Output:
%   rx_bits    - Recovered binary bit vector (0 or 1)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 2 || isempty(M)
        M = 16;
    end
    if nargin < 3 || isempty(pad_len)
        pad_len = 0;
    end

    rx_symbols_col = rx_symbols(:);

    if exist('qamdemod', 'file') == 2
        % Maximum-likelihood Euclidean distance demodulator with Gray code
        demod_bits = qamdemod(rx_symbols_col, M, 'OutputType', 'bit', 'UnitAveragePower', true);
    else
        % Self-contained analytical minimum Euclidean distance slicer
        demod_bits = local_qamdemod_gray(rx_symbols_col, M);
    end

    % Remove zero-padding bits added during modulation
    if pad_len > 0
        demod_bits = demod_bits(1:end-pad_len);
    end

    rx_bits = double(demod_bits(:));
end

function bits = local_qamdemod_gray(rx_symbols, M)
    % Analytical minimum distance slicer
    k = log2(M);
    k_half = k / 2;
    L = round(sqrt(M));
    avg_energy = 2 * (M - 1) / 3;
    norm_factor = 1 / sqrt(avg_energy);

    % De-normalize symbols
    unnorm = rx_symbols / norm_factor;
    r_I = real(unnorm);
    r_Q = imag(unnorm);

    % PAM decision boundaries
    ideal_pam = -(L-1):2:(L-1);

    dec_I = local_slice_pam(r_I, ideal_pam);
    dec_Q = local_slice_pam(r_Q, ideal_pam);

    % Map PAM levels back to Gray bits
    bits_I = local_pam_to_gray_bits(dec_I, ideal_pam, k_half);
    bits_Q = local_pam_to_gray_bits(dec_Q, ideal_pam, k_half);

    % Interleave I and Q bits
    num_symbols = length(rx_symbols);
    bit_chunks = [bits_I, bits_Q];
    bits = reshape(bit_chunks', [], 1);
end

function sliced = local_slice_pam(signal, ideal_pam)
    % Nearest neighbor slicer
    L = length(ideal_pam);
    diffs = abs(repmat(signal, 1, L) - repmat(ideal_pam, length(signal), 1));
    [~, min_idx] = min(diffs, [], 2);
    sliced = ideal_pam(min_idx)';
end

function bits = local_pam_to_gray_bits(sliced_pam, ideal_pam, k_half)
    L = length(ideal_pam);
    [~, gray_idx] = ismember(sliced_pam, ideal_pam);
    gray_idx = gray_idx - 1;

    % Gray to binary decoding
    % Generate Gray-to-integer lookup table
    gray_codes = bitxor(0:(L-1), bitshift(0:(L-1), -1));
    [~, bin_ints] = ismember(gray_idx, gray_codes);
    bin_ints = bin_ints - 1;

    % Binary integers to bits
    powers = 2 .^ (k_half-1:-1:0);
    bits = zeros(length(sliced_pam), k_half);
    for bit_pos = 1:k_half
        bits(:, bit_pos) = bitget(bin_ints, k_half - bit_pos + 1);
    end
end
