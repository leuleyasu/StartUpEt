import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../features/application/bloc/application_bloc.dart';
import '../../features/application/bloc/application_state.dart';
import '../../features/file/bloc/file_bloc.dart';
import '../../features/file/bloc/file_event.dart';
import '../../features/file/bloc/file_state.dart';
import '../../models/file_info.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<FileInfo> _vaultFiles = [];
  bool _isUploading = false;
  final TextEditingController _lookupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _extractFilesFromApplications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lookupController.dispose();
    super.dispose();
  }

  void _extractFilesFromApplications() {
    final appState = context.read<ApplicationBloc>().state;
    if (appState is ApplicationListLoaded) {
      for (final app in appState.applications) {
        if (app.data != null) {
          final data = app.data!;
          _addFileRef(
            id: data['businessLicenseFileId']?.toString(),
            name: 'Commercial Business License',
            category: 'BUSINESS_LICENSE',
          );
          _addFileRef(
            id: data['articlesOfIncorpFileId']?.toString(),
            name: 'Articles of Incorporation',
            category: 'ARTICLES_OF_INCORPORATION',
          );
          _addFileRef(
            id: data['pitchDeckFileId']?.toString(),
            name: 'Startup Pitch Deck',
            category: 'PITCH_DECK',
          );
          _addFileRef(
            id: data['financialsFileId']?.toString(),
            name: 'Financial Statements',
            category: 'FINANCIAL_STATEMENT',
          );
          _addFileRef(
            id: data['taxRegistrationFileId']?.toString(),
            name: 'Tax Registration Certificate',
            category: 'TAX_REGISTRATION',
          );

          if (data['files'] is List) {
            for (final f in data['files'] as List) {
              if (f is Map<String, dynamic>) {
                final fileInfo = FileInfo.fromJson(f);
                if (!_vaultFiles.any((existing) => existing.id == fileInfo.id)) {
                  _vaultFiles.add(fileInfo);
                }
              }
            }
          }
        }
      }
    }
  }

  void _addFileRef({
    required String? id,
    required String name,
    required String category,
  }) {
    if (id == null || id.isEmpty) return;
    if (_vaultFiles.any((f) => f.id == id)) return;

    _vaultFiles.add(
      FileInfo(
        id: id,
        name: name,
        originalName: name,
        category: category,
        status: 'ATTACHED',
      ),
    );
  }

  void _showAwesomeSnackbar(
    String title,
    String message,
    ContentType contentType,
  ) {
    if (!mounted) return;
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _pickAndUploadDocument(FileCategory category) async {
    final XFile? file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Documents & Images',
          extensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        ),
      ],
    );

    if (file == null) return;

    setState(() {
      _isUploading = true;
    });

    if (!mounted) return;
    context.read<FileBloc>().add(
          UploadFile(
            file.path,
            category: category,
            isPublic: false,
          ),
        );
  }

  void _showUploadDialog() {
    FileCategory selectedCategory = FileCategory.businessLicense;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.upload_file,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Upload Legal Document',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Document Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<FileCategory>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(
                            value: FileCategory.businessLicense,
                            child: Text('Commercial Business License'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.articlesOfIncorporation,
                            child: Text('Articles of Incorporation'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.pitchDeck,
                            child: Text('Investor Pitch Deck'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.taxRegistration,
                            child: Text('TIN Tax Registration Document'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.financialStatement,
                            child: Text('Financial Statement / Audit'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.investorDocument,
                            child: Text('Investor Agreement / Cap Table'),
                          ),
                          DropdownMenuItem(
                            value: FileCategory.other,
                            child: Text('Other Regulatory Document'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.amber.shade800,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Allowed formats: PDF, PNG, JPG, DOCX (Max 10 MB). Rate limit: 5 uploads / minute.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickAndUploadDocument(selectedCategory);
                      },
                      icon: const Icon(Icons.file_open_outlined, size: 18),
                      label: const Text(
                        'Browse & Upload File',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLookupDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Lookup File by ID'),
          content: TextField(
            controller: _lookupController,
            decoration: const InputDecoration(
              labelText: 'File ID / UUID',
              hintText: 'e.g. 64b8f... or uuid',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final id = _lookupController.text.trim();
                if (id.isNotEmpty) {
                  Navigator.pop(dialogCtx);
                  context.read<FileBloc>().add(FetchFile(id));
                }
              },
              child: const Text('Lookup'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteFile(FileInfo file) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text(
            'Are you sure you want to remove "${file.originalName ?? file.name ?? 'this document'}" from your vault?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                context.read<FileBloc>().add(DeleteFile(file.id));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return 'Size unknown';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  IconData _getCategoryIcon(String? category) {
    final cat = (category ?? '').toUpperCase();
    if (cat.contains('LICENSE') || cat.contains('INCORP')) {
      return Icons.gavel_outlined;
    }
    if (cat.contains('PITCH')) {
      return Icons.slideshow_outlined;
    }
    if (cat.contains('FINANCIAL') || cat.contains('STATEMENT')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (cat.contains('TAX') || cat.contains('TIN')) {
      return Icons.receipt_long_outlined;
    }
    if (cat.contains('CERTIFICATE')) {
      return Icons.workspace_premium_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  Color _getCategoryColor(String? category) {
    final cat = (category ?? '').toUpperCase();
    if (cat.contains('LICENSE') || cat.contains('INCORP')) {
      return Colors.indigo;
    }
    if (cat.contains('PITCH')) {
      return Colors.deepPurple;
    }
    if (cat.contains('FINANCIAL')) {
      return Colors.teal;
    }
    if (cat.contains('TAX')) {
      return Colors.blue.shade700;
    }
    if (cat.contains('CERTIFICATE')) {
      return Colors.amber.shade800;
    }
    return Colors.grey.shade700;
  }

  List<FileInfo> _getFilteredFiles(int tabIndex) {
    switch (tabIndex) {
      case 1:
        // Legal & Tax
        return _vaultFiles.where((f) {
          final cat = (f.category ?? '').toUpperCase();
          return cat.contains('LICENSE') ||
              cat.contains('INCORP') ||
              cat.contains('TAX');
        }).toList();
      case 2:
        // Pitch & Finance
        return _vaultFiles.where((f) {
          final cat = (f.category ?? '').toUpperCase();
          return cat.contains('PITCH') ||
              cat.contains('FINANCIAL') ||
              cat.contains('INVESTOR');
        }).toList();
      case 3:
        // Other Records
        return _vaultFiles.where((f) {
          final cat = (f.category ?? '').toUpperCase();
          return !cat.contains('LICENSE') &&
              !cat.contains('INCORP') &&
              !cat.contains('TAX') &&
              !cat.contains('PITCH') &&
              !cat.contains('FINANCIAL') &&
              !cat.contains('INVESTOR');
        }).toList();
      default:
        return _vaultFiles;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) {
        if (state is FileUploaded) {
          setState(() {
            _isUploading = false;
            if (!_vaultFiles.any((f) => f.id == state.file.id)) {
              _vaultFiles.insert(0, state.file);
            }
          });
          _showAwesomeSnackbar(
            'Document Uploaded',
            'Successfully vaulted ${state.file.originalName ?? state.file.name ?? 'file'}.',
            ContentType.success,
          );
        } else if (state is FileDeleted) {
          setState(() {
            _vaultFiles.removeWhere((f) => f.id == _lookupController.text);
          });
          _showAwesomeSnackbar(
            'Document Removed',
            'File deleted from the compliance vault.',
            ContentType.help,
          );
        } else if (state is FileLoaded) {
          setState(() {
            if (!_vaultFiles.any((f) => f.id == state.file.id)) {
              _vaultFiles.insert(0, state.file);
            }
          });
          _showAwesomeSnackbar(
            'File Retrieved',
            'Found file: ${state.file.originalName ?? state.file.name ?? state.file.id}',
            ContentType.success,
          );
        } else if (state is FileDownloaded) {
          _showAwesomeSnackbar(
            'Download Complete',
            'Received binary stream (${state.bytes.length} bytes).',
            ContentType.success,
          );
        } else if (state is FileError) {
          setState(() {
            _isUploading = false;
          });
          _showAwesomeSnackbar(
            'File Storage Notice',
            state.message,
            ContentType.failure,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compliance Document Vault'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Lookup File ID',
              onPressed: _showLookupDialog,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Attached Files',
              onPressed: () {
                setState(() {
                  _extractFilesFromApplications();
                });
                _showAwesomeSnackbar(
                  'Vault Refreshed',
                  'Synced file references with active applications.',
                  ContentType.help,
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All Documents'),
              Tab(text: 'Legal & Tax'),
              Tab(text: 'Pitch & Finance'),
              Tab(text: 'Other Records'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildFileList(_getFilteredFiles(0)),
                _buildFileList(_getFilteredFiles(1)),
                _buildFileList(_getFilteredFiles(2)),
                _buildFileList(_getFilteredFiles(3)),
              ],
            ),
            if (_isUploading)
              Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: const Center(
                  child: Card(
                    margin: EdgeInsets.all(32),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 16),
                          Text(
                            'Vaulting document securely...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Performing category validation & storage upload',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: _showUploadDialog,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text(
            'Upload Document',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildFileList(List<FileInfo> files) {
    if (files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_open_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'No Documents in this Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your business license, articles of incorporation, pitch deck, or TIN records to keep them safe and accessible for Ethiopian startup certification.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showUploadDialog,
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Upload Document Now'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final catColor = _getCategoryColor(file.category);
        final catIcon = _getCategoryIcon(file.category);
        final displayName = file.originalName ?? file.name ?? 'Document #${file.id}';
        final sizeText = _formatFileSize(file.size);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(catIcon, color: catColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  file.category ?? 'REGULATORY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: catColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                sizeText,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (val) {
                        if (val == 'copy_id') {
                          Clipboard.setData(ClipboardData(text: file.id));
                          _showAwesomeSnackbar(
                            'Copied to Clipboard',
                            'File ID: ${file.id}',
                            ContentType.help,
                          );
                        } else if (val == 'delete') {
                          _confirmDeleteFile(file);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'copy_id',
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 18),
                              SizedBox(width: 10),
                              Text('Copy File ID'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              SizedBox(width: 10),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.vpn_key_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          file.id.length > 14
                              ? '${file.id.substring(0, 14)}...'
                              : file.id,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () {
                        context.read<FileBloc>().add(DownloadFile(file.id));
                      },
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text(
                        'Download / Preview',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
