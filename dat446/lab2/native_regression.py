from matrix import Matrix
import sys
import matplotlib.pyplot as plt

def main():
    [X, Y] = Matrix.loadtxt(sys.argv[1]).columns
    Xp  = Matrix.powers(X,0,1)
    Yp  = Matrix.powers(Y,1,1)
    Xpt = Xp.transposed()

    [[b],[m]] = ((Xpt @ Xp).inverted() @ (Xpt @ Yp)).rows
    print(b, m)
    # prediction = b + m * temperature
    plt.plot(X,Y)
    plt.plot(X,Y, "ro")
    plt.show()


if __name__ == "__main__":
    main()