%% Uppgift 1
r=4;
A=pi*r^2


%% Uppgift 2
x=0:0.1:4*pi;
f=sin(x) + 0.3*sin(5*x);
plot(x,f)


%% Uppgift 3
A=[1 4 7 10;
   2 5 8 11;
   3 6 9 12];
b=[1; 
   3; 
   5];
c=[0 2 4 6 8];

size(A)
A(2,3), b(2), c(3)
A(2,3) = 15


%% Uppgift 4
A=[1 5 9;
   2 0 5;
   3 7 11];
b=[29;
   26;
   39];

R=rref([A b])


A=[1 1 3 4;
   -2 2 2 0;
   1 1 2 3;
   1 -1 -2 -1];
b=[2;
   -4;
   1;
   1];

R=rref([A b])
% x = [1-t; -2; 1-t; t];


%% Uppgift 5
s=0;
for i=1:5
    s=s + i^2
end


%% Uppgift 6
function y=my_fun(x)
    y=x.^2 - cos(x);
end

x=linspace(-1.5, 1.5);
y=my_fun(x);
plot(x,y)
grid on

format long
z=[fzero(@my_fun, -1);
   fzero(@my_fun, 1)]


%% Exempel 7
function f=my_diffeq(t,u)
    f=t*cos(t) + sin(4*t)*u;
end

[t, U]=ode45(@my_diffeq, [0,30], 1);
plot(t,U)

