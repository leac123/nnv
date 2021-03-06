function lf=lagrangeRemainder_tank6paramEq(x,u,dx,du,p)

lf=interval();

lf(1,1)=(3*2^(1/2)*109^(1/2)*dx(1)^2*p(1))/(80*x(1)^(3/2));
lf(2,1)=-p(1)*((3*2^(1/2)*109^(1/2)*dx(1)^2)/(80*x(1)^(3/2)) - (3*2^(1/2)*109^(1/2)*dx(2)^2)/(80*x(2)^(3/2)));
lf(3,1)=-p(1)*((3*2^(1/2)*109^(1/2)*dx(2)^2)/(80*x(2)^(3/2)) - (3*2^(1/2)*109^(1/2)*dx(3)^2)/(80*x(3)^(3/2)));
lf(4,1)=-p(1)*((3*2^(1/2)*109^(1/2)*dx(3)^2)/(80*x(3)^(3/2)) - (3*2^(1/2)*109^(1/2)*dx(4)^2)/(80*x(4)^(3/2)));
lf(5,1)=-p(1)*((3*2^(1/2)*109^(1/2)*dx(4)^2)/(80*x(4)^(3/2)) - (3*2^(1/2)*109^(1/2)*dx(5)^2)/(80*x(5)^(3/2)));
lf(6,1)=-p(1)*((3*2^(1/2)*109^(1/2)*dx(5)^2)/(80*x(5)^(3/2)) - (3*2^(1/2)*109^(1/2)*dx(6)^2)/(80*x(6)^(3/2)));
