import '../../../../core/core_importer.dart';

class UserNameTextField extends StatelessWidget {
  final TextEditingController usernameController;

  const UserNameTextField({Key key, this.usernameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextFormField(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        controller: usernameController,
        keyboardType: TextInputType.text,
        onEditingComplete: () => TextInput.finishAutofillContext(),
        cursorColor: primaryColor,
        autofillHints: const [AutofillHints.username],
        decoration: InputDecoration(
          labelText: 'اسم المستخدم',
          floatingLabelStyle: mainStyle.copyWith(fontSize: 30, color: primaryColor),
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
