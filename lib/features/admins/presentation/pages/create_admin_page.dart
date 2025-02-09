import 'package:kammun_app/features/admins/domain/entities/create_admin_entity.dart';
import 'package:kammun_app/features/admins/presentation/redux/admins_action.dart';

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
  final _passwordController = TextEditingController();
  int _selectedWarehouse;
  bool _isSuperUser = false; // Added isSuperUser variable

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kmColors,
              flexibleSpace: const SafeArea(
                  top: true, child: Padding(padding: EdgeInsets.only(right: 120), child: AppBarKammunImage())),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    children: [
                      // ... (other form fields - name, username, password, warehouse) ...
                      ProductEntryField(
                          title: 'اسم الأدمن',
                          controller: _nameController,
                          hint: 'name',
                          validator: (value) => value.isEmpty ? 'مطلوب' : null),
                      ProductEntryField(
                          title: 'اسم الحساب',
                          controller: _usernameController,
                          hint: 'user name',
                          validator: (value) => value.isEmpty ? 'مطلوب' : null),
                      ProductEntryField(
                          title: 'كلمة المرور',
                          controller: _passwordController,
                          hint: 'password',
                          validator: (value) {
                            if (value.isEmpty) return 'مطلوب';
                            if (value.length < 8) return 'كلمة المرور يجل أن تكون 8 محارف على الأقل';
                            return null;
                          }),
                      Text('المستودع', style: dropdownItemStyle),
                      Row(
                        children: [
                          DropdownButton(
                            value: _selectedWarehouse,
                            items: state.generalInformationState.warehouses
                                .map((warehouse) => DropdownMenuItem<int>(
                                    child: Center(child: Text(warehouse.name, style: dropdownItemStyle)),
                                    value: warehouse.id))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedWarehouse = value),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      CheckboxListTile(
                        // Added CheckboxListTile
                        title: const Text('Is Super User'),
                        value: _isSuperUser, activeColor: kmColors,
                        onChanged: (value) => setState(() => _isSuperUser = value),
                      ),
                      KammunButton(
                          color: kmColors, onTap: () => _validateAndSubmit(context, store), text: 'تأكيد', height: 50)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _validateAndSubmit(BuildContext context, Store<AppState> store) {
    // Check form validation + warehouse selection
    final isFormValid = _formKey.currentState.validate();
    final isWarehouseSelected = _selectedWarehouse != null;

    if (!isFormValid || !isWarehouseSelected) {
      // Build list of missing fields for SnackBar
      final missingFields = <String>[];

      if (_nameController.text.isEmpty) missingFields.add('اسم الأدمن');
      if (_usernameController.text.isEmpty) missingFields.add('اسم الحساب');
      if (_passwordController.text.isEmpty) missingFields.add('كلمة المرور');
      if (_passwordController.text.length < 8) missingFields.add('كلمة المرور أقل من 8 محارف');
      if (!isWarehouseSelected) missingFields.add('المستودع');
      snackBar(context: context, message: 'المعلومات الناقصة: ${missingFields.join('، ')}', success: false);
      return;
    }

    // Dispatch action if all valid
    store.dispatch(
      CreateAdminAction(
        context: context,
        admin: CreateAdminEntity(
          userName: _usernameController.text,
          password: _passwordController.text,
          name: _nameController.text,
          isSuperUser: _isSuperUser,
          warehouseId: _selectedWarehouse,
        ),
      ),
    );
  }
}
