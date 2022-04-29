classdef frame_mri
    properties(Constant)
        AREA=1;
        CENTROID_X=2;
        CENTROID_Y=3;
        TOP_LEFT_X=4;
        TOP_LEFT_Y=5;
        BOTTOM_LEFT_X=6;
        BOTTOM_LEFT_Y=7;
        V_Y=8;
        V=9;
        COALESCED=10;        
        SPLIT=11;
        NCOALESCE=12;
        RIGHT_BOTTOM_X=13;
        RIGHT_BOTTOM_Y=14;
        LEFT_BOTTOM_X=15;
        LEFT_BOTTOM_Y=16;
        ID=17;
    end
    
    properties
        bubbles;
        index;
        image;
        id_cnt=0;
    end
    
    methods
        function this_frame=frame_mri(s,image,frame_i)
            if nargin>0
                this_frame.id_cnt=0;
                centroids= cat(1,s.Centroid);
                areas=cat(1,s.Area);
                ext=cat(2,s.Extrema);
                this_frame.index=frame_i;
                this_frame.image=image;
                ii = 1;
                for j=1:size(areas,1)
                    if centroids(j,1)>25 && centroids(j,1)<size(image,2)-5 && ext(1,2*j)>2
                    temp_bubble=bubble_mri(areas(j),centroids(j,:),ext(:,2*j-1:2*j),j,size(image,1));
                    this_frame.bubbles{ii}=temp_bubble;
                    ii = ii+1;
                    end
                end
            end
        end
        
        function this_frame=track_frame(this_frame,previous_frame,v_thresh,area_thresh,id_cnt,v_est)
            this_frame.id_cnt=id_cnt;
            for i=1:size(this_frame.bubbles,2)
                this_bubble=this_frame.bubbles{1,i};
                found =0;
                for j=1:size(previous_frame.bubbles,2)
                    previous_bubble=previous_frame.bubbles{1,j};
                    [t,v_in]=this_bubble.isSameBubble(previous_bubble,v_thresh,area_thresh,v_est);
                    if t
                        this_bubble.v=v_in;
                        this_bubble.nc=previous_bubble.nc;
                        this_bubble.id=previous_bubble.id;
                        found =1;
                    end
                    ve = v_est;
                    if ceil(previous_bubble.top_left(2)) <= v_est 
                        ve = ceil(previous_bubble.top_left(2))-1;
                    end
                    previous_bubble_top=this_frame.image...
                    (ceil(previous_bubble.top_left(2))-ve,ceil(previous_bubble.top_left(1)));
                    
                    previous_bubble_centroid=this_frame.image...
                    (ceil(previous_bubble.centroid(2))-ve,ceil(previous_bubble.centroid(1)));
                    
                    if size(this_frame.image,1)-floor(this_bubble.bottom_left(2)) <= v_est
                        ve = size(this_frame.image,1)-floor(this_bubble.bottom_left(2))-1;
                    end
                    
                    this_bubble_bottom=previous_frame.image...
                    (floor(this_bubble.bottom_left(2))+ve,ceil(this_bubble.bottom_left(1)));
                
                    this_bubble_centroid=previous_frame.image...
                    (floor(this_bubble.centroid(2))+ve,ceil(this_bubble.centroid(1)));
                
                    this_bubble=this_bubble.contain_c(previous_bubble_centroid,previous_bubble_top,j);
                    previous_frame.bubbles{1,j}=previous_bubble.contain_s(this_bubble_centroid,this_bubble_bottom,i);
                    
                end
                if found ==0
                    this_frame.id_cnt = this_frame.id_cnt +1;
                    this_bubble.id=this_frame.id_cnt;
                end
                %coalesce
                if size(this_bubble.co_contain,2)>1
                    nc_sum=0;
                    data=zeros(size(this_bubble.co_contain,2),6);
                    for k=1:size(this_bubble.co_contain,2)
                        nc_sum=nc_sum+previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.nc;
                        data(k,1)=previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.area;
                        data(k,2)=previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.v(2);
                        data(k,3)=previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.right_bottom(1)-previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.left_bottom(1);
                        data(k,4)=previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.centroid(2);
                        data(k,6)=previous_frame.bubbles{1,this_bubble.co_contain(1,k)}.id;
                    end
                        this_bubble.nc=nc_sum;
                        this_bubble.coalesced=1;
                        this_bubble.coalesced_data=data;
                        this_frame.id_cnt = this_frame.id_cnt +1;
                        this_bubble.id=this_frame.id_cnt;
                end
                
                if this_bubble.centroid(2)>=size(this_frame.image,1)-10
                    this_bubble.nc=1;
                end
                this_frame.bubbles{1,i}=this_bubble;
            end
            %split
            for i=1:size(previous_frame.bubbles,2)
                previous_bubble=previous_frame.bubbles{1,i};
                if size(previous_bubble.sp_contain,2)>1
                        for k=1:size(previous_bubble.sp_contain,2)
                            this_frame.bubbles{1,previous_bubble.sp_contain(1,k)}.split=1;
                            this_frame.bubbles{1,previous_bubble.sp_contain(1,k)}.nc=previous_bubble.nc/size(previous_bubble.sp_contain,2);
                        end
                end
            end
        end
        
        function this_frame=writeFrame(this_frame,vo,bw_im)
            I = double(imresize(bw_im,6,'bilinear'));
            
            for i=1:size(this_frame.bubbles,2)
                temp_bubble=this_frame.bubbles{1,i};
                
                if temp_bubble.coalesced
                    I = insertShape(I,'FilledCircle',[temp_bubble.centroid*6 4],'Color','red','Opacity',1);
                else
                    I = insertShape(I,'FilledCircle',[temp_bubble.centroid*6 4],'Color','blue','Opacity',1);
                end
                I = insertText(I,temp_bubble.centroid*6,temp_bubble.id,'BoxColor','white','FontSize',16,'Anchorpoint','LeftCenter');
            end
            I = insertText(I,[0 size(I,1)],this_frame.index,'BoxColor','white','FontSize',16,'Anchorpoint','LeftBottom');
            I = rescale(I);
            writeVideo(vo,I);
        end
        
        function [arr,id_cnt]=frame2Array(this_frame)
            arr=zeros(50,17);
            id_cnt = this_frame.id_cnt;
            for i=1:size(this_frame.bubbles,2)
                temp_bubble=this_frame.bubbles{1,i};
                arr(i,this_frame.AREA)=temp_bubble.area;
                arr(i,this_frame.CENTROID_X)=temp_bubble.centroid(1);
                arr(i,this_frame.CENTROID_Y)=temp_bubble.centroid(2);
                arr(i,this_frame.TOP_LEFT_X)=temp_bubble.top_left(1);
                arr(i,this_frame.TOP_LEFT_Y)=temp_bubble.top_left(2);
                arr(i,this_frame.BOTTOM_LEFT_X)=temp_bubble.bottom_left(1);
                arr(i,this_frame.BOTTOM_LEFT_Y)=temp_bubble.bottom_left(2);
                arr(i,this_frame.V_Y)=temp_bubble.v(2);
                arr(i,this_frame.V)=temp_bubble.v(3);
                arr(i,this_frame.COALESCED)=temp_bubble.coalesced;
                arr(i,this_frame.SPLIT)=temp_bubble.split;
                arr(i,this_frame.NCOALESCE)=temp_bubble.nc;
                arr(i,this_frame.RIGHT_BOTTOM_X)=temp_bubble.right_bottom(1);
                arr(i,this_frame.RIGHT_BOTTOM_Y)=temp_bubble.right_bottom(2);
                arr(i,this_frame.LEFT_BOTTOM_X)=temp_bubble.left_bottom(1);
                arr(i,this_frame.LEFT_BOTTOM_Y)=temp_bubble.left_bottom(2);
                arr(i,this_frame.ID)=temp_bubble.id;

            end
        end
    end
end