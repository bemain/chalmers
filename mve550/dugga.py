#%% Fråga 1
import struct
def binary(num):
    return ''.join('{:0>8b}'.format(c) for c in struct.pack('!f', num))

a = binary(2.4)
print(" ".join([a[i:i+4] for i in range(0, len(a), 3)]))


#%% Fråga 2
from math import sqrt

def f(x):
    return sqrt(x**2 + 2) - sqrt(x**2 + 1)

def f2(x):
    return 2 / (sqrt(x**2 + 2) + sqrt(x**2 + 1))

n = 10
print(f(10**n))

for n in range(1, 1000):
    actual = f2(10**n)
    estimated = f(10**n)
    print(abs(actual - estimated) / actual)
    if abs(actual - estimated) / actual >= 1:
        print("n", n)
        break


print(f2(10**n))


#%% Fråga 3
import math as m
def f(x):
    return 3*x - 6 - m.log(x)

def df(x):
    return 3 - 1/x

x0 = 4
x1 = x0 - f(x0) / df(x0)
print(x1)
x2 = x1 - f(x1) / df(x1)
print(x2)

# Feluppskattning
dx = f(x2) / df(x2)
print("Feluppskattning:", dx)


#%% Fråga 4
import math as m
import numpy as np

def f(x):
    return np.array([
            3 + x[0] - 3*x[1],
            x[1]**3 - x[0] + 4
           ])

def df(x):
    return np.array([
            [1, -3],
            [-1, 3*x[1]**2]
           ])

x0 = np.array([3,3])

x1 = x0 - np.linalg.inv(df(x0)) @ f(x0)
print(x1)
x2 = x1 - np.linalg.inv(df(x1)) @ f(x1)
print(x2)


#%% Fråga 6
print(4* (8**5) / 2880)


#%% Fråga 7

A = np.array([
    [1, 1e-10, 2],
    [0, 1e-10, 1],
    [1, -1e-10, 2],
    [0, -1e-10, 1],
    ])
b = np.array([[1],[1],[1],[1]])

x = np.linalg.inv(np.matrix.transpose(A) @ A) @ (np.matrix.transpose(A) @ b)
print(x)

print("Konditionstal:", np.linalg.cond(np.matrix.transpose(A) @ A))


Q, R = np.linalg.qr(A)
x = np.linalg.inv(R) @ np.matrix.transpose(Q) @ b
print(x)
print("Konditionstal:", np.linalg.cond(R))