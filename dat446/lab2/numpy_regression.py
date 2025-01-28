import sys
import numpy as np
from matrix import powers
import matplotlib.pyplot as plt

def main():
    [X, Y] = np.transpose(np.loadtxt(sys.argv[1]))
    n = int(sys.argv[2]) # The degree of the polynomial
    Xp  = np.array(powers(X,0,n))
    Yp  = np.array(powers(Y,1,1))
    Xpt = np.transpose(Xp)

    a = np.matmul(np.linalg.inv(np.matmul(Xpt, Xp)), np.matmul(Xpt, Yp))
    a = a[:,0]
    
    plt.plot(X,Y, "ro")
    smallest = np.min(X)
    biggest = np.max(X)
    X2 = np.linspace(int(smallest), int(biggest), int((biggest - smallest) / 0.2)).tolist()
    plt.plot(X2,[poly(a,x) for x in X2])
    plt.show()

def poly(a,x):
    return sum([a[i] * (x**i) for i in range(len(a))])

if __name__ == "__main__":
    main()