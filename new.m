function new

load_sequence('C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\footage', 'footage_', 1, 10, 3, 'png');
imList=ans;
imList = im2double(imList);

returnList = imList;
[x,y,z] = size(imList);

I = returnList(:,:,1);

level = .64;

BW = im2bw(I, level);

save_sequence(I, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 1, 3);
save_sequence(BW, 'C:\Users\Rob\Desktop\Study Abroad Classes\Computational Photography\Lab 3\out', 'zzedit_footage_', 2, 3);

roi = BW;
roi=1;
frames = returnList;
L = 3;

N = z;
roiorig = roi;

Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
stable(1).roi = roiorig;
for k = 1 : N-1
	[A,T] = opticalflow(frames(:,:,k+1), frames(:,:,k), roi, L );
	motion(k).A = A;
	motion(k).T = T;
	[Acum,Tcum] = accumulatewarp( Acum, Tcum, A, T );
	roi = warp( roiorig, Acum, Tcum );
end


%%% STABILIZE TO LAST FRAME
stable(N).im = frames(N).im;
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
for k = N-1 : -1 : 1
	[Acum,Tcum] = accumulatewarp( Acum, Tcum, motion(k).A, motion(k).T );
	stable(k).im = warp( frames(k).im, Acum, Tcum );
end

% -------------------------------------------------------------------------
%%% ALIGN TWO FRAMES (f2 to f1)
function[ Acum, Tcum ] = opticalflow( f1, f2, roi, L )

f2orig = f2;
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];

for k = L : -1 : 0
%%% DOWN-SAMPLE
	f1d = down( f1, k );
	f2d = down( f2, k );

% changed roi to f1 to test
	ROI = down( roi, k );

%%% COMPUTE MOTION
	[Fx,Fy,Ft] = spacetimederiv( f1d, f2d );
	[A,T] = computemotion( Fx, Fy, Ft, ROI );
	T = (2^k)*T;
	[Acum,Tcum] = accumulatewarp( Acum, Tcum, A, T );
%%% WARP ACCORDING TO ESTIMATED MOTION
	f2 = warp( f2orig, Acum, Tcum );
end


%%% COMPUTE MOTION
function[ A, T ] = computemotion( fx, fy, ft, roi )
[ydim,xdim] = size(fx);
[x,y] = meshgrid( [1:xdim]-xdim/2, [1:ydim]-ydim/2 );
%%% TRIM EDGES
fx = fx( 3:end-2, 3:end-2 );
fy = fy( 3:end-2, 3:end-2 );
ft = ft( 3:end-2, 3:end-2 );
roi = roi( 3:end-2, 3:end-2 );
x = x( 3:end-2, 3:end-2 );
y = y( 3:end-2, 3:end-2 );
ind = find( roi > 0 );
x = x(ind); y = y(ind);
fx = fx(ind); fy = fy(ind); ft = ft(ind);
xfx = x.*fx; xfy = x.*fy; yfx = y.*fx; yfy = y.*fy;
M(1,1) = sum( xfx .* xfx ); M(1,2) = sum( xfx .* yfx ); M(1,3) = sum( xfx .* xfy );
M(1,4) = sum( xfx .* yfy ); M(1,5) = sum( xfx .* fx ); M(1,6) = sum( xfx .* fy );
M(2,1) = M(1,2); M(2,2) = sum( yfx .* yfx ); M(2,3) = sum( yfx .* xfy );
M(2,4) = sum( yfx .* yfy ); M(2,5) = sum( yfx .* fx ); M(2,6) = sum( yfx .* fy );
M(3,1) = M(1,3); M(3,2) = M(2,3); M(3,3) = sum( xfy .* xfy );
M(3,4) = sum( xfy .* yfy ); M(3,5) = sum( xfy .* fx ); M(3,6) = sum( xfy .* fy );
M(4,1) = M(1,4); M(4,2) = M(2,4); M(4,3) = M(3,4);
M(4,4) = sum( yfy .* yfy ); M(4,5) = sum( yfy .* fx ); M(4,6) = sum( yfy .* fy );
M(5,1) = M(1,5); M(5,2) = M(2,5); M(5,3) = M(3,5);
M(5,4) = M(4,5); M(5,5) = sum( fx .* fx ); M(5,6) = sum( fx .* fy );
M(6,1) = M(1,6); M(6,2) = M(2,6); M(6,3) = M(3,6);
M(6,4) = M(4,6); M(6,5) = M(5,6); M(6,6) = sum( fy .* fy );
k = ft + xfx + yfy;
b(1) = sum( k .* xfx ); b(2) = sum( k .* yfx );
b(3) = sum( k .* xfy ); b(4) = sum( k .* yfy );
b(5) = sum( k .* fx ); b(6) = sum( k .* fy );
v = inv(M)*b;
A = [v(1) v(2) ; v(3) v(4)];
T = [v(5) ; v(6)];

% -------------------------------------------------------------------------
%%% WARP IMAGE
function[ f2 ] = warp( f, A, T )
[ydim,xdim] = size( f );
[xramp,yramp] = meshgrid( [1:xdim]-xdim/2, [1:ydim]-ydim/2 );
P = [xramp(:)' ; yramp(:)'];
P = A*P;
xramp2 = reshape( P(1,:), ydim, xdim ) + T(1);
yramp2 = reshape( P(2,:), ydim, xdim ) + T(2);
f2 = interp2( xramp, yramp, f, xramp2, yramp2, 'bicubic' ); % warp
ind = find( isnan(f2) );
f2(ind) = 0;
% -------------------------------------------------------------------------
%%% BLUR AND DOWNSAMPLE (L times)
function[ f ] = down( f, L );
blur = [1 2 1]/4;
for k = 1 : L
f = conv2( conv2( f, blur, 'same' ), blur', 'same' );
f = f(1:2:end,1:2:end);
end
% -------------------------------------------------------------------------
%%% SPACE/TIME DERIVATIVES
function[ fx, fy, ft ] = spacetimederiv( f1, f2 )
%%% DERIVATIVE FILTERS
pre = [0.5 0.5];
deriv = [0.5 -0.5];
%%% SPACE/TIME DERIVATIVES
fpt = pre(1)*f1 + pre(2)*f2; % pre-filter in time
fdt = deriv(1)*f1 + deriv(2)*f2; % differentiate in time
fx = conv2( conv2( fpt, pre', 'same' ), deriv, 'same' );
fy = conv2( conv2( fpt, pre, 'same' ), deriv', 'same' );
ft = conv2( conv2( fdt, pre', 'same' ), pre, 'same' );
% -------------------------------------------------------------------------
%%% ACCUMULATE WARPS
function[ A2, T2 ] = accumulatewarp( Acum, Tcum, A, T )
A2 = A * Acum;
T2 = A*Tcum + T;