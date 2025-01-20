#%% Uppgift 1
import numpy as np
import matplotlib.pyplot as plt

r = 4
V = np.pi * r**2
print(round(V,2))

#%% Uppgift 2
x = np.linspace(0, 4*np.pi, 100)
f = x * np.sin(x)

plt.plot(x, f)

#%%
from scipy.optimize import fsolve

def my_fun(x):
    return x**2-np.cos(x)

x=np.linspace(-1.5,1.5)
y=my_fun(x)
plt.plot(x,y)
plt.grid("on")

z=fsolve(my_fun,1)
print("Nollstället nära x=1 är",z)
