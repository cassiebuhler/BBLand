
# Decision-Making for Land Conservation: A Derivative-Free Optimization Framework with Nonlinear Inputs

BBLand is software for spatial conservation planning with an unknown (i.e. black box) input. In its current form, we have [RAMAS Metapopulation](https://www.ramas.com/metapop-6-0) PVA software as the black box input. RAMAS is commercial software that requires a license to use. Our code invokes RAMAS using batch files, so we are able to provide all the source code. However, unless RAMAS is installed on your machine, this code won't run. 

## Contents 


### Code 
There are 7 scripts and 1 batch files in this directory. 
* driver_.py - main driver
* getRAMAS.py - inputs the current reserve configuration and outputs PVA metrics
* constrainedModel_.py - constrained model. Has 1 objective and 3 constraints. 
* unconstrainedModel_.py - multi-objective model. Has 4 objectives and 0 constraints. 

* functions.R - To use RAMAS in batch mode, we had to write scripts to convert file types. In this code, there are also hyperparameters that you can toggle which would impact PVA results. Ex: carrying capacity, habitat suitability threshold, relative survival rate, etc. 
* getMap.R - This code is the shell for functions.R. It outputs *.ASC, *.PTC, *.PDY, and *.BAT files that are necessary for RAMAS.
* getFigures.R - Used to generate figures in paper 

* runR.BAT - Executes the R code getBaseMap.R 


### Data 
The initial landscape $B$, was randomly generated consisting of values that are uniformly distributed from $[0,1]$ to represent the habitat suitability. 
  * This is generated in the *getLandscape* function in *functions.R*.
  * You can reproduce this data because there is a random number seed, but the ASC files are also provided in the data directory. 

The results from the paper used 4 scenarios: $n = 10$ and $n = 20$ solved with the unconstrained and constrained models. The data and their results are included in the data directory. 

Note that each iteration uses around 450 KB of space, and with 2005 iterations for $n=20$ and 505 iterations for $n=10$, this would greatly exceed the allowed submission size of 100 MB. For this reason, we have only included the base case and the iteration that yielded the best solution. However, you can see the objective function and constraints for each iteration's solution in the log files, with the text files prefixed with ``output''.

#### Results
In output directory
*  Expected minimum abundance in IntExtRisk.txt
*  Risk to extinction in TerExtRisk.txt
*  Time to extinction in QuasiExt.txt



## Usage
To run this code, you will interact primarily with the driver (driver.py). The only time you'd edit the other code is if you'd want to tinker with population parameters or ACO parameters. 


