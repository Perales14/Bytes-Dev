import 'package:flutter/material.dart';

class FileDragWidget extends StatefulWidget {
  final VoidCallback onSelectFiles;

  const FileDragWidget({
    super.key,
    required this.onSelectFiles,
  });

  @override
  State<FileDragWidget> createState() => _FileDragWidgetState();
}

class _FileDragWidgetState extends State<FileDragWidget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: DragTarget(
        onWillAcceptWithDetails: (data) {
          setState(() => _isDragging = true);
          return true;
        },
        onLeave: (data) {
          setState(() => _isDragging = false);
        },
        onAcceptWithDetails: (data) {
          setState(() => _isDragging = false);
          // Aquí iría la lógica para manejar el archivo
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: _isDragging
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDragging ? Colors.blue : Colors.grey,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: _isDragging ? Colors.blue : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Arrastra y suelta tus archivos aquí',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDragging ? Colors.blue : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'o',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: widget.onSelectFiles,
                  child: const Text('Seleccionar archivos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
