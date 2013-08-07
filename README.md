ROBOT_V1
========
v1.1.0 "Helianthus"

Matlab software to run the Staubli RX130 robotic arm and associated devices. This software was created by an ongoing collaboration of students within Dr. Chris Crawford's group at the University of Kentucky's Department of Physics and Astronomy. The ultimate goal of this software is to allow the arm to perfrom precision measurement and etching operations within many diverse scientific projects. This repository has been created with the hope of bringing order to the chaos that was our lab's MATLAB directory, and to create a central location to collect and organize our modifications to the main codebase. This code is available freely, and is intended for private or academic usage.


New in this Version:
- Crash detection has been sped up significantly by the addition of more complex bounding boxes.
- Full data collection procedure is in the /extensions/Patrick/Calibration folder. The script "QuickCollectData_Real.m" contains the main procedure. You will also find "testJs" and "histResults" to be helpful here.
- The geometricModel is now safer, including an intentionally oversized tool mount.
- Several more sophisticated ways of simulating the robot's movement, including a full simulation of the calibration procedure.


Quick Setup:
Place the folder "ROBOT_V1" into the desired MATLAB directory. Add the folder "robotCore" and all of its subfolder to the MATLAB path. You may also wish to add the "extensions" folder, or any of its subfolders. Any minor additions to the code which add extra features and do not alter the core software should be added here.


Usage:
A detailed guide to using the library will be included in the future. For now, see the documentation included within the source code for specific details. The two most important files for getting started are "RX130.m" (the class to control the robot) and "geometricModel.m" (the class to control the 3D simulation, which inludes crash detection).

The table and sphere grid positions can be found and modified in "~\models\modelTableAndSphereGrid.m". If you are using a different calibration method and the table has been fully removed (or are from a different university and have a different approach enitrely), you will need to alter "geometricModel.m" and "~\computerModel\getAdjacencyMatrix.m" in order to set up the correct environment for your situation. You may also need to generate new .stl models using CAD software (such as AutoCAD or PRO/E).

If MATLAB complains about an unknown function "isect", then run the following code (use foward slashes for a Linux/Unix/OSX evironment):
mex '[full path to MATLAB directory]\ROBOT_V1\robotCore\computerModel\isect.c'


Known Issues:
- The startup time for the geometricModel is pretty slow. This is an issue that is currently being addressed.
- The geometricModel can take longer than expected to check for collisions between some large or complex components. This is a result of the current design, and there is not much that can be done to correct this without a major overhaul of the system. However, as of this version, the addition of more complex bounding boxes has improved this problem significantly in most cases.
- As a result of the aforementioned slowness, the moveJ() function of the geometricModel works slowly for many actuations which osition non-adjacent parts of the robot very near each other or the environment. However, as of Version 1.1.0, moveJ() is again considered functional on reasonably fast computers.


In Development:
- Numerous tweaks, features, and bugfixes.


This official version of the repository is currently being maintained by Patrick VanMeter. Email pdvanmeter@gmail.com with questions, concerns, ideas, bugs, and/or suggestions. Bugfixes or new features should simply be uploaded to the official git repository at https://github.com/pdvanmeter/ROBOT_V1.git
