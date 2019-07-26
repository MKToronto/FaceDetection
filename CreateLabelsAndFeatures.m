% Look at Matlab OCR 
% % Load data
% Detect number areas through image labeller or segmentation


% imageDir = '/Users/marckendal/Dropbox/MSc Data Science/Computer Vision/Computer Vision Module/Computer Vision Coursework'
% addpath(imageDir);
% load('gTruth1.mat')
% gTruth.LabelDefinitions
% gTruth1NP = selectLabels(gTruth,'NumberPaper');
% 
% trainingData = objectDetectorTrainingData(gTruth1NP);
% summary(trainingData)
% acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);
% 
% 
% I = imread('IMG_0665.jpg');
% bboxes = detect(acfDetector,I);
% 
% annotation = acfDetector.ModelName;
% I = insertObjectAnnotation(I,'rectangle',bboxes,annotation);
% 
% figure 
% imshow(I)
% 
% 
% 
% 
% I = imread('IMG_0665.jpg');
% regions = detectMSERFeatures(I);
% 
% colorImage = imread('IMG_0665.jpg');
% I = rgb2gray(colorImage);
% 
% % Detect MSER regions.
% [mserRegions, mserConnComp] = detectMSERFeatures(I, ... 
%     'RegionAreaRange',[200 8000],'ThresholdDelta',4);
% 
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('MSER regions')
% hold off
% 
% 
% 
%  I = imread('/Users/marckendal/Dropbox/MSc Data Science/Computer Vision/Computer Vision Module/Computer Vision Coursework/CWimages/1of11/002/IMG_0669.jpg');
% % [ocrI, results] = evaluateOCRTraining(I);
% %  results.Text
% % results.CharacterConfidences
% 
% % Remove keypad background
% % Icorrected = imtophat(I, strel('disk', 15));
% 
% % BW1 = imbinarize(I);
% % 
% % figure; 
% % imshow(BW1);
% % Perform morphological reconstruction and show binarized image.
% marker = imerode(I, strel('line',10,0));
% Iclean = imreconstruct(marker, I);
% 
% BW2 = imbinarize(Iclean);
% 
% figure; 
% imshowpair(Iclean, BW2, 'montage');
% 
% results = ocr(BW2, 'CharacterSet', '0123456789', 'TextLayout','Block');
% 
% results.Text
% 
% 
% % The regular expression, '\d', matches the location of any digit in the
% % recognized text and ignores all non-digit characters.
% regularExpr = '\d';
% 
% % Get bounding boxes around text that matches the regular expression
% bboxes = locateText(results, regularExpr, 'UseRegexp', true);
% 
% digits = regexp(results.Text, regularExpr, 'match');
% 
% % draw boxes around the digits
% Idigits = insertObjectAnnotation(I, 'rectangle', bboxes, digits);
% 
% figure; 
% imshow(Idigits);
% 
% % Sort the character confidences
% [sortedConf, sortedIndex] = sort(results.CharacterConfidences, 'descend');
% 
% % Keep indices associated with non-NaN confidences values
% indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );
% 
% % Get the top ten indexes
% topTwoIndexes = indexesNaNsRemoved(1:2);
% 
% % Select the top ten results
% digits = num2cell(results.Text(topTwoIndexes));
% bboxes = results.CharacterBoundingBoxes(topTwoIndexes, :);
% 
% Idigits = insertObjectAnnotation(BW2, 'rectangle', bboxes, digits);
% figure; 
% imshow(Idigits);
% 
% 
% 
% 
% % Initialize the blob analysis System object(TM)
% blobAnalyzer = vision.BlobAnalysis('MaximumCount', 500);
% 
% % Run the blob analyzer to find connected components and their statistics.
% [area, centroids, roi] = step(blobAnalyzer, I);
% 
% % Show all the connected regions
% img = insertShape(I, 'rectangle', roi);
% figure;
% imshow(img);


    
    
%     
%     oTextChar = ocrtxt(i).Text
%         cBoundingBoxes = ocrtxt(i).CharacterBoundingBoxes
%     %     ccmac [] = ccma + ccmac
%         oTextChar = oTextChar(find(~isspace(oTextChar)))
%         oTextStr = cellstr(oTextChar)
% %         if  ~isempty(oTextChar)
% %             disp('True')
%             ocrtxtCharecterConfidences = cat(1,cConfidences,ocrtxtCharecterConfidences)
%             ocrtxtText = cat(1,oTextStr,ocrtxtText)
%             ocrtxtCharacterBoundingBoxes = cat(1,cBoundingBoxes,ocrtxtCharacterBoundingBoxes)
% %         end
%         %     disp(ccmac)
%     end
% cc = [ocrtxt.CharacterConfidences]
% results = ocr(BW2, 'CharacterSet', '0123456789', 'TextLayout','Block');
% End

% % Sort the character confidences
% [sortedConf, sortedIndex] = sort(ocrtxtCharecterConfidences, 'descend');
% 
% % Keep indices associated with non-NaN confidences values
% indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );
% 
% % Get the top ten indexes
% topTwoIndexes = indexesNaNsRemoved(1:2);
% 
% % Select the top ten results
% digits = num2cell(ocrtxtText(topTwoIndexes));
% bboxes = ([ocrtxt.CharacterBoundingBoxes(topTwoIndexes, :)]);
% 
% Idigits = insertObjectAnnotation(ITextRegion, 'rectangle', bboxes, digits);
% figure; 
% imshow(Idigits);
% 




% Label Data based on the number using OCR using pretrained CNN

% BEGinning
colorImage = imread('IMG_0655.JPG');
I = rgb2gray(colorImage);

% Detect MSER regions.
[mserRegions, mserConnComp] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[200 8000],'ThresholdDelta',4);
% 
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('MSER regions')
% hold off



% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

% Compute the aspect ratio using bounding box data.
bbox = vertcat(mserStats.BoundingBox);
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;

% Threshold the data to determine which regions to remove. These thresholds
% may need to be tuned for other images.
filterIdx = aspectRatio' > 3; 
filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
filterIdx = filterIdx | [mserStats.Solidity] < .3;
filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
filterIdx = filterIdx | [mserStats.EulerNumber] < -4;

% Remove regions
mserStats(filterIdx) = [];
mserRegions(filterIdx) = [];

% % Show remaining regions
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('After Removing Non-Text Regions Based On Geometric Properties')
% hold off

% Get a binary image of the a region, and pad it to avoid boundary effects
% during the stroke width computation.
regionImage = mserStats(6).Image;
regionImage = padarray(regionImage, [1 1]);

% Compute the stroke width image.
distanceImage = bwdist(~regionImage); 
skeletonImage = bwmorph(regionImage, 'thin', inf);

strokeWidthImage = distanceImage;
strokeWidthImage(~skeletonImage) = 0;

% % Show the region image alongside the stroke width image. 
% figure
% subplot(1,2,1)
% imagesc(regionImage)
% title('Region Image')
% 
% subplot(1,2,2)
% imagesc(strokeWidthImage)
% title('Stroke Width Image')


% Compute the stroke width variation metric 
strokeWidthValues = distanceImage(skeletonImage);   
strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);

% Threshold the stroke width variation metric
strokeWidthThreshold = 0.4;
strokeWidthFilterIdx = strokeWidthMetric > strokeWidthThreshold;


% Process the remaining regions
for j = 1:numel(mserStats)
    
    regionImage = mserStats(j).Image;
    regionImage = padarray(regionImage, [1 1], 0);
    
    distanceImage = bwdist(~regionImage);
    skeletonImage = bwmorph(regionImage, 'thin', inf);
    
    strokeWidthValues = distanceImage(skeletonImage);
    
    strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);
    
    strokeWidthFilterIdx(j) = strokeWidthMetric > strokeWidthThreshold;
    
end

% Remove regions based on the stroke width variation
mserRegions(strokeWidthFilterIdx) = [];
mserStats(strokeWidthFilterIdx) = [];

% % Show remaining regions
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('After Removing Non-Text Regions Based On Stroke Width Variation')
% hold off


% Get bounding boxes for all the regions
bboxes = vertcat(mserStats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Expand the bounding boxes by a small amount.
expansionAmount = 0.02;
xmin = (1-expansionAmount) * xmin;
ymin = (1-expansionAmount) * ymin;
xmax = (1+expansionAmount) * xmax;
ymax = (1+expansionAmount) * ymax;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
IExpandedBBoxes = insertShape(colorImage,'Rectangle',expandedBBoxes,'LineWidth',3);

% figure
% imshow(IExpandedBBoxes)
% title('Expanded Bounding Boxes Text')
% 

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);



% Merge the boxes based on the minimum and maximum dimensions.
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

% Remove bounding boxes that only contain one text region
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup == 1, :) = [];

% % Show the final text detection result.
% ITextRegion = insertShape(colorImage, 'Rectangle', textBBoxes,'LineWidth',3);
% 
% figure
% imshow(ITextRegion)
% title('Detected Text')



ocrtxt = ocr(I, textBBoxes,'CharacterSet', '0123456789', 'TextLayout','Word');
% results = ocrtxt.Text
    
%     ocrtxtCharecterConfidences= [];
%     ocrtxtText = [];
%     ocrtxtCharacterBoundingBoxes = [];
    theMaxConfidence = 0;
    for i = 1:length(ocrtxt)
        disp(i)
        cConfidences = ocrtxt(i).CharacterConfidences
        disp(i)
        if  max(cConfidences) > theMaxConfidence 
            theMaxConfidence =  max(cConfidences)
            theIndexAtMaxConfidence = i
        end
        disp(i)
        
        
    end
    
    Irotated = imrotate(I,-90);
    ocrtxt = ocr(Irotated, textBBoxes,'CharacterSet', '0123456789', 'TextLayout','Word');
    
    for i = 1:length(ocrtxt)
        disp(i)
        cConfidences = ocrtxt(i).CharacterConfidences
        disp(i)
        if  max(cConfidences) > theMaxConfidence 
            theMaxConfidence =  max(cConfidences)
            theIndexAtMaxConfidence = i
        end
        disp(i)
        
        
    end
    
word = cell2mat(ocrtxt(theIndexAtMaxConfidence).Words(1))
% digits = num2cell(word);
% 
%     for k = 1:length(digits)
%         string_contains_numeric = ~isnan(str2double(digits(k)))
%         if  string_contains_numeric
%             disp('not Empty')
%             disp(digits(k))
%             ocrtxtText(k) = digits(k)
%             ocrtxtCharacterBoundingBoxes(k) = ocrtxt(theIndexAtMaxConfidence).CharacterBoundingBoxes 
%         end
%         
%     end 
%     
%     

WordBoundingBoxes = ocrtxt(theIndexAtMaxConfidence).WordBoundingBoxes;

    
%     % Sort the character confidences
% [sortedConf, sortedIndex] = sort(ocrtxtCharecterConfidences, 'descend');
% 
%     
%     
%     
%     % Select the top ten results
%     digits = num2cell(oTextChar);
% %     bboxes = ([ocrtxt.CharacterBoundingBoxes(topTwoIndexes, :)]);
%     insertObjectAnnotation(ITextRegion, 'rectangle', WordBoundingBoxes, word);
    Idigits = insertObjectAnnotation(colorImage, 'rectangle', WordBoundingBoxes, word, 'FontSize', 60);
    figure; 
    imshow(Idigits);




% number = word;
% imagelabeled = Idigits; 
%     figure; 
%     imshow(Idigits);
% end

load('1of11');

for i = 1:'1of11
    NumberDetector(imageArg)

% Detect Faces

% Normalising the faces to a 200x200 box and then extracting consistent 
% features is one way to handle this. (J = imresize(I, [N, M]);)

% Create matrix with labels and features 
