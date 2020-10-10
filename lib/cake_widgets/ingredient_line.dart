import 'package:flutter/material.dart';

import 'helper_classes/ingredient_line_widget_params.dart';

class IngredientLine extends StatefulWidget {

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
          child: ingredientDropdownButton(),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
          flex: 3,
          child: ingredientCountTextForm(),
        ),
        SizedBox(
          width: 20.0,
        ),
        deleteIngredientWidgetButton(),
      ],
    );
  }

  Widget ingredientDropdownButton() {
    return DropdownButton<String>(
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
    );
  }

  Widget ingredientCountTextForm() {
    return Form(
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
    );
  }

  Widget deleteIngredientWidgetButton() {
    return RaisedButton(
      child: Icon(Icons.close),
      onPressed: () {
        widget.widgetParams
            .deleteIngredientLineFunction(widget.widgetParams.widgetId);
      },
    );
  }
}