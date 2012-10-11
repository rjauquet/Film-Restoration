
load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 1, 3, 'png');

im1 = ans;
im1 = im2double(im);

im2 = im1;


PSF = fspecial('motion',5,10);
INITPSF = ones(size(PSF));
[im2 P] = deconvblind(im1,INITPSF,5);


save_sequence(im2, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'edit_footage_', 5, 3);