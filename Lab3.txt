
% the scene change Boolean, 1 if scene changes
SC = 0

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

SceneCutFrames = [];

for k=1:500

N=0;
M=0;
R=0;

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k, k+1, 3, 'png');

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

if R > T
	SC = SC + 1
	k
	SceneCutFrames(SC)=k
end
end
