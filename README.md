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

