# segments_separation_tool

This tool can be used to separate different membrane segments in tomograms. To facilitate this separation, each segment needs to be converted into unique single-value labels. Below is a typical workflow for using this tool:

Workflow:

1. Membrane Segmentation: Apply membrane segmentation software (e.g., MemBrain or TomoSegMemTV) to convert the tomogram into a binary volume, where membrane are marked with label.

2. Applying Unique Labels: Use the script bwlabeln_sorted.m to assign unique integer values to each segmented membrane region if the labels are not continuous.

3. Manual Label Sorting: Run the script labels_separation.m to open both the tomogram (from step 1) and the labeled volume (from step 2). This tool allows you to manually sort the labeled segments with different values into groups (see the following gif image).

![separation_usage](https://github.com/user-attachments/assets/ddded349-69df-4f28-99cb-d933a6b60e5d)
