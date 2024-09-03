# Master Thesis Code Repository

This repository contains MATLAB scripts used for analyzing various types of data as part of a Master Thesis project. The scripts cover data processing and analysis for different experiments and measurements.

## Scripts Overview

1. **`beamlineTransmissionClean.m`**: Analyzes beamline transmission data. This script processes GMD data to evaluate transmission characteristics. (GAS Monitor Detector https://photon-science.desy.de/facilities/flash/photon_diagnostics/gmd_intensity_and_position/index_eng.html)

2. **`craterProfileClean.m`**: Processes crater profile data. It loads, analyzes, and plots cross-sectional profiles from crater measurements.

3. **`maxDepthClean.m`**: Computes and saves the maximum depth from silicon profile data. This script calculates the depth of features based on profile data and saves the results to a text file.

4. **`siliconShotAnalysisClean.m`**: Analyzes silicon shot data. It processes data files to extract and save pulse profiles.

5. **`wavefrontSensorProfileClean.m`**: Analyzes wavefront sensor profiles. It reads intensity distribution data, computes profile metrics, fits Gaussian models, and plots the results.

## Requirements

- MATLAB (preferably the latest version)
- MATLAB toolboxes used: 
  - Image Processing Toolbox (for image analysis and processing)
  - Curve Fitting Toolbox (for fitting models to data)

## Setup

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/your-username/your-repository-name.git
2. **Navigate to the Repository Directory**:

    ```sh
    cd your-repository-name
3. **Add Data**: Place your data files in the appropriate folders as referenced in the scripts. Update the file paths in the scripts if necessary to match your directory structure.

## Usage
1. `beamlineTransmissionClean.m`:

- Place your image files in the designated folder.
- Run the script in MATLAB to process the data and analyze beamline transmission.
2. `craterProfileClean.m`:

- Ensure your crater profile data files are in the specified folder.
- Execute the script to generate and view crater profile plots.
3. `maxDepthClean.m`:

- Place silicon profile data in the appropriate directory.
- Run the script to calculate and save the maximum depth data.
4. `siliconShotAnalysisClean.m`:

- Load your silicon shot data images into the designated folder.
- Run the script to extract pulse profiles and visualize them.
5. `wavefrontSensorProfileClean.m`:

- Ensure your .txt files with intensity distribution data are in the correct folder.
- Execute the script to compute profiles, fit Gaussian models, and plot the results.
### Example
To run a script, navigate to the script's directory in MATLAB and execute it. For example:

  ```matlab
  cd('path/to/your/repository')
  beamlineTransmissionClean
  ````
  
## Contributing
Feel free to fork the repository and submit pull requests with improvements or additional features. For any issues or suggestions, please open an issue on the GitHub repository page.

## License
This repository is licensed under the MIT License. See the LICENSE file for details.
