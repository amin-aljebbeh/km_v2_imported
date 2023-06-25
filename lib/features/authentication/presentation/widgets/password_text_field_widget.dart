import '../../../../core/core_importer.dart';

class PasswordTextFiled extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextFiled({Key key, this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextFormField(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        controller: passwordController,
        keyboardType: TextInputType.text,
        onEditingComplete: () => TextInput.finishAutofillContext(),
        autofillHints: const [AutofillHints.password],
        enableSuggestions: false,
        autocorrect: false,
        obscureText: true,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          floatingLabelStyle: mainStyle.copyWith(fontSize: 30, color: primaryColor),
          labelText: 'كلمة المرور',
          labelStyle: mainStyle.copyWith(fontSize: 30),
          hintStyle: mainStyle.copyWith(color: Colors.black45),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(5.0)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kmColors), borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }
}
