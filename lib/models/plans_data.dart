class PlansData{
  final String image;
  final String title;

  PlansData({required this.image,required this.title});

  @override
  String toString() {
    return 'PlansData{image: $image, title: $title}';
  }
}