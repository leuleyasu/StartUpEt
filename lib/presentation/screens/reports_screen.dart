import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/app_colors.dart';
import '../../features/file/bloc/file_bloc.dart';
import '../../features/file/bloc/file_event.dart';
import '../../features/file/bloc/file_state.dart';
import '../../features/report/bloc/report_bloc.dart';
import '../../features/report/bloc/report_event.dart';
import '../../features/report/bloc/report_state.dart';
import '../../models/file_info.dart';
import '../../models/report.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ReportType _selectedType = ReportType.startupProgress;
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<FileInfo> _attachedFiles = [];
  bool _isUploadingFile = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ReportBloc>().add(const FetchHubReports());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showAwesomeSnackbar(
    String title,
    String message,
    ContentType contentType,
  ) {
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

  Future<void> _pickAndUploadDocument() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'documents',
      extensions: <String>['pdf', 'doc', 'docx', 'xlsx', 'xls', 'csv'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file == null) return;

    setState(() {
      _isUploadingFile = true;
    });

    if (!mounted) return;
    context.read<FileBloc>().add(
          UploadFile(
            file.path,
            category: FileCategory.other,
            isPublic: false,
          ),
        );
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;

    final fileIds = _attachedFiles.map((f) => f.id).toList();

    context.read<ReportBloc>().add(
          SubmitStartupReport(
            reportType: _selectedType,
            notes: _notesController.text.trim(),
            fileIds: fileIds,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileBloc, FileState>(
          listener: (context, state) {
            if (state is FileUploaded) {
              setState(() {
                _isUploadingFile = false;
                _attachedFiles.add(state.file);
              });
              _showAwesomeSnackbar(
                'Document Attached',
                'Successfully uploaded ${state.file.originalName ?? state.file.name ?? "file"}',
                ContentType.success,
              );
            } else if (state is FileError) {
              setState(() {
                _isUploadingFile = false;
              });
              _showAwesomeSnackbar(
                'Upload Notice',
                state.message,
                ContentType.failure,
              );
            }
          },
        ),
        BlocListener<ReportBloc, ReportState>(
          listener: (context, state) {
            if (state is ReportSubmittedSuccess) {
              _showAwesomeSnackbar(
                'Report Submitted!',
                'Your compliance progress report has been submitted for review.',
                ContentType.success,
              );
              _notesController.clear();
              setState(() {
                _attachedFiles.clear();
              });
              context.read<ReportBloc>().add(const FetchHubReports());
              _tabController.animateTo(1);
            } else if (state is ReportError) {
              _showAwesomeSnackbar(
                'Submission Notice',
                state.message,
                ContentType.failure,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compliance & Progress Reports'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.post_add),
                text: 'Submit Report',
              ),
              Tab(
                icon: Icon(Icons.history_edu),
                text: 'Reports & History',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSubmitReportTab(),
            _buildReportsHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informational Hero Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Periodic Compliance Filing',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Designated Ethiopian startups and hubs must submit regular progress updates to maintain their certified label benefits.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey[600],
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Report Type Selector
            const Text(
              'Report Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ReportType>(
                  isExpanded: true,
                  value: _selectedType,
                  items: const [
                    DropdownMenuItem(
                      value: ReportType.startupProgress,
                      child: Text('Startup Progress Report (Quarterly)'),
                    ),
                    DropdownMenuItem(
                      value: ReportType.incubationProgress,
                      child: Text('Incubation Program Milestone Progress'),
                    ),
                    DropdownMenuItem(
                      value: ReportType.ecosystemAnnual,
                      child: Text('Ecosystem Builder Annual Impact Report'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedType = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Progress Notes / Executive Narrative
            const Text(
              'Executive Progress Summary & Metrics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Provide details on revenue, current team size, traction, new milestones achieved, and operational updates...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a summary of your progress.';
                }
                if (val.trim().length < 20) {
                  return 'Summary should be at least 20 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Supporting Attachments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Supporting Documents (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: _isUploadingFile ? null : _pickAndUploadDocument,
                  icon: _isUploadingFile
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.attach_file, size: 18),
                  label: const Text('Add Document'),
                ),
              ],
            ),
            const SizedBox(height: 6),

            if (_attachedFiles.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.file_present_outlined, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      'No files attached (PDF, DOCX, XLSX allowed)',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(_attachedFiles.length, (index) {
                final file = _attachedFiles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          file.originalName ?? file.name ?? 'Document',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _attachedFiles.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 30),

            // Submit Button
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                final isLoading = state is ReportLoading;
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : _submitReport,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      isLoading ? 'Submitting...' : 'Submit Progress Report',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsHistoryTab() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReportBloc>().add(const FetchHubReports());
      },
      child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: SpinKitThreeBounce(color: AppColors.primary, size: 30),
            );
          }

          List<HubReport> reports = [];
          if (state is HubReportsLoaded) {
            reports = state.reports;
          }

          if (reports.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Reports Filed Yet',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your submitted progress filings and hub monitoring records will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _tabController.animateTo(0),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('File New Report'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              report.title ?? 'Progress Filing',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              report.period ?? 'Filing',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (report.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          report.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.35,
                          ),
                        ),
                      ],
                      if (report.metrics != null && report.metrics!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: report.metrics!.entries.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
