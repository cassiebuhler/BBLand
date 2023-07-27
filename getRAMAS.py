#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  6 15:11:52 2023

@author: cassiebuhler
"""

import numpy as np
import subprocess
import os
from os import path
# import pygmo as pg
import re
# import sys

def getObj(n,config,i,tmax):
    """ runs RAMAS to get the PVA metrics 
    Parameters
    ----------
    n : int
        Problem size.
    config : Array of float64 (n*n,1)
        Current configuration X.
    i : int
        Current iteration.
    tmax : int
        Total duration of simulated timesteps in RAMAS.
        
    Returns
    -------
    risk : 
        PVA metrics. If none are found, we return a "bad" output to not break code

    """
    duration = 50
    basePath = os.getcwd()

    #creating directory for solutions from this iteration 
    iterPath = path.join(basePath,"data","n"+str(n),"iter"+str(i))
    if not os.path.exists(iterPath):
       os.makedirs(iterPath)
    
    #Save current configuration solution 
    fileName = "X"+str(n)+"_"+str(i)+".txt"
    np.savetxt(iterPath+"./"+fileName, config, delimiter=',',fmt = "%d")

    ## call r code to get .asc,.ptc, and .pdy files for X. 
    cmd_rcode = "runR.bat "+str(n) + " "+str(i)+" "+fileName
    subprocess.run(cmd_rcode, cwd = basePath, shell=True)
    
    #RUN SPATIAL DATA AND HABITAT DYNAMICS 
    subprocess.run("batch"+str(n)+"_"+str(i)+".BAT", cwd = iterPath, shell=True)
    
    mpFile = iterPath+"\\"+"Z"+str(n)+"_"+str(i)+".mp"
    if not os.path.isfile(mpFile):
        # if file doesn't exist, habitat dynamics didn't output an mp file. 
        print("No MP file was found.")
        return badProblem()
    
    #modifying metapop file to edit duration/tmax 
    with open(mpFile) as f: 
        metapopFile = f.read()
    metapopFile_new = re.sub("(1000\n100)", str(duration)+"\n"+str(tmax),metapopFile)
    
    with open(iterPath+"\\"+"Z"+str(n)+"_"+str(i)+".mp","w") as f:
        f.write(metapopFile_new)
    
    #Running metapop
    subprocess.run("batch"+str(n)+"_"+str(i)+"b.BAT", cwd = iterPath, shell=True)
    outputMetaPath = path.join(iterPath,"output","metapop")
    
    #gettingr results 
    risk = getResults(outputMetaPath,tmax)
    
    return risk

def getResults(outputMetaPath,tmax):
    """Getting using regex in the files saved in the directory

    Parameters
    ----------
    outputMetaPath : path
        Path to the output files.
    tmax : int
        Total duration of simulated timesteps in RAMAS.

    Returns
    -------
    risk : 
        PVA metrics. If none are found, we return a "bad" output to not break code

    """
    if not os.path.exists(outputMetaPath):
       os.makedirs(outputMetaPath)
    
    if not os.path.isfile(outputMetaPath+"\\"+"LocExtDur.txt"):
        # if there's no output, there are likely no patches found. 
        print("No metapop output files found.")
        return badProblem()

    with open(outputMetaPath+"\\"+"IntExtRisk.txt",'r') as f:
        IntExtRisk = f.readlines()
        
    with open(outputMetaPath+"\\"+"TerExtRisk.txt",'r') as f:
        TerExtRisk = f.readlines()
        
    with open(outputMetaPath+"\\"+"QuasiExt.txt",'r') as f:
        QuasiExt = f.readlines()
    
    numPopulations = TerExtRisk[7].split()[0]
    riskTotExt  = TerExtRisk[14].split()[1]
    # avgLocExtDur = [pop.split()[5] for pop in LocExtDur[15:]]
    medianQuasiExt = QuasiExt[13]
    expectedMinAbund = IntExtRisk[13].split()[-1]
    findNum = re.compile("(\d+(?:\.\d+)?)")
    findSign = re.compile("(=)")
    if findSign.search(QuasiExt[13]) is not None:
        medianQuasiExt = findNum.search(QuasiExt[13]).group()
    else:
        medianQuasiExt =  tmax+1 # max number of timesteps 
    print('Num Populations: '+str(numPopulations))
    print('Risk to Total Extinction: '+str(riskTotExt))
    # print('Average Local Extinction Duration: '+str(avgLocExtDur))
    print('Median quasi extinction: '+str(medianQuasiExt))
    print('Expected min abundance: '+str(expectedMinAbund))
    # risk = np.array([float(riskTotExt), -float(medianQuasiExt),-float(expectedMinAbund)])
    return float(riskTotExt), float(medianQuasiExt),float(expectedMinAbund)

def badProblem():
    """
    if no patches can be found, return this "bad" solution
    """
    print('BAD PROBLEM')
    riskTotExt = 1 #make this bad 
    medianQuasiExt = 0 # make this bad
    expectedMinAbund = 0 # make bad 
    return float(riskTotExt), float(medianQuasiExt),float(expectedMinAbund)