<<<<<<< HEAD
# Decision-Making for Land Conservation: A Derivative-Free Optimization Framework with Nonlinear Inputs
=======
# Black-box optimization for reserve design in biodiversity conservation 

BBLand is software for spatial conservation planning with an unknown (i.e. black box) input. In its current form, we have [RAMAS Metapopulation](https://www.ramas.com/metapop-6-0) PVA software as the black box input. RAMAS is commercial software that requires a license to use. Thus, unless RAMAS is installed on your machine, this code won't work. 

## Contents 

There are 8 scripts and 2 batch files in this directory. 
* driver.py - main driver
* getRAMAS.py - inputs the current reserve configuration and outputs PVA metrics
* constrainedModel.py - constrained model. Has 1 objective and 3 constraints. 
* unconstrainedModel.py - unconstrained model. Has 4 objectives and 0 constraints. 

* functions.R - To use RAMAS in batch mode, we had to write scripts to convert file types. In this code, there are also hyperparameters that you can toggle which would impact PVA results. Ex: carrying capacity, habitat suitability threshold, relative survival rate, etc. 
* getBaseMap.R - This code outputs batch files 
* getFigures.R
* getMap.R

* runInitR.BAT - Executes the R code that yields the initial base map
* runR.BAT - Executes the R code that runs the new configuration map 

## Data 
Data is automatically generated. 

## Usage
To run this code, you will interact primarily with the driver (driver.py). 
>>>>>>> refs/remotes/origin/main

## CONTENTS

## REQUIREMENTS

## IMPLEMENTATION