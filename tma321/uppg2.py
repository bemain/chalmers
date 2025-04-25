import numpy as np
from matplotlib import pyplot as plt



# Simulera normalfördelad data
simulated = np.random.normal(0, 1, 100000)
simulated = np.round(simulated, 1)
acc = {}
for x in simulated:
    acc[x] = acc.get(x, 0) + 1


plt.plot(acc.keys(), acc.values(), "o")
plt.show()