import 'package:flutter/material.dart';

class IngredientLineWidgetParams {

  final GlobalKey<FormState> formKey;
  final TextEditingController ingredientTitleController;
  final TextEditingController ingredientCountController;
  final int widgetId;
  final List<String> ingredientTitlesList;
  final Function deleteIngredientLineFunction;
  final int id;

  IngredientLineWidgetParams({
      this.formKey,
      this.ingredientTitleController,
      this.ingredientCountController,
      this.widgetId,
      this.ingredientTitlesList,
      this.deleteIngredientLineFunction,
      this.id,
  });
}