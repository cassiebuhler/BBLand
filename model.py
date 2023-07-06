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


n = 3
seed = 1
nFile = "n"+str(n)
iterFile = "iter"+str(seed)
config = np.array([[1,2,3],[4,5,6],[7,8,9]])

out = config.flatten()
basePath = "/Users/cassiebuhler/Library/CloudStorage/OneDrive-DrexelUniversity/bbland/bbland-github/data/"


dataPath = path.join(nFile,iterFile)

path = path.join(basePath,dataPath)

filePath = path+'/test.txt'

if not os.path.exists(path):
   os.makedirs(path)

np.savetxt(filePath, out, delimiter=',',fmt = "%d")


# subprocess.call([r'path where the batch file is stored\name of the batch file.bat'])
