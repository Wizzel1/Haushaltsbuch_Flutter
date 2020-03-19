class Category {
  Category({this.name});

  final String name;
  //todo: specify icon

  Map<String, String> categoryIconMap = {
    'Payment': 'coin',
    'Food': 'food-variant'
  };
}
