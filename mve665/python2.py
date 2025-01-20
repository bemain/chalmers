#%% Uppgift 1
import numpy as np
import matplotlib.pyplot as plt

x=np.linspace(0, 4*np.pi,50)
f=np.sin(x)+0.3*np.sin(4*x)
plt.plot(x,f)


#%%
x=[0.1,0.8,0.9,0.1]
y=[0.2,0.1,0.7,0.2]

plt.subplot(121) # Delar in figuren i 1x2 delar och g ̈or 1:a aktivt
plt.plot(x,y,"-o") # "-o" f ̈orbinder med r ̈ata linjer och markerar med ringar
plt.axis([0,1,0,0.8]) # Ger lite "luft" runt triangeln

plt.subplot(122) # Delar in figuren i 1x2 delar och gör 2:a aktivt
plt.fill(x,y,"green") # Fyller triangeln med grön färg
plt.axis([0,1,0,0.8])


#%% Uppgift 2
t=np.linspace(0,2*np.pi,4)
x=np.cos(t); y=np.sin(t)
plt.plot(x,y)

t=np.linspace(0,2*np.pi)
x=np.cos(t); y=np.sin(t)
plt.plot(x,y)
plt.axis("equal")


#%% Uppgift 3
t=np.linspace(0,2*np.pi, 200)

plt.subplot(121)
plt.plot(np.cos(t)+np.cos(3*t), np.sin(2*t))

plt.subplot(122)
plt.plot(np.cos(t)+np.cos(4*t), np.sin(2*t))


#%% Uppgift 4
fig, ax=plt.subplots()

def f(x): return (x**2 - 1) / (x**2 - x**4)

xn=np.linspace(-8,-0.4)
xp=np.linspace(0.4,8)

ax.plot(xn, f(xn), color="b")
ax.plot(xp, f(xp), color="b")
ax.axis("equal")


ax.plot([0,0],[-8,8],color="red",linestyle="--")


ax.set_xlabel("$x$",fontsize=10)
ax.set_ylabel("$y$",fontsize=10)
ax.set_title("$y = (x^2-1)/(x^2-x^4)$")
