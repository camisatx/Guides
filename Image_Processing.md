# Image Processing in Ubuntu Command Line Interface

These commands are useful when editing images within the Ubuntu command line interface. They are very good at editing a single image or thousands of images in one go.

### Contents

- [Image Manipulations](#image-manipulations)
    - [Compression](#compression)
    - [Resize](#resize)
    - [Prepare Images for the Web](#prepare-images-for-the-web)
- [Image Metadata](#image-metadata)

## Image Manipulations

[ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) is a very powerful tool for manipulating images via the command line.

To install ImageMagick, use:

```bash
sudo apt install imagemagick
```

### Compression

Most images can be compressed to a smaller size without any artifacts being visible. ImageMagick allows compression based on percent quality.

This command compresses the image's quality to 30% of the original.

```bash
convert -quality 30% source.jpg source-30p.jpg
```

### Resize

Modern day cameras take very high resolution images, however, most websites don't need images with resolutions that high. Thus, it is possible to resize the images to save bandwidth requirements when a user loads an image.

You can resize an image by a percentage point. To resize an image by 50%, use:

```bash
convert -resize 50% source.jpg destination.jpg
```

You can also resize an image to a specific resolution using a command like:

```bash
convert -resize 1920x1080 source.jpg destination.jpg
```

If you want to overwrite the original image when you resize the image, use `mogrify` instead of `convert` like:

```bash
mogrify -resize 50% *.jpg
```

All of these commands keep the image's aspect ratio. To not keep the aspect ratio, add an exclamation point (`!`) after the resize ratio.

View more of ImageMagick's image resizing options [here](https://www.imagemagick.org/Usage/resize/).

### Prepare Images for the Web

Images on websites should have as much quality as possible while minimizing size. This is possible by resizing and compressing the image.

You can resize and compress an image with one command:

```bash
convert -resize 1024x -quality 30% source.JPG source-1024-30p.JPG
```

As mentioned in this great [answer](https://askubuntu.com/a/781588) on Ask Ubuntu by Geppettvs D'Constanzo, you can batch resize and compress all jpg images in a folder by using this command:

```bash
for i in *.jpg; do convert $i -resize 1024x -quality 30% %i-1024x-30p.jpg; done;
```

If you want to overwrite the original images when resizing and compressing them, run this command:

```bash
mogrify -resize 1024x -quality 30% *.JPG
```

## Image Metadata

All images have metadata that can include incriminating information when posted on the internet. This data can include the camera make and model, camera settings, date and time, and **GPS location, elevation and speed**. Any image you post on the internet should have this information removed.

**exiftool** allows you to view and change an image's EXIF metadata. Install it with:

```bash
sudo apt install libimage-exiftool-perl
```

To view an image's EXIF metadata, use:

```bash
exiftool image.jpg
```

To remove an image's EXIF metadata, use:

```bash
exiftool -all= image.jpg
```

This command technically does not remove all metadata objects, but the items left are benign so it's okay.

This command also creates a backup of the original image that includes all of the prior metadata. To prevent this backup image from being created (essentially, overwriting the original image), use:

```bash
exiftool -overwrite_origininal -all= image.jpg
```

If you want to remove the metadata for all images in a directory, you can use the file wild-card when providing data on which image to edit:

```bash
exiftool -overwrite_original -all= *.jpg
```

View the exiftool documentation [here](http://www.sno.phy.queensu.ca/~phil/exiftool/exiftool_pod.html).
