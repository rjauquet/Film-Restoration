
load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 1, 3, 'png');
im=ans;
im = im2double(imList);

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
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;]

[x y] = size(matrix);

for i=1:x
	for j=1:y
		im(i,j) = matrix(i,j);
	end
end

save_sequence(im, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 1, 3);
