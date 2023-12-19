import './single_filter_model.dart';

class FilterCategoryModel {
  String identifier;
  String label;
  bool isSelcted;
  List<SingleFilterModel> singleFilterModel;

  FilterCategoryModel(
      {required this.identifier,
      required this.label,
      required this.isSelcted,
      required this.singleFilterModel});
}
