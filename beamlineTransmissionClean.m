% Script to analyze GMD Transmission Data with and without Zr211 Filter
% Author: Eike Hanel
% Date: 05.01.2024
% Description: This script processes and analyzes GMD data collected under different conditions
%              (with and without Zr211 filter). The data is loaded, processed, and visualized.

%% Clear Workspace and Command Window
clc;
clear;
close all;

%% Setup: Define the Folder Path and Load Data Files
dataFolder = 'MATLAB/Transmission';
dataFiles = dir(fullfile(dataFolder, '*.txt'));

% Initialize cell arrays to store loaded data
GMDData = cell(1, length(dataFiles));

% Load and store the data from each file
for i = 1:length(dataFiles)
    filePath = fullfile(dataFolder, dataFiles(i).name);
    GMDData{i} = readcell(filePath);
end

%% Extract and Organize Data

% No Filter Data
hall.noFilter_01 = extractColumnData(GMDData{5}, 4);
hall.noFilter_012 = extractColumnData(GMDData{6}, 4);
hall.noFilter_02 = extractColumnData(GMDData{7}, 4);

mobile.noFilter_01 = extractColumnData(GMDData{8}, 4);
mobile.noFilter_012 = extractColumnData(GMDData{9}, 4);
mobile.noFilter_02 = extractColumnData(GMDData{10}, 4);

% Zr211 Filter Data
hall.filter_01 = extractColumnData(GMDData{1}, 4);
hall.filter_02 = extractColumnData(GMDData{2}, 4);

mobile.filter_01 = extractColumnData(GMDData{3}, 4);
mobile.filter_02 = extractColumnData(GMDData{4}, 4);

%% Calculate Transmissions

% No Filter Transmission
transmission.noFilter_01 = mobile.noFilter_01 ./ hall.noFilter_01;
transmission.noFilter_012 = mobile.noFilter_012 ./ hall.noFilter_012;
transmission.noFilter_02 = mobile.noFilter_02 ./ hall.noFilter_02;

% Zr211 Filter Transmission
transmission.filter_01 = mobile.filter_01 ./ hall.filter_01;
transmission.filter_02 = mobile.filter_02 ./ hall.filter_02;

% Remove transmission values below 0.1
transmission.filter_01(transmission.filter_01 < 0.1) = NaN;

%% Statistical Analysis

% No Filter Statistics
stats.noFilter.mean = mean(transmission.noFilter_012);
stats.noFilter.std = std(transmission.noFilter_012);

% Zr211 Filter Statistics
stats.filter.mean = mean(transmission.filter_02);
stats.filter.std = std(transmission.filter_02);

% Error Propagation (No Filter)
finalNoFilter = calculateError(mobile.noFilter_012, hall.noFilter_012);

% Error Propagation (Zr211 Filter)
finalFilter = calculateError(mobile.filter_02, hall.filter_02, 0.1);

%% Plotting Data

% Plot No Filter Data
figure;
plot(mobile.noFilter_012, hall.noFilter_012, '+', 'LineWidth', 1.5);
title("GMD Data without Filter");
xlabel("GMD - Experimental Chamber [μJ]");
ylabel("GMD - Hall Entrance [μJ]");
set(gca, 'FontSize', 20);

% Plot Zr211 Filter Data
figure;
plot(mobile.filter_02, hall.filter_02, '+', 'LineWidth', 1.5);
title("GMD Data with Zr211 Filter");
xlabel("GMD - Experimental Chamber [μJ]");
ylabel("GMD - Hall Entrance [μJ]");
set(gca, 'FontSize', 20);

% Plot Transmission and Histogram (No Filter)
figure;
subplot(1, 2, 1);
plot(transmission.noFilter_012, 'LineWidth', 2);
title("Transmission (No Filter)");
xlabel("Data Points");
ylabel("Transmission");
set(gca, 'FontSize', 20);

subplot(1, 2, 2);
histogram(transmission.noFilter_012);
title("Transmission Histogram (No Filter)");
xlabel("Transmission");
ylabel("Counts");
set(gca, 'FontSize', 20);

% Plot Transmission and Histogram (Zr211 Filter)
figure;
subplot(1, 2, 1);
plot(transmission.filter_02, 'LineWidth', 2);
title("Transmission (Zr211 Filter)");
xlabel("Data Points");
ylabel("Transmission");
set(gca, 'FontSize', 20);

subplot(1, 2, 2);
histogram(transmission.filter_02);
title("Transmission Histogram (Zr211 Filter)");
xlabel("Transmission");
ylabel("Counts");
set(gca, 'FontSize', 20);

%% Function Definitions

% Function to extract a specific column from cell array data
function columnData = extractColumnData(dataCell, columnIndex)
    columnData = cell2mat(dataCell(:, columnIndex));
end

% Function to calculate mean, standard deviation, and error propagation
function stats = calculateError(mobileData, hallData, additionalError)
    if nargin < 3
        additionalError = 0; % Default value if not provided
    end
    
    mobileMean = mean(mobileData);
    hallMean = mean(hallData);
    
    mobileSTD = std(mobileData);
    hallSTD = std(hallData);
    
    mobileError = mobileSTD / mobileMean + 0.05;
    hallError = hallSTD / hallMean + 0.05;
    
    transmission = mobileMean / hallMean;
    errorPropagation = sqrt(mobileError^2 + hallError^2 + additionalError^2);
    
    stats.mean = transmission;
    stats.error = transmission * errorPropagation;
end
