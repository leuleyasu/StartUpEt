import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../features/file/services/file_service.dart';
import '../../features/pitch/bloc/pitch_bloc.dart';
import '../../features/pitch/bloc/pitch_event.dart';
import '../../features/pitch/bloc/pitch_state.dart';
import '../../injection_container.dart';
import '../../models/file_info.dart';

class SubmitPitchModal extends StatefulWidget {
  final String? defaultInvestorId;
  final String? investorName;

  const SubmitPitchModal({
    super.key,
    this.defaultInvestorId,
    this.investorName,
  });

  static Future<bool?> show(
    BuildContext context, {
    String? investorId,
    String? investorName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<PitchBloc>(),
        child: SubmitPitchModal(
          defaultInvestorId: investorId,
          investorName: investorName,
        ),
      ),
    );
  }

  @override
  State<SubmitPitchModal> createState() => _SubmitPitchModalState();
}

class _SubmitPitchModalState extends State<SubmitPitchModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _investorIdController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;

  bool _isUploadingFile = false;
  final List<String> _uploadedFileIds = [];
  final List<String> _uploadedFileNames = [];

  @override
  void initState() {
    super.initState();
    _investorIdController =
        TextEditingController(text: widget.defaultInvestorId ?? '');
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _investorIdController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPitchDeck() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'pitch_decks',
        extensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'zip'],
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null) {
        setState(() {
          _isUploadingFile = true;
        });

        final fileService = sl<FileService>();
        final result = await fileService.uploadFile(
          file.path,
          category: FileCategory.pitchDeck,
        );

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() {
              _isUploadingFile = false;
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
          (fileInfo) {
            setState(() {
              _isUploadingFile = false;
              _uploadedFileIds.add(fileInfo.id);
              _uploadedFileNames.add(file.name);
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingFile = false;
        });
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Attachment Error',
            message: 'Failed to pick file: $e',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  void _submitPitch() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'investorId': _investorIdController.text.trim(),
      'subject': _subjectController.text.trim(),
      'message': _messageController.text.trim(),
      if (_uploadedFileIds.isNotEmpty) 'attachments': _uploadedFileIds,
    };

    context.read<PitchBloc>().add(CreatePitch(data));
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<PitchBloc, PitchState>(
      listener: (context, state) {
        if (state is PitchCreated) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: const AwesomeSnackbarContent(
              title: 'Pitch Sent!',
              message:
                  'Your pitch has been submitted successfully to the investor.',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.of(context).pop(true);
        } else if (state is PitchError) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Pitch Failed',
              message: state.message,
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: bottomInset + 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.rocket_launch, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit Pitch to Investor',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (widget.investorName != null)
                            Text(
                              'Target: ${widget.investorName}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.defaultInvestorId == null ||
                    widget.defaultInvestorId!.isEmpty) ...[
                  TextFormField(
                    controller: _investorIdController,
                    decoration: InputDecoration(
                      labelText: 'Investor / Opportunity ID *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person_search),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please provide the target investor ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Pitch Subject / Headline *',
                    hintText: 'e.g. Revolutionary AgriTech Seed Round',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a pitch subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Executive Summary / Pitch Message *',
                    hintText:
                        'Briefly describe your traction, team, value proposition, and capital requirement...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your pitch narrative';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Pitch Deck Attachments',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (_uploadedFileNames.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _uploadedFileNames.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final name = entry.value;
                      return Chip(
                        avatar: const Icon(Icons.attachment, size: 16),
                        label: Text(name, style: const TextStyle(fontSize: 12)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          setState(() {
                            _uploadedFileIds.removeAt(idx);
                            _uploadedFileNames.removeAt(idx);
                          });
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isUploadingFile ? null : _pickAndUploadPitchDeck,
                  icon: _isUploadingFile
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file),
                  label: Text(_isUploadingFile
                      ? 'Uploading Deck...'
                      : 'Attach Pitch Deck (PDF/PPT)'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<PitchBloc, PitchState>(
                  builder: (context, state) {
                    final isLoading = state is PitchLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _submitPitch,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Send Pitch',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
