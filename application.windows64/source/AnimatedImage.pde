class AnimatedImage {
  //hard to explain, but this class is a helper for animated images, which is a majority of the images in the program
  int imageCount;
  int framesPerImage;
  PImage[] images;
  int width, height;
  //offset and pause are for the cacti to bob up and down at a different rate specifically
  int offset;
  int pause;
  AnimatedImage(String filePathPrefix, String fileSuffix, int imageCount, int framesPerImage, int offset, int pause) {
    this.imageCount = imageCount;
    //creates array for the number of images
    this.images = new PImage[imageCount];
    this.framesPerImage = framesPerImage;
    this.offset = offset;
    this.pause = pause;
    //checks how many images there are given the specified imageCount
    for (int i = 1; i <= this.imageCount; i++) {
      //loads the image given the specified fields (could remove suffix, since all images are the same kind being png's)
      this.images[i-1] = loadImage(filePathPrefix + nf(i) + "." + fileSuffix);
    }
    this.width = this.images[0].width;
    this.height = this.images[0].height;
  }
  void draw(float x, float y) {
    //displays the current image based on the framesPerImage specified, and the frameCount of the program (thats why % is used)
    int currentImage = (((frameCount + pause ) / framesPerImage) + offset) % (imageCount + pause);
    //restarts the loop
    if (currentImage >= imageCount) {
      currentImage = 0;
    }
    image(images[currentImage], x, y);
  }
}
