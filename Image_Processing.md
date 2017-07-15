# Image Processing in Ubuntu Command Line Interface

These commands are useful when editing images within the Ubuntu command line interface. They are very good at editing a single image or thousands of images in one go.

## Image Manipulations

[ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) is a very powerful tool for manipulating images via the command line.

To install ImageMagick, use:
`sudo apt install imagemagick`

### Image Resize

Modern day cameras take very high resolution images, however, most websites don't need images with resolutions that high. Thus, it is possible to resize the images to save bandwidth requirements when a user loads an image.

You can resize an image by a percentage point. To resize an image by 50%, use:
`convert -resize 50% source.jpg destination.jpg`

You can also resize an image to a specific resolution using a command like:
`convert -resize 1920x1080 source.jpg destination.jpg`

If you want to overwrite the original image when you resize the image, use `mogrify` instead of `convert` like:
`mogrify -resize 50% *.jpg`

All of these commands keep the image's aspect ratio,

View more of ImageMagick's image resizing options [here](https://www.imagemagick.org/Usage/resize/).

## Image Metadata

All images have metadata that can include incriminating information when posted on the internet. This data can include the camera make and model, camera settings, date and time, and **GPS location, elevation and speed**. Any image you post on the internet should have this information removed.

**exiftool** allows you to view and change an image's EXIF metadata. Install it with:
`sudo apt install libimage-exiftool-perl`

To view an image's EXIF metadata, use:
`exiftool image.jpg`

To remove an image's EXIF metadata, use:
`exiftool -all= image.jpg`

This command technically does not remove all metadata objects, but the items left are benign so it's okay.

This command also creates a backup of the original image that includes all of the prior metadata. To prevent this backup image from being created (essentially, overwriting the original image), use:
`exiftool -overwrite_origininal -all= image.jpg`

If you want to remove the metadata for all images in a directory, you can use the file wild-card when providing data on which image to edit:
`exiftool -overwrite_original -all= *.jpg`

View the exiftool documentation [here](http://www.sno.phy.queensu.ca/~phil/exiftool/exiftool_pod.html).
