#%% Uppgift 1
import numpy as np
import matplotlib.pyplot as plt

def f(x): return x**3 - np.cos(4*x)
def Df(x): return 3*x**2 + 4*np.sin(4*x)

v=np.linspace(-2, 2,100)
plt.plot(v,f(v))

def find_root(f, Df, x0, kmax=10, tol=0.5e-8):
    x=x0
    for k in range(kmax):
        h=-f(x)/Df(x)
        x+=h
        if abs(h) < tol: break
    return (x,h)

print(find_root(f, Df, -1))
print(find_root(f, Df, -0.5))
print(find_root(f, Df, 0.5))


#%% Uppgift 2
from scipy.optimize import fsolve

def r(v): return (2 + np.sin(3*v)) / np.sqrt(1 + np.exp(np.cos(v)))
def c(v): return np.full_like(v, 1)

v = np.linspace(0, 2*np.pi, 200)
plt.plot(v, r(v))
plt.plot(v, c(v))

plt.ginput()


#%% Uppgift 3
from scipy.optimize import fminbound
def y(u): return np.sin(u)**2 / (u**2)
def h(u): return -y(u)

u = np.linspace(-10, 10, 200)
plt.plot(u, y(u))

# Oändligt antal lokala maxpunkter
u=fminbound(h,2,6)
print(u, y(u))


#%% Uppgift 4
def f(x): return x*np.sin(x)

x = np.linspace(-20, 20, 200)
plt.plot(x, f(x))

a=0; b=1
n=100
x=np.linspace(0,1,n+1)
h=(b-a)/n
V=sum(h*f(x[0:n]))
H=sum(h*f(x[1:n+1]))
M=sum(h*f((x[0:n] + x[1:n+1]) / 2))
T=sum((h/2) * (f(x[0:n]) + f(x[1:n+1])))
print(V,H,M, T)

#%% Uppgift 5
from scipy.integrate import quad

def g(x): return np.exp(-x**2/2)
def h(x): return x**2 - 3*x + 2
def d(x): return g(x)-h(x)

x = np.linspace(0, 3, 200)
plt.plot(x, g(x), x, h(x))

a = fsolve(d, 0.5)
b = fsolve(d, 2)

q=quad(d,a,b)
print(q)


#%% Uppgift 6
from scipy.integrate import solve_ivp

def f(t,u): return np.cos(3*t) - np.sin(5*t)*u

tspan=[0,15]; u0=[2]
sol=solve_ivp(f,tspan,u0,dense_output=True)

t=np.linspace(*tspan, 200)
U=sol.sol(t)
plt.plot(t, U[0])