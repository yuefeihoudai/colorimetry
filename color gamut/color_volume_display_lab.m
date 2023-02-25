% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];

% Simulate XYZ measurements
rgbType = 'Rec.2020';
XYZ = rgb2xyz_i(RGB, rgbType);
Lab = xyz2lab_i(XYZ, rgbType);

% Create tessellation of the surface
[i,j,f] = meshgrid(0:N-2, 0:N-2, 0:5);
startidx = f*N*N + i*N + j + 1;
tri = [[startidx(:), startidx(:)+1, startidx(:) + N+1]; ...
 [startidx(:), startidx(:)+N, startidx(:) + N+1]];
%% Optional PLOT THE VOLUME
figure, clf; view([-37.5 15]);
patch('faces',tri,'vertices', Lab(:,[2 3 1]),...
 'facevertexcdata',RGB.^(1/2.2),...
 'facecolor','interp','edgealpha',0.1);
xlabel('a'),ylabel('b'),zlabel('L'); title(rgbType);
xlim([-180 180]), ylim([-180 180]), zlim([0 150]); 
grid on; box on; 


function output = rgb2xyz_i(input, rgbType)
switch rgbType
   case 'sRGB'
       M = [0.412390799265959   0.357584339383878   0.180480788401834;
            0.212639005871510   0.715168678767756   0.072192315360734;
            0.019330818715592   0.119194779794626   0.950532152249661];
   case 'DCI-P3'
       M = [0.445169815564552   0.277134409206778   0.172282669815565;
            0.209491677912731   0.721595254161044   0.068913067926226;
           -0.000000000000000   0.047060560053981   0.907355394361973];
   case 'Display-P3'
       M = [0.486570948648216   0.265667693169093   0.198217285234362
            0.228974564069749   0.691738521836506   0.079286914093745
           -0.000000000000000   0.045113381858903   1.043944368900976];  
   case 'Rec.2020'
       M = [0.636958048301291   0.144616903586208   0.168880975164172;
            0.262700212011267   0.677998071518871   0.059301716469862;
            0.000000000000000   0.028072693049087   1.060985057710791];   
   otherwise
       M = [0.412390799265959   0.357584339383878   0.180480788401834;
            0.212639005871510   0.715168678767756   0.072192315360734;
            0.019330818715592   0.119194779794626   0.950532152249661];
end

output = (M * input')';

end

function output = xyz2lab_i(input, rgbType)
switch rgbType
   case 'sRGB'
      xy_w = [0.3127, 0.3290];  
   case 'DCI-P3'
      xy_w = [0.314, 0.351];
   case 'Display-P3'
      xy_w = [0.3127, 0.3290];  
   case 'Rec.2020'
      xy_w = [0.3127, 0.3290];
   otherwise
      xy_w = [0.3127, 0.3290];  
end

Xn = xy_w(1)/xy_w(2);
Yn = 1;
Zn = (1-xy_w(1)-xy_w(2))/xy_w(2);

output(:,1) = 116 * labfun(input(:,2)/Yn) - 16;
output(:,2) = 500 * (labfun(input(:,1)/Xn)-labfun(input(:,2)/Yn));
output(:,3) = 200 * (labfun(input(:,2)/Yn)-labfun(input(:,3)/Zn));
end


function [result] = labfun( in )
z = in > 0.008856;
result(z) = in(z).^(1/3);
result(~z) = (903.3*in(~z) + 16)/116;
end