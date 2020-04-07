### Instance Segmentation Pipeline, using Mask R-CNN and PyTorch with an Azure Data Science Virtual Machine, to count fish in Baited Remote Underwater Video.

Easily create custom computer vision models to detect and mask objects in your images and video for counting, movement, shape[,](https://www.grammarly.com/blog/what-is-the-oxford-comma-and-why-do-people-care-so-much-about-it/) and proportions.

![Instance Segmentation Pipeline](InstanceSegmentationPipeline.jpg "Instance Segmentation Pipeline")

1. **Frame Reduction** - From a video, retain only the frames consisting of the visual content you're interested in, using the [Cognitive Services, Scene and Activity Recognition Service](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/#analyze).
2. **Frame Annotation** - Annotate frames using [VGG Image Annotator](http://www.robots.ox.ac.uk/~vgg/software/via/), [COCO Annotation UI](https://github.com/tylin/coco-ui), [Labelbox](https://labelbox.com/) or another image annotation tool.
3. **View Class Distribution** - View the accumulation of samples per class. Extend this notebook to describe frames using custom metadata for subsetting.
4. **Prepare Training Dataset** - Create Training and Validation sets using metadata to subset.
5. **View Training Dataset** - View the Training and Validation sets - and right any wrongs from annotating frames - prior to model training.
6. **Model Training** - Let the magic begin. Be sure to  specify the Training and Validation set and initial model weights, and then experiment with different training regimes.
7. **Model Scoring**
8. **Frame Proposal**

## Setup
1. Create a Storage Account -
    * Add File Shares -
        * frames
        * labeledframes
        * modeltraining
        * modelweights
        * video

2. Deploy a [Data Science Virtual Machine for Linux (Ubuntu)]( https://azuremarketplace.microsoft.com/en-in/marketplace/apps/microsoft-ads.linux-data-science-vm-ubuntu)
    * Add Inbound Port Rules -
        * FrameReductionNotebook - 8888
        * ViewClassDistributionNotebook - 8889
        * CreateMetadataNotebook - 8890
        * PrepareTrainingDatasetNotebook - 8891
        * ModelTrainingNotebook - 8892
        * ModelScoringNotebook - 8893
        * FrameProposalNotebook - 8894

    * Configure DNS Name -
        * \<DNS Name Label>.australiaeast.cloudapp.azure.com

3. Create Cognitive Services - Computer Vision Service

4. `ssh <Username>@<Public IP address>`

5. Create directories
    * /mnt/frames
    * /mnt/video/processed
    * /mnt/video/unprocessed

6. Mount directories
    * sudo mount -t cifs //instancesegmentation.file.core.windows.net/frames /mnt/frames -o vers=3.0,username=instancesegmentation,password=<Key>,dir_mode=0777,file_mode=0777,sec=ntlmssp
    * sudo mount -t cifs //instancesegmentation.file.core.windows.net/video /mnt/video -o vers=3.0,username=instancesegmentation,password=<Key>,dir_mode=0777,file_mode=0777,sec=ntlmssp

7. `git clone https://github.com/Azure/Machine-Learning-Containers.git`
8. `pip install pip==9.0.1`
9. `cd /Machine-Learning-Containers/Containers/<Container Name>`
10. `chmod 777 Build.sh`
11. `chmod 777 Deploy.sh`
12. `./Build.sh`
13. `./Deploy.sh`
14. `docker container list`
15. `docker logs <Name>`
16. Copy Jupyter Notebook URL

## Credits
* [multimodallearning](https://github.com/multimodallearning) / [pytorch-mask-rcnn](https://github.com/multimodallearning/pytorch-mask-rcnn)
* [michhar](https://github.com/michhar) / [custom-jupyterhub-linux-vm](https://github.com/michhar/custom-jupyterhub-linux-vm)
* [Azadehkhojandi](https://github.com/Azadehkhojandi) / [computer-vision-fish-frame-proposal](https://github.com/Azadehkhojandi/computer-vision-fish-frame-proposal)
