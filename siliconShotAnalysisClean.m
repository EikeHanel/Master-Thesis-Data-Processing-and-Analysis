%% Project: Photon and Electron Data Analysis
% Author: Eike Hanel
% Date: 12.11.2023
% This script processes and analyzes data related to photon and electron experiments.
% The data is organized into different sections for electrons, photons, and shutter states.
% The goal is to identify shots, compute relevant metrics, and analyze transmission fluctuations.

%% Clear Environment
clc;             % Clear command window
close all;       % Close all figures
clear;           % Clear workspace

%% Load Data
% Define the folder containing the datasets
folder = 'MATLAB/GMD DATA';

% Get a list of all text files in the folder
file_list = dir(fullfile(folder, '*.txt'));

% Load data into structured arrays
data = struct();
for i = 1:12  % Electron data
    data.Elec{i} = load(fullfile(folder, file_list(i).name));
end
for i = 13:15  % Index data
    data.Idx{i} = load(fullfile(folder, file_list(i).name));
end
for i = 16:27  % Photon data
    data.Photon{i} = load(fullfile(folder, file_list(i).name));
end
for i = 28:30  % Shutter data
    data.Shutter{i} = load(fullfile(folder, file_list(i).name));
end

%% Finding Shots in Silicon Experiments
% Process shutter data to identify open (1) and closed (0) states
for i = 1:3
    data.Shutter{i + 27}(data.Shutter{i + 27} < 0.5) = 0;
    data.Shutter{i + 27}(data.Shutter{i + 27} > 0.5) = 1;
end

% Identify shots within the shutter data
trueIdx = cell(1, 3);
for i = 1:3
    figure(i);
    plot(data.Shutter{i + 27}(:,1));
    val = round(ginput(2));  % Select boundaries using graphical input
    idx = find(data.Shutter{i + 27}(val(1,1):val(2,1)) == 1);
    trueIdx{i} = idx + val(1,1);  % Adjust index to account for the selected range
end
close all;

%% Counting Shots per Row (Rows 1-8)
% Identify shot indices for rows 1 to 8
rowTrueIdx = cell(1, 8);
for i = 1:8
    figure(4);
    plot(data.Shutter{29}(:,1));
    rowVal = round(ginput(2));
    rowIdx = find(data.Shutter{29}(rowVal(1,1):rowVal(2,1)) == 1);
    rowTrueIdx{i} = rowIdx + rowVal(1,1);
end
close all;

% Calculate the distance between shots for each row
doubleShot = zeros(7, 8);  % Preallocate matrix for shot distances
for i = 1:8
    for k = 1:(length(rowTrueIdx{i}) - 1)
        doubleShot(k, i) = rowTrueIdx{i}(k + 1) - rowTrueIdx{i}(k);
    end
end

%% Counting Shots per Row (Rows 9-10)
% Identify shot indices for rows 9 to 10
rowTrueIdx2 = cell(1, 2);
for i = 1:2
    figure(5);
    plot(data.Shutter{30}(:,1));
    rowVal2 = round(ginput(2));
    rowIdx2 = find(data.Shutter{30}(rowVal2(1,1):rowVal2(2,1)) == 1);
    rowTrueIdx2{i} = rowIdx2 + rowVal2(1,1);
end
close all;

% Calculate the distance between shots for rows 9 to 10
doubleShot2 = zeros(1, 2);  % Preallocate matrix for shot distances
for i = 1:2
    for k = 1:(length(rowTrueIdx2{i}) - 1)
        doubleShot2(k, i) = rowTrueIdx2{i}(k + 1) - rowTrueIdx2{i}(k);
    end
end

%% Finding Shots in Diamond Experiments
% Identify shots in the diamond experiments
figure(6);
plot(data.Shutter{30}(:,1));
val = round(ginput(2));
idx = find(data.Shutter{30}(val(1,1):val(2,1)) == 1);
trueIdx{4} = idx + val(1,1);
close all;

%% Counting Shots per Row for Diamond Experiments
% Identify shot indices for rows 1 to 4 in diamond experiments
diaRowTrueIdx = cell(1, 4);
for i = 1:4
    figure(7);
    plot(data.Shutter{30}(:,1));
    diaRowVal = round(ginput(2));
    diaRowIdx = find(data.Shutter{30}(diaRowVal(1,1):diaRowVal(2,1)) == 1);
    diaRowTrueIdx{i} = diaRowIdx + diaRowVal(1,1);
end
close all;

% Calculate the distance between shots for diamond experiments
diaDoubleShot = zeros(3, 4);  % Preallocate matrix for shot distances
for i = 1:4
    for k = 1:(length(diaRowTrueIdx{i}) - 1)
        diaDoubleShot(k, i) = diaRowTrueIdx{i}(k + 1) - diaRowTrueIdx{i}(k);
    end
end

%% Photon Hall/Tunnel Data Analysis
% Extract photon data for hall and tunnel resolved experiments
photon = struct();
for i = 1:3
    photon.HallResolved{i} = data.Photon{i + 18}(trueIdx{i}, :);
    photon.TunnelResolved{i} = data.Photon{i + 24}(trueIdx{i}, :);
end
photon.HallResolved{4} = data.Photon{21}(trueIdx{4}, :);
photon.TunnelResolved{4} = data.Photon{27}(trueIdx{4}, :);

%% Average Pulse Energy Calculation
% Test experiment (no filter)
pulseEnergy.test = (photon.HallResolved{1}(:, 1) .* 0.5942) - 6.245;
pulseEnergy.testAvg = mean(pulseEnergy.test);
pulseEnergy.testStd = std(pulseEnergy.test);

% Silicon (first 8 rows, no filter)
pulseEnergy.silicon = (photon.HallResolved{2}(:, 1) .* 0.5942) - 6.245;
pulseEnergy.siliconAvg = mean(pulseEnergy.silicon);
pulseEnergy.siliconStd = std(pulseEnergy.silicon);

% Silicon (last 2 rows, Zr211 filter)
pulseEnergy.siliconFilter = (photon.HallResolved{3}(:, 1) .* 0.3218) + 0.2427;
pulseEnergy.siliconFilterAvg = mean(pulseEnergy.siliconFilter);
pulseEnergy.siliconFilterStd = std(pulseEnergy.siliconFilter);

% Diamond (no filter)
pulseEnergy.diamond = (photon.HallResolved{4}(:, 1) .* 0.5942) - 6.245;
pulseEnergy.diamondAvg = mean(pulseEnergy.diamond);
pulseEnergy.diamondStd = std(pulseEnergy.diamond);

%% Column-Wise Mean Energy for Silicon (No Filter)
siliconColumnEnergy = struct();
for i = 1:8
    figure(8);
    plot(data.Shutter{29}(:,1));
    val = round(ginput(2));
    idx = find(data.Shutter{29}(val(1,1):val(2,1)) == 1);
    trueIdx{i} = idx + val(1,1);
    photon.siliconColumn{i} = data.Photon{20}(trueIdx{i}, :);
    siliconColumnEnergy.Min{i} = min(photon.siliconColumn{i}(:, 1) .* 0.5942 - 6.245);
    siliconColumnEnergy.Max{i} = max(photon.siliconColumn{i}(:, 1) .* 0.5942 - 6.245);
    siliconColumnEnergy.Avg{i} = mean(photon.siliconColumn{i}(:, 1) .* 0.5942 - 6.245);
    siliconColumnEnergy.Std{i} = std(photon.siliconColumn{i}(:, 1) .* 0.5942 - 6.245);
end
close all;

%% Column-Wise Mean Energy for Silicon (With Filter)
siliconColumnEnergyFilter = struct();
for i = 1:2
    figure(9);
    plot(data.Shutter{30}(:,1));
    val = round(ginput(2));
    idx = find(data.Shutter{30}(val(1,1):val(2,1)) == 1);
    trueIdx{i} = idx + val(1,1);
    photon.siliconColumn{i + 8} = data.Photon{22}(trueIdx{i}, :);
    siliconColumnEnergyFilter.Min{i} = min(photon.siliconColumn{i + 8}(:, 1) .* 0.3218 + 0.2427);
    siliconColumnEnergyFilter.Max{i} = max(photon.siliconColumn{i + 8}(:, 1) .* 0.3218 + 0.2427);
    siliconColumnEnergyFilter.Avg{i} = mean(photon.siliconColumn{i + 8}(:, 1) .* 0.3218 + 0.2427);
    siliconColumnEnergyFilter.Std{i} = std(photon.siliconColumn{i + 8}(:, 1) .* 0.3218 + 0.2427);
end
close all;

%% Conclusion
% The script successfully identifies and counts the shots for various electron and photon data sets.
% It calculates the pulse energy for different experimental setups and resolves column-wise energy variations.
% Further analysis can be conducted to investigate the underlying physical phenomena based on these results.
