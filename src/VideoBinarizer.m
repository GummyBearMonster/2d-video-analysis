classdef VideoBinarizer
    properties
        fps;
        nframes;
        dx;
        method;
        roi;
        system_width; %in mm
        bg;
        vr;
        binarized_array;
        bw_params;
        subtract_bg;
        min_bub_area;
        min_black_area;
    end
    
    methods
        function vb = VideoBinarizer(filePath, options)
            arguments
                filePath {mustBeText}
                options.Method {mustBeMember(options.Method, ["global","adaptive","pca"])} = 'global'
                options.SubtractBg {mustBeNumericOrLogical} = false
                options.SystemWidth {mustBeNumeric} = 200
                options.MinBubArea {mustBeNumeric} = 100
                options.MinBlackArea {mustBeNumeric} = 2000
            end
            
            vb.vr=VideoReader(filePath);
            vb.fps=vb.vr.FrameRate;
            vb.nframes = vb.vr.NumFrames;
            vb.method = options.Method;
            vb.system_width = options.SystemWidth;
            vb.roi = [1, vb.vr.Width,1, vb.vr.Height];
            vb.subtract_bg = options.SubtractBg;
            vb.min_bub_area = options.MinBubArea;
            vb.min_black_area = options.MinBlackArea;
        end
        
        function I = get_frame(vb,frame, options)
            arguments
                vb
                frame {mustBeInteger}
                options.Mode {mustBeText} = 'original'
                options.Show {mustBeNumericOrLogical} = false
            end
            o = vb.vr.read(frame);
            switch options.Mode
                case 'original'
                    I = o;
                case 'cropped'
                    I = o(vb.roi(3):vb.roi(4),vb.roi(1):vb.roi(2));
                case 'binarized'
                    I = vb.binarize_frame(o(vb.roi(3):vb.roi(4),vb.roi(1):vb.roi(2)));
            end
            if options.Show
                imshow(I)
            end
        end
        
        function vb = set.roi(vb,roi)
            arguments
                vb
                roi {mustBeVector}
            end
            vb.roi = roi;
            vb.dx = vb.system_width/(roi(2)-roi(1));
        end
        
        
        function bw = binarize_frame(vb, I)
            I = im2uint8(I);
            
            if vb.subtract_bg
                I = I-vb.bg;
            end
            
            switch vb.method
                case 'global'
                    bw=imbinarize(I);
                    if size(vb.params)>0
                        bw = imbinarize(I,vb.bw_params.thresh);
                    end

                case 'adaptive'
                    I=imgaussfilt(I,vb.bw_params.gaussian_sigma);
                    bw=logical(cvAdaptiveThreshold(I,vb.bw_params.nblock,vb.bw_params.bar));
                
            end
            bw=bwareaopen(bw, vb.min_bub_area);
            bw=imcomplement(bw);
            bw=bwareaopen(bw, vb.min_black_area);
            bw=imcomplement(bw);
        end
    end
    
    
end