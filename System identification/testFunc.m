function dydt = testFunc(t, y, coeff)
       
    dydt = zeros(2, 1);
    dydt(1) = y(2);
    dydt(2) = -coeff(1)*sin(y(1))-coeff(2)*y(2);
end