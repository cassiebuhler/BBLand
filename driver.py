# -*- coding: utf-8 -*-
"""
Created on Wed Jul 26 15:27:52 2023

@author: cb3452
"""
from constrainedModel import optimizeC, writeLogC
from unconstrainedModel import optimizeU, writeLogU

import numpy as np
import os
import random
from timeit import default_timer as timer


basePath = "C:/Users/cb3452/OneDrive - Drexel University/bbland/bbland-github"
os.chdir(basePath)

random.seed(0)

# set parameters 
n = 25
#budget = (n*n+1)*5/2
cost =  np.array([random.randint(1,10) for j in range(n*n)])
tmax = 100
numGen = 1
constrained = 0 #constrained or unconstrained model 

if constrained == 1:
# Run optimization code ! 
    startCode = timer()
    my_prob, pop, algo, uda,B_met = optimizeC(n,cost,tmax,numGen)
    endCode = timer()
    totalTime = endCode-startCode #record time 
    writeLogC(n,cost,pop,B_met,tmax,uda,totalTime) #write output 
else: 
    startCode = timer()
    my_prob, pop, algo, uda,B_met = optimizeU(n,cost,tmax,numGen)
    endCode = timer()
    totalTime = endCode-startCode #record time 
    writeLogU(n,cost,pop,B_met,tmax,uda,totalTime) #write output 






