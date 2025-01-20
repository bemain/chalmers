%% Uppgift 1
function [x,y]=cirkel(a,b,r)
    % Returnera punkter utmed en cirkel med radien r och centrum i (a,b).
    t=linspace(0, 2*pi, 50);
    x=a + r*cos(t);
    y=b + r*sin(t);
end

[x,y]=cirkel(0,0,2);
size(x)
plot(x,y)
axis equal
help cirkel % Funkar inte då cirkel inte ligger i en egen fil


%% Uppgift 2
clf
[x,y]=ginput();
x=[x; x(1)]; y=[y; y(1)];
plot(x,y,"-o")


%% Uppgift 3
function [x,y]=cirkel2(a,b,r,n)
    % Returnera n punkter utmed en cirkel med radien r och centrum i (a,b).
    if nargin ~= 4
        n=100;
    end
    t=linspace(0, 2*pi, n);
    x=a + r*cos(t);
    y=b + r*sin(t);
end

[x,y]=cirkel2(0,0,2,10);
size(x)
plot(x,y)
axis equal


%% Uppgift 4
function L=polylen(x,y)
    L=0;
    for i=1:length(x)-1
        L=L+ sqrt((x(i+1) - x(i))^2 + (y(i+1) - y(i))^2);
    end
end

function A=polyarea(x,y)
    A=0;
    for i=1:length(x)-1
        A=A+(x(i+1)+x(i))*(y(i+1)-y(i));
    end
    A=abs(A)/2;
end


x=[1 1 0 0, 1];
y=[1 0 0 1, 1];

plot(x,y)
axis equal

polylen(x,y)
polyarea(x,y)


%% Uppgift 5
function s=estimate_pi(tol)
    % Estimate the square root of c with the given tolerance c
    if nargin ~= 1
        tol=0.5e-5;
    end
    s=0; n=0;
    while abs(pi-s*4) > tol
        s=s+ (-1)^n / (2*n+1);
        n=n+1;format long
    end
    s=s*4;
end

estimate_pi()


%% Uppgift 6
clf; axis([0 1 0 1]); hold on

x_pol=[]; y_pol=[];
while true
    [x,y,b]=ginput(1);
    if b~=1
        x_pol=[x_pol x_pol(1)]; y_pol=[y_pol y_pol(1)];
        break
    end
    x_pol=[x_pol x]; y_pol=[y_pol y];
    plot(x_pol,y_pol, "-o")
end

fill(x_pol,y_pol,"g")
L=polylen(x_pol, y_pol)
A=polyarea(x_pol, y_pol)

hold off