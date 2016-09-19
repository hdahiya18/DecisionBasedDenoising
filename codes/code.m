clc; close all; clear all;

img = imread('nature.jpg');
img = im2double(img);
org = img;
figure, imshow(org); title('Original image');
noisePercentage = 75;
img = imnoise(img,'salt & pepper', noisePercentage/100);
figure, imshow(img); title('Noisy image');
[r,c] = size(img);

w = 3;
ws = floor(w/2);

meanFilt = filter2(fspecial('average',3),img);
medianFilt = medfilt2(img);
adapFilt = wiener2(img,[5 5]);

img = padarray(img, [1,1], (min(img(:))+max(img(:)))/2);

for i=2:r
    for j=2:c
        patch = img(i-ws:i+ws,j-ws:j+ws);
        patch = reshape(patch, 1, []);
        wMin = min(patch);
        wMax = max(patch);
        wMed = median(patch);
        if img(i,j) == wMin || img(i,j) == wMax
            if wMed == wMin || wMed == wMax
                img(i,j) = mean([img(i-1,j-1:j+1) img(i,j-1)]);
            else
                img(i,j) = wMed;
            end
        end
    end
end
img = img(2:r+1,2:c+1);
figure, imshow(meanFilt); title('Mean filtered image');
figure, imshow(medianFilt); title('Median filtered image');
figure, imshow(adapFilt); title('Adaptive filtered image');
figure, imshow(img);