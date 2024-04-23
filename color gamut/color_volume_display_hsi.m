% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];

% Simulate XYZ measurements
XYZ = rgb2hsi(RGB);

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
xlabel('X'),ylabel('Y'),zlabel('Z'); title('HSI');
xlim([-1.5 1.5]), ylim([-1.5 1.5]), zlim([0 1.5]); 
grid on; box on; 

function result = rgb2hsi(rgb)
for i = 1:size(rgb,1)
    [h, s, I] = rgb_HSI(rgb(i,1), rgb(i,2), rgb(i,3), 1);
	%转成直角坐标
	result(i,:) = [s*cos(h*pi/180), s*sin(h*pi/180), I];
end
end

function [h, s, i] = rgb_HSI(r, g, b, max_value)
%https://github.com/josgard94/Image-Processing-Convert-chanel-color-HSI-to-RGB-and-RGB-to-HSI
%对于奇点(未定义点）的不同处理方式：1. 加上无穷小量 2. 强行给出定义。但是需要确保反变换后接近原值
%根据HSI定义，处理不了r+g+b = 0的情况，反变换会被截断为0
    r = r/max_value;
    g = g/max_value;
    b = b/max_value;
    numerador = 0.5*((r-g) + (r-b));
    denominador = sqrt((r-g)^2 + (r - b)*(g - b));
    theta = acos(numerador/(denominador+eps));
    h = theta*180/pi;
    if b > g
        h = 360 - h;
    end
    
    if 0 == r+g+b
        s = 0;
    else
        s = 1 - 3*min([r, g, b])/(r+g+b);
    end
    
    i = (r + g + b)/3;
end