function [bits, meta] = image_to_bits(img_input)
% IMAGE_TO_BITS Converts a 2D grayscale or 3D RGB image into a binary bitstream.
%
% Syntax:
%   [bits, meta] = image_to_bits(img_input)
%
% Inputs:
%   img_input - Either a file path (char/string) or a uint8 image matrix [H x W] or [H x W x C]
%
% Outputs:
%   bits      - Column vector of bits (0 or 1, uint8/double)
%   meta      - Struct containing metadata required for perfect reconstruction:
%               .img_size   : Dimensions [H, W] or [H, W, C]
%               .is_rgb     : Boolean flag (true if 3-channel RGB)
%               .num_pixels : Total number of pixels
%               .total_bytes: Total number of bytes
%               .total_bits : Total bit count (8 * total_bytes)
%
% DCS Project: Performance Analysis of BPSK and QAM for Digital Image Transmission
% Authors: Glenn Monteiro (24BEC0474), Sanskriti Sarkar (24BEC0183), Aakash Nair (24BEC0080)
% VIT - School of Electronics Engineering (SENSE)

    % 1. Load image if filename is provided
    if ischar(img_input) || isstring(img_input)
        if ~isfile(img_input)
            error('image_to_bits:FileNotFound', 'Image file not found: %s', img_input);
        end
        img = imread(img_input);
    else
        img = img_input;
    end

    % 2. Ensure uint8 format
    if ~isa(img, 'uint8')
        if isfloat(img) && max(img(:)) <= 1.0
            img = uint8(round(img * 255));
        else
            img = uint8(img);
        end
    end

    % 3. Extract dimensions and metadata
    img_size = size(img);
    is_rgb = (ndims(img) == 3 && img_size(3) == 3);
    num_bytes = numel(img);
    total_bits = num_bytes * 8;

    meta.img_size = img_size;
    meta.is_rgb = is_rgb;
    meta.num_pixels = img_size(1) * img_size(2);
    meta.total_bytes = num_bytes;
    meta.total_bits = total_bits;

    % 4. Convert bytes to 8-bit MSB-first binary representation
    % Flatten image bytes to 1D column vector
    bytes_1d = img(:);

    % Use bitget for high speed and independence from external toolboxes
    % bit 8 is MSB, bit 1 is LSB
    bit_matrix = bitget(repmat(bytes_1d, 1, 8), repmat(8:-1:1, num_bytes, 1));

    % Reshape to single column vector
    bits = double(reshape(bit_matrix', [], 1));
end
