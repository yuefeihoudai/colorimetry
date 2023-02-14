% ===================================================
% *** FUNCTION pca_demo
% ***
% *** function pca_demo
% *** performs svd on set of spectra
% ===================================================
function recon = pca_demo(numbas, w, spectra)
% P is n by w
% subtract the mean
m = mean(spectra);
diff = spectra-ones(size(spectra,1),1)*m;
% compute the covariance matrix
cova = (diff'*diff)/(size(spectra,1)-1);
% find the eigenvectors and eigenvalues
[pc,e]=eig(cova);
e = diag(e);
% sort the variance in decreasing order
[~, rindices]=sort(-1*e);
v1 = pc(:,rindices);
% only keep the first numbas
v1 = v1(:,1:numbas);
plot(w,v1);
% the columns of pc contain the eigenvectors
title('basis function with centering')
xlabel('wavelength')

% find the weights
x1 = diff/v1';

% reconstruct the spectra from the weights
recon = x1*v1'+ones(size(spectra,1),1)*m;
end


    
    
    