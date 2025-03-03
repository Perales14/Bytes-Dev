import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUploadPanel extends StatelessWidget {
  final List<FileData> files;
  final Function(FileData) onRemove;
  final VoidCallback onAdd;

  const FileUploadPanel({
    required this.files,
    required this.onRemove,
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          height: 180, // Match the height of observations
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border:
                Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // File list in a scrollable area
              Expanded(
                child: files.isEmpty
                    ? Center(
                        child: Text(
                          'No hay archivos adjuntos',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.hintColor,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: files
                              .map((file) => FileListItem(
                                    file: file,
                                    onRemove: () => onRemove(file),
                                  ))
                              .toList(),
                        ),
                      ),
              ),

              // Upload button centered at the bottom
              Center(
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir Archivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FileListItem extends StatelessWidget {
  final FileData file;
  final VoidCallback onRemove;

  const FileListItem({
    required this.file,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getIconForFileType(file.type),
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              file.name,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
              size: 18,
            ),
            onPressed: onRemove,
            tooltip: 'Eliminar',
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            padding: EdgeInsets.zero,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  IconData _getIconForFileType(FileType type) {
    switch (type) {
      case FileType.pdf:
        return Icons.picture_as_pdf_outlined;
      case FileType.image:
        return Icons.image_outlined;
      case FileType.document:
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class FileData {
  final String id;
  final String name;
  final FileType type;
  final DateTime uploadDate;

  FileData({
    required this.id,
    required this.name,
    required this.type,
    required this.uploadDate,
  });
}

enum FileType {
  pdf,
  image,
  document,
  other,
}
