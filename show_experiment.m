% This script shows the 2D snapshots at estimated depths from RF-Capture
% and the skeleton captured by Kinect
%
% INPUT: experiment name (exp_name)
%
% OUTPUT: show RF-capture snapshots with Kinect skeleton
%
% IMPORTANT NOTE: 
%   After you open MATLAB, navigate to the 'codes' folder before you run 
%   this script.
%
%   Chen-Yu Hsu (cyhsu@mit.edu)
%   Last update: 09/06/2015
%

%% load data
exp_name  = 'cy_walk_kinect_5'; 
% To change the experiment, replace 'cy_walk_kinect_4' by any of the file
% names in the data folder

data_path = ['../data/' exp_name];
data = load(data_path);
num_frames_RFcap  = size(data.images,3);
num_frames_kinect = length(data.joints{1}.x);

%% plot results
scale = 4;
h_RFcap = figure('Position', [100, 500, [length(data.x_range)*2, length(data.z_range)]*scale]);
h_kinect = figure('Position', [600, 500, [length(data.x_range)*2, length(data.z_range)]*scale]);

dt = 0.001; 
% The actual frame rate of RF-capture is around 0.033 frame/sec. Since the 
% plotting delay in MATLAB is larger then the actual frame rate, we simply 
% set dt to a very small value here.

for t = 1:num_frames_RFcap
    % snapshots from RF-capture
    figure(h_RFcap);
    subplot(1,2,1); surf(data.x_range, data.z_range, data.images(:,:,t),'edgecolor','none');  
    axis tight; view(0,90); colormap('jet'); title('RF-Capture');     
    xlabel('x (meters)'); ylabel('z (meters)');
    
    % snapshots from RF-capture with beam compensation
    subplot(1,2,2); surf(data.x_range, data.z_range, data.images_decv(:,:,t),'edgecolor','none');
    axis tight; view(0,90); colormap('jet'); title(sprintf('RF-Capture \n with beam compensation')); 
    xlabel('x (meters)'); ylabel('z (meters)');
    
    % skeletons from kinect
    figure(h_kinect);    
    t_kinect = round(t * data.frame_rate_ratio);
    if(t_kinect > num_frames_kinect)
        t_kinect = num_frames_kinect;
    end
    plot_kinect_skeleton(h_kinect, t_kinect, data.joints)
    title('Kinect''s skeleton output ')
    
    pause(dt)
end
