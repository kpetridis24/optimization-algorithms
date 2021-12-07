function [xk, fValues, kValues] = levenbergMarquardt_armijo(f,x1,limit)
fValues = [];
kValues = [];

xk = x1.x;
yk = x1.y;
k = 1;

syms x y g;
J = jacobian(f, [x,y]);
H = hessian(f, [x,y]);
Jval = vpa(subs(J, [x,y], [xk,yk]));
Hval = vpa(subs(H, [x,y], [xk,yk]));

fValues(1) = subs(f,[x,y],[xk,yk]);
kValues(1) = k;

while norm(Jval) >= limit
    m = 0;
    P = Hval + m * eye(size(Hval));
    while P(1,1)<=0 || P(1,1)*P(2,2)-P(1,2)*P(2,1)<=0
        m = m + 1;
        P = Hval + m * eye(size(Hval));
    end
    d = -Jval / P;
    [xk,yk] = armijo(f,xk,yk,d);
    Jval = vpa(subs(J, [x,y], [xk,yk]));
    Hval = vpa(subs(H, [x,y], [xk,yk]));
    fValues(k + 1) = subs(f, [x,y], [xk,yk]);
    kValues(k + 1) = k;
    k = k + 1;
end

xk = [xk, yk];
end

