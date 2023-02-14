% 参考https://gitee.com/mirrors/Colour
% https://www.mathworks.com/matlabcentral/fileexchange/40640-computational-colour-science-using-matlab-2e
% Pointer, M. R. (1980). Pointer's Gamut Data. Retrieved from http://www.cis.rit.edu/research/mcsl2/online/PointerData.xls

function [] = rgb_color_gamut()
cieplot();

% %Rec.709
rec709_xyz_r = [0.640, 0.330];
rec709_xyz_g = [0.300, 0.600];
rec709_xyz_b = [0.150, 0.060];
rec709_x = [rec709_xyz_r(1), rec709_xyz_g(1), rec709_xyz_b(1), rec709_xyz_r(1)];
rec709_y = [rec709_xyz_r(2), rec709_xyz_g(2), rec709_xyz_b(2), rec709_xyz_r(2)];

% %Display-P3
displayp3_xyz_r = [0.680, 0.320];
displayp3_xyz_g = [0.265, 0.690];
displayp3_xyz_b = [0.150, 0.060];
displayp3_x = [displayp3_xyz_r(1), displayp3_xyz_g(1), displayp3_xyz_b(1), displayp3_xyz_r(1)];
displayp3_y = [displayp3_xyz_r(2), displayp3_xyz_g(2), displayp3_xyz_b(2), displayp3_xyz_r(2)];

%Rec.2020
rec2020_xyz_r = [0.708, 0.292];
rec2020_xyz_g = [0.170, 0.797];
rec2020_xyz_b = [0.131, 0.046];
rec2020_x = [rec2020_xyz_r(1), rec2020_xyz_g(1), rec2020_xyz_b(1), rec2020_xyz_r(1)];
rec2020_y = [rec2020_xyz_r(2), rec2020_xyz_g(2), rec2020_xyz_b(2), rec2020_xyz_r(2)];

p1 = plot(rec709_x, rec709_y);
p2 = plot(displayp3_x, displayp3_y);
p3 = plot(rec2020_x, rec2020_y);

%display The Pointer’s Gamut
pointer_gamut = load('pointer_gamut.txt');
p4 = plot(pointer_gamut(:,1), pointer_gamut(:,2));

legend([p1 p2 p3 p4], {'Rec.709', 'DisplayP3', 'Rec.2020', 'Pointer’s Gamut'});
end