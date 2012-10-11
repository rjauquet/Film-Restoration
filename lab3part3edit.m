

for k=34:34


load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', k-2, k+2, 3, 'png');
ims=ans;
ims = im2double(ims);
% ims(:,:,3) is the current target image, k


% take the differences between the two frames on either side of the current frame.
im1 = ims(:,:,3);
im2 = ims(:,:,1);
im3 = ims(:,:,2);
im4 = ims(:,:,4);
im5 = ims(:,:,5);

im6 = im2 - im1;

im7 = im3 - im1;

im8 = im4 - im1;

im9 = im5 - im1;


% change the differences into binary values, based on a threashold T
T = .07;
for e=1:360
	for f=1:476
		if (im6(e,f) > T)		
			im6(e,f) = 1;
		else
			im6(e,f) = 0;
		end

		if (im7(e,f) > T)		
			im7(e,f) = 1;
		else
			im7(e,f) = 0;
		end

		if (im8(e,f) > T)		
			im8(e,f) = 1;
		else
			im8(e,f) = 0;
		end

		if (im9(e,f) > T)		
			im9(e,f) = 1;
		else
			im9(e,f) = 0;
		end

		if (im6(e,f) == 1 & im7(e,f) == 1 & im8(e,f) == 1 & im9(e,f) == 1)
			
			im1(e,f) = im2(e,f);
			
			if(e > 1 & f >1)
				im1(e-1,f-1) = im2(e-1,f-1);
				end
				
			if(e > 1)
				im1(e-1,f) = im2(e-1,f);
				end
				
			if(f > 1)
				im1(e,f-1) = im2(e,f-1);
				end
				
			if(e < 360)
				im1(e+1,f) = im2(e+1,f);
				end
				
			if(f < 476)
				im1(e,f+1) = im2(e,f+1);
				end
				
			if(e < 360 & f < 476)
				im1(e+1,f+1) = im2(e+1,f+1);
				end
			if(e < 360 & f > 1)
				im1(e+1,f-1) = im2(e+1,f-1);
				end
			if(e > 0 & f < 476)
				im1(e-1,f+1) = im2(e-1,f+1);
				end
			end
	end
end
save_sequence(im1, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', k, 3);

end