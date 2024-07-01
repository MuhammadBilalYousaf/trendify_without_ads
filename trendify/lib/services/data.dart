import 'package:trendify/models/category_model.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category=[];
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.categoryName= "Business";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  categoryModel.categoryName= "Entertainment";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  categoryModel.categoryName= "General";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  categoryModel.categoryName= "health";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  categoryModel.categoryName= "science";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  categoryModel.categoryName= "sport";
  category.add(categoryModel);
  categoryModel= new CategoryModel();
  
  categoryModel.categoryName= "technology";
  category.add(categoryModel);
  categoryModel= new CategoryModel();

  return category;

}