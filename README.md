## Instance Segmentation Pipeline - Mask R-CNN, PyTorch

Easily create custom computer vision models to detect and mask objects in your images and video for counting, movement, shape[,](https://www.grammarly.com/blog/what-is-the-oxford-comma-and-why-do-people-care-so-much-about-it/) and proportions.

![Instance Segmentation Pipeline](InstanceSegmentationPipeline.jpg "Instance Segmentation Pipeline")

1. **Frame Reduction** - From a video, retain only the frames consisting of the visual content you're interested in, using the [Cognitive Services, Scene and Activity Recognition Service](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/#analyze).
2. **Frame Annotation** - Annotate frames using [VGG Image Annotator](http://www.robots.ox.ac.uk/~vgg/software/via/), [COCO Annotation UI](https://github.com/tylin/coco-ui), [Labelbox](https://labelbox.com/) or another image annotation tool.
3. **View Class Distribution** - View the accumulation of samples per class. Extend this notebook to describe frames using custom metadata for subsetting.
4. **Prepare Training Dataset** - Create Training and Validation sets using metadata to subset.
5. **View Training Dataset** - View the Training and Validation sets - and right any wrongs from annotating frames - prior to model training.
6. **Model Training** - Let the magic begin. Be sure to  specify the Training and Validation set and initial model weights, and then experiment with different training regimes.
7. **Model Scoring**
    * Image
    * Video
8. **Frame Proposal**

## Setup
### Windows
1. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest)
2. Install `kubectl`
    * [PowerShell Gallery](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-powershell-from-psgallery), or
    * [Chocolatey](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-powershell-from-psgallery)
3. Install [Helm](https://docs.helm.sh/using_helm/#installing-helm)
4. Install [Docker](https://docs.docker.com/docker-for-windows/install/)

### Credits
* [multimodallearning](https://github.com/multimodallearning) / [pytorch-mask-rcnn](https://github.com/multimodallearning/pytorch-mask-rcnn)
* [michhar](https://github.com/michhar) / [custom-jupyterhub-linux-vm](https://github.com/michhar/custom-jupyterhub-linux-vm)
* [Azadehkhojandi](https://github.com/Azadehkhojandi) / [computer-vision-fish-frame-proposal](https://github.com/Azadehkhojandi/computer-vision-fish-frame-proposal)