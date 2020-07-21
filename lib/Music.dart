class Music{
  String title;
  String artist;
  String imagePath;
  String url;

  Music(String title, String artist, String imagePath, String url){
    this.title = title;
    this.artist = artist;
    this.imagePath = imagePath;
    this.url = url;
  }

  String getTitle() => this.title;

  void setTitle(String title){
    this.title = title;
  }

  String getArtist() => this.artist;

  void setArtist(String artist){
    this.artist = artist;
  }

  String getImagePath() => this.imagePath;

  void setImagePath(String imagePath){
    this.imagePath = imagePath;
  }

  String getUrl() => this.url;

  void setUrl(String url){
    this.url = url;
  }

}