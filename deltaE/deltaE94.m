function err = deltaE94(Lab_o, Lab_p)

L1 = Lab_o(:,1)';
a1 = Lab_o(:,2)';
b1 = Lab_o(:,3)';

L2 = Lab_p(:,1)';
a2 = Lab_p(:,2)';
b2 = Lab_p(:,3)';

delta_L = L2 - L1;
delta_a = a2 - a1;
delta_b = b2 - b1;

delta_C = sqrt(a1.^2 + b1.^2) - sqrt(a2.^2 + b2.^2);
delta_H = sqrt(delta_a.^2 + delta_b.^2 - delta_C.^2);
C = sqrt(sqrt(a1.^2 + b1.^2) .* sqrt(a2.^2 + b2.^2));
S_C = 1 + 0.045 * C;
S_H = 1 + 0.015 * C;
delta_E94 = sqrt(delta_L.^2 + (delta_C ./ S_C).^2 + (delta_H ./ S_H).^2);
err = sum(delta_E94);