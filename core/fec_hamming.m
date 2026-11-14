function [rx_bits_coded, ber_coded, ber_uncoded] = fec_hamming(tx_bits, snr_dB, mod_type)
% FEC_HAMMING Demonstrates Forward Error Correction (FEC) using (7,4) Hamming code.
%
% Syntax:
%   [rx_bits_coded, ber_coded, ber_uncoded] = fec_hamming(tx_bits, snr_dB, mod_type)
%
% Implements:
%   - Systematic (7,4) Hamming encoder with generator matrix G
%   - BPSK or 16-QAM modulation over AWGN channel
%   - Syndrome-based single-bit error detection and correction decoder
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    if nargin < 3 || isempty(mod_type)
        mod_type = 'BPSK';
    end

    tx_bits = tx_bits(:);
    k = 4;
    n = 7;

    % Generator Matrix G = [I_4 | P]
    G = [1 0 0 0  1 1 0;
         0 1 0 0  1 0 1;
         0 0 1 0  0 1 1;
         0 0 0 1  1 1 1];

    % Parity Check Matrix H = [P' | I_3]
    H = [1 1 0 1  1 0 0;
         1 0 1 1  0 1 0;
         0 1 1 1  0 0 1];

    % Pad if necessary to multiple of 4
    rem_bits = mod(length(tx_bits), k);
    if rem_bits ~= 0
        pad_len = k - rem_bits;
        tx_bits_padded = [tx_bits; zeros(pad_len, 1)];
    else
        pad_len = 0;
        tx_bits_padded = tx_bits;
    end

    num_blocks = length(tx_bits_padded) / k;
    msg_blocks = reshape(tx_bits_padded, k, num_blocks)';

    % Encode: c = m * G (modulo 2)
    code_blocks = mod(msg_blocks * G, 2);
    coded_stream = reshape(code_blocks', [], 1);

    % Transmit over AWGN
    switch upper(mod_type)
        case 'BPSK'
            [s_tx, bits_per_sym] = modulate_bpsk(coded_stream);
            [s_rx, ~, ~] = awgn_channel(s_tx, snr_dB, bits_per_sym, 'EbNo');
            rx_stream = demodulate_bpsk(s_rx);

            % Uncoded reference
            [s_u_tx, b_u] = modulate_bpsk(tx_bits_padded);
            [s_u_rx, ~, ~] = awgn_channel(s_u_tx, snr_dB, b_u, 'EbNo');
            rx_uncoded = demodulate_bpsk(s_u_rx);

        case '16-QAM'
            [s_tx, bits_per_sym, qam_pad] = modulate_qam(coded_stream, 16);
            [s_rx, ~, ~] = awgn_channel(s_tx, snr_dB, bits_per_sym, 'EbNo');
            rx_stream = demodulate_qam(s_rx, 16, qam_pad);

            [s_u_tx, b_u, u_pad] = modulate_qam(tx_bits_padded, 16);
            [s_u_rx, ~, ~] = awgn_channel(s_u_tx, snr_dB, b_u, 'EbNo');
            rx_uncoded = demodulate_qam(s_u_rx, 16, u_pad);
    end

    % Decode: Syndrome calculation S = r * H' (modulo 2)
    rx_code_blocks = reshape(rx_stream(1:num_blocks*n), n, num_blocks)';
    syndromes = mod(rx_code_blocks * H', 2);

    % Syndrome decoding dictionary: map syndrome to error bit position
    % Column j of H corresponds to single-bit error in position j
    H_cols = H';
    corrected_blocks = rx_code_blocks;

    for blk = 1:num_blocks
        syn = syndromes(blk, :);
        if any(syn)
            % Find matching column in H
            for col = 1:n
                if isequal(syn, H_cols(col, :))
                    % Correct error bit
                    corrected_blocks(blk, col) = 1 - corrected_blocks(blk, col);
                    break;
                end
            end
        end
    end

    % Extract information bits (first k positions in systematic code)
    decoded_info = corrected_blocks(:, 1:k)';
    rx_bits_coded = reshape(decoded_info, [], 1);

    if pad_len > 0
        rx_bits_coded = rx_bits_coded(1:end-pad_len);
        rx_uncoded = rx_uncoded(1:end-pad_len);
    end

    ber_coded = mean(tx_bits ~= rx_bits_coded);
    ber_uncoded = mean(tx_bits ~= rx_uncoded);
end
