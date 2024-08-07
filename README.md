# SpinSpinSpin

A Simple MATLAB Simulation for Unstable Free Rotation of a Rigid Body.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=berocs/SpinSpinSpin_RotationVector)

NOTE(s):
- Rotating object kinematics is "**Rotation Vector**" based.
- The projects "**SpinSpinSpin_Quaternion_v1**" and "**SpinSpinSpin_Quaternion_v2**" are similar but **Quaternion** based.
- Rotation Vector Definition:
  - A rotation vector is a one dimensional row or column vector of length three.
  - The norm of the rotation vector is the rotation angle.
  - The normalized rotation vector is a 3D unit vector which serves as the rotation axis.
- Ordinary Differential Equations (ODEs) are solved using the  Matlab "ode45" function to apply the Dorman-Prince 4(5) explicit embedded adaptive time step Runge-Kutta method.
  - Error limits in Matlab "ode45" function set to 10<sup>-13</sup>.
- State Vector Components:
  - State Vector components 1, 2 and 3 are the "rotation vector".
  - State Vector components 4, 5 and 6 are the angular velocity vector.
  - Initial Conditions:
    - Rotation Vector:  [ 1.0; 0.0; 0.0 ].
      - 1 [radian] (57.3 [degrees]) rotation about the body X axis.
    - Angular Velocity: [  0.10;  0.00001;  0.0 ] [radians/second]
      - Spin about body X axis with a small spin about the body Y axis.
    - Principal components of moments of inertia:  [  4.0;   1.0;      9.0 ]
      - Rectangular block dimensions determined by principal components of moments of inertia.
      - Spin will be about the rectangular block axis of intermediate length.
- Time rate of change of the rotation vector:
  - **The time rate of change of the rotation vector is not the angular velocity vector**.
  - To determine the time rate of change of the rotation  vector, use **Equation (42) on Page 265 of Reference [ 1 ]**.
- Note that the 2D plots of inertial angular momentum quantities reveal the constant nature of the inertial angular momentum over time as expected for free rotation.
  - Change is within 10<sup>-13</sup>.
- Note that the 2D plot of rotational kinetic energy reveals the constant nature of this energy over time as expected for free rotation.
  - Change is within 10<sup>-13</sup>.
- Note that the 3D animation video reveals the constant nature of the angular momentum vector over time as expected for free rotation.
  - Simulation generates a rotation vector solution every millisecond for 1000 seconds generating a total of one million rotation vector solutions.
  - Simulation creates a sequence of 3D animation frames, one 3D animation frame for every 200 th rotation vector solution.  3D simulation animation frames are at 5 [frames/second] rate.

CONTENTS:

- freeUnstableRigidBodyRotationDemonstration.m

  MATLAB source code file for top level simulation function.
- generateSolutionsForFreeRotationRigidBodyKinematics.m

  MATLAB source code file for non-real time solution of Ordinary Differential Equations (ODEs).
- generateInertialResults.m

  MATLAB source code file to convert state vector solutions at each time sample from body coordinates to inertial coordinates.
- generatePlots2D.m

  MATLAB source code file to generate 2D plots.
- generatePlots3D.m

  MATLAB source code file to generate 3D plots.
- performNonRealTimeAnimationPlayBack3D.m

  MATLAB source code file to generate 3D animation non-real time playback of solution applied to a rigid rectangular 3D block.
- generateFreeUnstableRigidBodyRotationDemoPurposeMessage.m
- generateFreeUnstableRigidBodyRotationDemoUsageMessage.m
- generateKinematicsSolutionsPurposeMessage.m
- generateKinematicsSolutionsUsageMessage.m

  Auxiliary MATLAB source code files.
- Utilities.

  Directory of utility MATLAB source code files.

EXAMPLES:
- nonRealTimeAnimationPartialPlayBackMovie.avi

  A non-real time 3D animation of a partial results play back AVI movie file.

- TwoDimensionalPlots

  Directory containing the two dimensional plots generated by this simulation.

REFERENCE(s):
    
    - [ 1 ]  "The Kinematic Equation for the Rotation Vector",      
              Malcolm D. Shuster,      
              IEEE Transactions on Aerospace and Electronic Systems,      
              Vol. 29, No. 1, pp. 263 - 267,      
              January 1993      
              https://malcolmdshuster.com/Pub_1993c_J_RotVec_IEEE.pdf
              

    - [ 2 ] "A Survey of Attitude Representations",
             Malcolm D. Shuster,      
             The Journal of the Astronautical Sciences,      
             Vol. 41, No. 4, pp. 430 - 517,      
             October-December, 1993      
             https://malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf
             

    - [ 3 ] "The Bizarre Behavior of Rotating Bodies -    - 
            The Dzhanibekov Effect",      
            Derek Alexander Muller      
            YouTube channel Veritasium      
            Spinning objects have strange instabilities known as      
            "The Dzhanibekov Effect" or "Tennis Racket Theorem" -      
            this video offers an intuitive explanation.      
            https://www.youtube.com/watch?v=1VPfZ_XzisU
            
      
    - [ 4 ] Elements of the following were used to help create this project:
      
        [ 4.1 ]  Gatech AE (2024). Euler Free Body Motion (https://github.com/alaricgregoire/EulerFreeBody/releases/tag/v1.0.0), GitHub. Retrieved July 15, 2024
        
        [ 4.2 ]   Ligong Han (2024). phymhan/matlab-axis-label-alignment (https://github.com/phymhan/matlab-axis-label-alignment), GitHub. Retrieved July 15, 2024. 
                 
        [ 4.3 ]   Georg Stillfried (2024). mArrow3.m - easy-to-use 3D arrow (https://www.mathworks.com/matlabcentral/fileexchange/25372-marrow3-m-easy-to-use-3d-arrow), MATLAB Central File Exchange. Retrieved July 15, 2024. 
      
<iframe width="1198" height="674" src="https://www.youtube.com/embed/1VPfZ_XzisU" title="The Bizarre Behavior of Rotating Bodies" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>



    

