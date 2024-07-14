# SpinSpinSpin

A Simple MATLAB Simulation for Unstable Free Rotation of a Rigid Body.

NOTE(s):
- Rotating object kinematics is "rotation vector" based.
- Rotation Vector Definition:
  - A rotation vector is a one dimensional row or column vector of length three.
  - The norm of the rotation vector is the rotation angle.
  - The normalized rotation vector is a 3D unit vector which serves as the rotation axis.
- Ordinary Differential Equations (ODEs) are solved using the  Matlab "ode45" function to apply the Dorman-Prince 4(5) explicit embedded variable time step Runge-Kutta method.
- State Vector Components:
  - State Vector components 1, 2 and 3 are the "rotation vector".
  - State Vector components 4, 5 and 6 are the angular velocity vector.
- Time rate of change of the rotation vector:
  - The time rate of change of the rotation vector is not the angular velocity vector.
  - To determine the time rate of change of the rotation  vector, use Equation (42) on Page 265 of Reference [ 1 ].

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
- Utilities directory.

  Directory of utility MATLAB source code files.

- nonRealTimeAnimationPartialPlayBackMovie.avi

  A non-real time 3D animation of a partial results play back AVI movie file.  

  - REFERENCE(s):
    
    - [ 1 ]
    "The Kinematic Equation for the Rotation Vector",      
              Malcolm D. Shuster,      
              IEEE Transactions on Aerospace and Electronic Systems,      
              Vol. 29, No. 1, pp. 263 - 267,      
              January 1993      
              malcolmdshuster.com/Pub_1993c_J_RotVec_IEEE.pdf

    - [ 2 ] "A Survey of Attitude Representations",
             Malcolm D. Shuster,      
             The Journal of the Astronautical Sciences,      
             Vol. 41, No. 4, pp. 430 - 517,      
             October-December, 1993      
             malcolmdshuster.com/Pub_1993h_J_Repsurv_scan.pdf

    - [ 3 ] "The Bizarre Behavior of Rotating Bodies -    - 
            The Dzhanibekov Effect",      
            Derek Alexander Muller      
            YouTube channel Veritasium      
            Spinning objects have strange instabilities known as      
            "The Dzhanibekov Effect" or "Tennis Racket Theorem" -      
            this video offers an intuitive explanation.      
            https://www.youtube.com/watch?v=1VPfZ_XzisU
      
    - [ 4 ] Elements of the following were used to help create this project:
      
      - [ 4.1 ]  https://github.com/alaricgregoire/EulerFreeBody       
                 www.mathworks.com/matlabcentral/fileexchange/75265-euler-free-body-motion

      - [ 4.2 ]  https://github.com/phymhan/matlab-axis-label-alignment            
                 www.mathworks.com/matlabcentral/fileexchange/49542-phymhan-matlab-axis-label-alignment

      - [ 4.3 ]  www.mathworks.com/matlabcentral/fileexchange/25372-marrow3-m-easy-to-use-3d-arrow


    

