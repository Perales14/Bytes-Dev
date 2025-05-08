import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';

class FileCardsGrid extends StatelessWidget {
  final List<FileData> files;
  final Function(FileData)? onFileTap;
  final Function(FileData) onDownload;
  final Function(FileData) onDelete;

  static const double cardWidth = 280.0;
  static const double cardHeight = 160.0;
  static const double cardSpacing = 16.0;

  const FileCardsGrid({
    required this.files,
    required this.onDownload,
    required this.onDelete,
    this.onFileTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            (constraints.maxWidth / (cardWidth + cardSpacing)).floor();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: cardWidth / cardHeight,
            crossAxisSpacing: cardSpacing,
            mainAxisSpacing: cardSpacing,
          ),
          itemCount: files.length,
          itemBuilder: (context, index) =>
              _buildFileCard(files[index], context),
        );
      },
    );
  }

  Widget _buildFileCard(FileData file, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: file.type.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        file.type.icon,
                        size: 32,
                        color: file.type.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            file.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                file.formattedSize,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                _formatDate(file.uploadDate),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(12)),
                        border: Border(
                          left: BorderSide(
                            color: theme.dividerColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            onPressed: () => onDownload(file),
                            icon: Icons.download_rounded,
                            label: 'Descargar',
                            context: context,
                            showLabel: false,
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: theme.dividerColor.withOpacity(0.2),
                          ),
                          _buildActionButton(
                            onPressed: () => onDelete(file),
                            icon: Icons.delete_rounded,
                            label: 'Eliminar',
                            context: context,
                            isDestructive: true,
                            showLabel: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required BuildContext context,
    bool isDestructive = false,
    bool showLabel = true,
  }) {
    final theme = Theme.of(context);
    final color =
        isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;

    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
