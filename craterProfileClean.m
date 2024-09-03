%% Script to Analyze Crater Profiles from AFM Measurements
% Author: Eike Hanel
% Date: 05.01.2024
% Description: This script loads crater profile data from text files,
% calculates horizontal, vertical, and diagonal profiles, and visualizes
% them for each dataset.

%% Clear Environment
clc;
clear;
close all;

%% Load Data
% Define the folder containing the crater profile data
load.craterFolder = 'Silicon/Rotated txt Data';

% Get a list of all the text files in the folder
load.craterList = dir(fullfile(load.craterFolder, '*.txt'));

% Load data from each text file
data.craterProfile = cell(1, length(load.craterList));
for i = 1:length(load.craterList)
    load.craterProfilePath = fullfile(load.craterFolder, load.craterList(i).name);
    data.craterProfile{i} = readmatrix(load.craterProfilePath);
end

%% Analyze Profiles
% Define window size and pixel size
windowSize = 75; % Size of the window for profile extraction
pix = 60 / 256; % Pixel size in micrometers
windowSize_SI = (-windowSize:windowSize) * pix; % Window size in micrometers

% Process each dataset
for i = 1:length(data.craterProfile)
    dataSet = data.craterProfile{i};
    
    % Find the minimum value and its position
    [minValue, minIndex] = min(dataSet(:));
    [numRows, numCols] = size(dataSet);
    [row, col] = ind2sub([numRows, numCols], minIndex);

    % Extract horizontal and vertical profiles
    horizontalProfile = dataSet(row, col - windowSize:col + windowSize) * 10^6; % in micrometers
    verticalProfile = dataSet(row - windowSize:row + windowSize, col) * 10^6; % in micrometers
    
    % Extract diagonal profiles
    diagonalProfile45 = diag(dataSet(row - windowSize:row + windowSize, col - windowSize:col + windowSize)) * 10^6;
    diagonalProfile135 = diag(flipud(dataSet(row - windowSize:row + windowSize, col - windowSize:col + windowSize))) * 10^6;
    
    % Create figure for plotting
    figure(i);
    subplot(2, 2, 1);
    plot(windowSize_SI, horizontalProfile, 'LineWidth', 2);
    title('Horizontal Profile');
    xlabel('Width (μm)');
    ylabel('Height (μm)');
    grid on;
    ax = gca;
    ax.FontSize = 25;
    
    subplot(2, 2, 2);
    plot(windowSize_SI, diagonalProfile45, 'LineWidth', 2);
    title('Diagonal Profile 45°');
    xlabel('Width (μm)');
    ylabel('Height (μm)');
    grid on;
    ax = gca;
    ax.FontSize = 25;
    
    subplot(2, 2, 3);
    plot(windowSize_SI, verticalProfile, 'LineWidth', 2);
    title('Vertical Profile');
    xlabel('Width (μm)');
    ylabel('Height (μm)');
    grid on;
    ax = gca;
    ax.FontSize = 25;
    
    subplot(2, 2, 4);
    plot(windowSize_SI, diagonalProfile135, 'LineWidth', 2);
    title('Diagonal Profile 135°');
    xlabel('Width (μm)');
    ylabel('Height (μm)');
    grid on;
    ax = gca;
    ax.FontSize = 25;

    % Optional: Save the profiles to a text file (commented out)
    % finalData = [windowSize_SI, horizontalProfile, diagonalProfile45, verticalProfile, diagonalProfile135];
    % filename = sprintf('Silicon_Profile_%d.txt', i);
    % writematrix(finalData, filename);
end
