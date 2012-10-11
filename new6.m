load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 22, 23, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

in = returnList(:,:,2);
base = returnList(:,:,1);

 in=mean(in,3);
 base=mean(base,3);

In = fft2(double(in));
Base = fft2(double(base));

% steps from Matlab documentation

c = (Base .* conj(In)) ./ abs((Base .* conj(In)));

cifft = ifft2(double(c));
Xmax = 1;
Ymax = 1;
max =0;
for i=1:x
	for j=1:y
		if(cifft(i,j) > max)
			max = cifft(i,j);
			Xmax=i;
			Ymax=j;
		end
	end
end

Xmax = Xmax;
Ymax = Ymax;

T = [1 0 0; 0 1 0; Ymax Xmax 1];
tform = maketform('affine', T);

in = imtransform(in,tform,'XData',[1 size(in,2)],'YData',[1 size(in,1)]);

save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 2, 3);

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