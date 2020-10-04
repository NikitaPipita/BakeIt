import 'package:flutter/material.dart';

import 'helper_classes/ingredient_line_widget_params.dart';

class IngredientLine extends StatefulWidget {
  /*final GlobalKey<FormState> formKey;
  final TextEditingController ingredientValueController;
  final TextEditingController ingredientCountController;
  final int widgetId;
  final List<String> ingredientValues;
  final Function deleteIngredientLine;


  const IngredientLine ({
    Key key,
    @required this.formKey,
    @required this.ingredientValueController,
    @required this.ingredientCountController,
    @required this.widgetId,
    @required this.ingredientValues,
    @required this.deleteIngredientLine,
     }): super(key: key);*/

  final IngredientLineWidgetParams widgetParams;

  const IngredientLine ({
    Key key,
    @required this.widgetParams
  }): super(key: key);

  @override
  _IngredientLineState createState() => _IngredientLineState();
}

class _IngredientLineState extends State<IngredientLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 7,
          child: DropdownButton<String>(
            value: widget.widgetParams.ingredientTitleController.text,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                widget.widgetParams.ingredientTitleController.text = newValue;
              });
            },
            items: widget.widgetParams.ingredientTitlesList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
          flex: 3,
          child: Form(
            key: widget.widgetParams.formKey,
            child: TextFormField(
              controller: widget.widgetParams.ingredientCountController,
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
              decoration: InputDecoration(
                labelText: 'Кол-во',
              ),
              validator: (value) {
                if (value.isEmpty || int.tryParse(value) == null) {
                  return 'Число должно быть целочисленным';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        RaisedButton(
          child: Icon(Icons.close),
          onPressed: () {
            widget.widgetParams
                .deleteIngredientLineFunction(widget.widgetParams.widgetId);
          },
        ),
      ],
    );
  }
}