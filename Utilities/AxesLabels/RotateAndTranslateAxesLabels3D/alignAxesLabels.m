function                                                                     ...
alignAxesLabels                                                              ...
     (                                                                       ...
       ~,                                                                    ...
       ax                                                                    ...
     )
%===============================================================================
%|
%| FUNCTION:
%|   alignAxesLabels
%|
%| PURPOSE:
%|
%|   This function first rotates the x, y and z labels of a plot figure
%|   to the direction of their corresponding axes after a user invoked
%|   rotate operation has finished.
%|
%|   The labels will become parallel to plot axes.
%|
%|   Finally this function will move the axis labels to a proper 
%|   distance from the axes by invoking of the function
%|   axisLabelTranslation.
%|
%| INPUTS:
%|
%|   ~
%|   ax
%|
%| OUTPUTS:
%|
%|   None
%|
%| NOTE(s):
%|
%|   [ 1 ]  This function is used as a callback function via the
%|          parameter 'ActionPostCallback' of the Matlab rotate3d
%|          function object.
%|
%|   [ 2 ]  This function works when the projection mode is
%|          perspective or when the data aspect ratio is not
%|          uniform axes length ([ 1 1 1 ]).
%|
%| EXAMPLE(s):
%|
%|   [ 1 ] Set the Matlab ActionPostCallback to alignAxesLabels
%|         via the following Matlab statements:
%|
%|           handleRotate3D = rotate3d;
%|           set                                           ...
%|            (                                            ...
%|              handleRotate3D                             ...
%|              'ActionPostCallback',  @alignAxesLabels    ...
%|            );
%|
%|   [ 2 ] Set the Matlab WindowButtonMotionFcn to
%|         alignAxesLabels via the following statements:
%|
%|           handleRotate3D = rotate3d;
%|
%|           set                                                     ...
%|            (                                                      ...
%|              handleRotate3D                                       ...
%|              'ActionPreCallback',   @alignAxesLabels              ...
%|            );
%|           set                                                     ...
%|            (                                                      ...
%|              handleRotate3D                                       ...
%|              'ActionPostCallback',                                ...
%|                  'set( gcf, ''windowButtonMotionFcn'', '''' )' )
%|            );
%|
%===============================================================================


%===============================================================================
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%===============================================================================


%{------------------------------------------------------------------------------
%
% NOTE(s):
%
%   [ 1 ]  trans_mode controls the way to define
%            trans_vec_x
%              and 
%            trans_vec_y,
%          which are input arguments passed to function
%            axislabel_translation.
%
%   [ 2 ]  x-axis for example:
%          If trans_mode == 2,
%             the translation direction is parallel      to the y-axis,
%          If trans_mode == 1,
%             the translation direction is perpendicular to the x-axis.
%
%-------------------------------------------------------------------------------
   trans_mode = 1;
%-------------------------------------------------------------------------------
   if( isa( ax, 'struct' ) == true )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       currentAxesHandle = ax.Axes;
    %}--------------------------------------------------------------------------
   elseif                                                                    ...
     ( isa( ax, 'matlab.graphics.axis.Axes' ) == true )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       currentAxesHandle = ax;
    %}--------------------------------------------------------------------------
   else
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       currentAxesHandle = gca;
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   ORTHOGRAPHIC_PROJECTION_MODE = 1;
    PERSPECTIVE_PROJECTION_MODE = 2;
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   projectionMode = get( currentAxesHandle, 'projection' );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if( strcmpi( projectionMode, 'orthographic' ) == true )
    %{--------------------------------------------------------------------------
    %  The type of projection of the 3D data onto the 2D screen view is
    %  ORTHOGRAPHIC.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %  ORTHOGRAPHIC PROJECTION MODE:
    %
    %    Maintain the correct relative dimensions of graphics objects
    %    regarding the distance of a given point from the viewer,
    %    AND
    %    draw lines that are parallel in the data parallel on the screen.
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Set projection mode to ORTHOGRAPHIC.
    %---------------------------------------------------------------------------
       projectionMode = ORTHOGRAPHIC_PROJECTION_MODE;
    %}--------------------------------------------------------------------------
   else
    %{--------------------------------------------------------------------------
    %  The type of projection of the 3D data onto the 2D screen view is
    %  not ORTHOGRAPHIC.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Assume the type of projection of the 3D data onto the 2D screen view is
    %  PERSPECTIVE.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %  PERSPECTIVE PROJECTION MODE:
    %
    %    Incorporate foreshortening,
    %    which enables you to perceive depth in 2-D representations
    %    of 3-D objects.
    %
    %    Perspective projection does not preserve the relative dimensions
    %    of objects.
    %
    %    Instead, it displays a distant line segment smaller than a
    %    nearer line segment of the same length.
    %
    %    Lines that are parallel in the data might not appear
    %    parallel on screen
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Set projection mode to PERSPECTIVE.
    %---------------------------------------------------------------------------
       projectionMode = PERSPECTIVE_PROJECTION_MODE;
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
%
%  Data Aspect Ratio:
%
%    Relative length of data units along each axis,
%    specified as a three-element vector of the form [dx dy dz].
%
%    This vector defines the relative x, y, and z data scale factors.
%
%-------------------------------------------------------------------------------
   dataAspectRatio = get( currentAxesHandle, 'dataAspectRatio' );
   dataAspectRatio = dataAspectRatio( : );
%-------------------------------------------------------------------------------
%  Optional, you can comment this line out.
%-------------------------------------------------------------------------------
   set(                                                                      ...
        currentAxesHandle,                                                   ...
        'DataAspectRatio', dataAspectRatio                                   ...
      );
%-------------------------------------------------------------------------------
   xAxisLimit     = get( currentAxesHandle, 'xlim' );
   yAxisLimit     = get( currentAxesHandle, 'ylim' );
   zAxisLimit     = get( currentAxesHandle, 'zlim' );
%-------------------------------------------------------------------------------
%  Camera Vector:  A vector from the camera target to the camera.
%-------------------------------------------------------------------------------
   cameraPosition = get( currentAxesHandle, 'cameraPosition' );
   cameraTarget   = get( currentAxesHandle, 'cameraTarget'   );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   cameraVector   = cameraPosition - cameraTarget;
%-------------------------------------------------------------------------------
%  Near Field:   Distance from camera to camera target.
%-------------------------------------------------------------------------------
   TWO_NORM       = 2;
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   nearFieldNorm  = norm( cameraVector, TWO_NORM );
%-------------------------------------------------------------------------------
   [                                                                         ...
     cameraLineOfSightAzimuthAngleDeg,                                       ...
     cameraLineOfSightElevationAngleDeg                                      ...
   ] = view;
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if( abs( abs( cameraLineOfSightElevationAngleDeg ) - 90.0 ) < eps )
    %{--------------------------------------------------------------------------
    %  Camera line of sight elevation angle is 90 degrees.
    %  Camera is looking directly down or up to the target.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Adjust the camera line of sight azimuth angle using the
    %  data aspect ratio.
    %---------------------------------------------------------------------------
       xDataAspectRatio = dataAspectRatio( 1 );
       yDataAspectRatio = dataAspectRatio( 2 );
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       cameraLineOfSightAzimuthAngleDeg =                                    ...
             atan2d                                                          ...
              (                                                              ...
                yDataAspectRatio * sind( cameraLineOfSightAzimuthAngleDeg ), ...
                xDataAspectRatio * cosd( cameraLineOfSightAzimuthAngleDeg )  ...
              );
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   RADIANS_PER_DEGREE = pi / 180.0;
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   cameraLineOfSightAzimuthAngleRad   = RADIANS_PER_DEGREE *                 ...
                                        cameraLineOfSightAzimuthAngleDeg;
   cameraLineOfSightElevationAngleRad = RADIANS_PER_DEGREE *                 ...
                                        ( 90.0 -                             ...
                                          cameraLineOfSightElevationAngleDeg );
%-------------------------------------------------------------------------------
%
%  Azimuth Rotation Matrix About z axis:
%
%-------------------------------------------------------------------------------
   rotationAzimuthAngle = -cameraLineOfSightAzimuthAngleRad;
   cosineAzimuth        =  cos( rotationAzimuthAngle );
     sineAzimuth        =  sin( rotationAzimuthAngle );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   rotationCameraLineOfSightAzimuth =                                        ...
           [                                                                 ...
              cosineAzimuth, -  sineAzimuth,            0.0,            0.0; ...
                sineAzimuth,  cosineAzimuth,            0.0,            0.0; ...
                        0.0,            0.0,            1.0,            0.0; ...
                        0.0,            0.0,            0.0,            1.0  ...
           ];
%-------------------------------------------------------------------------------
%
%  Elevation Rotation Matrix About x axis:
%
%-------------------------------------------------------------------------------
   rotationElevationAngle = -cameraLineOfSightElevationAngleRad;
   cosineElevation        =  cos( rotationElevationAngle );
     sineElevation        =  sin( rotationElevationAngle );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   rotationCameraLineOfSightElevation =                                      ...
           [                                                                 ...
             1.0,              0.0,              0.0,             0.0;       ...
             0.0,  cosineElevation, -  sineElevation,             0.0;       ...
             0.0,    sineElevation,  cosineElevation,             0.0;       ...
             0.0,              0.0,              0.0,             1.0        ...
           ];
%-------------------------------------------------------------------------------
%
%  Translation Matrices:
%
%-------------------------------------------------------------------------------
   X     = 1;
   Y     = 2;
   Z     = 3;
%-------------------------------------------------------------------------------
%  Translate the camera target position to be at the origin.
%-------------------------------------------------------------------------------
   T_tar =                                                                   ...
     [                                                                       ...
       1.0,     0.0,     0.0, -cameraTarget( X );                            ...
       0.0,     1.0,     0.0, -cameraTarget( Y );                            ...
       0.0,     0.0,     1.0, -cameraTarget( Z );                            ...
       0.0,     0.0,     0.0,                1.0                             ...
     ];
%-------------------------------------------------------------------------------
%  Translate the camera position to be at the origin?
%-------------------------------------------------------------------------------
   T_cam =                                                                   ...
     [                                                                       ...
       1.0,     0.0,     0.0,                0.0;                            ...
       0.0,     1.0,     0.0,                0.0;                            ...
       0.0,     0.0,     1.0,     -nearFieldNorm;                            ...
       0.0,     0.0,     0.0,                1.0                             ...
     ];
%-------------------------------------------------------------------------------
%
%  Obtain the corrdinates of the eight 3D Viewing Area Vertices.
%
%-------------------------------------------------------------------------------
%
%    Z
%     |                Y
%     |                /
%     |               /      8--------------7
%     |              /      /|             /|
%     |             /      / |            / |
%     |            /      /  |           /  |
%     |           /      /   |          /   |
%     |          /      5----|---------6    |     3D Viewing Area Vertices
%     |         /       |    |         |    |
%     |        /        |    |         |    |
%     |       /         |    |         |    |
%     |      /          |    4---------|----3
%     |     /           |   /          |   /
%     |    /            |  /           |  /
%     |   /             | /            | /
%     |  /              |/             |/
%     | /               1--------------2
%     |/
%     +-------------------------------------->X
%
%-------------------------------------------------------------------------------
   minimumX = xAxisLimit( 1 );
   maximumX = xAxisLimit( 2 );
   minimumY = yAxisLimit( 1 );
   maximumY = yAxisLimit( 2 );
   minimumZ = zAxisLimit( 1 );
   maximumZ = zAxisLimit( 2 );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   viewAreaVertices3D   =                                                    ...
       [                                                                     ...
         minimumX,   minimumY,   minimumZ,        1.0;                       ...
         maximumX,   minimumY,   minimumZ,        1.0;                       ...
         maximumX,   maximumY,   minimumZ,        1.0;                       ...
         minimumX,   maximumY,   minimumZ,        1.0;                       ...
         minimumX,   minimumY,   maximumZ,        1.0;                       ...
         maximumX,   minimumY,   maximumZ,        1.0;                       ...
         maximumX,   maximumY,   maximumZ,        1.0;                       ...
         minimumX,   maximumY,   maximumZ,        1.0                        ...
       ]';
%-------------------------------------------------------------------------------
   pnt_cam = zeros( 4, 8 );
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if( projectionMode == ORTHOGRAPHIC_PROJECTION_MODE )
    %{--------------------------------------------------------------------------
    %  The type of projection of the 3D data onto the 2D screen view is
    %  ORTHOGRAPHIC.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %  ORTHOGRAPHIC PROJECTION MODE:
    %
    %    [ 1 ] Maintain the correct relative dimensions of graphics objects
    %          regarding the distance of a given point from the viewer,
    %
    %    [ 2 ] Draw lines that are parallel in the data parallel on the screen.
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Far field, the value would not influence the projection.
    %---------------------------------------------------------------------------
       farField = nearFieldNorm + 100.0;
    %---------------------------------------------------------------------------
       a      = -( farField + nearFieldNorm ) /                              ...
                 ( farField - nearFieldNorm );
       b      = -( 2.0 * farField * nearFieldNorm ) /                        ...
                 ( farField - nearFieldNorm );
       orthogonalProjectionMatrix =                                          ...
                 [                                                           ...
                   nearFieldNorm,            0.0,          0.0,         0.0; ...
                             0.0,  nearFieldNorm,          0.0,         0.0; ...
                             0.0,            0.0,            a,           b; ...
                             0.0,            0.0,         -1.0,         0.0  ...
                 ];
    %---------------------------------------------------------------------------
    %  Determine coorindates for the 3D camera viewing area vertices.
    %---------------------------------------------------------------------------
       for( columnIndex = 1 : 8 )
         %{---------------------------------------------------------------------
            currentViewVertex         = viewAreaVertices3D( :, columnIndex );
         %----------------------------------------------------------------------
         %  Translate the current vertex to coordinates where the origin is at
         %  the camera target.
         %----------------------------------------------------------------------
            translatedViewingVertex   = T_tar * currentViewVertex;
         %----------------------------------------------------------------------
         %  Scale the current vertex.
         %----------------------------------------------------------------------
            translatedViewingVertex                                          ...
                          ( 1 : 3 )   = translatedViewingVertex( 1 : 3 ) ./  ...
                                        dataAspectRatio;
            p                         = rotationCameraLineOfSightElevation   ...
                                        *                                    ...
                                        rotationCameraLineOfSightAzimuth     ...
                                        *                                    ...
                                        translatedViewingVertex;
            p                         = T_cam  * p;
            pnt_cam( :, columnIndex ) = orthogonalProjectionMatrix * p;
         %}---------------------------------------------------------------------
       end;
    %---------------------------------------------------------------------------
       xAxisVector = pnt_cam( :, 2 ) - pnt_cam( :, 1 );
       yAxisVector = pnt_cam( :, 4 ) - pnt_cam( :, 1 );
       zAxisVector = pnt_cam( :, 5 ) - pnt_cam( :, 1 );
    %---------------------------------------------------------------------------
    %  Find the index of the left-most point in the field of view.
    %  (minimum x value over all vertices)
    %---------------------------------------------------------------------------
       [ ~, ix ] = min( pnt_cam( 1, : ) );
    %---------------------------------------------------------------------------
    %  Find the index of the lowest point in the field of view.
    %  (minimum y value over all vertices)
    %---------------------------------------------------------------------------
       [ ~, iy ] = min( pnt_cam( 2, : ) );
    %---------------------------------------------------------------------------
    %  Use ix to determine       z axis.
    %  Then
    %  Use iy to determine x and y axis.
    %---------------------------------------------------------------------------
       switch( ix )
            %{------------------------------------------------------------------
               case{ 1, 5 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 1 and 5.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 1 );                      ...
                                       yAxisLimit( 1 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 2 )
                      %{--------------------------------------------------------
                      %  iy is 2.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 4.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 2, 6 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 2 and 6.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 2 );                      ...
                                       yAxisLimit( 1 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 3 )
                      %{--------------------------------------------------------
                      %  iy is 3.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 1.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 1 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 1 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 3, 7 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 3 and 7.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 2 );                      ...
                                       yAxisLimit( 2 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 4 )
                      %{--------------------------------------------------------
                      %  iy is 4.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 2.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 4, 8 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 4 and 8.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 1 );                      ...
                                       yAxisLimit( 2 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 1 )
                      %{--------------------------------------------------------
                      %  iy is 1.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 1 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 1 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 3.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         trans_vec_x_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %}------------------------------------------------------------------
       end;
    %}--------------------------------------------------------------------------
   else
    %{--------------------------------------------------------------------------
    %  The type of projection of the 3D data onto the 2D screen view is
    %  not ORTHOGRAPHIC.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Assume the type of projection of the 3D data onto the 2D screen view is
    %  PERSPECTIVE.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %  PERSPECTIVE PROJECTION MODE:
    %
    %    [ 1 ]  Incorporate foreshortening,
    %           which enables you to perceive depth in 2-D representations
    %           of 3-D objects.
    %
    %    [ 2 ]  Perspective projection does not preserve the relative
    %           dimesions of objects.
    %
    %    [ 3 ]  Instead, it displays a distant line segment smaller than a
    %           nearer line segment of the same length.
    %
    %    [ 4 ]  Lines that are parallel in the data might not appear
    %           parallel on screen
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Far field, the value would not influence the projection.
    %---------------------------------------------------------------------------
       for( columnIndex = 1 : 8 )
         %{---------------------------------------------------------------------
            p          = viewAreaVertices3D( :, columnIndex );
            p          = T_tar * p;
            p( 1 : 3 ) = p( 1 : 3 ) ./ dataAspectRatio;
            p          = rotationCameraLineOfSightElevation                  ...
                         *                                                   ...
                         rotationCameraLineOfSightAzimuth                    ...
                         *                                                   ...
                         p;
            p          = T_cam * p;
            z          = p( 3 );
            factorZ    = newFieldNorm / z;
            M_pers     = [                                                   ...
                           -factorZ,  0.0,       0.0,             0.0;       ...
                            0.0,     -factorZ,   0.0,             0.0;       ...
                            0,0,      0.0,      -nearFieldNorm,   0.0;       ...
                            0.0,      0.0,       0.0,             1.0        ...
                         ];
            pnt_cam( :, columnIndex ) = M_pers * p;
         %}---------------------------------------------------------------------
       end;
    %---------------------------------------------------------------------------
    %  Find the index of the left-most point in the field of view.
    %  (minimum x value over all vertices)
    %---------------------------------------------------------------------------
       [ ~, ix ] = min( pnt_cam( 1, : ) );
    %---------------------------------------------------------------------------
    %  Find the index of the lowest point in the field of view.
    %  (minimum y value over all vertices)
    %---------------------------------------------------------------------------
       [ ~, iy ] = min( pnt_cam( 2, : ) );
    %---------------------------------------------------------------------------
    %  Find the proper axis to label.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Use ix to determine       z axis.
    %  Then
    %  Use iy to determine x and y axis.
    %---------------------------------------------------------------------------
       switch( ix )
            %{------------------------------------------------------------------
               case{ 1, 5 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 1 and 5.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     zAxisVector = pnt_cam( :, 5 ) - pnt_cam( :, 1 );
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 1 );                      ...
                                       yAxisLimit( 1 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 2 )
                      %{--------------------------------------------------------
                      %  iy is 2.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         xAxisVector      = pnt_cam(   :,   2 ) -            ...
                                            pnt_cam(   :,   1 );
                         yAxisVector      = pnt_cam(   :,   3 ) -            ...
                                            pnt_cam(   :,   2 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge =  viewAreaVertices3D( 1 : 2, 2 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 1 );
                         trans_vec_y_edge =  viewAreaVertices3D( 1 : 2, 2 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 4.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         yAxisVector      = pnt_cam(   :,   4 ) -            ...
                                            pnt_cam(   :,   1 );
                         xAxisVector      = pnt_cam(   :,   3 ) -            ...
                                            pnt_cam(   :,   2 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 4 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 2, 6 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 2 and 6.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     zAxisVector = pnt_cam( :, 6 ) - pnt_cam( :, 2 );
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 2 );                      ...
                                       yAxisLimit( 1 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 3 )
                      %{--------------------------------------------------------
                      %  iy is 3.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         yAxisVector      = pnt_cam(   :,   3 ) -            ...
                                            pnt_cam(   :,   2 );
                         xAxisVector      = pnt_cam(   :,   4 ) -            ...
                                            pnt_cam(   :,   3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge =  viewAreaVertices3D( 1 : 2, 3 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 2 );
                         trans_vec_y_edge =  viewAreaVertices3D( 1 : 2, 3 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 1.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         xAxisVector      = pnt_cam(   :,   1 ) -            ...
                                            pnt_cam(   :,   2 );
                         yAxisVector      = pnt_cam(   :,   4 ) -            ...
                                            pnt_cam(   :,   1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 3, 7 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 3 and 7.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     zAxisVector = pnt_cam( :, 7 ) - pnt_cam( :, 3 );
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 2 );                      ...
                                       yAxisLimit( 2 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 4 )
                      %{--------------------------------------------------------
                      %  iy is 4.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         xAxisVector      = pnt_cam(   :,   4 ) -            ...
                                            pnt_cam(   :,   3 );
                         yAxisVector      = pnt_cam(   :,   1 ) -            ...
                                            pnt_cam(   :,   4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge =  viewAreaVertices3D( 1 : 2, 4 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 1 );
                         trans_vec_y_edge =  viewAreaVertices3D( 1 : 2, 4 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 2.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         yAxisVector      = pnt_cam(   :,   2 ) -            ...
                                            pnt_cam(   :,   3 );
                         xAxisVector      = pnt_cam(   :,   1 ) -            ...
                                            pnt_cam(   :,   4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 3 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 2 ) -            ...
                                            pnt_cam( 1 : 2, 1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %-------------------------------------------------------------------
               case{ 4, 8 }
                  %{------------------------------------------------------------
                  %  Minimum x value occurs between points indexed by 4 and 8.
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                  %
                  %-------------------------------------------------------------
                     zAxisVector = pnt_cam( :, 8 ) - pnt_cam( :, 4 );
                  %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                     trans_pnt_z = [                                         ...
                                       xAxisLimit( 1 );                      ...
                                       yAxisLimit( 2 );                      ...
                                     ( zAxisLimit( 1 ) +                     ...
                                       zAxisLimit( 2 )   ) / 2.0             ...
                                   ];
                  %-------------------------------------------------------------
                     if( iy == 1 )
                      %{--------------------------------------------------------
                      %  iy is 1.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         yAxisVector      = pnt_cam(   :,   1 ) -            ...
                                            pnt_cam(   :,   4 );
                         xAxisVector      = pnt_cam(   :,   2 ) -            ...
                                            pnt_cam(   :,   1 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge =  viewAreaVertices3D( 1 : 2, 1 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 4 );
                         trans_vec_y_edge =  viewAreaVertices3D( 1 : 2, 1 )  ...
                                             -                               ...
                                             viewAreaVertices3D( 1 : 2, 2 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 1 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     else
                      %{--------------------------------------------------------
                      %  iy must be 3.
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      %
                      %---------------------------------------------------------
                         xAxisVector      = pnt_cam(   :,   3 ) -            ...
                                            pnt_cam(   :,   4 );
                         yAxisVector      = pnt_cam(   :,   2 ) -            ...
                                            pnt_cam(   :,   3 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_vec_x_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 2 );
                         trans_vec_y_edge = pnt_cam( 1 : 2, 3 ) -            ...
                                            pnt_cam( 1 : 2, 4 );
                      %- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                         trans_pnt_x      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 4 ) ...
                                            ) / 2.0;
                         trans_pnt_y      = (                                ...
                                              viewAreaVertices3D( 1 : 3, 2 ) ...
                                              +                              ...
                                              viewAreaVertices3D( 1 : 3, 3 ) ...
                                            ) / 2.0;
                      %}--------------------------------------------------------
                     end;
                  %}------------------------------------------------------------
            %}------------------------------------------------------------------
       end;
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   if( trans_mode == 1 )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       trans_vec_x = [                                                       ...
                        xAxisVector( 2 );                                    ...
                       -xAxisVector( 1 )                                     ...
                     ];
       trans_vec_y = [                                                       ...
                        yAxisVector( 2 );                                    ...
                       -yAxisVector( 1 )                                     ...
                     ];
       trans_vec_z = [                                                       ...
                       -zAxisVector( 2 );                                    ...
                        zAxisVector( 1 )                                     ...(
                     ];
    %---------------------------------------------------------------------------
       if( ( ( trans_vec_x' ) * trans_vec_x_edge ) < 0.0 )
        %{----------------------------------------------------------------------
        %
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        %
        %-----------------------------------------------------------------------
           trans_vec_x = -trans_vec_x;
        %}----------------------------------------------------------------------
       end;
    %---------------------------------------------------------------------------
       if( ( ( trans_vec_y' ) * trans_vec_y_edge ) < 0.0 )
        %{----------------------------------------------------------------------
        %
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        %
        %-----------------------------------------------------------------------
           trans_vec_y = -trans_vec_y;
        %}----------------------------------------------------------------------
       end
    %}--------------------------------------------------------------------------
   elseif                                                                    ...
     ( trans_mode == 2 )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       trans_vec_x = trans_vec_x_edge;
       trans_vec_y = trans_vec_y_edge;
       trans_vec_z = [                                                       ...
                       -zAxisVector( 2 );                                    ...
                        zAxisVector( 1 )                                     ...
                     ];
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
%  Normalize translation vectors.
%-------------------------------------------------------------------------------
   trans_vec_x = trans_vec_x / norm( trans_vec_x, 2 );
   trans_vec_y = trans_vec_y / norm( trans_vec_y, 2 );
   trans_vec_z = trans_vec_z / norm( trans_vec_z, 2 );
%-------------------------------------------------------------------------------
%  Compute rotation angles.
%-------------------------------------------------------------------------------
   theta_x = atan2d( xAxisVector( 2 ), xAxisVector( 1 ) );
   theta_y = atan2d( yAxisVector( 2 ), yAxisVector( 1 ) );
   theta_z = atan2d( zAxisVector( 2 ), zAxisVector( 1 ) );
%-------------------------------------------------------------------------------
   if( abs( theta_x ) >= 90.0 )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       theta_x = theta_x + 180.0;
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   if( abs( theta_y ) >= 90.0 )
    %{--------------------------------------------------------------------------
    %
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %---------------------------------------------------------------------------
       theta_y = theta_y + 180.0;
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
%  if( abs( theta_z ) >= 90.0 )
%   %{--------------------------------------------------------------------------
%   %
%   %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   %
%   %---------------------------------------------------------------------------
%      theta_z = theta_z + 180.0;
%   %}--------------------------------------------------------------------------
%  end;
%-------------------------------------------------------------------------------
   set(                                                                      ...
        get( currentAxesHandle, 'xlabel' ),                                  ...
        'Rotation',                            theta_x                       ...
      );
   set(                                                                      ...
        get( currentAxesHandle, 'ylabel' ),                                  ...
        'Rotation',                            theta_y                       ...
      );
   set(                                                                      ...
        get( currentAxesHandle, 'zlabel' ),                                  ...
        'Rotation',                            theta_z                       ...
      );
%-------------------------------------------------------------------------------
%
%  Axis label translation
%
%-------------------------------------------------------------------------------
%
%  NOTE(s):
%
%    [ 1 ] Not satisfied with the axis label translations here.
%
%-------------------------------------------------------------------------------
   axisTranslationUnits = 'character';
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   axisLabelTranslation                                                     ...
       (                                                                     ...
         currentAxesHandle,                                                  ...
         [                                                                   ...
           trans_pnt_x,                                                      ...
           trans_pnt_y,                                                      ...
           trans_pnt_z                                                       ...
         ],                                                                  ...
         [                                                                   ...
           trans_vec_x,                                                      ...
           trans_vec_y,                                                      ...
           trans_vec_z                                                       ...
         ],                                                                  ...
         axisTranslationUnits                                                ...
       );
%-------------------------------------------------------------------------------
   return;
%}------------------------------------------------------------------------------
