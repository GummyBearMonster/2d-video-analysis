% %%
rheo = 0;
fps = 250;
system_height = size(binarizedArray,1);
bub=zeros(0,9);
minbubarea=1;


for i=1:size(binarizedArray,3)
    I = bwareaopen(binarizedArray(:,:,i),minbubarea);
    s=regionprops(I,'Area','Centroid','BoundingBox');
    ars=cat(1,s.Area);
    ctds= cat(1,s.Centroid);
    bbx = cat(1,s.BoundingBox);
    
    bub= cat(1,bub,[i*ones(size(ars)) ars ctds bbx nan(size(ars))]);
end
global bubbles
bubbles = array2table(bub,'VariableNames',{'Frame','Area','CentroidX','CentroidY','TopLeftX','TopLeftY','Width','Height','Track'});
clear('bub')

%%
global tracks centroids bboxes areas assignments unassignedTracks unassignedDetections ...
    nextId videoPlayer frame frame_ind;
nextId = 1;
tracks = initializeTracks();
videoPlayer = vision.VideoPlayer('Position', [20, 400, 284, 902]);
costOfNonAssignment = 20;
invisibleForTooLong = 5;
ageThreshold = 3;
bubbles{:,"Coalesced"} = cell(size(bubbles.Frame));

for i = 1:size(binarizedArray,3)
    frame_ind = i;
    frame = binarizedArray(:,:,i);
    [centroids, bboxes, areas] = detectObjects();
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment(costOfNonAssignment);
    updateAssignedTracks(ageThreshold);
    updateUnassignedTracks();
    deleteLostTracks(invisibleForTooLong, ageThreshold);
    createNewTracks();
    
    %displayTrackingResults();
end

%% Assign velocities
bubbles{:,["Vx_mm_s","Vy_mm_s","Ax_mm_s2","Ay_mm_s2","Shear_Rate_s","Ca","Re","LeadTrail"]} = nan(size(bubbles.Frame,1),8);
for i=1:max(bubbles.Track)
    filter = (bubbles.Track==i & bubbles.TopLeftY+bubbles.Height<system_height-1 & bubbles.TopLeftY > 1);
    
    if size(bubbles.Frame(filter),1)>2 
        bubbles.Vy_mm_s(filter) =-[NaN; diff(bubbles.CentroidY(filter))] *dx*fps;
        bubbles.Vx_mm_s(filter) =[NaN; diff(bubbles.CentroidX(filter))] *dx*fps;
        bubbles.Ay_mm_s2(filter) =-[NaN; NaN; diff(diff(bubbles.CentroidY(filter)))] *dx*fps*fps;
        bubbles.Ax_mm_s2(filter) =[NaN; NaN; diff(diff(bubbles.CentroidX(filter)))] *dx*fps*fps;
        bubbles.Shear_Rate_s(filter) = bubbles.Vy_mm_s(filter)/dx ./bubbles.Width(filter);
        
        d_eff = sqrt(bubbles.Area(filter) ./pi) * 2 *dx ;
        v_bub = sqrt(bubbles.Vy_mm_s(filter).^2 + bubbles.Vx_mm_s(filter).^2);
        
        % calculate effective viscosity
        if rheo
            mu = mean([interp1(shear(4:17,1),vis(4:17,1),bubbles.Shear_Rate_s(filter),'pchip'),...
                interp1(shear(4:17,2),vis(4:17,2),bubbles.Shear_Rate_s(filter),'pchip'),...
                interp1(shear(4:17,3),vis(4:17,3),bubbles.Shear_Rate_s(filter),'pchip')],2);
            bubbles.Ca(filter) = v_bub.*mu /sigma;
            bubbles.Re(filter) = rho * v_bub.* ...
                d_eff * 1e-6./mu .* (10./d_eff).^2;
        end
    end
    if size(bubbles.Frame(bubbles.Track==i),1) < ageThreshold
        bubbles(bubbles.Track==i,:)=[];
    end

end
% med_Ca=median(bubbles.Ca,'omitnan');
% med_Re=median(bubbles.Re,'omitnan');
%% Assign LeadTrail: -1 for trailing, 1 for leading, NaN for no coalescence, 0  for right after coalescence
for i =1:size(bubbles,1)   
    
    if length(bubbles.Coalesced{i}) == 2 %only consider two bubbles coalescing for leading/trailing
        absorbed_1 = bubbles.Coalesced{i}(1); 
        absorbed_2 = bubbles.Coalesced{i}(2); 
        
        % absorbed 1 higher
        if bubbles.CentroidY(find(bubbles.Track == absorbed_1,1,'last')) ...
                < bubbles.CentroidY(find(bubbles.Track == absorbed_2,1,'last'))
            bubbles.LeadTrail(find(bubbles.Track == absorbed_2,1,'last')) = -i;
            bubbles.LeadTrail(find(bubbles.Track == absorbed_1,1,'last')) = i;
            bubbles.LeadTrail(i) = 0;

        else
            bubbles.LeadTrail(find(bubbles.Track == absorbed_2,1,'last')) = i;
            bubbles.LeadTrail(find(bubbles.Track == absorbed_1,1,'last')) = -i;
            bubbles.LeadTrail(i) = 0;
        end
        
     end
end
save('bubbles.mat','bubbles','system_height','dx','fps')
%% Save tree plot, with bubble and coalescence tracking
not_at_top = bubbles.TopLeftY>1;
for i=1:max(bubbles.Track)
plot(bubbles.Frame(bubbles.Track==i )/fps,(system_height-bubbles.CentroidY(bubbles.Track==i ))*dx)
hold on
end
plot(bubbles.Frame(bubbles.LeadTrail==0 & not_at_top)/fps,(system_height-bubbles.CentroidY(bubbles.LeadTrail==0 & not_at_top))*dx,'b*')
hold off
set(gcf, 'Position', get(0, 'Screensize'))
set(gca, 'Position',[0.05 0.05 0.9 0.9])
xlabel('Time (s)')
xlim([0 30])
ylim([0 system_height*dx])
ylabel('Bubble Vertical Position (mm)')
saveas(gca,'tree.jpg')
saveas(gca,'tree.fig')

%% EXPERIMENTAL: Clustering:- Automatically sorts bubble coalescence by y distribution
dbscan_window = 50; % Cluster size ~ 50 pixels
dbscan_num = 200; % Number of coalescence in cluster ~ 

co_coord = [bubbles.CentroidX(bubbles.LeadTrail==0 & not_at_top),bubbles.CentroidY(bubbles.LeadTrail==0 & not_at_top)];
co_ind = find(bubbles.LeadTrail==0 & not_at_top);
cluster_idx = dbscan(co_coord(:,2),dbscan_window,dbscan_num);
gscatter(co_coord(:,1),co_coord(:,2),cluster_idx)
xlim([0 size(binarizedArray,2)])
ylim([0 size(binarizedArray,1)])
daspect([1 1 1])
set(gca, 'YDir','reverse')
saveas(gca,'clusters.jpg')
saveas(gca,'clusters.fig')
save('bubbles.mat','co_coord','co_ind','cluster_idx','dbscan_window','dbscan_num',"-append")

%%
function [centroids, bbx, areas] = detectObjects()
global bubbles frame_ind
ind = find(bubbles.Frame == frame_ind);

areas = bubbles.Area(ind);
centroids= bubbles{ind, {'CentroidX','CentroidY'}};
bbx = bubbles{ind, {'TopLeftX','TopLeftY','Width','Height'}};

end

function tracks = initializeTracks()
% create an empty array of tracks
tracks = struct(...
    'id', {}, ...
    'bbox', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {}, ...
    'coalesced', {});
end

function predictNewLocationsOfTracks()
% "Where are the bubbles now?"
global tracks
for i = 1:length(tracks)
    bbox = tracks(i).bbox;
    
    % Predict the current location of the track.
    predictedCentroid = predict(tracks(i).kalmanFilter);
    
    % Shift the bounding box so that its center is at
    % the predicted location.
    predictedCentroid = int32(predictedCentroid) - int32(bbox(3:4) / 2);
    tracks(i).bbox = [predictedCentroid, bbox(3:4)];
end
end

function [assignments, unassignedTracks, unassignedDetections] = ...
    detectionToTrackAssignment(costOfNonAssignment)
% "Which detections match the predicted bubble position?"

global tracks centroids
nTracks = length(tracks);
nDetections = size(centroids, 1);

% Compute the cost of assigning each detection to each track.
cost = zeros(nTracks, nDetections);
for i = 1:nTracks
    cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
end

% Solve the assignment problem.

[assignments, unassignedTracks, unassignedDetections] = ...
    assignDetectionsToTracks(cost, costOfNonAssignment);
end


function updateAssignedTracks(ageThreshold)
% Update the fields for a confirmed bubble

global centroids bboxes tracks assignments frame_ind bubbles ...
    unassignedTracks unassignedDetections 
numAssignedTracks = size(assignments, 1);
ind = find(bubbles.Frame == frame_ind);

for i = 1:numAssignedTracks
    trackIdx = assignments(i, 1);
    detectionIdx = assignments(i, 2);
    centroid = centroids(detectionIdx, :);
    bbox = bboxes(detectionIdx, :);
    coalesced = [];
     % check if the assigned track is overlapped with any unassigned tracks, if so
     % change its coalesced value, remove the unassigned track, and move the assigned
     % track to unassignedDetections
     
     for j = 1:length(unassignedTracks)
        jj = unassignedTracks(j);
        if bboxOverlapRatio(tracks(jj).bbox,bbox)>0  && tracks(jj).age >=ageThreshold && tracks(trackIdx).age >=ageThreshold
            coalesced=[coalesced tracks(jj).id tracks(trackIdx).id];
            tracks(trackIdx).coalesced = 1;
            unassignedDetections = [unassignedDetections; assignments(i,2)];
            tracks(jj).coalesced = 1;
        end
     end

    if tracks(trackIdx).coalesced == 0
    % Correct the estimate of the object's location using the new detection.
    correct(tracks(trackIdx).kalmanFilter, centroid);
    
    % Replace predicted bounding box with detected
    % bounding box.
    tracks(trackIdx).bbox = bbox;
    
    % Update track's age.
    tracks(trackIdx).age = tracks(trackIdx).age + 1;
    
    % Update visibility.
    tracks(trackIdx).totalVisibleCount = ...
        tracks(trackIdx).totalVisibleCount + 1;
    tracks(trackIdx).consecutiveInvisibleCount = 0;
    
    % Link detection's ID to the Track ID in the Table
    bubbles.Track(ind(detectionIdx)) = tracks(trackIdx).id;
    end
    
    if ~isempty(coalesced) 
        bubbles.Coalesced(ind(detectionIdx)) = num2cell(coalesced,[1 2]);
    end  
end

end

function updateUnassignedTracks()
% A bubble is not detected, but let's keep track of it and continue predict
% its position in the next cycle.

global tracks unassignedTracks 
for i = 1:length(unassignedTracks)
    ii = unassignedTracks(i); 
    tracks(ii).age = tracks(ii).age + 1;
    tracks(ii).consecutiveInvisibleCount = ...
        tracks(ii).consecutiveInvisibleCount + 1;
end
end

function deleteLostTracks(invisibleForTooLong, ageThreshold)
% If a bubble is not detected for too long, forget it

global tracks 

if isempty(tracks)
    return;
end

% Compute the fraction of the track's age for which it was visible.
ages = [tracks(:).age];
totalVisibleCounts = [tracks(:).totalVisibleCount];
visibility = totalVisibleCounts ./ ages;

% A bubble is invisible for two long - also harsher condition for new
% detections to filter noise
lostInds = (ages < ageThreshold & visibility < 0.6) | ...
    [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong | [tracks(:).coalesced]==1;

% Delete lost tracks.
tracks = tracks(~lostInds);
end


function createNewTracks()
% Create new bubbles to fit with the new detections

    global centroids bboxes unassignedDetections nextId tracks bubbles frame_ind
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        ind = find(bubbles.Frame == frame_ind);
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            bbox = bboxes(i, :);
            
            % Kalman filter inputs 
            InitialEstimateError = [10, 5];
            MotionNoise = [10, 5];
            MeasurementNoise = 1;
            % Create a Kalman filter object.
            
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, InitialEstimateError, MotionNoise, MeasurementNoise);
            
            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0, ...
                'coalesced', 0);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            bubbles.Track(ind(unassignedDetections(i))) = nextId;
            
            % Increment the next id.
            nextId = nextId + 1;
        end
end
    

function displayTrackingResults()
global frame tracks bboxes videoPlayer
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(frame, [1, 1, 3])) .* 255;
        
        minVisibleCount = 0;
        if ~isempty(tracks)
              
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than 
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Create labels for objects indicating the ones for 
                % which we display the predicted rather than the actual 
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);
               
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        
        % Display the mask and the frame.
        videoPlayer.step(mask);   
        pause(0.1)
    end