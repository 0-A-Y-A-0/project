import 'dart:io';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  const UploadBox({
    required this.onTap,
    this.imageFile,
  });

  final VoidCallback onTap;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.onSurface, width: 2),
        ),
        child: imageFile == null
            ? Center(
                child: Icon(Icons.add, size: 34, color: cs.onSurface),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
      ),
    );
  }
}