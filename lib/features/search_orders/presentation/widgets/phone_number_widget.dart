import '../../../../core/core_importer.dart';

class PhoneNumberWidget extends StatelessWidget {
  final String phoneNumber;
  final String userName;
  final Function(String) onChoose;

  const PhoneNumberWidget({Key key, this.phoneNumber, this.userName = ' ', this.onChoose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: 1, color: kmColors),
        LabelRow(rightSideText: phoneNumberString, leftSideText: phoneNumber, leftSideStyle: informationStyle),
        LabelRow(rightSideText: nameString + ' ', leftSideText: userName, leftSideStyle: informationStyle),
        Divider(thickness: 1, color: kmColors),
      ],
    );
  }
}
