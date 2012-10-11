%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Name: Robert Jauquet
% Class: COMP3085
% Assignment: Labs3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%
% Read a sequence of images and correct the film defects. This is the file 
% you have to fill for the coursework. Do not change the function 
% declaration, keep this skeleton. You are advised to create subfunctions.
% 
% Arguments:
%
% path: path of the files
% prefix: prefix of the filename
% first: first frame
% last: last frame
% digits: number of digits of the frame number
% suffix: suffix of the filename
%
% This should generate corrected images named [path]/corrected_[prefix][number].png
%
% Example:
%
% mov = labs3('../images','myimage', 0, 10, 4, 'png')
%   -> that will load and correct images from '../images/myimage0000.png' to '../images/myimage0010.png'
%   -> and export '../images/corrected_myimage0000.png' to '../images/corrected_myimage0010.png'
%
function output = labs3(path, prefix, first, last, digits, suffix)


cutFrames = sceneCut(path, prefix, first, last, digits, suffix);


% this loop runs the various functions on the movie one scene at a time.
% If there is only one scene, all frames are done at once, reguardless
% of how many frames are in the scene. fixedImages contains the current 
% set of all frames, so each function is being called on the returned
% frames from the last function.
%
load_sequence(path, prefix, first, last, digits, suffix);
fixedImages=ans;
fixedImages = im2double(fixedImages);

% displays CUT in the upper left of the first frame of new scenes (except the first scene)
for c=1:size(cutFrames)
	cutFrames(c)
	fixedImages(:,:,cutFrames(c)) = addText(fixedImages(:,:,cutFrames(c)));
	end
[x,y,z] = size(fixedImages);
% save images
correctedName = strcat('corrected_',  prefix);
save_sequence(fixedImages, path, correctedName, first, digits);
ererere
end





% function: sceneCut
%
% runs through entire move, and fills an array with the frame number 
% of the last frame in every scene change (doesn't include end of film)
% 
% Arguments:
%
% path: path of the files
% prefix: prefix of the filename
% first: first frame
% last: last frame
% digits: number of digits of the frame number
% suffix: suffix of the filename
%
%
%
function a = sceneCut(path, prefix, first, last, digits, suffix)

% the scene change Boolean, 1 if scene changes
SC = 0;

% the current pixel
N=0;

% the number of pixels that are different by a certain amount D
M=0;

% the threshold for a significant pixel change
D=.1;

% the total pixel area
P=360*476;


% the threshold for scene changes
T=.75;

% the ratio for the two frames
R=0;

% the return array, fills with frame numbers
SceneCutFrames = [];

% loop through entire movie. For each frame, compare it to the next frame.
% If the absolute value of the difference of the intesity of the pixels is greater
% than some threshold D, increment M. M represents a count of the pixels
% that changed greatly from frame to frame. This is then compared to another
% threshold, T, to determine if enough pixels changed to constitute a scene change.
% This loop can produce errors if there is a very significant amount of motion difference
% in two consecutive frames, or if two scenes are very simmilar to each other. But, 
% because it compares pixel by pixel, it can detect scene changes with simmilar
% overall intensity. Thresholds were determined via trial and error, and then adjusted so 
% as to pick up the most scenes in general execution.
%
for k=first:(last-1)
	% N is the current pixel difference
	N=0;
	% M is the count of pixels that changed significantly
	M=0;
	% R gives the ratio of pixels changed to total number of pixels
	R=0;
	
	load_sequence(path, prefix, k, k+1, digits, suffix);
	imgs=ans;
	imgs = im2double(imgs);

	for i=1:360
		for j=1:476
			N = abs(imgs(i,j,1) - imgs(i,j,2));
			if N > D
				M = M+1;
				end
			end
		end
	R = M/P;

		if (R > T)
			SC = SC + 1;
			SceneCutFrames(SC)=k;
			end
	end
	
% return an array of scene	
a = SceneCutFrames;
end





% function: globalFlick
%
% Given a list of frames, adjusts each frames intensity to better match 
% the previous frame.
% 
% Arguments:
%
% imList: a 3D matrix of frames
%
%
%
function b = globalFlick(imList)

returnList = imList;
[x,y,z] = size(imList);

% starting with the second frame, compare this frame to the previous frame.
% average the intesity of both frames, and subtract the intesity of the first
% frame from the second. This gives the avereage difference in intesity between
% each frame. Then, imB is adjusted pixel by pixel by this difference.
% This method will produce errors when the frames have high dynamic range, or when
% the first frame has very high intensity, or very low intensity, as each frame after
% the first will be affected by the first frames average.
for k=2:z

imA = imList(:,:,k);
imB = imList(:,:,k-1);

% average intensities
countA=mean2(imA);
countB=mean2(imB);

count = countA - countB;

for m=1:x
	for n=1:y
		imB(m,n) = imB(m,n) + count;
	end
end

returnList(:,:,z) = imB;

% end cycling through all pictures
end
% return the adjusted images
b=returnList;
% end globalFlick
end




% function: blotchFix
%
% atempts to find and fix blotched in each frame.
% 
% Arguments:
%
% imList: a 3D matrix of frames
%
%
% notes: blotchFix needs at least 5 images to function.
%
function c = blotchFix(imList)

returnList = imList;
[x,y,z] = size(imList);


% loop through all images. For every image, take the two previous and two next images
% and create a set of four images representing their differences from the first. These new
% images are then converted into binary based on a threshold, and the middle three images
% are adjusted if all four images are different than the middle image.
% This method is not very perfect. It correctly identifies large and dark
% blotches, but does not do well with very small, or semi transparent
% blotches. It also does not have motion detection, so movement
% is percieved as differences between frames, and can be picked up
% as blotch ares. The threshold was adjusted to minimize changes
% to moving objects while still detecting major blotches.
%
for k=3:(z-2)


% the middle image of the 5 is the working image, now named 'im1'
im1 = returnList(:,:,k);
im2 = returnList(:,:,k-2);
im3 = returnList(:,:,k-1);
im4 = returnList(:,:,k+1);
im5 = returnList(:,:,k+2);


% take the differences between the two frames on either side of the current frame.
im6 = im2 - im1;
im7 = im3 - im1;
im8 = im4 - im1;
im9 = im5 - im1;


% change the differences into binary values, based on a threashold T
T = .07;
for e=1:x
	for f=1:y
		if (im6(e,f) > T)		
			im6(e,f) = 1;
		else
			im6(e,f) = 0;
		end

		if (im7(e,f) > T)		
			im7(e,f) = 1;
		else
			im7(e,f) = 0;
		end

		if (im8(e,f) > T)		
			im8(e,f) = 1;
		else
			im8(e,f) = 0;
		end

		if (im9(e,f) > T)		
			im9(e,f) = 1;
		else
			im9(e,f) = 0;
		end
% fix blotches. to doublecheck, frame-1 and frame+1 are also changed.
% to make sure all of the blotch is removed, the pixels surrounding
% detected blotch pixels are also changed. the list of if statements
% merely checks to make sure there are no out of bounds accesses on
% the matrix of pixels.
		if (im6(e,f) == 1 & im7(e,f) == 1 & im8(e,f) == 1 & im9(e,f) == 1)
			
			im1(e,f) = im2(e,f);
			im3(e,f) = im2(e,f);
			im4(e,f) = im5(e,f);
			
			if(e > 1 & f >1)
				im1(e-1,f-1) = im2(e-1,f-1);
				im3(e-1,f-1) = im2(e-1,f-1);
				im4(e-1,f-1) = im5(e-1,f-1);
				end
				
			if(e > 1)
				im1(e-1,f) = im2(e-1,f);
				im3(e-1,f) = im2(e-1,f);
				im4(e-1,f) = im5(e-1,f);
				end
				
			if(f > 1)
				im1(e,f-1) = im2(e,f-1);
				im3(e,f-1) = im2(e,f-1);
				im4(e,f-1) = im5(e,f-1);
				end
				
			if(e < x)
				im1(e+1,f) = im2(e+1,f);
				im3(e+1,f) = im2(e+1,f);
				im4(e+1,f) = im5(e+1,f);
				end
				
			if(f < y)
				im1(e,f+1) = im2(e,f+1);
				im3(e,f+1) = im2(e,f+1);
				im4(e,f+1) = im5(e,f+1);
				end
				
			if(e < x & f < y)
				im1(e+1,f+1) = im2(e+1,f+1);
				im3(e+1,f+1) = im2(e+1,f+1);
				im4(e+1,f+1) = im5(e+1,f+1);
				end
			if(e < x & f > 1)
				im1(e+1,f-1) = im2(e+1,f-1);
				im3(e+1,f-1) = im2(e+1,f-1);
				im4(e+1,f-1) = im5(e+1,f-1);
				end
			if(e > 1 & f < y)
				im1(e-1,f+1) = im2(e-1,f+1);
				im3(e-1,f+1) = im2(e-1,f+1);
				im4(e-1,f+1) = im5(e-1,f+1);
				end
			end
	end
end
% update all frames.
returnList(:,:,k) = im1;
returnList(:,:,k-2) = im2;
returnList(:,:,k-1) = im3;
returnList(:,:,k+1) = im4;
returnList(:,:,k+2) = im5;

end
c=returnList;
% end blotchFix
end




% function: vertFix
%
% attempts to fix vertical artifacts in frames.
% 
% Arguments:
%
% imList: a 3D matrix of frames
%
%
%
function d = vertFix(imList)

returnList = imList;
[x,y,z] = size(imList);


% this method is designed to simply remove or lessen
% the vertical artifacts found specifically in the third
% scene of the test video. it loops through every other row
% and filters the column data. Then a less intense filter
% is applied to the entire matrix. This effectivly lessens
% the vertical lines, while only minimally blurring the image,
% compared to applying a stronger filter over the entire 
% matrix right away.
for k=1:z

im1=returnList(:,:,k);
for e=1:x
	im1(e,2:2:end) = medfilt1(im1(e,2:2:end), 5);
end

for f=1:x
	im1(f,:) = medfilt1(im1(f,:), 3);
end
returnList(:,:,k)=im1;
end

d=returnList;
% end vertFix
end






% function: shakeFix
%
% attempts to realign frames that have been shifted
% due to camera movement.
% 
% Arguments:
%
% imList: a 3D matrix of frames
%
% notes: I origionally had a much simpler solution using Matlab's
% 'cpselect' and 'cp2tform' functions, however I could not discover
% a viable solution to automate 'cpselect'. Instead of having the user
% pick controll points, I decided to attempt to write a phase correlation
% method. The latter method does not work as well and isn't as simple, but is 
% easier to use when working with large numbers of images. The phase correlation 
% method is largely dependent on how the translation vector is calculated, so there
% is probably a much better way to translate the image once the correlation
% has been found.
%
function e = shakeFix(imList)

returnList = imList;
[x,y,z] = size(imList);

% this method attempts to use a phase shift aproach to 
% detecting changes in frames. the first frame is used as
% the base frame to make the first adjustment, and every
% adjustment after that uses the previous frame as its
% reference. This procedure was based on the documentation
% for the function 'translation' as well as a guide for
% phase correlation in OpenCV found here: "http://www.nashruddin.com
% /phase-correlation-function-in-opencv.html" the four steps described
% under the heading 'The Basics' were used to calculate the correlation
% between each set of two frames. 
for q=2:z

% in is the current frame being adjusted
% base is an already adjusted frame (or the first frame)
in = returnList(:,:,z);
base = returnList(:,:,z-1);

% calculate the Fast Fourier transform on each image
In = fft2(double(in));
Base = fft2(double(base));

% calculate the spectral density 
c = (Base .* conj(In)) ./ abs((Base .* conj(In)));

% phase correlation is obtained with the inverse.
cifft = ifft2(double(c));

% cifft now contains a matrix of values between -1 and 1, where
% the max value is in the location of the transform vector
% needed to shift the current image to match the previous one.
% Xmax and Ymax hold the location vector, initally set to (1,1).
% max is the current maximum value. This loop steps through
% the entire matrix and finds the loctation of the max value.
Xmax = 1;
Ymax = 1;
max =0;
for i=1:x
	for j=1:y
		if(cifft(i,j) > max)
			max = cifft(i,j);
			Xmax=i;
			Ymax=j;
		end
	end
end

% now that the vector is found, a transformation must be made.
% 'imtransform' requires a value for tform of a certain type,
% so after a bit of trial and error, this affine function
% seemed to produce the least amount of errors.
T = [1 0 0; 0 1 0; Ymax Xmax 1];
tform = maketform('affine', T);

in = imtransform(in,tform,'XData',[1 size(in,2)],'YData',[1 size(in,1)]);

% fill in removed area, with a pixel overlap.
for j=1:x
	for k=1:y
		if(in(j,k)==0)
			in(j,k) = base(j,k);
			
			if(j > 1 & k >1)
				in(j-1,k-1) = base(j-1,k-1);
				end
				
			if(j > 1)
				in(j-1,k) = base(j-1,k);
				end
				
			if(k > 1)
				in(j,k-1) = base(j,k-1);
				end
				
			if(j < x)
				in(j+1,k) = base(j+1,k);
				end
				
			if(k < y)
				in(j,k+1) = base(j,k+1);
				end
				
			if(j < x & k < y)
				in(j+1,k+1) = base(j+1,k+1);
				end
			if(j < x & k > 1)
				in(j+1,k-1) = base(j+1,k-1);
				end
			if(j > 1 & k < y)
				in(j-1,k+1) = base(j-1,k+1);
				end
		end
	end
end
returnList(:,:,z) = in;
end
e = returnList;
% end shakeFix
end


% function: addText
%
% adds the word 'CUT' to the top left of a frame
% 
% Arguments:
%
% frame: a single frame to be edited
%
function z = addText(frame)
returnFrame=frame;


% this was the simplest way I could find to quickly
% add a note of frame changes. the matrix contains
% the data for the word 'CUT', and replaces a small
% number of pixels in the frame. The only error
% possible is an attempt to change the pixels
% in a picture with less than 11 rows, or less than
% 24 columns. It will also severly block any frame
% that is relativly the same size as 'matrix', 
% but this shouldn't ever be an issue.
matrix = [
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; 
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ; 
0 0 0 0 1 1 0 0 0 1 1 0 0 1 1 0 0 1 1 1 1 1 1 0 ; 
0 0 0 1 1 1 1 0 0 1 1 0 0 1 1 0 0 1 1 1 1 1 1 0 ;
0 0 1 1 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 ;
0 0 1 1 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 ;
0 0 1 1 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 1 1 0 0 0 ;
0 0 0 1 1 1 1 0 0 0 1 1 1 1 0 0 0 0 0 1 1 0 0 0 ;
0 0 0 0 1 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 ;
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;];

[x y] = size(matrix);

for i=1:x
	for j=1:y
		returnFrame(i,j) = matrix(i,j);
	end
end
z=returnFrame;
% end add text to frame
end
