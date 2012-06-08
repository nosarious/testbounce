
String[] loadFilenames(String path) {
  File folder = new File(path);
  FilenameFilter filenameFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      counter+=1;

     return name.toLowerCase().endsWith(".png"); // change this to any extension you want
    }
  };
  println(counter);
  return folder.list(filenameFilter);
}

String[] loadImages(String path) {
  File folder = new File(path);
  FilenameFilter filenameFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      counter+=1;
      return name.toLowerCase().endsWith(".jpeg"); // change this to any extension you want
   
    }
    
  };
  return folder.list(filenameFilter);
}
