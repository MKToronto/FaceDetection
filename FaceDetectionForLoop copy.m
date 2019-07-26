img = imread('londonEye.jpg'); 
imgG = rgb2gray(img); 
imgd = im2double(imgG); 
f = ones(3,3)/9; 
img1 = imfilter(imgd,f); 
subplot(121);imshow(im2uint8(imgG)); 
subplot(122);imshow(im2uint8(img1));


img = imread('cameraman.tif'); imgd = im2double(img); % imgd in [0,1] 
imgd = imnoise(imgd,'salt & pepper',0.02); 
f = ones(3,3)/9; 
img1 = imfilter(imgd,f); 
subplot(121);
imshow(imgd); 
subplot(122);
imshow(img1);


I = imread('cameraman.tif'); 
J = imnoise(I,'salt & pepper',0.02); 
K = medfilt2(J); 
subplot(121);
imshow(J); 
subplot(122);
imshow(K);


I = imread('cameraman.tif'); 
radius = 1; 
J1 = fspecial('disk', radius); 
K1 = imfilter(I,J1,'replicate'); 
radius = 10; 
J10 = fspecial('disk', radius); 
K10 = imfilter(I,J10,'replicate'); 
subplot(131);
imshow(I);
title('original'); 
subplot(132);
imshow(K1);
title('disk: radius=1'); 
subplot(133);
imshow(K10);
title('disk: radius=10');


I = imread('Westminster.jpg'); J = imnoise(I,'salt & pepper',0.2);

% filter each channel separately 
r = medfilt2(J(:, :, 1), [3 3]); g = medfilt2(J(:, :, 2), [3 3]); b = medfilt2(J(:, :, 3), [3 3]);

% reconstruct the image from r,g,b channels 
K = cat(3, r, g, b); 
figure 
subplot(121);
imshow(J); 
subplot(122);
imshow(K);


% Task 1 with image from class

A = imread('IMG_0619.jpg');
FaceDetector = vision.CascadeObjectDetector(); 
BBOX = step(FaceDetector,A);

B = insertObjectAnnotation(A,'rectangle',BBOX,'Face'); 
imshow(B),title('Detected Faces');

% Now blur the faces

imgG = rgb2gray(B); 
imgd = im2double(imgG); 
f = ones(3,3)/9; 
img1 = imfilter(imgd,f); 
subplot(121);
imshow(im2uint8(imgG)); 
subplot(122);
imshow(im2uint8(img1));

radius = 1; 
J1 = fspecial('disk', radius); 
K1 = imfilter(BBOX,J1,'replicate'); 
radius = 10; 
J10 = fspecial('disk', radius); 
K10 = imfilter(BBOX,J10,'replicate'); 
subplot(131);
imshow(B);
title('original'); 
subplot(132);
imshow(K1);
title('disk: radius=1'); 
subplot(133);
imshow(K10);
title('disk: radius=10');



A = imread('IMG_0619.jpg');
FaceDetector = vision.CascadeObjectDetector(); 
BBOX = step(FaceDetector,A);

B = insertObjectAnnotation(A,'rectangle',BBOX,'Face'); 
imshow(B),title('Detected Faces');



a = imread('IMG_0619.jpg');
imshow(a);
FaceDetector = vision.CascadeObjectDetector;
bbox=step(FaceDetector,a);
for j=1:size(bbox)
    xbox=bbox(j,:);
    subImage = imcrop(a, xbox);
    H = fspecial('disk',10);
    blurred = imfilter(subImage,H);
    a(xbox(2):xbox(2)+xbox(4),xbox(1):xbox(1)+xbox(3),1:end) = blurred; 
end
imshow(a);