%% Uppgift 1
function x=find_root(f, Df, x, tol)
    if nargin ~= 4
        tol=0.5e-8;
    end

    h=1;
    while abs(h)>tol
        h= -f(x)/Df(x);
        x=x+h;
    end
end

f=@(x) x.^3 - cos(4*x);
Df=@(x) 3*x.^2 + 4*sin(4*x);

x=linspace(-2,2);
plot(x,f(x))
axis ([-2 2 -2 2])
hold on

roots=[find_root(f,Df,-1)
       find_root(f,Df,-0.5)
       find_root(f,Df,0.5)]
plot(roots,f(roots),"o")
hold off


%% Uppgift 2
r=@(v) (2 + sin(3.*v)) ./ sqrt(1 + exp(cos(v)));
c=@(x) cos(x).^2 + sin(x).^2; % Enhetscirkeln

x=linspace(0,2*pi);

clf
polarplot(x,r(x))
hold on
polarplot(x,c(x))

[x,y]=ginput(1);
root=fzero(@(v) r(v)-c(v),x);
plot(root,r(root),"o")
hold off


%% Uppgift 3
y=@(u) sin(u).^2 ./ u.^2;
h=@(u) -y(u);

clf
x=linspace(-10,10,300);
plot(x,y(x))
axis padded

% Det finns oändligt många lokala maximum

x=fminbnd(h, 3, 8);
disp([x y(x)])


%% Uppgift 4
n=100;
a=0; b=1; 
f=@(x) x.*sin(x);

x=linspace(a,b,n+1);
h=(b-a)/n;

V=sum(h*f(x(1:n))) % Vänster
H=sum(h*f(x(2:n+1))) % Höger
M=sum(h*f((x(1:n) + x(2:n+1))./2)) % Mitten
T=sum((h/2)*(f(x(1:n))+ f(x(2:n+1)))) % Trapets


%% Uppgift 5
g=@(x) exp(-1 .*x.^2./2);
h=@(x) x.^2 - 3.*x + 2;
diff=@(x) g(x)-h(x);

% Rita graf
x=linspace(0,3);
clf
plot(x,g(x))
hold on
plot(x,h(x))
hold off

a=fzero(diff, 0.5);
b=fzero(diff, 2);

q=integral(diff, a,b)


%% Uppgift 6
f=@(t,u) cos(3*t) - sin(5*t)*u;
tspan=[0 15];
u0=2;

[t,U] = ode45(f, tspan, u0);
plot(t,U);


%% Uppgift 7
function f=pendel(t,u,L)
    f=[u(2)
    -9.82*sin(u(1))/L];
end

clf
hold on

L=0.1; tspan=[0 3]; u0=[pi/6 0];
[t,U]=ode45(@(t,u) pendel(t,u,L),tspan,[pi/6 0]);
plot(t,U(:,1),"b")
[t,U]=ode45(@(t,u) pendel(t,u,L),tspan,[pi/4 0]);
plot(t,U(:,1),"g")
[t,U]=ode45(@(t,u) pendel(t,u,L),tspan,[pi/3 0]);
plot(t,U(:,1),"r")
xlabel("t"), ylabel("x(t)")

hold off