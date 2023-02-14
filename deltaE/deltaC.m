function err = deltaC(Lab_o, Lab_p)

a1 = Lab_o(:,2);
b1 = Lab_o(:,3);

a2 = Lab_p(:,2);
b2 = Lab_p(:,3);

% delta_L = L2 - L1;
% delta_a = a2 - a1;
% delta_b = b2 - b1;
% 
% delta_Cab = sqrt(delta_a.^2 + delta_b.^2);
% err = delta_Cab;

err = sum(abs(sqrt(a1.^2 + b1.^2) - sqrt(a2.^2 + b2.^2));

