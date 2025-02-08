import '../../../../core/core_importer.dart';

class CreateAdminPage extends StatefulWidget {
  const CreateAdminPage({Key key}) : super(key: key);

  @override
  State<CreateAdminPage> createState() => _CreateAdminPageState();
}

class _CreateAdminPageState extends State<CreateAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  int _selectedWarehouse;
  bool _isSuperUser = false; // Added isSuperUser variable

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kmColors,
            flexibleSpace: const SafeArea(
                top: true, child: Padding(padding: EdgeInsets.only(right: 120), child: AppBarKammunImage())),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (other form fields - name, username, password, warehouse) ...
                  ProductEntryField(title: 'الاسم',controller: _nameController,hint: 'name'),
                  ProductEntryField(title: 'اسم الحساب',controller: _usernameController,hint: 'user name'),
                  ProductEntryField(title: 'كلمة المرور',controller: _usernameController,hint: 'password'),
                  Text('المستودع',style: dropdownItemStyle),
                  DropdownButton(
                    value: _selectedWarehouse,
                    items: state.generalInformationState.warehouses
                        .map((warehouse) => DropdownMenuItem<int>(
                        child: Center(child: Text(warehouse.name, style: dropdownItemStyle)),
                        value: warehouse.id))
                        .toList(),
                    onChanged: (value) {
                      _selectedWarehouse = value;

                    },
                  ),
                  CheckboxListTile(
                    // Added CheckboxListTile
                    title: const Text('Is Super User'),
                    value: _isSuperUser,activeColor: kmColors,
                    onChanged: (value) {
                      setState(() {
                        _isSuperUser = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
