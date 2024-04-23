% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];

% Simulate XYZ measurements
XYZ = rgb2hsl(RGB);

% Create tessellation of the surface
[i,j,f] = meshgrid(0:N-2, 0:N-2, 0:5);
startidx = f*N*N + i*N + j + 1;
tri = [[startidx(:), startidx(:)+1, startidx(:) + N+1]; ...
 [startidx(:), startidx(:)+N, startidx(:) + N+1]];
%% Optional PLOT THE VOLUME
figure, clf; view([-37.5 15]);
patch('faces',tri,'vertices', XYZ(:,[1 2 3]),...
 'facevertexcdata',RGB.^(1/2.2),...
 'facecolor','interp','edgealpha',0.1);
xlabel('X'),ylabel('Y'),zlabel('Z'); title('HSL');
xlim([-1.5 1.5]), ylim([-1.5 1.5]), zlim([0 1.5]); 
grid on; box on; 

function result = rgb2hsl(rgb)
for i = 1:size(rgb,1)
    [h, s, L] = rgb_HSL(rgb(i,1), rgb(i,2), rgb(i,3), 1);
	%转成直角坐标
	result(i,:) = [s*cos(h*pi/180), s*sin(h*pi/180), L];
end
end

function [h, s, l] = rgb_HSL(r, g, b, max_value)
%https://github.com/ratkins/RGBConverter/blob/master/RGBConverter.cpp
%根据HSL定义，处理不了maxValue + minValue = 0 || maxValue + minValue = 2
%的情况，反变换会被截断为0
    r = r/max_value;
    g = g/max_value;
    b = b/max_value;
    
    maxValue = max([r, g, b]);
    minValue = min([r, g, b]);
    l = (maxValue + minValue) / 2;
    diff = maxValue - minValue;
    
    if maxValue == minValue
        h = 0;
        s = 0;
    else
        if l > 0.5
            s = diff / (2 - maxValue - minValue + eps);
        else
            s = diff / (maxValue + minValue + eps);
        end

        if maxValue == r
            h = 60.0 * (g - b) / diff ;
        elseif maxValue == g
            h = 60.0 * (b - r) / diff + 120.0;
        else
            h = 60.0 * (r - g) / diff + 240.0;
        end
    end
    
   if h < 0 
        h = h + 360.0;
    end
end