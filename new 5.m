load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

in = returnList(:,:,2);
base = returnList(:,:,1);

ptA = base(20:130,90:200);
origP(1,1)=round(sum(20:130)/(130-20));
origP(1,2)=round(sum(90:200)/(200-90));

shiftA = real(ifft2(fft2(in) .* fft2(rot90(ptA,2),x,y)));


threshA = max(shiftA(:)) - 5;

Acount=1;


for e=1:x
	for f=1:y

		if(shiftA(e,f)>threshA)
			inLocA(Acount,1)=e;
			inLocA(Acount,2)=f;
			Acount=Acount+1;
		end
		
		
	end
end
shiftP(1,1) = round(mean2(inLocA(:,1)));
shiftP(1,2) = round(mean2(inLocA(:,2)));

changeX=shiftP(1,1)-origP(1,1);
changeY=shiftP(1,2)-origP(1,2);

old=in;
new=in;

for o=1:x
	for p=1:y
		if(((o+changeX) < x) & ((o+changeX) >0) & ((p+changeY) < y) & ((p+changeY) >0))
			new(o,p) = old(o+changeX,p+changeY);
		else
			new(o,p)=0;
		end
	end	
end

save_sequence(base, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 4, 3);
		


transform = cp2tform(shiftP, origP, 'similarity');
in = imtransform(in,transform, 'XData', [1 y], 'YData', [1 x]);

save_sequence(new, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 6, 3);

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





save_sequence(in, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', k, 3);


