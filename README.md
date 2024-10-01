#  Rest-to-Rest Trajectory Planning of a Flexible Robot Link with Elastic Joint

The two primary sources of vibrations in lightweight robots are **link flexibility** and **joint elasticity**. Link flexibility is distributed in nature, but can be modeled as an *Euler-Bernoulli beam* with dynamic boundary conditions, using a *finite number of exact shape eigenfunctions and associated eigenfrequencies* [1]. **Joint elasticity** is usually modeled as a *concentrated effect with an elastic spring at the joint* [2].
Since the two phenomena interact and link mode shapes are also affected by the elasticity at the joint, they **must be considered together for an accurate dynamic modeling** [3]. Various control methods exist separately for the two classes of robots with link flexibility or with joint elasticity, but they are rarely combined together. *For a flexible link*, this problem has been solved using **input shaping** [4] or by defining an *output with no zero dynamics* (flat) and then applying an **inverse dynamics to a suitably planned trajectory** [5]. **In this work, we show that the latter approach can be extended also to the complete dynamic model of a one-link flexible robot with an elastic joint**.

<p align="center">
  <img src="/images/system_3D.png" alt="Image 1" width="400"/>
  <img src="/images/system_2D.png" alt="Image 2" width="400"/>
</p>

# Installation
1. Clone the repository:  
 ```sh 
 git clone "https://github.com/cybernetic-m/r2r_flexible-link_elastic-joint.git"
 ```
2. Install Matlab/Simulink 2023b
 ```sh 
 "https://it.mathworks.com/products/new_products/release2023b.html"
 ```

# Project Structure 

```sh 
src
├── getMode.m => Function to compute the Mode Analysis of the robot
├── getTau.m => Function to compute the needed torque command
├── getTrajectory.m => Function to plan the trajectory of the robot
├── init.m => Function to initialize the simulation
├── plotSimulation.m => Function to plot the stroboscopic view motion
├── simulation.slx => Simulink file for the simulation
```
    
# Run


# Simulations


**Performances comparison**

<img src="images/tab_no_prep.png" alt="Alt Text" width="300">


**Confusion Matrix**

<img src="images/cm.png" alt="Alt Text" width="400">


**Loss Function**

<img src="images/loss.png" alt="Alt Text" width="400">


**Accuracy**

<img src="images/acc.png" alt="Alt Text" width="400">

# Authors



# References
[1]. [Review on chest pathogies detection systems using deep learning techniques](https://link.springer.com/article/10.1007/s10462-023-10457-9#Abs1).

[2]. [FA-Net: A Fuzzy Attention-aided Deep Neural Network for Pneumonia Detection in Chest X-Rays](https://arxiv.org/pdf/2406.15117).

[3]. [KAN: Kolmogorov–Arnold Networks](https://arxiv.org/pdf/2404.19756).
