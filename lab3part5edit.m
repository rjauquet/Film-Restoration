

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

% hGTE = vision.GeometricTransformEstimator;
% hGT = vision.GeometricTransformer;
% hGTPrj = vision.GeometricTransformer;
maxPts = 150;
ptThresh = 1e-3;

for k=2:z
	imA=returnList(:,:,k-1);
	imB=returnList(:,:,k);

% hCD = vision.CornerDetector('MaximumCornerCount', maxPts, 'CornerThreshold', ptThresh, 'NeighborhoodSize', [9 9]);
	A = step(H, imA);
	B = step(H, imB);

	blockSize = 9;
	
	[featuresA, A] = extractFeatures(imA, A, 'BlockSize', blockSize);
	[featuresB, B] = extractFeatures(imB, B, 'BlockSize', blockSize);

	indexPairs = matchFeatures(featuresA, featuresB, 'Metric', 'SSD');
	A = A(indexPairs(:, 1), :);
	B = B(indexPairs(:, 2), :);
	
	nRansacTrials = 1;
	Ts = cell(1,nRansacTrials);
	costs = zeros(1,nRansacTrials);
	nPts = int32(size(pointsA,2));
	inliers = cell(1,nRansacTrials);

	for j=1:nRansacTrials
% Estimate affine transform
		[Ts{j},inliers{j}] = step(hGTE, B, A);

% Warp image and compute error metric.
		imgBp = step(hGT, imB, Ts{j});
		costs(j) = sum(sum(imabsdiff(imgBp, imA)));
		end
% Take best result.
	[~,ix] = min(costs);
	imgBp = step(hGT, imB, Ts{ix});
	pointsBp = [single(B), ones(size(B,1), 1)] * Ts{ix};
	H = [Ts{ix} [0 0 1]'];
	
% Extract scale and rotation part sub-matrix.
	R = H(1:2,1:2);
% Compute theta from mean of two possible arctangents
	theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
% Compute scale from mean of two stable mean calculations
	scale = mean(R([1 4])/cos(theta));
% Translation remains the same:
	translation = H(3, 1:2);
% Reconstitute new s-R-t transform:
	HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; translation], [0 0 1]'];

	imgBold = step(hGTPrj, imB, H);
	imgBsRt = step(hGTPrj, imB, HsRt);
	end