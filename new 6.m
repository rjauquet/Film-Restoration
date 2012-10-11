load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
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

c = (In .* conj(Base)) ./ abs((In .* conj(Base)));

cifft = ifft2(double(c));

ci=abs(cifft);

c = conj(ci);