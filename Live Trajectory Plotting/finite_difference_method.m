

N = 10000;
X0 = 0.07; %0.07 good for hrydogen X1=300, N=8000
X1 = 2000;
x = linspace(X0,X1,N);

dx=x(2)-x(1);
l=0;
Z1=3;
U = -3./x + l*(l+1)./(2*x.^2)-2*(1-(1+Z1.*x./1).*exp(-2*Z1.*x./1)); %input function of V of r
% U=-1./x;
%D matrix
e = ones(N,1);
D = spdiags([e -2*e e],-1:1,N,N)/dx;
%apply conditions of zero at start and end
startcond = 0.005;
D(1,1) = startcond; D(1,2) = startcond; D(2,1) = startcond; %f(o) = 0
D(N,N-1) =0; D(N-1,N)=0; D(N,N) = 0; %f(N) =0;

V = diag(U);
H = -1/2*D+V;

[psiE, E] = eig(H);
Esort = sort(diag(E));
Esort(1:5)

figure(1)
plot(x, U)
figure(2)
plot(x,abs(psiE(3,:))) 


