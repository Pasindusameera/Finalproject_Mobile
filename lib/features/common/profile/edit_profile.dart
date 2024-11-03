import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:playhub/core/common/widgets/custom_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfile({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String address;
  late List<String> preferredSports;
  late String profilePictureUrl;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    firstName = widget.initialData['firstName'];
    lastName = widget.initialData['lastName'];
    phone = widget.initialData['phone'] ?? '';
    address = widget.initialData['address'] ?? '';
    preferredSports =
        List<String>.from(widget.initialData['preferredSports'] ?? []);
    profilePictureUrl = widget.initialData['profilePictureUrl'] ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_profileImage == null) return null;
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_profileImage!);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: AppPalettes.foreground,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // Profile Picture
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (profilePictureUrl.isNotEmpty
                            ? NetworkImage(profilePictureUrl)
                            : null) as ImageProvider?,
                    child: _profileImage == null && profilePictureUrl.isEmpty
                        ? Icon(Icons.add_a_photo, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(height: 16),
                // Other fields
                _buildTextFormField(
                  label: 'First Name',
                  initialValue: firstName,
                  onChanged: (value) => firstName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'First name is required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextFormField(
                  label: 'Last Name',
                  initialValue: lastName,
                  onChanged: (value) => lastName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Last name is required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextFormField(
                  label: 'Phone',
                  initialValue: phone,
                  onChanged: (value) => phone = value,
                ),
                const SizedBox(height: 12),
                _buildTextFormField(
                  label: 'Address',
                  initialValue: address,
                  onChanged: (value) => address = value,
                ),
                const SizedBox(height: 12),
                _buildTextFormField(
                  label: 'Preferred Sports (comma separated)',
                  initialValue: preferredSports.join(', '),
                  onChanged: (value) => preferredSports =
                      value.split(',').map((sport) => sport.trim()).toList(),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final imageUrl = await _uploadImageToFirebase();
                      widget.onSave({
                        'firstName': firstName,
                        'lastName': lastName,
                        'phone': phone,
                        'address': address,
                        'preferredSports': preferredSports,
                        'profilePictureUrl': imageUrl ?? profilePictureUrl,
                      });
                    }
                  },
                  text: 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
