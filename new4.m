load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

in = returnList(:,:,2);
base = returnList(:,:,1);

cpselect(in,base);

transform = cp2tform(input_points, base_points, 'similarity');
in = imtransform(in,transform, 'XData', [1 y], 'YData', [1 x]);

save_sequence(base, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 5, 3);
save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 6, 3);

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





save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 7, 3);


