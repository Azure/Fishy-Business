## Instance Segmentation Pipeline - Mask R-CNN, PyTorch

Easily create custom computer vision models to detect and mask objects in your images and video for counting, movement, shape[,](https://www.grammarly.com/blog/what-is-the-oxford-comma-and-why-do-people-care-so-much-about-it/) and proportions.

![Instance Segmentation Pipeline](InstanceSegmentationPipeline.jpg "Instance Segmentation Pipeline")

1. **Frame Reduction and Proposal** - From a video, retain only the frames consisting of the visual content you're interested in, using the [Cognitive Services, Scence and Activity Recognition Service](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/#analyze).
2. **Frame Annotation** - Annotate frames using [VGG Image Annotator](http://www.robots.ox.ac.uk/~vgg/software/via/), [COCO Annotation UI](https://github.com/tylin/coco-ui), [Labelbox](https://labelbox.com/) or another image annotation tool.
3. **Visualise Class Distribution** - View the accumulation of samples per class. Extend this notebook to describe frames using metadata for subsetting.
4. **Prepare Training Dataset** - Create Training and Validation sets using metadata to subset
5. **View Training Dataset** - View the Training and Validation sets, and right any wrongs from annotating frames, prior to model training
6. **Model Training** - Let the magic begin. Be Sure tune select the Training and Validation set and model weights, and experiment with different training regimes.
7. **Model Scoring**
    * Image
    * Video

### Credits
* [multimodallearning](https://github.com/multimodallearning) / [pytorch-mask-rcnn](https://github.com/multimodallearning/pytorch-mask-rcnn)
* [michhar](https://github.com/michhar) / [custom-jupyterhub-linux-vm](https://github.com/michhar/custom-jupyterhub-linux-vm)
* [Azadehkhojandi](https://github.com/Azadehkhojandi) / [computer-vision-fish-frame-proposal](https://github.com/Azadehkhojandi/computer-vision-fish-frame-proposal)