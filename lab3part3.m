% blotches - loop for every scene
%	load three frames in the scene
%	scan first frame for zero values
%	check second picture for same value
%		if different, set zero to other value
%
%
%
%

for k=3:50


load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k, k, 3, 'png');

im1 = ans;
im1 = im2double(im1);

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k-1, k-1, 3, 'png');

im2 = ans;
im2 = im2double(im2);

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k-2, k-2, 3, 'png');

im3 = ans;
im3 = im2double(im3);


for m=1:360
	for n=1:476
	
	if (im1(m,n) < .25)
		if (im2(m,n) >= .25)
			im1(m,n) = im2(m,n);
		end
		if (im3(m,n) > im2(m,n))
			im1(m,n) = im3(m,n);
		end
	end


	end
end

se = strel('disk',1);
im1 = imclose(im1,se);

save_sequence(im1, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zdit_footage_', k, 3);

end