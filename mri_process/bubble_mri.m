classdef bubble_mri
    properties 
        area;
        centroid;
        top_left;
        right_bottom;
        bottom_left;
        split=0;
        coalesced=0;
        left_bottom;
        v=[0,0,0];
        co_contain;
        sp_contain;
        nc=0;
        ind;
        coalesced_data;
        id;
    end
    methods
        function bubble_obj=bubble_mri(area,centroid,ext,ind,height)
            if nargin>0
                bubble_obj.area=area;
                bubble_obj.centroid=centroid;
                bubble_obj.top_left=ext(1,:);
                bubble_obj.right_bottom=ext(4,:);
                bubble_obj.bottom_left=ext(6,:);
                bubble_obj.left_bottom=ext(7,:);
                bubble_obj.ind=ind;
                if centroid(2)>=height-50
                    bubble_obj.nc=1;
                end
            end
        end
        function [x,v_out]=isSameBubble(this_bubble,bubble2,v_thresh,area_thresh,v_est)
            x=false;
            v_out=[0 0 0];
            v_temp=this_bubble.centroid - bubble2.centroid;
            
            if sqrt((v_temp(2)+v_est)^2+v_temp(1)^2)<v_thresh &&...
                    abs(this_bubble.area-bubble2.area)<area_thresh
                
                x=true;
                v_out(1)=v_temp(1);
                v_out(2)=-v_temp(2);
                v_out(3)=sqrt(v_temp(1)^2+v_temp(2)^2);
            end
        end
        function this_bubble=set.v(this_bubble,vin)
            this_bubble.v=vin;
        end
        function this_bubble=set.nc(this_bubble,ncin)
            this_bubble.nc=ncin;
        end
        function this_bubble=contain_c(this_bubble,inbubble_centroid,inbubble_top,inbubind)
            
            if inbubble_top==this_bubble.ind || inbubble_centroid==this_bubble.ind
                  this_bubble.co_contain=[this_bubble.co_contain inbubind];
            end
        end
        function this_bubble=contain_s(this_bubble,inbubble_centroid,inbubble_bottom,inbubind)
            if inbubble_bottom==this_bubble.ind || inbubble_centroid==this_bubble.ind
                  this_bubble.sp_contain=[this_bubble.sp_contain inbubind];
            end
        end
    end
end

