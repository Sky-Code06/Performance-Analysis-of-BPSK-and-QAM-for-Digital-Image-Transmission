function img = bits_to_image(bits, meta)
% BITS_TO_IMAGE Reconstructs an image from a binary bitstream using metadata.
%
% Syntax:
%   img = bits_to_image(bits, meta)
%
% Inputs:
%   bits - Column or row vector of received bits (0 and 1)
%   meta - Struct containing metadata from image_to_bits (.img_size, .total_bytes, etc.)
%
% Output:
%   img  - Reconstructed uint8 image matrix [H x W] or [H x W x C]
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Aakash Nair (24BEC0080), Sanskriti Sarkar (24BEC0183), Glenn Monteiro (24BEC0474)
% VIT - School of Electronics Engineering (SENSE)

    % 1. Enforce correct length and format
    expected_bits = meta.total_bytes * 8;
    if length(bits) < expected_bits
        error('bits_to_image:TruncatedStream', ...
            'Received bitstream length (%d) is less than required (%d).', length(bits), expected_bits);
    end

    % Truncate padding if bitstream had extra alignment bits
    bits = bits(1:expected_bits);
    bits = double(bits(:) > 0.5); % Ensure hard binary 0 or 1

    % 2. Convert 8-bit MSB-first blocks back to bytes
    % Powers of 2 weights: 2^7, 2^6, ..., 2^0
    weights = 2 .^ (7:-1:0)';

    bit_matrix = reshape(bits, 8, meta.total_bytes);
    bytes_1d = uint8(weights' * bit_matrix)';

    % 3. Reshape back into original image dimensions
    img = reshape(bytes_1d, meta.img_size);
end
