function err = deltaE(Lab_o, Lab_p)

L1 = Lab_o(:,1);
a1 = Lab_o(:,2);
b1 = Lab_o(:,3);

L2 = Lab_p(:,1);
a2 = Lab_p(:,2);
b2 = Lab_p(:,3);

delta_L = L1 - L2;
delta_a = a1 - a2;
delta_b = b1 - b2;

err = sum(sqrt(delta_L.^2 + delta_a.^2 + delta_b.^2));

