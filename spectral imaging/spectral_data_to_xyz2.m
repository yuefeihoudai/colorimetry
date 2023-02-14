%spectral_data_to_xyz - Calculate CIE1931 2 degree standard observer XYZ values under D65 illuminant given the object reflectances
%
% Syntax:  [xyz] = spectral_data_to_xyz(reflectances, reflectances_wl)
%
% Inputs:
%  reflectances - Object reflectances
%  reflectances_wl - Wavelenghts of the object reflectances
%
% Example:
%  Calculate CIE1931 2 degree standard observer XYZ values for ColorCheckerClassic
%
%     xyz = spectral_data_to_xyz(ColorChecker.reflectances, ColorChecker.lambda);
%
% Outputs:
%  XYZ - XYZ values of the CIE1931 2 degree standard observer
function XYZ = spectral_data_to_xyz2(reflectances, reflectances_wl, ill, ill_wl)  
   [xyz,wl]=observer('2');
   
   XYZ = [];
   
   X_obs = interp1(wl, xyz(:,1), ill_wl, 'linear', 'extrap');
   Y_obs = interp1(wl, xyz(:,2), ill_wl, 'linear', 'extrap');
   Z_obs = interp1(wl, xyz(:,3), ill_wl, 'linear', 'extrap');
   reflectances = interp1(reflectances_wl, reflectances, ill_wl, 'linear', 'extrap');
   for i=1:size(reflectances,2)
      % use trapezoidal numerical integration to calculate the response for each channel
      x = trapz(reflectances(:,i).*ill.*X_obs);
      y = trapz(reflectances(:,i).*ill.*Y_obs);
      z = trapz(reflectances(:,i).*ill.*Z_obs);
      XYZ = [XYZ; x y z];
   end
   
   % normalization coefficient
   k = 100/trapz(ill.*Y_obs);
   XYZ = k.*XYZ;
end
