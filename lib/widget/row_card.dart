import '../core/core_importer.dart';

class RowCard extends StatelessWidget {
  final String title;
  final String info;
  final String details;
  final IconData icon;
  final bool isForAddress;
  const RowCard({Key key, this.title, this.info, this.details = ' ', this.icon, this.isForAddress = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(title, style: isForAddress ? informationStyle : disableStyle),
            if (info.isNotEmpty) const SizedBox(height: 10),
            if (info.isNotEmpty)
              SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: AutoSizeText(info, style: isForAddress ? disableStyle : informationStyle)),
            if (details != ' ') const SizedBox(height: 10),
            if (details != ' ')
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: AutoSizeText(details, style: disableStyle),
              ),
          ],
        )
      ],
    );
  }
}
