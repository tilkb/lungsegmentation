# lungsegmentation: This is my research, which is created in order to write my thesis. 
Project to create a CAD system, this framework is created the first step, which is lungsegmentation.
Part of the framework:
-Matlab_functions: Core functions of the imageprocessing
-Modell_images: binary images, which describe the shape and size of a lung. Theese images requires to use model based segmentation.
-reference: it contains the expected result (the gold standard), it is used only when fake tomo pictures are used, so it is possible to project masks from CT images
-result: the folder of the output
-source: input folder for tomo images.
-sourceCT: input folder for CT images, it is used, when lung must be segmented on CT image
-CTsegmenter.m: segment the lung on CT images
-LungModel.mat: describes the shape and axial size of the lung
-ModelBuilder.m: build a lung model from images
-segment.m: segment the lung on tomo images
-tomovetites.m: project lung mask from CT to tomo with the correct matrix
