# -*- coding: utf-8 -*-
"""
Created on September 24, 2025

@author: Annika Lang, TMS150 & MSG400
"""
#%%

import random

M = 100000

random.seed()

mu = 0
sigma = 1

average = 0

for m in range(M):
    average += random.gauss(mu,sigma)
    
average = average/M

print(average)
