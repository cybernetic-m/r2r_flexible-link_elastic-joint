#  Rest-to-Rest Trajectory Planning of a Flexible Robot Link with Elastic Joint

The two primary sources of vibrations in lightweight robots are **link flexibility** and **joint elasticity**. Link flexibility is distributed in nature, but can be modeled as an *Euler-Bernoulli beam* with dynamic boundary conditions, using a *finite number of exact shape eigenfunctions and associated eigenfrequencies* [1]. **Joint elasticity** is usually modeled as a *concentrated effect with an elastic spring at the joint* [2].
Since the two phenomena interact and link mode shapes are also affected by the elasticity at the joint, they **must be considered together for an accurate dynamic modeling** [3]. Various control methods exist separately for the two classes of robots with link flexibility or with joint elasticity, but they are rarely combined together. *For a flexible link*, this problem has been solved using **input shaping** [4] or by defining an *output with no zero dynamics* (flat) and then applying an **inverse dynamics to a suitably planned trajectory** [5]. **In this work, we show that the latter approach can be extended also to the complete dynamic model of a one-link flexible robot with an elastic joint**.

<p align="center">
  <img src="/images/system_3D.png" alt="Image 1" width="400"/>
  <img src="/images/system_2D.png" alt="Image 2" width="400"/>
</p>

# Installation and Usage
1. Clone the repository:  
 ```sh 
 git clone "https://github.com/cybernetic-m/r2r_flexible-link_elastic-joint.git"
 ```
2. Install Matlab/Simulink 2023b (go to the following link and download it)
 ```sh 
 "https://it.mathworks.com/products/new_products/release2023b.html"
 ```
3. Open src directory

4. **Run** *init.m* to initialize Matlab/Simulink

5. **Open** *simulation.slx* and **Run** the simulation

6. **Run** *plotSimulation.m* to plot the Stroboscopic View


# Project Structure 

```sh 
src
├── getMode.m => Function to compute the Mode Analysis of the robot
├── getTau.m => Function to compute the needed torque command
├── getTrajectory.m => Function to plan the trajectory of the robot
├── init.m => Function to initialize the simulation
├── plotSimulation.m => Function to plot the stroboscopic view motion
├── realTimePlot.m => Function to plot in a video the variables
├── simulation.slx => Simulink file for the simulation
```
    
# Simulations

We performed numerical simulations in MATLAB on a flexible arm having the following parameters:
1. Rotor Inertia: **IR = 1 kg·m^2** 
2. Spring Stiffness **k= 100 Nm/rad** 
3. Length of the arm: **l= 0.7 m** 
4. Linear density: **ρ= 4 kg/m** 
5. Flexural Rigidity: **EI = 0.6 N·m^2**

The modal analysis is done taking in consideration **n=3** modes.

The rest-to-rest motion is from **θi = 0 rad** to **θf= π/2 rad**.
A polynomial of degree **15** has been used for trajectory planning. 

The results showed are in the case of motion time **T = 1 s** or **T = 0.5 s** and in the case of payload mass **m = 2 kg** or no payload **m= 0 kg**

**Stroboscopic View**

This is the stroboscopic view of the planar motion of the flexible arm in the 3 cases. The rotor motion is represented by the black arrow at the base of the link.

*T = 1 s, No Payload*

<img src="images/stroboscopic_view_T1.gif" alt="Alt Text" width="400">

*T = 0.5 s, No Payload*

<img src="images/stroboscopic_view_T05.gif" alt="Alt Text" width="400">

*T = 1 s, Payload m = 2kg*

<img src="images/stroboscopic_view_T1_p2.gif" alt="Alt Text" width="400">


**Quantities**

These are the plots of torque, angles and tip displacement profiles. 


*T = 1 s, No Payload*

<img src="images/tau_angles_tipdis_T1.gif" alt="Alt Text" width="400">

*T = 0.5 s, No Payload*

<img src="images/stroboscopic_view_T05.gif" alt="Alt Text" width="400">

*T = 1 s, Payload m = 2kg*

<img src="images/tau_angles_tipdis_T1_p2.gif" alt="Alt Text" width="400">


# Authors

1. Massimo Romano (romano.2043836@studenti.uniroma1.it)

2. Luca Murra (murra.1920342@studenti.uniroma1.it)

3. Alessandro De Luca (deluca@diag.uniroma1.it)

# References
[1]. [F. Bellezza, L. Lanari, and G. Ulivi, “Exact modeling of the flexible
slewing link,” in Proc. IEEE Int. Conf. on Robotics and Automation,
pp. 734–739, 1990](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=126073&tag=1).

[2]. [A. De Luca and W. Book, “Robots with flexible elements,” in B. Siciliano,
O. Khatib (Eds.), Springer Handbook of Robotics (2nd ed.), pp. 243–282,
Springer, 2016.](https://link.springer.com/chapter/10.1007/978-3-319-32552-1_11).

[3]. [D. Li, J.W. Zu and A.A. Goldenberg, “Dynamic modeling and mode
analysis of flexible-link, flexible-joint robots,” Mechanisms and Machine
Theory, vol. 33, no. 7, pp.1031–1044, 1998.](https://www.sciencedirect.com/science/article/pii/S0094114X97000542).

[4]. [N.C. Singer and W.P. Seering, “Preshaping command inputs to reduce
system vibration,” ASME J. of Dynamic Systems, Measurements, and
Control, vol. 112, no. 1, pp. 76–82, 1990.](https://www.academia.edu/56942661/Preshaping_command_inputs_to_reduce_system_vibration)

[5]. [A. De Luca and G. Di Giovanni, “Rest-to-rest motion of a one-link
flexible arm,” in Proc. IEEE/ASME Int. Conf. on Advanced Intelligent
Mechatronics, pp. 923–928, 2001.](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=936793)