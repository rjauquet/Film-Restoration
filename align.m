load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

base = returnList(:,:,1);
in = returnList(:,:,2);

cpselect(in, base);
save_sequence(base, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 0, 3);
save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 1, 3);


% find the corners in the base image
basePoints = cornermetric(base, 'SensitivityFactor', 0.01);
inPoints = cornermetric(in, 'SensitivityFactor', 0.01);

bCount = 1;
inCount = 1;


baseP = [0 0; 0 1; 1 0; 1 1];
inP = [0 0; 0 1; 1 0; 1 1];


for e=1:360
	for f=1:476
	
		if(basePoints(e,f) > .003 & bCount < 4)
			kk=3
			baseP(bCount, 1) = e;
			baseP(bCount, 2) = f;
			bCount = bCount + 1;
			end
			
		if(inPoints(e,f) > .003 & inCount < 4)
			kk=4
			inP(inCount, 1) = e;
			inP(inCount, 2) = f;
			inCount = inCount + 1;
			end
		end
	end

% find the corners in the image to be processed


%define the transformation
transform = cp2tform(inP, baseP, 'similarity');

in = imtransform(in,transform, 'XData', [1 y], 'YData', [1 x]);


save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 2, 3);



 I = returnList(:,:,3);
 subplot(1,3,1);
 imshow(I);
 title('Original Image');
 CM = cornermetric(I);

CM_adjusted = imadjust(CM);
subplot(1,3,2);
imshow(CM_adjusted);
title('Corner Metric');

corner_peaks = imregionalmax(CM);
corner_idx = find(corner_peaks == true);
[r g b] = deal(I);
r(corner_idx) = 255;
g(corner_idx) = 255;
b(corner_idx) = 0;
RGB = cat(3,r,g,b);
subplot(1,3,3);
imshow(RGB);
title('Corner Points');
