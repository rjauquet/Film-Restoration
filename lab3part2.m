load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 1, 3, 'png');
im=ans;
im = im2double(im);

save_sequence(im, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'edit_footage_', 1, 3);


for k=2:500

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k, k, 3, 'png');
imA=ans;

imA = im2double(imA);



load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k-1, k-1, 3, 'png');
imB=ans;

imB = im2double(imB);






for i=1:360
	for j=1:476
		imA(i,j)= (imA(i,j) + imB(i,j))/2;
	end
end


save_sequence(imA, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'edit_footage_', k, 3);


% end cycling through all pictures
end