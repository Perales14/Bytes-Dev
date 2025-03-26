import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUploadPanel extends StatelessWidget {
  final RxList<FileData> files; // Cambiado a RxList
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
                child: Obx(() => files.isEmpty
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
                      )),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          _getFileIcon(file.type, theme),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                if (file.size != null)
                  Text(
                    file.formattedSize,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            onPressed: onRemove,
            tooltip: 'Eliminar archivo',
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _getFileIcon(FileType type, ThemeData theme) {
    IconData iconData;
    Color color;

    switch (type) {
      case FileType.pdf:
        iconData = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case FileType.image:
        iconData = Icons.image;
        color = Colors.blue;
        break;
      case FileType.word:
        iconData = Icons.description;
        color = Colors.blue.shade800;
        break;
      case FileType.excel:
        iconData = Icons.table_chart;
        color = Colors.green;
        break;
      default:
        iconData = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Icon(iconData, size: 24, color: color);
  }
}

class FileData {
  final String id;
  final String name;
  final FileType type;
  final DateTime uploadDate;
  final String? path; // Ruta del archivo en el sistema
  final int? size; // Tamaño en bytes

  FileData({
    required this.id,
    required this.name,
    required this.type,
    required this.uploadDate,
    this.path,
    this.size,
  });

  // Método para obtener tamaño formateado
  String get formattedSize {
    if (size == null) return '';
    if (size! < 1024) return '$size B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)} KB';
    return '${(size! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class FileType {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> extensions;

  const FileType._({
    required this.name,
    required this.icon,
    required this.color,
    required this.extensions,
  });

  static const FileType pdf = FileType._(
    name: 'PDF',
    icon: Icons.picture_as_pdf,
    color: Colors.red,
    extensions: ['.pdf'],
  );

  static const FileType word = FileType._(
    name: 'Word',
    icon: Icons.description,
    color: Color(0xFF2B579A), // Word blue
    extensions: ['.doc', '.docx'],
  );

  static const FileType excel = FileType._(
    name: 'Excel',
    icon: Icons.table_chart,
    color: Colors.green,
    extensions: ['.xls', '.xlsx'],
  );

  static const FileType image = FileType._(
    name: 'Image',
    icon: Icons.image,
    color: Colors.blue,
    extensions: ['.jpg', '.jpeg', '.png', '.gif', '.bmp'],
  );

  static const FileType document = FileType._(
    name: 'Document',
    icon: Icons.article,
    color: Colors.orange,
    extensions: ['.txt', '.rtf'],
  );

  static const FileType other = FileType._(
    name: 'Other',
    icon: Icons.insert_drive_file,
    color: Colors.grey,
    extensions: [],
  );

  // Helper method to determine file type from extension
  static FileType fromExtension(String extension) {
    final ext = extension.toLowerCase();
    if (pdf.extensions.contains(ext)) return pdf;
    if (word.extensions.contains(ext)) return word;
    if (excel.extensions.contains(ext)) return excel;
    if (image.extensions.contains(ext)) return image;
    if (document.extensions.contains(ext)) return document;
    return other;
  }
}
