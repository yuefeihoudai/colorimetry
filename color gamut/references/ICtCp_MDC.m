% 参考Perceptual Color Volume：Measuring the Distinguishable Colors of HDR and WCG Displays
% Define EOTF functions
EOTF = @(PQ) (max(PQ.^(32/2523)-(3424/4096),0) ./ ...
 ((2413/128)-(2392/128)*PQ.^(32/2523))).^(16384/2610)*10000;
invEOTF = @(Lin) (((3424/4096)+(2413/128)*(max(0,Lin)/10000).^(2610/16384)) ./ ...
 (1+(2392/128)*(max(0,Lin)/10000).^(2610/16384))).^(2523/32);
% Define lattice points
N = 9;
Nodes = linspace(0,1,N);
[C1,C2,C3] = meshgrid(Nodes,Nodes,[0 1]);
RGB = [C1(:) C2(:) C3(:); C2(:) C3(:) C1(:); C3(:) C1(:) C2(:)];
% Simulate XYZ measurements
Black = 0.1;
White = 100;
M = [3.2410 -0.9692 0.0556; -1.5374 1.8760 -0.2040; -0.4986 0.0416 1.0570];
XYZ = EOTF(RGB * (invEOTF(White) - invEOTF(Black)) + invEOTF(Black)) / M;
%% Step 2 - CONVERTING TO A PERCEPTUALLY UNIFORM COLOR REPRESENTATION
% Convert to ICtCp
XYZ2LMSmat = [0.3593 -0.1921 0.0071; 0.6976 1.1005 0.0748; -0.0359 0.0754 0.8433];
LMS2ICTCPmat = [2048 2048 0; 6610 -13613 7003; 17933 -17390 -543]'/4096;
ICTCP = bsxfun(@times, invEOTF(XYZ * XYZ2LMSmat) * LMS2ICTCPmat, [720, 360, 720]);
%% Step 3 - COMPUTING THE 3D VOLUME – Millions of Distinguishable Colors (MDC)
% Create tessellation of the surface
[i,j,f] = meshgrid(0:N-2, 0:N-2, 0:5);
startidx = f*N*N + i*N + j + 1;
tri = [[startidx(:), startidx(:)+1, startidx(:) + N+1]; ...
 [startidx(:), startidx(:)+N, startidx(:) + N+1]];
% Calculate the volume of the tessellation
v321 = ICTCP (tri(:,3),1) .* ICTCP (tri(:,2),2) .* ICTCP (tri(:,1),3);
v231 = ICTCP (tri(:,2),1) .* ICTCP (tri(:,3),2) .* ICTCP (tri(:,1),3);
v312 = ICTCP (tri(:,3),1) .* ICTCP (tri(:,1),2) .* ICTCP (tri(:,2),3);
v132 = ICTCP (tri(:,1),1) .* ICTCP (tri(:,3),2) .* ICTCP (tri(:,2),3);
v213 = ICTCP (tri(:,2),1) .* ICTCP (tri(:,1),2) .* ICTCP (tri(:,3),3);
v123 = ICTCP (tri(:,1),1) .* ICTCP (tri(:,2),2) .* ICTCP (tri(:,3),3);
v = abs((1/6)*(-v321 + v231 + v312 - v132 - v213 + v123));
MDC = round(sum(v)/1000000,1);
percHDR = round(MDC/43*100);
percSDR = round(MDC/5.1*100);
%% Optional PLOT THE VOLUME
figure(1), clf; view([-37.5 15]);
patch('faces',tri,'vertices', ICTCP(:,[2 3 1]),...
 'facevertexcdata',(EOTF(RGB)/10000).^(1/3),...
 'facecolor','interp','edgealpha',0.1);
xlabel('C_T'),ylabel('C_P'),zlabel('I'); title(sprintf('Color Volume: %.2g MDC',MDC));
xlim([-720/4 720/4]), ylim([-720/2 720/2]), zlim([0 720]), grid on; box on; 