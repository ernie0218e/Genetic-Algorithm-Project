function dydt = invPendulum(t, y, F, rhos)
%     rhos = zeros(5, 1);
%     rhos(1) = (InvPend.m*InvPend.g*InvPend.l)/(InvPend.I+InvPend.m*InvPend.l^2);
%     rhos(2) = (InvPend.m*InvPend.l)/(InvPend.I+InvPend.m*InvPend.l^2);
%     rhos(3) = -(InvPend.b)/(InvPend.M+InvPend.m);
%     rhos(4) = (InvPend.m*InvPend.l)/(InvPend.M+InvPend.m);
%     rhos(5) = -(InvPend.m*InvPend.l)/(InvPend.M+InvPend.m);
    dydt = zeros(4, 1);
    dydt(1) = y(2);
    dydt(2) = 1/(1-rhos(2)*rhos(4)*cos(y(1))^2)*(rhos(1)*sin(y(1)) + rhos(2)*cos(y(1))*F ...
        +rhos(2)*rhos(3)*y(4)*cos(y(1))+rhos(2)*rhos(5)*(y(2))^2*sin(y(1))*cos(y(1)));
    dydt(3) = y(4);
    dydt(4) = 1/(1-rhos(4)*rhos(2)*cos(y(1))^2) ...
        *(F+rhos(3)*y(4)+rhos(4)*rhos(1)*sin(y(1))*cos(y(1))+rhos(4)*(y(2))^2*sin(y(1)));
end