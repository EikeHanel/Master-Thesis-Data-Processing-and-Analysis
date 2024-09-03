%% Script to Analyze Cross Profiles from AFM Measurements
% Author: Eike Hanel
% Date: 05.01.2024
% Description: This script loads cross profile data from text files, calculates
% the surface mean for horizontal and vertical profiles, and determines the maximum
% depth based on these calculations.

%% Clear Environment
clc;
clear;
close all;

%% Load Cross Profile Data
% Define the folder containing the text datasets
load.crossProfileFolder = 'Silicon/Cross Profile';

% Get a list of all the text files in the folder
load.crossProfileList = dir(fullfile(load.crossProfileFolder, '*.txt'));

% Initialize cell array to store data
data.crossProfile = cell(1, length(load.crossProfileList));

% Load data from each text file
for i = 1:length(load.crossProfileList)
    load.crossProfilePath = fullfile(load.crossProfileFolder, load.crossProfileList(i).name);
    data.crossProfile{i} = readmatrix(load.crossProfilePath);
end

%% Define Surface Mean
% Initialize arrays to store surface means
val.surfaceMeanHorizontal = zeros(1, length(data.crossProfile));
val.surfaceMeanVertical = zeros(1, length(data.crossProfile));

% Calculate horizontal and vertical surface means
for i = 1:length(data.crossProfile)
    % Plot horizontal profile and select boundaries
    figure;
    plot(data.crossProfile{i}(:,1), data.crossProfile{i}(:,2));
    title('Select two points to define boundaries (Horizontal)');
    xlabel('Position (μm)');
    ylabel('Intensity');
    
    % Select boundaries for horizontal profile
    [idx.valX_H, ~] = ginput(2);
    idx.trueIDX_H = find(data.crossProfile{i}(:,1) >= idx.valX_H(1) & data.crossProfile{i}(:,1) <= idx.valX_H(2));
    calc.surfaceMean_H = mean(data.crossProfile{i}(idx.trueIDX_H, 2));
    val.surfaceMeanHorizontal(i) = calc.surfaceMean_H * 10^6;
    close;

    % Plot vertical profile and select boundaries
    figure;
    plot(data.crossProfile{i}(:,3), data.crossProfile{i}(:,4));
    title('Select two points to define boundaries (Vertical)');
    xlabel('Position (μm)');
    ylabel('Intensity');
    
    % Select boundaries for vertical profile
    [idx.valX_V, ~] = ginput(2);
    idx.trueIDX_V = find(data.crossProfile{i}(:,3) >= idx.valX_V(1) & data.crossProfile{i}(:,3) <= idx.valX_V(2));
    calc.surfaceMean_V = mean(data.crossProfile{i}(idx.trueIDX_V, 4));
    val.surfaceMeanVertical(i) = calc.surfaceMean_V * 10^6;
    close;
end

% Calculate the average surface mean and max depth
val.surfaceMean = (val.surfaceMeanHorizontal + val.surfaceMeanVertical) / 2;
val.depthMax = -val.surfaceMean;

%% Save Max Depth Data
% Define the folder for saving results
saveFolder = 'Silicon/TXT Data/MaxDepth';

% Ensure the directory exists
if ~exist(saveFolder, 'dir')
    mkdir(saveFolder);
end

% Save the max depth values to a text file
filename = fullfile(saveFolder, 'siliconMaxDepth.txt');
writematrix(val.depthMax, filename);
