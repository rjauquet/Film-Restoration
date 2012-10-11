load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 1, 3, 'png');

im = ans;
im = im2double(im);

save_sequence(im, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'edit_footage_', 1, 3);


for k=2:500

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k, k, 3, 'png');

imA=ans;
imA = im2double(imA);


load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k-1, k-1, 3, 'png');

imB=ans;
imB = im2double(imB);


countA=mean2(imA);
countB=mean2(imB);

count = countB - countA;

for m=1:360
	for n=1:476
	
	imA(m,n) = imA(m,n) + count;
	
	end
end

save_sequence(imA, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'edit_footage_', k, 3);


% end cycling through all pictures
end