% Script to analyze the measured profile from the Wavefront Sensor
% Author: Eike Hanel
% Date: 02.11.2023
% Description: This script reads a .txt file containing intensity 
% distribution data and generates 2D profiles for four axes.

%% Clear Environment
clc;           % Clear the command window
clear all;     % Clear all variables from the workspace
close all;     % Close all figure windows

%% Load Data
cd 'MATLAB/WFS - Analysis';

% Load the wavefront sensor data
wfsdata = readmatrix("2216high.txt");

% Find the maximum value and its position within the matrix
[maxValue, maxIndex] = max(wfsdata(:));
[row, col] = ind2sub(size(wfsdata), maxIndex);
fprintf('Maximum value: %d\n', maxValue);
fprintf('Position (Row, Col): (%d, %d)\n', row, col);

% Define window size for profiles and calculate the corresponding SI units
windowSize = 60;                 % Adjust the size of the window as needed
pixel_size = 200/256;            % Pixel size in micrometers
windowSize_SI = -pixel_size*windowSize:pixel_size:pixel_size*windowSize;

% Extract profiles: horizontal, vertical, and diagonal (45° and 135°)
horizontalProfile = wfsdata(row, col - windowSize:col + windowSize);
verticalProfile = wfsdata(row - windowSize:row + windowSize, col);
diagonalProfile45 = diag(wfsdata(row - windowSize:row + windowSize, col - windowSize:col + windowSize));
diagonalProfile135 = diag(flipud(wfsdata(row - windowSize:row + windowSize, col - windowSize:col + windowSize)));

% Combine all profile data into a single matrix
full_data(:, 1) = windowSize_SI;
full_data(:, 2) = horizontalProfile;
full_data(:, 3) = diagonalProfile45;
full_data(:, 4) = verticalProfile;
full_data(:, 5) = diagonalProfile135;

%% Save Profile Data
outputDir = 'Third Report/DataSets';
cd(outputDir);

filename = 'WFS_Profile.txt';
writematrix(full_data, filename);

%% Gaussian Fit to Profiles
% Define Gaussian model
gaussianModel = fittype('a*exp(-((x-b)/c)^2)', 'independent', 'x', 'dependent', 'y');

% Initial guesses for Gaussian parameters: [amplitude, center, width]
initialGuess = [65400, 0, 1];

% Fit Gaussian model to each profile
fithorizontal = fit(windowSize_SI, horizontalProfile, gaussianModel, StartPoint, initialGuess);
fitvertical = fit(windowSize_SI, verticalProfile, gaussianModel, StartPoint, initialGuess);
fit45 = fit(windowSize_SI, diagonalProfile45, gaussianModel, StartPoint, initialGuess);
fit135 = fit(windowSize_SI, diagonalProfile135, gaussianModel, StartPoint, initialGuess);

% Display fit results
disp(fithorizontal);
disp(fit45);
disp(fitvertical);
disp(fit135);

% Example constants (replace with actual fit values if needed)
c(1) = 5.654;  % Horizontal
c(2) = 2.817;  % Diagonal 45°
c(3) = 5.542;  % Vertical
c(4) = 6.259;  % Diagonal 135°

% Calculate full-width at half maximum (FWHM)
for i = 1:4
    w(i) = 2 * sqrt(2 * log(2)) * c(i);
end

% Calculate areas under the Gaussian curves
a(1) = w(1) * w(3) * pi;  % Horizontal and Vertical
a(2) = w(2) * w(4) * pi;  % Diagonal 45° and 135°
m = (a(1) + a(2)) / 2;    % Mean area
mcm = m * 1e-8;           % Convert to cm²

%% Plot Profiles and Fits
figure;

% Plot horizontal profile
subplot(2, 2, 1);
plot(windowSize_SI, horizontalProfile, 'o', 'LineWidth', 1.5);
hold on;
plot(fithorizontal);
title('Horizontal Profile');
xlabel('Position (μm)');
ylabel('Intensity');
set(gca, 'FontSize', 25);

% Plot diagonal profile at 45°
subplot(2, 2, 2);
plot(windowSize_SI, diagonalProfile45, 'o', 'LineWidth', 1.5);
hold on;
plot(fit45);
title('Diagonal Profile at 45°');
xlabel('Position (μm)');
ylabel('Intensity');
set(gca, 'FontSize', 25);

% Plot vertical profile
subplot(2, 2, 3);
plot(windowSize_SI, verticalProfile, 'o', 'LineWidth', 1.5);
hold on;
plot(fitvertical);
title('Vertical Profile');
xlabel('Position (μm)');
ylabel('Intensity');
set(gca, 'FontSize', 25);

% Plot diagonal profile at 135°
subplot(2, 2, 4);
plot(windowSize_SI, diagonalProfile135, 'o', 'LineWidth', 1.5);
hold on;
plot(fit135);
title('Diagonal Profile at 135°');
xlabel('Position (μm)');
ylabel('Intensity');
set(gca, 'FontSize', 25);
