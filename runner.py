#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 20 05:48:32 2022

@author: hvb22
"""
import numpy as np
from TwoSym import *
from FiveSym import *
from optModel import *
from generatingPlots import *

import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import re
import itertools

#reading in data 
n = 10 #grid size 
f1name = 'speciesCountPerPixel/high1_10x10_N100_speciesCountPerPixel.txt'
f2name = 'speciesCountPerPixel/high2_10x10_N100_speciesCountPerPixel.txt'
f3name = 'speciesCountPerPixel/high1_10x10_N250_speciesCountPerPixel.txt'
f4name = 'speciesCountPerPixel/high2_10x10_N250_speciesCountPerPixel.txt'
f5name = 'speciesCountPerPixel/low1_10x10_N100_speciesCountPerPixel.txt'
f6name = 'speciesCountPerPixel/low2_10x10_N100_speciesCountPerPixel.txt'
f7name = 'speciesCountPerPixel/low1_10x10_N250_speciesCountPerPixel.txt'
f8name = 'speciesCountPerPixel/low2_10x10_N250_speciesCountPerPixel.txt'



x1 = np.loadtxt(f1name).flatten()
x2 = np.loadtxt(f2name).flatten()
x3 = np.loadtxt(f3name).flatten()
x4 = np.loadtxt(f4name).flatten()
x5 = np.loadtxt(f5name).flatten()
x6 = np.loadtxt(f4name).flatten()
x7 = np.loadtxt(f5name).flatten()
x8 = np.loadtxt(f4name).flatten()

case = 2
# graphBudget = 55
graphBudget = 55 #budget to create heatmap with 

# NEDSI figures use Case 2 and 5 with budget 55 for both 

 # #-----------------------
# each case of reserves with 8 species. 
if case == 1:
    group1= np.array([x1,x2]) 
    group_species = [0,1]
    N = np.array([x1,x2]) 
    
elif case == 2:
    group2= np.array([x3,x4]) 
    group_species = [2,3]
    N = np.array([x3,x4]) 
    
elif case == 3:
    group3= np.array([x5,x6]) 
    group_species = [4,5]
    N = np.array([x5,x6])   
    
elif case == 4:
    group4= np.array([x7,x8]) 
    group_species = [6,7]
    N = np.array([x7,x8]) 
    
if case == 5:
    group1 = np.array([x1,x2,x3,x4,x5]) 
    group_species = [0,1,2,3,4]
    N = np.array([x1,x2,x3,x4,x5])  
    
if case == 6:
    group2 = np.array([x6,x7,x8,x1,x2])
    group_species = [5,6,7,0,1]
    N = np.array([x6,x7,x8,x1,x2])

if case in [1,2,3,4]: #get 2-species reserve 
    N_tilde = TwoSym(N,n)
    N_tilde = np.rint(N_tilde)
    
if case in [5,6]: #get 5-species reserve 
    N_tilde = FiveSym(N,n) 
    N_tilde = np.rint(N_tilde)

#saving another copy of N, the prior copy is modified when solving the model 

if case == 1:
    N = np.array([x1,x2]) 
elif case == 2:
    N = np.array([x3,x4]) 
elif case == 3:
    N = np.array([x5,x6])   
elif case == 4:
    N = np.array([x7,x8]) 
if case == 5:
    N = np.array([x1,x2,x3,x4,x5])  
if case == 6:
    N = np.array([x6,x7,x8,x1,x2])

# #-----------------------

weighted = 0 # weighted obj function 1 = weighted, 0 = unweighted
budgets = [b for b in np.arange(0,101,5)]
# budgets = [b for b in np.arange(0,101,1)]


#creating dataframe for graphs 
numSpecies, numParcels = np.shape(N) #getting dimension of animals 
df = pd.DataFrame() #creating dataframe for graphs 
labels = [] #annotation labels 
Ncols = ['N'+str(i) for i in group_species]
Ntildecols = ['Ntilde'+str(i) for i in group_species]

#naming columns in dataframe 
for i in range(numSpecies):
    colName = Ncols[i]
    df[colName] = N[i]
    colName = Ntildecols[i]
    df[colName] = N_tilde[i]

#this gives the annotation labels
N_df = df[Ncols]
N_list = N_df.astype('int').to_string(header=False, index=False, index_names=False).split('\n')

Ntilde_df = df[Ntildecols]
Ntilde_list = Ntilde_df.astype('int').to_string(header=False, index=False, index_names=False).split('\n')


if numSpecies == 2:
    labels_N = np.array(['\n'.join(ele.split()) for ele in N_list]).reshape(n,n)
    labels_Ntilde = np.array(['\n'.join(ele.split()) for ele in Ntilde_list]).reshape(n,n)
elif numSpecies == 5:
    delim = [' ','\n','\n',' ']
    labels_N =  np.array(["".join([x for x in itertools.chain.from_iterable(itertools.zip_longest(row.split(),delim)) if x]) for row in N_list]).reshape(n,n)   
    labels_Ntilde =  np.array(["".join([x for x in itertools.chain.from_iterable(itertools.zip_longest(row.split(),delim)) if x]) for row in Ntilde_list]).reshape(n,n)   

mod1_names = []
mod2_names = []

#solving opt models and saving to dataframe 
for b in budgets: 
    #SOLVING MODEL HERE 
    opt1 = optimize(N,b,weighted) #solving model 1
    opt2 = optimize(N_tilde,b,weighted) #Solving model 2
    colName1 = 'sol1-budget'+str(b) #saving to dataframe 
    mod1_names.append(colName1)
    colName2 = 'sol2-budget'+str(b)
    mod2_names.append(colName2)
    df[colName1] = opt1
    df[colName2] = opt2

colGraph1 = 'sol1-budget' + str(graphBudget)
colGraph2 = 'sol2-budget'+ str(graphBudget)
b = str(graphBudget)
# b =re.findall('[\d]+', colGraph1.split('-')[1])[0] #get budget from the column name 

labels = [labels_N, labels_Ntilde]
data1 = df[[colGraph1]].to_numpy().reshape(n,n) 
data2 = df[[colGraph2]].to_numpy().reshape(n,n)

## GRAPHING HEATMAPS 
# single heatmap 
# title1 = 'Model 1 - Protected areas for ' + str(numSpecies)+' species (budget ='+b+')'
# createHeatmap(data1,labels_N,title1)

# sidebyside
if weighted == 1:
    title = 'Protected areas for ' + str(numSpecies)+' species (weighted)'
else: 
    title = 'Protected areas for ' + str(numSpecies)+' species'

data = [data1,data2]
create2Heatmaps(data,labels,title,numSpecies)


## COMPARING WITH AND WITHOUT INTERACTION MODELS 
## count the number of same parcels with and without interactions 
#weighted
similarALL_weighted = []
similar_weighted = []
for b in budgets: 
    #SOLVING MODEL HERE 
    opt1 = optimize(N,b,1) #solving model 1
    opt2 = optimize(N_tilde,b,1) #Solving model 2
    similarALL_weighted.append(sum(opt1==opt2))
    if b not in ['0','100']: #ignore where budget = 0 or 100 cuz they'll always be the same 
        similar_weighted.append(sum(opt1==opt2))

#unweighted 
similarity_unweighted = [] #omit b = 0 and 100
similarityALL_unweighted = []
for m1,m2 in zip(mod1_names,mod2_names): #similarity of the two models 
    b = m1[11:]
    same = sum(df[m1]==df[m2])
    similarityALL_unweighted.append(same)
    if b not in ['0','100']: #ignore where budget = 0 or 100 cuz they'll always be the same 
        similarity_unweighted.append(same)


#graphing barplot of similarity  
df_similarity = pd.DataFrame({'budgets': budgets,
                    'Unweighted': similarityALL_unweighted,
                    'Weighted': similarALL_weighted})
df_similarity.set_index('budgets', inplace = True)

print('min\n'+str(df_similarity[['Unweighted','Weighted']].min())+'\n')
print('mean\n'+str(df_similarity[['Unweighted','Weighted']].mean())+'\n')
print('median\n'+str(df_similarity[['Unweighted','Weighted']].median())+'\n')
#generating graph
similarityBargraph(df_similarity) #graph the number of same 


# SAVING SOLUTIONS
#saving to cvs file
# df.to_csv('data/5species-case1.csv')
# df.to_csv('data/5species-case2.csv')

# df.to_csv('data/2species-case1.csv')
# df.to_csv('data/2species-case2.csv')
# df.to_csv('data/2species-case3.csv')
# df.to_csv('data/2species-case4.csv')

