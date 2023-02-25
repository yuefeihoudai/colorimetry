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
rgbType = 'sRGB';
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

XYZ = (M * (EOTF(RGB * (invEOTF(White) - invEOTF(Black)) + invEOTF(Black)))')';
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
%% Optional PLOT THE VOLUME
figure, clf; view([-37.5 15]);
patch('faces',tri,'vertices', ICTCP(:,[2 3 1]),...
 'facevertexcdata',(EOTF(RGB)/10000).^(1/3),...
 'facecolor','interp','edgealpha',0.1);
xlabel('C_T'),ylabel('C_P'),zlabel('I'); title(rgbType);
xlim([-720/4 720/4]), ylim([-720/2 720/2]), zlim([0 720]), grid on; box on; 