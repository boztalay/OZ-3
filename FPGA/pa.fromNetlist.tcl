
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

hdi::project new -name OZ-3_System -dir "C:/Users/Ben/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/planAhead_run_1" -netlist "C:/Users/Ben/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System/OZ3_System.ngc" -search_path { {C:/Users/Ben/Desktop/Folders/FPGA/Projects/Current Projects/Systems/OZ-3_System} }
hdi::project setArch -name OZ-3_System -arch spartan3e
hdi::param set -name project.paUcfFile -svalue "OZ3_System.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s500efg320-4 -project OZ-3_System
hdi::pconst import -project OZ-3_System -floorplan floorplan_1 -file "OZ3_System.ucf"
