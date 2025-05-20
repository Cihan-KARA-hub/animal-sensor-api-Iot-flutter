import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserFormWidget extends StatefulWidget {
  @override
  _UserFormWidgetState createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _vetNameController = TextEditingController();

  String _role = 'VET';
  bool _enabled = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> data = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "lastName": _lastNameController.text,
      "firstName": _firstNameController.text,
      "role": _role,
      "enable": _enabled,
    };

    if (_role == 'COMPANY') {
      data['companyName'] = _companyNameController.text;
    } else if (_role == 'VET') {
      data['licenseNumber'] = _licenseNumberController.text;
      data['vetName'] = _vetNameController.text;
      data['companyName'] = _companyNameController.text;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        'http://localhost:8081/api/v1/user',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer YOUR_TOKEN',
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success: ${response.statusCode}')),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.response?.data ?? e.message}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create User'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Username required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Password required' : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'First name required' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Last name required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: InputDecoration(labelText: 'Role'),
                items: ['COMPANY', 'VET']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _role = value!);
                },
              ),
              if (_role == 'COMPANY')
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  validator: (value) => _role == 'COMPANY' && value!.isEmpty
                      ? 'Company name required'
                      : null,
                ),
              if (_role == 'VET') ...[
                TextFormField(
                  controller: _vetNameController,
                  decoration: InputDecoration(labelText: 'Vet Name'),
                  validator: (value) => _role == 'VET' && value!.isEmpty
                      ? 'Vet name required'
                      : null,
                ),
                TextFormField(
                  controller: _licenseNumberController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => _role == 'VET' && value!.isEmpty
                      ? 'Title required'
                      : null,
                ),
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'Company name'),
                  validator: (value) => _role == 'VET' && value!.isEmpty
                      ? 'Company name required'
                      : null,
                ),
              ],
              SwitchListTile(
                title: Text("Enabled"),
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
