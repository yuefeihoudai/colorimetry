% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];

% Simulate XYZ measurements
XYZ = rgb2hsv(RGB);

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
xlabel('X'),ylabel('Y'),zlabel('Z'); title('HSV');
xlim([-1.5 1.5]), ylim([-1.5 1.5]), zlim([0 1.5]); 
grid on; box on; 

function result = rgb2hsv(rgb)
for i = 1:size(rgb,1)
    [h, s, v] = rgb_HSV(rgb(i,1), rgb(i,2), rgb(i,3), 1);
	%转成直角坐标
	result(i,:) = [s*cos(h*pi/180), s*sin(h*pi/180), v];
end
end

function [h, s, v] = rgb_HSV(r, g, b, max_value)
%https://gist.github.com/yoggy/8999625
%根据HSV定义，处理不了RGB全部小于等于0的情况，反变换会被截断为0
    r = r/max_value;
    g = g/max_value;
    b = b/max_value;

    % Find maximum and minimum values and calculate difference
    maxValue = max([r, g, b]);
    minValue = min([r, g, b]);
    diff = maxValue - minValue;

    % Color space conversion from RGB to HSV
    v = maxValue;

    if maxValue == 0 || diff == 0
        s = 0.0;
        h = 0.0;
    else
        s = diff / maxValue;

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