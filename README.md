# SOP draft for Track localization / Fluo quantification based on Allen Brain CCF

## Objectives:

This document describes how to process images of full slides of mouse brain's sections  to get probe location data and fluorescence levels by brain area. It can be also useful to align brains from a group of mice, to compose group-based images of fluorescence, track locations, or (third-party) detected ROI(s) like neurons or injection sites.
This process is based on the work of several projects to rapidly pre-process, automatically align, and manually correct (paint over) atlases. It then allows information extraction and various image export options. Note that it currently only support coronal sections.


This is the documentation specific to AtlasPainter, a GUI build on top SHARP-Track by Philip Shamash (https://github.com/cortex-lab/allenCCF, https://www.biorxiv.org/content/10.1101/447995v1) et the original AP extension from Andy Peters (https://github.com/petersaj/AP_histology).

## Requirements

Download/Clone the SHARP-Track repository (https://github.com/cortex-lab/allenCCF).

Add the full path (with subfolders) by clicking in matlab on the Set Path button of the Home menu (don't forget to click on "Add with subfolders")

Download and save locally on your computer (network-based repository could delay significantly each loading of the atlas) the Allen Mouse Brain Atlas (2015) with region annotations (2017). Available from: http://download.alleninstitute.org/informatics-archive/current-release/mouse_ccf/annotation/

Download/Clone this repository (https://github.com/juliencarponcy/AP_histology), which is just a fork of the original AP_histology folder (https://github.com/petersaj/AP_histology) with the added Graphical User Interface (GUI) and documentation.

You then have to set your matlab working directory to this repository, click on the AtlasPainter.mlapp file in matlab to open MATLAB's AppDesigner, and then click the Run button to open the GUI.

The following section describes the steps necessary in order to obtain the exported images to the right format, it completes the documentation of the two underlying projects. The more relevant instructions are in https://github.com/petersaj/AP_histology#readme but you can also check out https://github.com/cortex-lab/allenCCF/wiki for the original project wiki.

Importantly, all these scripts are only taking RGB (3 channels max.) .tif images
Support for more channels or other image formats is considered. Feel free to contribute.

## Workflow description

### Export
- Full Slides acquired with ZEN: 
  - Open ZEN blue
  - ​	Select maximum 3 channels and change their display color to Green, Red, and Blue. If less than 3 channels, just leave out one color, if more than 3, we'll have to had an extra step. Meanwhile, just leave out one not displayed.

​			§ Not Cyan, Magenta, White etc..

​		○ Adjust levels : 

​			§ manually and equally for all channels:

​				□ First click on the reset button in the histogram to observe the real picture without any tuning of the curves

​				□ Then change, in the histogram, for all channels, the White value (out of 65555), to something lower that will allow you to see anatomical landmarks (eg. 20000). Be careful not to "eat to much" in your histogram as you are decreasing the range of the fluo intensity by doing that (certain noisy or very bright pixel will appear at maximum value whereas they would have not if you did not touch the histogram, this must be carefully selected in order to not saturate your signals).

![](https://github.com/juliencarponcy/AP_histology/blob/master/Histogram Image.png)



​		○ In processing, click on Batch, then in Batch Method, select Image export, and in the Method Parameters, Show All. 

​		○ As a File type, select Tagged Image File Format (TIFF), not Big Tiff format 64 bit (Big Tiff)

​		○ Do not convert to 8 Bit

​		○ Compression: None

​		○ Resize:  ? Depending on acquisition resolution. The trade-off is to find the best compromise between processing speed and quantification sampling (resolution) quality.

​		○ Tick the boxes Apply display Curve and Channel Color

​			§ Merged Channel Image

​		○ Use Full Set of Dimensions

​		○ Do Not Create Folder

​		○ Generate xml file

​		○ Do Not Generate zip file

![](https://github.com/juliencarponcy/AP_histology/blob/master/Export Image.png)


- One Section only
  - To adapt from above
- Full Slides acquired with StereoInvestigator
- - To be written
- Single Section with ZEN
- - To be written
- Single Section with StereoInvestigator
- - To be written

## AP matlab script (build on top of Sharp-Track)

Open the pipeline script e.g.  JulienTestPipeline.m


1. Set the allen_atlas_path to the local folder where you have put your atlas files into.

	- Set im_path to the current mice path
    - Then execute the commands blocks by clicking in the Run and Advance button and follow instructions
2. Preprocess

	- Individual sections within the slide will be highlighted in the section, potentially alongside dust or debris patches on your slide. Click on the section in the order they have been mounted, after a delay, every selected region should have a rectangle around them
	- Finally press spacebar to finish your section selection and switch to next slide. 

3. Rotate, centre, pad, flip slice images

	- It will display you individual section and ask you to draw the midline so the sections will be rotated and centred for next steps
	- It will then prompt you if you wish to further rotate and reorder sections, that should not be necessary and you might as well press escape right away. (or you can browse to check)

4. Select CCF that matches slices

	- Scroll to the atlas section that fit yours, you can flip in every plane to match cutting angle, press enter to make correspond an atlas plane to your section, then move on to next section by pressing 2. Any time you can go back and check by  pressing 1. Check that all your sections get associated with an atlas plane then press Esc to save

5. Align CCF slices and  histology slices

	- This step might take some time depending on image size to automatically fit the atlas to your sections.

	- The quality of the alignment by default with hugely vary according to the way previous steps have been done. E.g.: Are some sections deformed by the mounting? How carefully you selected the atlas plane (have you adapted the angle of slicing in the atlas) ? Are there debris and dust around the section, how well the midline has been drawn? etc... 

6. Manually adjust:

	- Browse all your sections and possibly adjust the atlas matching by clicking on a few anatomical landscapes on your section, then, in the same order, on the atlas. Points      located at the external limits of the brain tends to work better than particular landmarks within the brain. Repeat for other sections. Press Esc when done
Note that everything is modifiable by "painting" later in the AtlasPainter GUI.

7. Utilize aligned CCF

	- Allow you to visualize the  results of the previous steps

8. Optional: Draw probe(s) trajectory(ies)

	- Based on your records and observations, assign a number to each of your penetration/probe

	- Get a first glance at your tracks by browsing through all the sections with 1 and 2, then, when you know which tracks corresponds to what, start drawing on top of your DiI/DiD signals by first pressing the number key corresponding to the penetration/probe you want to label

	- Press Esc at the end, you should see that after matlab processed it all:

 ![](https://github.com/juliencarponcy/AP_histology/blob/master/3D probe track Image.png)

And that: 

![](https://github.com/juliencarponcy/AP_histology/blob/master/Probe Histology Image.png)

After these steps, you then have the possibility to align electrophysiological markers like spike rate, with the histology.

Check https://github.com/petersaj/AP_histology#ap_align_probe_histology for a preview and more infomation.

## AtlasPainter Matlab GUI

This interface has been made to facilitate exploration, quantification and modification of data related to automatically fitted atlas and probe tracing in the previous steps.

### A few hints for usage

- Specify the (brain-specific) path to the "slices" directory created by AP_histology for each mouse.
- Specify the path to the Allen Mouse Brain Atlas directory.
- Click on the Load button, after reconstructing transformed atlases, you will see your first section

![](https://github.com/juliencarponcy/AP_histology/blob/master/Atlas Painter Screenshot Image.png)
