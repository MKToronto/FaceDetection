function [numberClassification, imagelabeled] = detectNum(imageORvideo)
% Summary

% After running detectNum the labelled images will open
% Feel free to close all the images in an easier way by running the
% function: closeimages


% Instatiating the variables
word = 'NaN'
numberClassification = word;
imagelabeled = 'NaN'


try
%     This returns variables from a seperate function that I wrote called
% OCRpreprocessing
[textBBoxes, I, colorImage] = OCRPreprocessing(imageORvideo);

ocrtxt = ocr(I, textBBoxes,'CharacterSet', '0123456789', 'TextLayout','Block');

% This loop finds the numbers detected with the most confidence
% As the ocr function returned a more complex array alot of variables are
% needed to return the numbers with the highest confidence
    theMaxConfidence = 0 ;
    theIndexatMaxValue = 0;
    theIndexinLoopAtMaxConfidence = 0;
    for i = 1:length(ocrtxt)
        disp(i)
        WConfidences = ocrtxt(i).WordConfidences
        disp(i)
        [MV,I] = max(WConfidences)
        wordStringDouble = str2double (cell2mat(ocrtxt(i).Words(I)))
%         Here I made sure that an integer within a reasonable range of
%         consideration was returned
        if  MV > theMaxConfidence & wordStringDouble >= 0 & wordStringDouble  <= 999 & ~wordStringDouble == 00
            theMaxConfidence =  MV
            theIndexatMaxValue = I
            theIndexinLoopAtMaxConfidence = i
        end
        disp(i)
        
        
    end
    
    
%     Sometimes the image would come rotated. Therefore the same process 
% of finding the maximum confidence was run on the rotated image
% was run
colorImageR = imrotate(colorImage,-90);
[textBBoxesR, Irotated, colorImageR] = OCRPreprocessing(colorImageR);
ocrtxtR = ocr(Irotated, textBBoxesR,'CharacterSet', '0123456789', 'TextLayout','Block');

    wordR = 'Nan'
    theMaxConfidenceR = 0;
    theIndexatMaxValueR = 0;
    theIndexinLoopAtMaxConfidenceR = 0;
    for j = 1:length(ocrtxtR)
        disp(j)
        WConfidencesR = ocrtxtR(j).WordConfidences
        disp(j)
        [MVR,IR] = max(WConfidencesR)
        wordStringDoubleR = str2double (cell2mat(ocrtxtR(j).Words(IR)))
        if  MVR > theMaxConfidenceR & wordStringDoubleR >= 0 & wordStringDoubleR  <= 999 & ~wordStringDoubleR == 00
            theMaxConfidenceR =  MVR
            theIndexatMaxValueR = IR
            theIndexinLoopAtMaxConfidenceR = j
        end
        disp(j)
        
        
    end
% A decision rule was made to return the image and number with the maximum 
% OCR confidence

% This if statement was to stop any error occuring if a text wasn't 
% recognised in an image
        if    (theIndexinLoopAtMaxConfidenceR == 0  || theIndexatMaxValueR == 0)
            numberClassification = word;
            imagelabeled = colorImage 
% If the rotated image has a higher confidence, that image is chosen        
        elseif  theMaxConfidenceR > theMaxConfidence  
    	    wordR = cell2mat(ocrtxtR(theIndexinLoopAtMaxConfidenceR).Words(theIndexatMaxValueR))
            WordBoundingBoxes = ocrtxtR(theIndexinLoopAtMaxConfidenceR).WordBoundingBoxes; 
            IdigitsR = insertObjectAnnotation(colorImageR, 'rectangle', WordBoundingBoxes, wordR, 'FontSize', 60);
            figure; 
            imshow(IdigitsR);
            numberClassification = wordR;
            imagelabeled = IdigitsR; 
            
        elseif (theIndexinLoopAtMaxConfidence == 0  || theIndexatMaxValue == 0) 
            numberClassification = word;
            imagelabeled = colorImage
            
        else
            word = cell2mat(ocrtxt(theIndexinLoopAtMaxConfidence).Words(theIndexatMaxValue))
            WordBoundingBoxes = ocrtxt(theIndexinLoopAtMaxConfidence).WordBoundingBoxes;
            Idigits = insertObjectAnnotation(colorImage, 'rectangle', WordBoundingBoxes, word, 'FontSize', 60);
            figure; 
            imshow(Idigits);
            numberClassification = word;
            imagelabeled = Idigits; 
        end    
catch
    
end

end

