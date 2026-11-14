function [tx_symbols, k] = modulate_bpsk(bits)
% MODULATE_BPSK Binary Phase Shift Keying Modulator
%
% Syntax:
%   [tx_symbols, k] = modulate_bpsk(bits)
%
% Mapping (Standard Gray coded):
%   bit 0 -> +1 + 0j
%   bit 1 -> -1 + 0j
%
% Outputs:
%   tx_symbols - Complex baseband symbols with unit average energy (Es = 1)
%   k          - Bits per symbol (k = 1)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    k = 1;
    bits_col = double(bits(:));

    % Optimal antipodal BPSK mapping: 0 -> +1, 1 -> -1
    % Expressed as complex baseband signal
    s_real = 1 - 2 * bits_col;
    tx_symbols = complex(s_real, 0);
end
