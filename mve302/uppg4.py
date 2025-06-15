#%% Fjärde uppgiften

import matplotlib.pyplot as plt
import numpy as np

data = np.genfromtxt('birth.dat')

vikt = data[:,2]
m_vikt = data[:,14]
m_langd = data[:,15]
aldersgrupp = data[:,17]
rokvanor = data[:,19]
rokexponering = data[:,23]
alkohol = data[:,25]
motion = data[:,24]


BMI = m_vikt / ((m_langd / 100) ** 2)

behall = np.full(len(vikt), True)
behall = behall & np.all(~np.isnan([vikt, m_vikt, m_langd, aldersgrupp, rokvanor, rokexponering, alkohol, motion]))
behall = behall & ~(aldersgrupp == 3)
behall = behall & ~(rokvanor == 3)
behall = behall & ~(rokexponering == 3)
behall = behall & ~(alkohol == 2)
behall = behall & ~(motion == 2)
behall = behall & (BMI >= 18.5) & (BMI <= 25)


vikt_clean = vikt[behall] / m_langd[behall]
print(len(vikt_clean))




[counts, bins] = np.histogram(vikt_clean, 50)
plt.hist(bins[:-1], bins, weights=counts)

plt.xlabel("Födelsevikt / Moderns vikt [g]")
plt.ylabel("Antalet observationer")

plt.show()

# %%
