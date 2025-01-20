%% Uppgift 1
A=[1 4 7 10;
   2 5 8 11;
   3 6 9 12];
c=[0 2 4 6 8];

v=tan(c)
V=tan(A)


%% Uppgift 2
d=linspace(2,14,5)
%e=2:3:14


%% Uppgift 3
x= linspace(0,8);
y= x - x.*cos(7*x);
plot(x,y)
title("f(x) = x - xcos(7x)")


%% Uppgift 4
t=linspace(0,2*pi);
x=cos(t)+cos(3*t);
y=sin(2*t);

subplot(2,1,1)
plot(x,y)
axis equal
grid on


x=cos(t)+cos(4*t);
y=sin(2*t);

subplot(2,1,2)
plot(x,y)
axis equal
grid on


%% Uppgift 5
t=linspace(0,2*pi);
subplot(2,1,1)
fill(cos(t),sin(t), "g")
axis equal

subplot(2,1,2)
fill(cos(t),sin(t), "g")
hold on
s=1/sqrt(2);
fill([-s,s,s,-s,-s], [s,s,-s,-s,s], "y")
axis equal
hold off


%% Uppgift 6
function y=kastbana(x,theta)
   t=theta*pi/180;
   v0=10; y0=1.85; g=9.81;
   a=g/(2*v0^2*cos(t)^2);
   b=v0^2*sin(2*t)/(2*g);
   c=v0^2*sin(t)^2/(2*g);
   y=y0-a*(x-b).^2+c;
end

x=linspace(0,14);
plot([0 14], [0 0], "g") % Gräsmatta
hold on

plot(x, kastbana(x, 15)); text(6.4, 1.6, "15^o");
plot(x, kastbana(x, 30)); text(6.4, 3.2, "30^o");
plot(x, kastbana(x, 45)); text(6.4, 4.6, "45^o");

title("Kastbana med v_0=10m/s och olika \theta")
xlabel("x"); ylabel("y");
axis equal; axis([0 14 -2 6]);
hold off


%% Uppgift 7
subplot(1,1,1)
x=linspace(-2,2,30); y=linspace(-2,2,30);
[X, Y] = meshgrid(x,y);
Z=-X.*Y.*exp(-2*(X.^2 + Y.^2));
surf(X,Y,Z);
%lighting gouraud, camlight right
grid on




%% Exempel 6
r=1.5; h=6;
s=linspace(0,h,20); t=linspace(0,2*pi,20);
[S,T] = meshgrid(s,t);
X=r*cos(T); Y=r*sin(T); Z=S;
surf(X,Y,Z)
colormap("cool")