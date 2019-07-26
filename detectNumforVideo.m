function [numberClassificationForVideo, imagelabeled] = detectNumforVideo(videoArg)
%detectNumforVideo runs detect Num on images from a video and takes the
%mode number returns for all the images

    
  vid=VideoReader(videoArg);
  numFrames = vid.NumberOfFrames;
  y=numFrames;
  classification = NaN(y,1)
for l = 1:y
    frames = read(vid,l);
    [numberClassified, imagelabeled] = detectNum(frames)
    classification(l,1) = str2double(numberClassified)
end 


    numberClassificationForVideo = mode(classification)
end

