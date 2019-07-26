# Face Detection 

The objective of this project was to develop two functions. 
The first function P = RecogniseFace(I, featureType, classifierName) returns a matrix P representing the people present in an RGB image I. P is a matrix of size Nx3, where N is the number of people detected in the number of image. The three columns represent
1. id, a unique number associated with each person that matches the number in database provided
2. x, the x location of the person detected in the image (central face region)
3. y, the y location of the person detected in the image (central face region)
The second function, detectNum (filename) accepts an image or video file of a person holding a number in their hand and detectNum returns the number seen in that image/video.
