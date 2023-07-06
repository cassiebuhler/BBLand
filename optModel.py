#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 23 11:58:00 2022

@author: cassiebuhler
"""

import gurobipy as gp
from gurobipy import GRB
import numpy as np


def optimize(bigN,budget,weighted):
    S,P = np.shape(bigN) #num of species, num of pixels
    cost = np.ones((P)) #cost
    if weighted == 1:
        # w = np.array([0.1,0.9]) #species 1 with 0.2 and species 2 with weight 0.8
        w = np.array([0.9,0.1]) #species 1 with 0.2 and species 2 with weight 0.8

        # w = np.array([0.2,0.8]) #species 1 with 0.2 and species 2 with weight 0.8
    else:
        w = np.ones((S))/S #weight

        # w = np.ones((S)) #weight
    # budget = P/2 # budget , preserve half of pixels 

    #create model
    m = gp.Model('p4')
    
    #create variables
    x = m.addMVar(shape=P, vtype=GRB.BINARY, name="x")
    
    #set objective
    m.setObjective(w@bigN@x, GRB.MAXIMIZE)
    
    #add constraints 
    m.addConstr(x@cost<= budget, name = "budget")


    
    
    #solve model
    m.optimize()
    
    #print results
    print(x.X)
    print('Obj:%g' %m.ObjVal)
    return(x.X)

