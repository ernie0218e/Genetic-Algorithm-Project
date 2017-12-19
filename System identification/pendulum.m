function dydt = pendulum(t, y, rhos)
    a = rhos(1);
    b = rhos(2);
    dydt = zeros(2, 1);
    dydt(1) = y(2);
    dydt(2) = -a*sin(y(1)) - b*y(2);
end