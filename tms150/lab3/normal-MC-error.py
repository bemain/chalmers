# -*- coding: utf-8 -*-
"""
Created on September 24, 2025

@author: Annika Lang, TMS150 & MSG400
"""
#%%

import random
import numpy as np
import matplotlib.pyplot as plt

K = 10


random.seed()

mu = 0
sigma = 1

sample_size= np.zeros(K)

for k in range(K):
    sample_size[k] = 2**(k+1)

print(sample_size)


average = np.zeros(K)

error_av = np.zeros(K)

average_1 = 0

for m in range(int(sample_size[K-1])):
    average_1 += random.gauss(mu,sigma)
    for k in range(K):
        if m == int(sample_size[k]):
            average[k] = average_1
            error_av[k] = np.abs(average[k]-mu)/sample_size[k]
    
print(error_av)

plt.loglog(sample_size,error_av)
plt.loglog(sample_size,1/np.sqrt(sample_size))   

plt.savefig('normal_error.pdf')