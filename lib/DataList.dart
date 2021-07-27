class DataList {
  DataList(this.title, [this.children = const <DataList>[]]);
  final String title;
  List<DataList> children;
}