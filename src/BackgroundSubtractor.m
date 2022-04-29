   classdef BackgroundSubtractor
   %backgroundSubtractor Wrapper class for OpenCV class BackgroundSubtractorMOG2
   %   obj = backgroundSubtractor(history, dist2Threshold, bShadowDetection)
   %   creates an object with properties 
   %
   %   Properties:
   %   history          - Length of the history.
   %   dist2Threshold     - Threshold on the squared Mahalanobis distance
   %   bShadowDetection - Flag to enable/disable shadow detection
   %
   %   fgMask = getForegroundMask(obj, img) computes foreground mask on
   %   input image, img, for the object defined by obj.
   %
   %   reset(obj) resets object.
   %
   %   release(obj) releases object memory.

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %  Properties
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
       properties
           history = 500;
           dist2Threshold = 400;
           bShadowDetection = false;
           kNNSamples = 7;
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %  Public methods
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
       methods
           % Constructor
           function obj = BackgroundSubtractor(history, dist2Threshold, bShadowDetection,kNNSamples)
               if(nargin > 0)
                 obj.history          = history; 
                 obj.dist2Threshold     = dist2Threshold;
                 obj.bShadowDetection = bShadowDetection; 
                 obj.kNNSamples = kNNSamples;
               else
                 obj.history          = 500; 
                 obj.dist2Threshold     = 400;
                 obj.bShadowDetection = false; 
                 obj.kNNSamples = 7;
               end
               params = struct('history', obj.history, ...
                               'dist2Threshold', obj.dist2Threshold, ...
                               'bShadowDetection', obj.bShadowDetection,...
                               'kNNSamples', obj.kNNSamples);
               backgroundSubtractorOCV('construct', params);
           end

           % Get foreground mask
           function fgMask = getForegroundMask(~, img)

               % Get foreground mask
               fgMaskU8 = backgroundSubtractorOCV('compute', img);
               fgMask = (fgMaskU8 ~= 0);
           end
          
           % Get background mask
           function bgMask = getBackgroundMask(~)

               % Get foreground mask
               bgMaskU8 = backgroundSubtractorOCV('bg');
               bgMask = bgMaskU8;
           end
           % Reset object states
           function reset(obj)

               % Reset the background model with default parameters
               % This is done in two steps. First free the persistent
               % memory and then reconstruct the model with original
               % parameters
               backgroundSubtractorOCV('destroy');
               params = struct('history', obj.history, ...
                               'dist2Threshold', obj.dist2Threshold, ...
                               'bShadowDetection', obj.bShadowDetection, ...
                                'kNNSamples', obj.kNNSamples);
               backgroundSubtractorOCV('construct', params);               
           end
           
           % Release object memory
           function release(~)
               % free persistent memory for model
               backgroundSubtractorOCV('destroy');
           end

       end
   end