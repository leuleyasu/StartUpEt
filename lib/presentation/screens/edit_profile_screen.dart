import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/api_config.dart';
import '../../core/app_colors.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/file/services/file_service.dart';
import '../../injection_container.dart';
import '../../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;

  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _imageUrlController;

  bool _isSubmitting = false;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    final nameParts = (u?.name ?? '').trim().split(' ');
    final defaultFirstName =
        u?.firstName ?? (nameParts.isNotEmpty ? nameParts.first : '');
    final defaultLastName =
        u?.lastName ??
        (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');

    _firstNameController = TextEditingController(text: defaultFirstName);
    _lastNameController = TextEditingController(text: defaultLastName);
    _nameController = TextEditingController(text: u?.name ?? '');
    _phoneController = TextEditingController(text: u?.phone ?? '');
    _addressController = TextEditingController(text: u?.address ?? '');
    _imageUrlController = TextEditingController(text: u?.image ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    required IconData prefixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  void _onSave() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Validation Error',
          message: 'Please enter both first and last name',
          contentType: ContentType.warning,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : '$firstName $lastName'.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final image = _imageUrlController.text.trim();

    context.read<AuthBloc>().add(
      AuthUpdateProfileRequested(
        firstName: firstName.isNotEmpty ? firstName : null,
        lastName: lastName.isNotEmpty ? lastName : null,
        name: name.isNotEmpty ? name : null,
        phone: phone.isNotEmpty ? phone : null,
        address: address.isNotEmpty ? address : null,
        image: image.isNotEmpty ? image : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          setState(() {
            _isSubmitting = false;
          });
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Profile Updated',
              message: 'Profile updated successfully!',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pop(context);
        } else if (state is AuthError) {
          setState(() {
            _isSubmitting = false;
          });
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Update Failed',
              message: state.message,
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar Header
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.primary,
                    backgroundImage: _imageUrlController.text.isNotEmpty &&
                            !_isUploadingAvatar
                        ? (_imageUrlController.text.startsWith('http')
                            ? NetworkImage(_imageUrlController.text)
                            : NetworkImage(
                                '${ApiConfig.baseUrl}${_imageUrlController.text.startsWith('/') ? '' : '/'}${_imageUrlController.text}'))
                        : null,
                    child: _isUploadingAvatar
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : (_imageUrlController.text.isEmpty
                            ? Text(
                                (_firstNameController.text.isNotEmpty
                                        ? _firstNameController.text[0]
                                        : (user?.name?.isNotEmpty == true
                                              ? user!.name![0]
                                              : 'U'))
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null),
                  ),
                  GestureDetector(
                    onTap: _isUploadingAvatar
                        ? null
                        : () async {
                            try {
                              final XTypeGroup typeGroup = const XTypeGroup(
                                label: 'images',
                                extensions: ['jpg', 'jpeg', 'png', 'webp'],
                              );
                              final XFile? file = await openFile(
                                acceptedTypeGroups: [typeGroup],
                              );
                              if (file != null) {
                                setState(() {
                                  _isUploadingAvatar = true;
                                });
                                final fileService = sl<FileService>();
                                final uploadResult =
                                    await fileService.uploadAvatar(file.path);

                                if (!mounted) return;

                                uploadResult.fold(
                                  (failure) {
                                    setState(() {
                                      _isUploadingAvatar = false;
                                    });
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Upload Failed',
                                        message: failure.message,
                                        contentType: ContentType.failure,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  },
                                  (avatarUrl) {
                                    setState(() {
                                      _imageUrlController.text = avatarUrl;
                                      _isUploadingAvatar = false;
                                    });
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Avatar Uploaded',
                                        message:
                                            'Profile picture uploaded successfully. Tap Save to apply.',
                                        contentType: ContentType.success,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  },
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() {
                                  _isUploadingAvatar = false;
                                });
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Image Error',
                                    message: 'Error selecting image: $e',
                                    contentType: ContentType.failure,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            }
                          },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'User Account',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Read-only Info Badge Row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Email',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'Not available',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        user?.role ?? 'USER',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields (using TextField like login screen)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      decoration: _inputDecoration(
                        context,
                        hintText: 'First Name',
                        prefixIcon: Icons.person_outline,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: _inputDecoration(
                        context,
                        hintText: 'Last Name',
                        prefixIcon: Icons.person_outline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                decoration: _inputDecoration(
                  context,
                  hintText: 'Full Display Name (e.g. Abebe Bikila)',
                  prefixIcon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  context,
                  hintText: 'Phone Number (e.g. +251 91 123 4567)',
                  prefixIcon: Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _addressController,
                decoration: _inputDecoration(
                  context,
                  hintText: 'Address / Location (e.g. Addis Ababa)',
                  prefixIcon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _imageUrlController,
                decoration: _inputDecoration(
                  context,
                  hintText: 'Profile Picture URL',
                  prefixIcon: Icons.image_outlined,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isSubmitting ? null : _onSave,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Save Profile Updates',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
