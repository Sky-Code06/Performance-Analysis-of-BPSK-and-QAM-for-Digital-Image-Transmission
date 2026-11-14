function rx_bits = demodulate_bpsk(rx_symbols)
% DEMODULATE_BPSK Coherent Maximum Likelihood (ML) Demodulator for BPSK
%
% Syntax:
%   rx_bits = demodulate_bpsk(rx_symbols)
%
% Decision Boundary:
%   Threshold = 0 on In-phase (Real) axis.
%   If real(r) >= 0 -> bit 0 (+1 transmitted)
%   If real(r) < 0  -> bit 1 (-1 transmitted)
%
% Output:
%   rx_bits - Column vector of hard-decision recovered bits (0 or 1)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Aakash Nair (24BEC0080), Sanskriti Sarkar (24BEC0183), Glenn Monteiro (24BEC0474)
% VIT - School of Electronics Engineering (SENSE)

    % Coherent projection onto the real in-phase decision axis
    r_real = real(rx_symbols(:));

    % Hard decision slicing at threshold 0
    % real >= 0 => 0, real < 0 => 1
    rx_bits = double(r_real < 0);
end
