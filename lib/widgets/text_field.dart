import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sunstone_ui_kit/color/color.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

enum CustomTextFormFieldType { email, password, generic }

typedef Function CustomTextFormFieldValidator(String value);

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final CustomTextFormFieldType type;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Function? onActionTap;
  final AutovalidateMode? autoValidateMode;

  const CustomTextFormField(
      {super.key,
        this.controller,
        this.placeholder,
        this.type = CustomTextFormFieldType.generic,
        this.focusNode,
        this.keyboardType = TextInputType.text,
        this.textInputAction,
        this.onActionTap,
        this.autoValidateMode
      });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  TextFieldValidator getValidator() {
    switch (widget.type) {
      case CustomTextFormFieldType.email:
        return EmailValidator(errorText: 'Please enter a valid email address');

      case CustomTextFormFieldType.password:
        return RequiredValidator(errorText: 'Please enter a password');

      default:
        return NoValidation('');
    }
  }

  bool showPassword = false;

  void onEyeTap() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  bool get isObscureField => widget.type == CustomTextFormFieldType.password;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        autovalidateMode: widget.autoValidateMode,
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: isObscureField && !showPassword,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: (_) {
          widget.onActionTap?.call();
        },
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: UIKitDefaultTypography().bodyText1.copyWith(
            color: UIKitColor.neutral3,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.only(bottom: 0.0, top: 15.0),
          prefix: const Padding(
              padding: EdgeInsets.only(left: 20.0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: UIKitColor.neutral1.withOpacity(0.2),
            ),
          ),
          suffixIcon: isObscureField
              ? IconButton(
            icon: Icon(showPassword
                ? CupertinoIcons.eye_fill
                : CupertinoIcons.eye_slash_fill),
            onPressed: () {
              onEyeTap();
            },
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: UIKitColor.neutral1.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: UIKitColor.neutral1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: UIKitColor.error1.withOpacity(0.2),
            ),
          ),
        ),
        validator: getValidator(),
      ),
    );
  }
}

class NoValidation extends TextFieldValidator {
  NoValidation(super.errorText);

  @override
  bool isValid(String? value) {
    return true;
  }
}
