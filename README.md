# COVIDSim — SEIRS-based COVID-19 Simulation Package #

## Table of Contents ##
  1. [Introduction](#introduction)
  2. [Modelling the Dynamics of COVID-19](#modelling-the-dynamics-of-covid-19)
  3. [Simulation Package](#the-simulation-package)
  4. [Download](#download)


## Introduction ##
The current global health emergency triggered by the pandemic COVID-19 is one of the greatest challenges we face in this generation. Computational simulations have played an important role to predict the development of the current pandemic. Such simulations enable early indications on the future projections of the pandemic and is useful to estimate the efficiency of control action in the battle against the SARS-CoV-2 virus. The SEIR model is a well-known method used in computational simulations of infectious viral diseases and it has been widely used to model other epidemics such as Ebola, SARS, MERS, and influenza A. This paper presents a modified SEIRS model with additional exit conditions in the form of death rates and resusceptibility, where we can tune the exit conditions in the model to extend prediction on the current projections of the pandemic into three possible outcomes; death, recovery, and recovery with a possibility of resusceptibility. The model also considers specific information such as ageing factor of the population, time delay on the development of the pandemic due to control action measures, as well as resusceptibility with temporal immune response. Owing to huge variations in clinical symptoms exhibited by COVID-19, the proposed model aims to reflect better on the current scenario and case data reported, such that the spread of the disease and the efficiency of the control action taken can be better understood. The model is verified using two case studies based on the real-world data in South Korea and Northern Ireland.

The simulation package is available free and as an open-source, and distributed under the [GNU license](https://en.wikipedia.org/wiki/GNU_General_Public_License).

If you use this simulation package in your research, please cite the following publication:
- K. Y. Ng and M. M. Gui (2020), [COVID-19: Development of a robust mathematical model and simulation package with consideration for ageing population and time delay for control action and resusceptibility](https://doi.org/10.1016/j.physd.2020.132599), *Physica D: Nonlinear Phenomena*.


## Modelling the Dynamics of COVID-19 ##
The model is a modified SEIRS model with consideration for ageing population in the population as well as time delay for the control action and potential resusceptibility due to temporal immunity. The model is defined using the equations below:

<img src="/COVID_model.png" width="450">


## The Simulation Package ##
The figure below shows the graphical user interface (GUI) of the simulation package developed using the MATLAB/Simulink environment. Users can use this interface to set preferred settings for the simulation and also to view simulation results.

![](/GUI_COVID.png)
###### The main graphical user interface of the simulation package in Matlab. 􏰀1) Load real-world data for the selected country. 􏰀2) Set the stock population for simulation. 􏰀3) Set the percentage of recovered cases. 􏰀4) Set the fraction of elderly population. 􏰀5) Set the fatality rate for the elderly population. 􏰀6) Computed values for beta, alpha, and gamma. 􏰀7) Set the simulation time in days. 􏰀8) Set the value for the basic reproduction number *R_0*. 􏰀9) Set the initial number of infected cases *I(0)*. 􏰀10) Set the incubation time. 􏰀11) Set the recovery time. 􏰀12) Settings for recusceptibility, including the percentage of resusceptible cases and duration of temporal immunity. 􏰀13) Settings for control action, including the effeciency rate as well as the time delay during pre- and post-control action, respectively. 􏰀14) Reset the GUI and clear all plots. 􏰀15) Run the simulation. 􏰀16) Recreate the graphs on external Matlab figure windows. 􏰀17) Graphical plots from the simulation (left figure for overall simulation while right figure compare initial projections of the model with real-world data). ######  


## Download ##
The simulation package can be downloaded [here](https://github.com/nkymark/COVIDSIM).



Data are obtained from the following sources:
* [2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins CSSE](https://github.com/CSSEGISandData/COVID-19)
* [COVID-19 UK Historical Data](https://github.com/tomwhite/covid-19-uk-data)
