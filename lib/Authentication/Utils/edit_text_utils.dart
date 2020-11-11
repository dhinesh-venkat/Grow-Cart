import 'package:flutter/material.dart';

class EditTextUtils {
  TextFormField getCustomEditTextArea({
    String labelValue = "",
    String hintValue = "",
    Function validator,
    IconData icon,
    bool validation,
    TextEditingController controller,
    TextInputType keyboardType,
    String validationErrorMsg,
    Function onsubmit,
    TextInputAction action,
    bool autoFocus,
    FocusNode focusNode,
    Function onchanged,
  }) {
    return TextFormField(
      onChanged: onchanged,
      textInputAction: action,
      // autofocus: autoFocus,
      //focusNode: focusNode,
      //onEditingComplete: ,
      onFieldSubmitted: onsubmit,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixStyle: TextStyle(color: Colors.orange),
        fillColor: Colors.white.withOpacity(0.6),
        filled: true,
        isDense: true,
        labelStyle: TextStyle(color: Colors.orange),
        focusColor: Colors.orange,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 1.0,
          ),
        ),
        hintText: hintValue,
        labelText: labelValue,
      ),
      validator: validator,
    );
  }
}
