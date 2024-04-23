% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];

% Simulate XYZ measurements
rgbType = 'sRGB';
yuv = rgb_ycbcr(RGB, rgbType);

% Create tessellation of the surface
[i,j,f] = meshgrid(0:N-2, 0:N-2, 0:5);
startidx = f*N*N + i*N + j + 1;
tri = [[startidx(:), startidx(:)+1, startidx(:) + N+1]; ...
 [startidx(:), startidx(:)+N, startidx(:) + N+1]];
%% Optional PLOT THE VOLUME
figure, clf; view([-37.5 15]);
patch('faces',tri,'vertices', yuv(:,[2 3 1]),...
 'facevertexcdata',RGB.^(1/2.2),...
 'facecolor','interp','edgealpha',0.1);
xlabel('U'),ylabel('V'),zlabel('Y'); title(rgbType);
xlim([0 1.5]), ylim([0 1.5]), zlim([0 1.5]); 
grid on; box on; 

function [result] = rgb_ycbcr(rgb, colorgamut)
rgb2ycbcrmatrix = rgb2yuv(colorgamut);
result = (rgb2ycbcrmatrix*rgb')';
offset = 0.5;
result(:,2:3) = result(:,2:3) + offset;
end

function result = rgb2yuv(colorgamut)
switch colorgamut
	case {'BT.709', 'sRGB'}
		xyz_r = [0.640, 0.330];
		xyz_g = [0.300, 0.600];
		xyz_b = [0.150, 0.060];
		xyz_w = [0.3127, 0.3290];
	case 'Wide Gamut RGB'
		xyz_r = [0.7347, 0.2653];
		xyz_g = [0.1152, 0.8264];
		xyz_b = [0.1566, 0.0177];
		xyz_w = [0.3457, 0.3585];
	case 'DCI-P3'
		xyz_r = [0.680, 0.320];
		xyz_g = [0.265, 0.690];
		xyz_b = [0.150, 0.060];
		xyz_w = [0.314, 0.351];
	case 'Display-P3'
		xyz_r = [0.680, 0.320];
		xyz_g = [0.265, 0.690];
		xyz_b = [0.150, 0.060];
		xyz_w = [0.3127, 0.3290];
	case {'BT.2020', 'BT.2100'}
		xyz_r = [0.708, 0.292];
		xyz_g = [0.170, 0.797];
		xyz_b = [0.131, 0.046];
		xyz_w = [0.3127, 0.3290];
	otherwise
		xyz_r = [0.640, 0.330];
		xyz_g = [0.300, 0.600];
		xyz_b = [0.150, 0.060];
		xyz_w = [0.3127, 0.3290];
end
temp = [xyz_r(1)/xyz_r(2) xyz_g(1)/xyz_g(2) xyz_b(1)/xyz_b(2); 1 1 1; (1 - xyz_r(1) - xyz_r(2))/xyz_r(2) (1 - xyz_g(1) - xyz_g(2))/xyz_g(2) (1 - xyz_b(1) - xyz_b(2))/xyz_b(2)];
C = temp^(-1) * [xyz_w(1)/xyz_w(2); 1;  (1 - xyz_w(1) - xyz_w(2))/xyz_w(2)];
rgb2xyz = temp * diag(C);
Kr = rgb2xyz(2,1);
Kg = rgb2xyz(2,2);
Kb = rgb2xyz(2,3);
result = [Kr Kg Kb; (-Kr)/(2*(1-Kb)), (-Kg)/(2*(1-Kb)), ((1- Kb))/(2*(1-Kb)); ((1 -Kr))/(2*(1-Kr)), (-Kg)/(2*(1-Kr)), (- Kb)/(2*(1-Kr))];
end