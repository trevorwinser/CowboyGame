class AnimatedImage {
  int imageCount;
  int framesPerImage;
  PImage[] images;
  int width, height;
  int offset;
  int pause;
  AnimatedImage(String filePathPrefix, String fileSuffix, int imageCount, int framesPerImage, int offset, int pause) {
    this.imageCount = imageCount;
    this.images = new PImage[imageCount];
    this.framesPerImage = framesPerImage;
    this.offset = offset;
    this.pause = pause;
    for (int i = 1; i <= this.imageCount; i++) {
      
      this.images[i-1] = loadImage(filePathPrefix + nf(i) + "." + fileSuffix);
    }
    
    this.width = this.images[0].width;
    this.height = this.images[0].height;
  }

  void draw(float x, float y) {
    int currentImage = (((frameCount + pause ) / framesPerImage) + offset) % (imageCount + pause);
    if (currentImage >= imageCount) {
      currentImage = 0;
    }
    image(images[currentImage], x, y);
  }
}