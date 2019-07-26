
% Work out min size of images in each category and partition

croppedResizedFaces = imageSet('resizedCroppedImaged','recursive'); 
 minimumSetCount = min([croppedResizedFaces.Count])
 imgSets = partition(croppedResizedFaces, minimumSetCount, 'randomize');
[trainingAndval,finaltest] = partition(imgSets,[0.9 0.1]); 
[trainingSets,validationSets] = partition(trainingAndval,[0.8 0.2]);

% Get SURF features
bag = bagOfFeatures(trainingSets);

img = read(imgSets(1), 1);

featureVector = encode(bag, img);

% Plot the histogram of visual word occurrences

figure; bar(featureVector)

title('Visual word occurrences')
xlabel('Visual word index') 
ylabel('Frequency of occurrence')

% Train surfSVM
surfSVM = trainImageCategoryClassifier(trainingSets, bag);
save surfSVM
confMatrixTrain = evaluate(surfSVM, trainingSets);

confMatrixVal = evaluate(surfSVM, validationSets);

% Compute average accuracy

mean(diag(confMatrixVal))
img = imread(I);

[labelIdx, ~] = predict(surfSVM, img);

% Display the string labels

surfSVM.Labels(labelIdx)


% MLP - Unfortunaltely, I didnt have train this network
% Also planned to train a CNN
% Load the training data into memory
% 
% imds = imageDatastore('resizedCroppedImaged','IncludeSubfolders',true, 'LabelSource' 'foldernames')
% minimumSetCount = min([croppedResizedFaces.Count])
% imgSets = partition(imds, minimumSetCount, 'randomize');
% [trainingAndval,finaltest] = partition(imgSets,[0.9 0.1]); 
% [trainingSets,validationSets] = partition(trainingAndval,[0.8 0.2]);
% 
% 
% [xTrainImages, imds.Labels] = trainingSets; 
% 
% 
% % Get the number of pixels in each image image
% Width = 28; imageHeight = 28; inputSize = imageWidth*imageHeight; 
% % Load the test images
% 
% % Turn the training images into vectors and put them in a matrix 
% xTrain = zeros(inputSize,numel(xTrainImages)); 
% for i = 1:numel(xTrainImages) xTrain(:,i) = xTrainImages{i}(:); end
% 
% for i = 1 : 5000 tTrainLabels(i) = uint8(find(tTrain(:,i))); tTestLabels(i) = uint8(find(tTest(:,i)));

% end
% 
% The next three lines, create the network, assign the training function of the network 
% (in this case Scaled Conjugate Gradient Backpropagation), configure the training and labels sizes and train the network:
% 
% net = feedforwardnet(100, 'trainscg'); 
% net = configure(net,xTrain,tTrain); net = train(net,XTrain, tTrain);
% 
% Here we have created and configures and trained a network with 100 hidden neurons. 
% You can compare the results with a different number of neurons to see how the network 
% perfoems. We can test the neural network on the training and test images:
% 
% outPuts = net(xTrain); outPutsTest = net(xTest);
% 
% for i = 1 : 5000 [value outPutLabels(1,i)] = max(outPuts(:,i)); [value outPutLabelsTest(1,i)] = max(outPutsTest(:,i)); end
% 
% We can calculate the accuracy of the neural network on training and test sets using the following lines of code:
% 
% ACCTrain = sum(outPutLabels == tTrainLabels) / 5000 ACCTest = sum(outPutLabelsTest == tTestLabels) / 5000
