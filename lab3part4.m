

for k=499:657


load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k, k, 3, 'png');

im1 = ans;
im1 = im2double(im1);


for e=1:360
	im1(e,2:2:end) = medfilt1(im1(e,2:2:end), 4);
end

for f=1:360
	im1(f,:) = medfilt1(im1(f,:), 3);
end


save_sequence(im1, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', k, 3);


end