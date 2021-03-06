using JuMP, PowerModels, Ipopt, Clustering, Plots, DataFrames, CSV,
    LinearAlgebra, Statistics

const tol=1e-4

### Test case to consider ###
testcase="../data/pglib_opf_case24_ieee_rts.m"
network=PowerModels.parse_file(testcase)
###

### Scenario Structure ###
include("scenario.jl")

### Data initialization ###
include("data.jl")

### Plotting and csv tools ###
include("csvSACOPF.jl")
include("plotSACOPF.jl")

### Bulding load perturbation ###
include("load_perturbation.jl")

### Critical Scenarios detection ###
include("critical_scenarios.jl")

### function for solving and iterating for Robust AC OPF ###
include("robust_acopf.jl")

### pushing methods ###
include("push.jl")



### Example of run for testcase 1354_pegase
# pert=0.02
# pertLoads=DetectEndLoads()
# nbSamples=1000
# nbScenToAdd=5
# maxNbScen=30

# PG0,V0=solveDeterministic(pertLoads,pert)
# ClustIt=[CentralScenario()]
# PG0,V0=IterateRACOPF(ClustIt,nbSamples,nbScenToAdd,maxNbScen,pertLoads, pert,
#                      "Hybrid","GradPush")
# res=SamplePF(nbSamples,PG0,V0,pertLoads,pert)
# PlotSamplesPF(res[3],res[4],ClustIt,"test")

### Example of run for testcase 24 73 118 ieee
pert=0.03
pertLoads=Set{String}(keys(netload))#DetectEndLoads()
nbSamples=1000
nbScenToAdd=5
maxNbScen=31
threshold=0.02

PG0,V0=solveDeterministic(pertLoads,pert)
SampleScenario(CentralScenario(),PG0,V0,pertLoads,pert)
CriticalScen,WeightScen=FindCriticalScenarios(PG0,V0,pertLoads,threshold,pert)
PlotHeatScenarios(CriticalScen,WeightScen,"testHeat")
ScenariosToCSV(CriticalScen,"testSTCSV")
WeightToCSV(WeightScen,"testWTCSV")


ClustIt=[CentralScenario()]
PG0,V0=IterateRACOPF(ClustIt,nbSamples,nbScenToAdd,maxNbScen,pertLoads, pert,
                     "NbConstr","GradPush")
res=SamplePF(nbSamples,PG0,V0,pertLoads,pert)
SampleScenario(CentralScenario(),PG0,V0,pertLoads,pert)
PlotSamplesPF(res[3],res[4],ClustIt,"testNbConstrGradPush")

ClustIt=[CentralScenario()]
PG0,V0=IterateRACOPF(ClustIt,nbSamples,nbScenToAdd,maxNbScen,pertLoads, pert,
                     "MaxViol","GradPush")
res=SamplePF(nbSamples,PG0,V0,pertLoads,pert)
SampleScenario(CentralScenario(),PG0,V0,pertLoads,pert)
PlotSamplesPF(res[3],res[4],ClustIt,"testMaxViolGradPush")

ClustIt=[CentralScenario()]
PG0,V0=IterateRACOPF(ClustIt,nbSamples,nbScenToAdd,maxNbScen,pertLoads, pert,
                     "Hybrid","GradPush")
res=SamplePF(nbSamples,PG0,V0,pertLoads,pert)
SampleScenario(CentralScenario(),PG0,V0,pertLoads,pert)
PlotSamplesPF(res[3],res[4],ClustIt,"testHybridGradPush")
