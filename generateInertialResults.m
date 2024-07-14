function                                                                     ...
[                                                                            ...
  angularVelocitiesInertialCoords,                                           ...
  angularMomentumsInertialCoords,                                            ...
  rotationalKineticEnergies                                                  ...
] =                                                                          ...
generateInertialResults                                                      ...
        (                                                                    ...
          rotationVectorsBodyCoords,                                         ...
          angularVelocitiesBodyCoords,                                       ...
          angularMomentumsBodyCoords                                         ...
        )
%===============================================================================
%
%  FUNCTION:
%
%    generateInertialResults
%
%===============================================================================

%===============================================================================
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%===============================================================================

%{------------------------------------------------------------------------------
   [                                                                         ...
     numberRotationVectorRows,                                               ...
     numberRotationVectorColumns                                             ...
   ] = size( rotationVectorsBodyCoords );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   numberTimeSamples = numberRotationVectorColumns;
%-------------------------------------------------------------------------------
   angularVelocitiesInertialCoords =                                         ...
                    zeros                                                    ...
                     (                                                       ...
                       3,                                                    ...
                       numberTimeSamples                                     ...
                     );
   angularMomentumInertialCoords =                                           ...
                    zeros                                                    ...
                     (                                                       ...
                       3,                                                    ...
                       numberTimeSamples                                     ...
                     );
   rotationalKineticEnergies = zeros( numberTimeSamples, 1 );
%-------------------------------------------------------------------------------
   for( timeIndex = 1 : numberTimeSamples )
     %{-------------------------------------------------------------------------
        currentRotationVectorBodyCoords =                                    ...
                             rotationVectorsBodyCoords                       ...
                                            (                                ...
                                              :, timeIndex                   ...
                                            );
     %--------------------------------------------------------------------------
        if( all( currentRotationVectorBodyCoords == 0.0 ) == false )
         %{---------------------------------------------------------------------
         %  Current rotation vector is not the zero vector.
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
         %  Proceed to generate quantities in inertial coordinates.
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
         %
         %  NOTE(s):
         % 
         %   [ 1 ] The kinematics of this simulation are centered on the
         %         use of rotation vectors.
         %
         %         Rotation Vector Definition:
         % 
         %         A rotation vector is a one dimensional row or column
         %         vector of length three.
         % 
         %           [ 1.1 ] The norm of the rotation vector is the
         %                   rotation angle.
         % 
         %           [ 1.2 ] The normalized rotation vector is a 3D unit
         %                   vector which serves as the rotation axis.
         %
         %----------------------------------------------------------------------
            currentRotationAngleRadians =                                    ...
                            norm                                             ...
                             (                                               ...
                               currentRotationVectorBodyCoords               ...
                             );
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            oneRevolution                  = 2.0 * pi;
            currentRotationAngleRadiansMod = mod                             ...
                                              (                              ...
                                                currentRotationAngleRadians, ...
                                                oneRevolution                ...
                                              );
         %----------------------------------------------------------------------
         %  Obtain the rotation axis unit vector.
         %----------------------------------------------------------------------
            currentRotationAxisUnitVector =                                  ...
                               currentRotationVectorBodyCoords /             ...
                               currentRotationAngleRadians;
         %----------------------------------------------------------------------
         %
         %  Given:
         %    A unit rotation axis.
         %    A rotation angle in radians,
         %
         %  Use the Matlab function 'makehgtform' to generate the 4 by 4
         %  matrix which performs the specified body coordinates
         %  to inertial coordinates transform operation.
         %
         %  The three-by-three transform matrix will be contained in the upper
         %  left of the generated four-by-four matrix.
         %
         %----------------------------------------------------------------------
            [                                                                ...
              currentBodyToInertialCoordinatesTranslationMatrix              ...
            ] = makehgtform                                                  ...
                    (                                                        ...
                      'AxisRotate',                                          ...
                      currentRotationAxisUnitVector,                         ...
                      currentRotationAngleRadiansMod                         ...
                    );
         %----------------------------------------------------------------------
         %
         %  NOTE(s):
         %
         %    [ 1 ]  ROTATION OPERATION DEFINITION:
         %
         %             Given:
         %               One coordinate system S.
         %               One vector A expressed in coordinate system S.
         %               A rotation unit vector R expressed in coordinate
         %               system S.
         %               A rotation angle theta in radians.
         %             Generate:
         %               A new vector B expressed in the coordinate system S.
         %               The new vector B is the result of rotating the
         %               vector A through the angle theta about the rotation
         %               axis R.
         %
         %    [ 2 ]  TRANSFORM OPERATION DEFINITION:
         %
         %             Given:
         %               Two coordinate systems S1 and S2.
         %               A rotation unit vector R expressed in coordinate
         %               system S1.
         %               A rotation angle theta in radians.
         %               Coordinate system S2 is generated from coordinate
         %               system S1 by rotating coordinate system S1 about
         %               the unit axis R through an angle theta.
         %               One vector A expressed in coordinate system S1.
         %             Generate:
         %               The representation vector B of the vector A.
         %               The vector B is the same as the vector A but is to
         %               be expressed in the coordinate system S2.
         %
         %    [ 3 ]  The Matlab function  'makehgtform' creates a
         %           four-by-four transform matrix for:
         %             translation,
         %             scaling
         %           and
         %             transformation of graphics objects.
         %           The transform part of the transformation matrix is
         %           contained in the upper left three-by-three portion
         %           of the four-by-four matrix returned by the Matlab
         %           function 'makehgtform'.
         %
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         %  Fetch the three-by-three transform portion of the matrix returned
         %  by the Matlab function 'makehgtform'.
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         %  This matrix will transform non-inertial body coordinates to
         %  inertial coordinates.
         %----------------------------------------------------------------------
            bodyToInertialTransformMatrix =                                  ...
                  currentBodyToInertialCoordinatesTranslationMatrix          ...
                                                   ( 1 : 3, 1 : 3 );
         %----------------------------------------------------------------------
            currentAngularVelocityBodyCoord = angularVelocitiesBodyCoords    ...
                                                            ( :, timeIndex );
            currentAngularMomentumBodyCoord = angularMomentumsBodyCoords     ...
                                                            ( :, timeIndex );
         %----------------------------------------------------------------------
            currentAngularVelocityInertialCoord =                            ...
                                  bodyToInertialTransformMatrix *            ...
                                  currentAngularVelocityBodyCoord;
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            angularVelocitiesInertialCoords                                  ...
                             (                                               ...
                               :, timeIndex                                  ...
                             ) =  currentAngularVelocityInertialCoord( : );
         %----------------------------------------------------------------------
            currentAngularMomentumInertialCoord =                            ...
                                  bodyToInertialTransformMatrix *            ...
                                  currentAngularMomentumBodyCoord;
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            angularMomentumsInertialCoords                                   ...
                            (                                                ...
                               :, timeIndex                                  ...
                            )  =  currentAngularMomentumInertialCoord( : );
         %----------------------------------------------------------------------
         %  Use inertial values to compute the current rotational kinetic
         %  energy value.
         %----------------------------------------------------------------------
            currentRotationalKineticEnergy =                                 ...
                             0.5 *                                           ...
                             dot(                                            ...
                                  currentAngularVelocityInertialCoord,       ...
                                  currentAngularMomentumInertialCoord        ...
                                );
         %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            rotationalKineticEnergies                                        ...
                             ( timeIndex ) = currentRotationalKineticEnergy;
         %}---------------------------------------------------------------------
        end;
     %}-------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   return;
%}------------------------------------------------------------------------------

