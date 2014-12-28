function [im] = openslide_read_associated_image(openslidePointer,imageName)
% OPENSLIDE_READ_ASSOCIATED_IMAGE Reads an associated image
%
% [im] = openslide_read_associated_image(openslidePointer,imageName)
%
% INPUT ARGUMENTS
% openslidePointer          - Pointer to slide to read from
% imageName                 - Associated image to read
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT
% im                        - Read image

% Copyright (c) 2013 Daniel Forsberg
% daniel.forsberg@liu.se
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%
% Check if openslide library is opened
if ~libisloaded('openslidelib')
    error('openslide:openslide_read_region',...
        'Make sure to load the openslide library first\n')
end

% Read size of associated image
width = 0;
height = 0;
[~, string, width, height] = calllib('openslidelib',...
    'openslide_get_associated_image_dimensions',openslidePointer,imageName,...
    width,height);
    
% Read image
data = uint32(zeros(width*height,1));
region = libpointer('uint32Ptr',data);
[~, string, region] = calllib('openslidelib',...
    'openslide_read_associated_image',openslidePointer,imageName,region);
RGBA = typecast(region,'uint8');
im = uint8(zeros(width,height,3));
im(:,:,1) = reshape(RGBA(3:4:end),width,height);
im(:,:,2) = reshape(RGBA(2:4:end),width,height);
im(:,:,3) = reshape(RGBA(1:4:end),width,height);

% Permute image to make sure it is according to standard MATLAB format
im = permute(im,[2 1 3]);