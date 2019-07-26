function P = RecogniseFace(I, featureType, classifierName)

%     featureType = 'SURF'
%     I = 'IMG_0626.jpg'
%     classifierName = 'SVM'
% I couldnt work out how to save the image classifier
% So DetectFaces needs to be run to get surfSVM
% Uncomment DetectFaces and run

DetectFaces
% surfSVMLoaded = [];
if strcmp(featureType,'SURF')& strcmp(classifierName,'SVM') 
%     surfSVMLoaded = load('surfSVMClassifier.mat')
    
	img = imread(I);
	[labelIdx, ~] = predict(surfSVM, img);
% Display the string label
	surfSVM.Labels(labelIdx)
end    


A = imread(I); 

FaceDetector = vision.CascadeObjectDetector(); 
BBOX = step(FaceDetector,A); 


B=img
P = NaN(length(BBOX),3)
for i=1:length(BBOX)
    BBOX(i,:)
    
    
    J = imcrop(img,BBOX(i,:))
    [labelIdx,~] = predict(surfSVM, J);
    labelssurfsvm = surfSVM.Labels(labelIdx)
    B = insertObjectAnnotation(B,'rectangle',BBOX(i,:),labelssurfsvm); 
    xCenter =  (BBOX(i,1) + BBOX(i,3))/2
    yCenter = (BBOX(i,2) - BBOX(i,4))/2
    id = labelIdx
    P(i,:) = [id, xCenter, yCenter]
end

figure;
imshow(B),title('Detected Faces');


end

