# Lung Estimation on Digital Tomosynthesis images
This is my research, which is created in order to write my thesis. 
![Segmented Lung on DTS](result/LIDC_IDRI_0438_0.25_114.png?raw=true "Segmented Lung on DTS")
+ Blue is the reference
+ Red is segmentation without Model
+ Green is segmentation with Model
Project to create a CAD system, this framework is created the first step, which is lungsegmentation.
##Folders of the framework:
=================
+ Matlab_functions: Core functions of the imageprocessing
+ Modell_images: binary images, which describe the shape and size of a lung. Theese images requires to use model based segmentation.
+ reference: it contains the expected result (the gold standard), it is used only when fake tomo pictures are used, so it is possible to project masks from CT images
+ result: the folder of the output
+ source: input folder for tomo images.
+ sourceCT: input folder for CT images, it is used, when lung must be segmented on CT image
+ CTsegmenter.m: segment the lung on CT images
+ LungModel.mat: describes the shape and axial size of the lung
+ ModelBuilder.m: build a lung model from images
+ segment.m: segment the lung on tomo images
+ tomovetites.m: project lung mask from CT to tomo with the correct matrix

##How to use:
###Prepocessing of the images
+ If you need any preprocessing, you can use temp forlder for DTS images image_scale.m is for resize the images.
+ You have to to put images to resize_from folder and get the results in resize_to folder.
###Build model before first running
+ Put the binary images which descibes the shape of the lung to Model_images folder.
+ You can create a folder in Model_images/axial for each axial CT imageset. These images must describe the volumendistibution os the lung.
+ After theese steps, please run ModelBuilder.m
![Segmented lung on CT slice](Modell_images/MASK139.png?raw=true "Reference Lung")
###Run the segmentetion on DTS
+ Put the DTS images to source folder and put reference masks(binary image) to reference folder in the same order
+ Open segment.m set the central images and run it. You can modify theese parameters.
+ Results will appear in the result folder and PREFIX_result.csv file will contain the metrics of the result
###Run the segmentetion on axial CT images
+ Put images to source and run CT segmenter.m and the segmented images will appear in result folder
![Segmented lung on CT slice](temp/segmented/ct/CT001.png?raw=true "Segmented lung on CT slice")

##How does it works?
+ You can read about it in my paper and my Thesis (unfortunately it is Hungarian, if you have question, please contact me)
+ Read BSc-thesis.pdf and IMEKO-final-paper.pdf
