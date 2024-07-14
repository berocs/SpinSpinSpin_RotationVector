function                                                                     ...
[                                                                            ...
  angularVelocityVectorPatchGraphicsHandle,                                  ...
  angularVelocityLabelHandle                                                 ...
] =                                                                          ...
createAngularVelocityVector                                                  ...
      (                                                                      ...
        arrowColor,                                                          ...
        labelColor,                                                          ...
        initialReferencePosition,                                            ...
        angularVelocityVectorEndCoordinates,                                 ...
        specifiedFont,                                                       ...
        specifiedFontSize                                                    ...
      )
%===============================================================================
%|
%| UNCLASSIFIED
%|
%|==============================================================================
%|
%| FUNCTION:
%|
%|   createAngularVelocityVector
%|
%| PURPOSE:
%|
%|   This function will create:
%|     [ 1 ] A graphics object containing the              specified
%|           angular velocity arrow vector.
%|     [ 2 ] A graphics object containing the label of the specified
%|           angular velocity arrow vector.
%|
%| INPUT(s):
%|
%|   arrowColor
%|     The color to be used for the angular velocity arrow vector.
%|
%|   labelColor
%|     The color to be used for the angular velocity arrow label.`
%|
%|   initialReferencePosition
%|     The (x,y,z) inertial World Coordinates (WCS) of the origin
%|     of the Body Coordinates System (BCS).
%|
%|   angularVelocityVectorEndCoordinates
%|     The (x,y,z) coordinates of the end of the angular velocity
%|     vector.
%|
%|   specifiedFontSize
%|     The font size to be used for the x body axis arrow label.
%|
%|   specifiedFont
%|     The font style to be used for the x body axis arrow label.
%|
%| OUTPUT(s):
%|
%|   angularVelocityVectorPatchGraphicsHandle
%|     The handle of the graphics object containing the specified
%|     angular velocity vector.
%|
%|   angularVelocityLabelHandle
%|     The handle of the graphics object containing the label for the
%|     specified angular velocity vector.
%|
%|------------------------------------------------------------------------------
%|
%| USAGE:
%|
%|   [                                                 ...
%|     angularVelocityVectorPatchGraphicsHandle,       ...
%|     angularVelocityLabelHandle                      ...
%|   ] = createAngularVelocityVector                   ...
%|             (                                       ...
%|               arrowColor,                           ...
%|               labelColor,                           ...
%|               initialReferencePosition,             ...
%|               angularVelocityVectorEndCoordinates,  ...
%|               specifiedFontSize,                    ...
%|               specifiedFont                         ...
%|             );
%|
%|==============================================================================
%|
%| UNCLASSIFIED
%|
%===============================================================================

%===============================================================================
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%===============================================================================

%{------------------------------------------------------------------------------
   STDOUT = 1;
%-------------------------------------------------------------------------------
   expectedNumberInputArgs  = 6;
   expectedNumberOutputArgs = 2;

   actualNumberInputArgs    = nargin;
   actualNumberOutputArgs   = nargout;
%-------------------------------------------------------------------------------
%  Check number of input arguments.
%-------------------------------------------------------------------------------
   if( actualNumberInputArgs == expectedNumberInputArgs )
    %{--------------------------------------------------------------------------
    %  Encountered expected number of input arguments.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  Check number of output arguments.
    %---------------------------------------------------------------------------
       if( actualNumberOutputArgs == expectedNumberOutputArgs )
        %{----------------------------------------------------------------------
        %  Encountered expected number of input arguments.
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        %  Obtain color definitions.
        %-----------------------------------------------------------------------
           colorDefinitions;
        %-----------------------------------------------------------------------
        %  Create a graphics object containing a two dimensional representation
        %  of the specified three dimensional angular velocity arrow vector.
        %-----------------------------------------------------------------------
           X        = 1;
           Y        = 2;
           Z        = 3;
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           angularVelocityUnitVector =                                       ...
                                    angularVelocityVectorEndCoordinates    / ...
                              norm( angularVelocityVectorEndCoordinates );
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           angularVelocityScaleFactor = 0.9;
           angularVelocityIndicatorVector = angularVelocityScaleFactor *     ...
                                            angularVelocityUnitVector;
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           arrowStop3D  = initialReferencePosition +                         ...
                          [                                                  ...
                            angularVelocityIndicatorVector( X );             ...
                            angularVelocityIndicatorVector( Y );             ...
                            angularVelocityIndicatorVector( Z )              ...
                          ];
        %-----------------------------------------------------------------------
           angularVelocityVectorPatchGraphicsHandle = [ ];
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           [                                                                 ...
             angularVelocityVectorPatchGraphicsHandle                        ...
           ] = mArrow3Create                                                 ...
                 (                                                           ...
                    initialReferencePosition,                                ...
                    arrowStop3D,                                             ...
                    'Color',            arrowColor                           ...
                 );
        %-----------------------------------------------------------------------
        %  Create a graphics object containing a two dimensional representation
        %  of the label for specified three dimensional angular velocity arrow
        %  vector.
        %-----------------------------------------------------------------------
           [                                                                 ...
             angularVelocityLabelString                                      ...
           ] = sprintf                                                       ...
                (                                                            ...
                  '%s',                                                      ...
                  ' \omega'                                                  ...
                );
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           angularVelocityLabelHandle = [ ];
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           [                                                                 ...
             angularVelocityLabelHandle                                      ...
           ] = text                                                          ...
                (                                                            ...
                  arrowStop3D( X ),                                          ...
                  arrowStop3D( Y ),                                          ...
                  arrowStop3D( Z ),                                          ...
                  angularVelocityLabelString,                                ...
                  'FontName',                  'Helvetica',                  ...
                  'FontSize',                  24,                           ...
                  'FontWeight',                'Bold',                       ...
                  'Color',                     labelColor                    ...
                );
        %}----------------------------------------------------------------------
       else
        %{----------------------------------------------------------------------
        %  Encountered unexpected number of output arguments.
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        %  This is an error.
        %  Generate a  purpose message.
        %-----------------------------------------------------------------------
           [                                                                 ...
             purposeMessageString                                            ...
           ] = generatePurposeMessage(  );
        %-----------------------------------------------------------------------
        %  Generate an usage   message.
        %-----------------------------------------------------------------------
           [                                                                 ...
             usageMessageString                                              ...
           ] = generateUsageMessage(  );
        %-----------------------------------------------------------------------
        %  Output a  purpose message.
        %-----------------------------------------------------------------------
           fprintf                                                           ...
             (                                                               ...
               STDOUT,                                                       ...
               '%s',                                                         ...
               purposeMessageString                                          ...
             );
        %-----------------------------------------------------------------------
        %  Output an usage   message.
        %-----------------------------------------------------------------------
           fprintf                                                           ...
             (                                                               ...
               STDOUT,                                                       ...
               '%s',                                                         ...
               usageMessageString                                            ...
             );
        %-----------------------------------------------------------------------
        %  Generate an error message.
        %-----------------------------------------------------------------------
           errorMessageFormattingString =                                    ...
                [                                                            ...
                  '\n\n\n'                                                   ...
                  '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                         ...
                  '%s%d\n'                                                   ...
                  '%s%d\n'                                                   ...
                  '%s\n%s\n%s\n%s\n%s\n'                                     ...
                  '\n\n\n'                                                   ...
                ];
        %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           fprintf                                                           ...
           (                                                                 ...
             STDOUT,                                                         ...
             errorMessageFormattingString,                                   ...
             '------------------------------------------------------------', ...
             '|',                                                            ...
             '| ERROR:',                                                     ...
             '|',                                                            ...
             '|   Function "createAngularVelocityVector":',                  ...
             '|',                                                            ...
             '|   Encountered unexpected number of output arguments.',       ...
             '|',                                                            ...
             '|   Expected number output arguments:-->',                     ...
             expectedNumberOutputArgs,                                       ...
             '|   Actual   number output arguments:-->',                     ...
             actualNumberOutputArgs,                                         ...
             '|',                                                            ...
             '|  This is an error.',                                         ...
             '|  The program will terminate.',                               ...
             '|',                                                            ...
             '------------------------------------------------------------'  ...
            );
        %-----------------------------------------------------------------------
           angularVelocityVectorPatchGraphicsHandle = [ ];
           angularVelocityLabelHandle               = [ ];
        %-----------------------------------------------------------------------
        %  Terminate the program.
        %-----------------------------------------------------------------------
           error( 'Encountered unexpected number of output arguments.' );
        %}----------------------------------------------------------------------
       end;
    %}--------------------------------------------------------------------------
   else
    %{--------------------------------------------------------------------------
    %  Encountered unexpected number of input arguments.
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %  This is an error.
    %  Generate a  purpose message.
    %---------------------------------------------------------------------------
       [                                                                     ...
         purposeMessageString                                                ...
       ] = generatePurposeMessage(  );
    %---------------------------------------------------------------------------
    %  Generate an usage   message.
    %---------------------------------------------------------------------------
       [                                                                     ...
         usageMessageString                                                  ...
       ] = generateUsageMessage(  );
    %---------------------------------------------------------------------------
    %  Output a  purpose message.
    %---------------------------------------------------------------------------
       fprintf                                                               ...
         (                                                                   ...
           STDOUT,                                                           ...
           '%s',                                                             ...
           purposeMessageString                                              ...
         );
    %---------------------------------------------------------------------------
    %  Output an usage   message.
    %---------------------------------------------------------------------------
       fprintf                                                               ...
         (                                                                   ...
           STDOUT,                                                           ...
           '%s',                                                             ...
           usageMessageString                                                ...
         );
    %---------------------------------------------------------------------------
    %  Generate an error message.
    %---------------------------------------------------------------------------
       errorMessageFormattingString =                                        ...
            [                                                                ...
              '\n\n\n'                                                       ...
              '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                             ...
              '%s%d\n'                                                       ...
              '%s%d\n'                                                       ...
              '%s\n%s\n%s\n%s\n%s\n'                                         ...
              '\n\n\n'                                                       ...
            ];
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       fprintf                                                               ...
       (                                                                     ...
         STDOUT,                                                             ...
         errorMessageFormattingString,                                       ...
         '----------------------------------------------------------------', ...
         '|',                                                                ...
         '| ERROR:',                                                         ...
         '|',                                                                ...
         '|   Function "createAngularVelocityVector":',                      ...
         '|',                                                                ...
         '|   Encountered unexpected number of input arguments.',            ...
         '|',                                                                ...
         '|   Expected number input  arguments:-->',                         ...
         expectedNumberInputArgs,                                            ...
         '|   Actual   number input  arguments:-->',                         ...
         actualNumberInputArgs,                                              ...
         '|',                                                                ...
         '|  This is an error.',                                             ...
         '|  The program will terminate.',                                   ...
         '|',                                                                ...
         '----------------------------------------------------------------'  ...
       );
    %---------------------------------------------------------------------------
       angularVelocityVectorPatchGraphicsHandle = [ ];
       angularVelocityLabelHandle               = [ ];
    %---------------------------------------------------------------------------
    %  Terminate the program.
    %---------------------------------------------------------------------------
       error( 'Encountered unexpected number of input arguments.' );
    %}--------------------------------------------------------------------------
   end;
%-------------------------------------------------------------------------------
   return;
%}------------------------------------------------------------------------------


%===============================================================================
function                                                                     ...
[                                                                            ...
  purposeMessageString                                                       ...
] =                                                                          ...
generatePurposeMessage(  )
%{------------------------------------------------------------------------------
   purposeMessageFormattingString =                                          ...
          [                                                                  ...
            '\n\n\n',                                                        ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                       ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                       ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                       ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                       ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                       ...
            '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                           ...
            '\n\n\n'                                                         ...
          ];
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   [                                                                         ...
     purposeMessageString                                                    ...
   ] =                                                                       ...
    sprintf                                                                  ...
     (                                                                       ...
       purposeMessageFormattingString,                                       ...
       '==================================================================', ...
       '|',                                                                  ...
       '| UNCLASSIFIED',                                                     ...
       '|',                                                                  ...
       '|=================================================================', ...
       '|',                                                                  ...
       '| FUNCTION:',                                                        ...
       '|',                                                                  ...
       '|   createAngularVelocityVector',                                    ...
       '|',                                                                  ...
       '| PURPOSE:',                                                         ...
       '|',                                                                  ...
       '|   This function will create:',                                     ...
       '|     [ 1 ] A graphics object containing the angular velocity',      ...
       '|           vector.',                                                ...
       '|     [ 2 ] A graphics object containing the label of the angular',  ...
       '|           velocity vector.',                                       ...
       '|',                                                                  ...
       '| INPUT(s):',                                                        ...
       '|',                                                                  ...
       '|   arrowColor',                                                     ...
       '|     The color to be used for the angular velocity vector',         ...
       '|     arrow.',                                                       ...
       '|',                                                                  ...
       '|   labelColor',                                                     ...
       '|     The color to be used for the angular velocity vector',         ...
       '|     label.',                                                       ...
       '|',                                                                  ...
       '|   initialReferencePosition',                                       ...
       '|     The (x,y,z) inertial World Coordinates (WCS) of the origin',   ...
       '|     of the Body Coordinates System (BCS).',                        ...
       '|',                                                                  ...
       '|   angularVelocityVectorEndCoordinates',                            ...
       '|     The (x,y,z) coordinates of the end of the angular velocity',   ...
       '|     arrow vector.',                                                ...
       '|',                                                                  ...
       '|   specifiedFontSize',                                              ...
       '|     The font size to be used for the angular velocity arrow',      ...
       '|     label.',                                                       ...
       '|',                                                                  ...
       '|   specifiedFont',                                                  ...
       '|     The font style to be used for the angular velocity arrow',     ...
       '|     label.',                                                       ...
       '|',                                                                  ...
       '| OUTPUT(s):',                                                       ...
       '|',                                                                  ...
       '|   angularVelocityVectorPatchGraphicsHandle',                       ...
       '|     The handle of the patch graphics object containing the',       ...
       '|     angular velocity vector.',                                     ...
       '|',                                                                  ...
       '|   angularVelocityLabelHandle',                                     ...
       '|     The handle of the graphics object containing the label for',   ...
       '|     the angular velocity vector.',                                 ...
       '|',                                                                  ...
       '|=================================================================', ...
       '|',                                                                  ...
       '| UNCLASSIFIED',                                                     ...
       '|',                                                                  ...
       '=================================================================='  ...
     );
%-------------------------------------------------------------------------------
   return;
%}------------------------------------------------------------------------------


%===============================================================================
function                                                                     ...
[                                                                            ...
  usageMessageString                                                         ...
] =                                                                          ...
generateUsageMessage(  )
%{------------------------------------------------------------------------------
   usageMessageFormattingString =                                            ...
        [                                                                    ...
          '\n\n\n'                                                           ...
          '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                         ...
          '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n'                                 ...
          '\n\n\n'                                                           ...
        ];
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   [                                                                         ...
     usageMessageString                                                      ...
   ] =                                                                       ...
    sprintf                                                                  ...
     (                                                                       ...
       usageMessageFormattingString,                                         ...
       '----------------------------------------------------------------',   ...
       '|',                                                                  ...
       '| USAGE:',                                                           ...
       '|',                                                                  ...
       '|   [                                                 ...',          ...
       '|     angularVelocityVectorPatchGraphicsHandle,       ...',          ...
       '|     angularVelocityLabelHandle                      ...',          ...
       '|   ] = createAngularVelocityVector                   ...',          ...
       '|             (                                       ...',          ...
       '|               arrowColor,                           ...',          ...
       '|               labelColor,                           ...',          ...
       '|               initialReferencePosition,             ...',          ...
       '|               angularVelocityVectorEndCoordinates,  ...',          ...
       '|               specifiedFontSize,                    ...',          ...
       '|               specifiedFont                         ...',          ...
       '|             );',                                                   ...
       '|',                                                                  ...
       '----------------------------------------------------------------'    ...
     );
%-------------------------------------------------------------------------------
   return;
%}------------------------------------------------------------------------------


%===============================================================================
%
%  UNCLASSIFIED
%
%===============================================================================
