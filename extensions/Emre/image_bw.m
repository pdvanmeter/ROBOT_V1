function theHandle = image_bw( BW )
%Displays a black and white image.
BW_display = zeros(size(BW,1), size(BW,2), 3);
BW_display(:,:,1) = BW;
theHandle = image(BW_display);
end

