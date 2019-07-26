% Create Cropped resized images
% DetectFaces
A = imread('IMG_0737.jpg'); 
imshow(A);
FaceDetector = vision.CascadeObjectDetector(); 
BBOX = step(FaceDetector,A); 
B = insertObjectAnnotation(A,'rectangle',BBOX,'Face'); 
imshow(B),title('Detected Faces');