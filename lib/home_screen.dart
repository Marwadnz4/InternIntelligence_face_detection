import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  List<Face> faces = [];

  Future _pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        _image = File(image.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future _detectFaces(File img) async {
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final inputImage = InputImage.fromFilePath(img.path);
    faces = await faceDetector.processImage(inputImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Face Detection'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            20.0,
            16.0,
            20.0,
            28.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Container(
                height: 450,
                color: Colors.blueGrey,
                child: Center(
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 60,
                        )
                      : Image.file(_image!),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.camera).then((value) {
                    if (_image != null) _detectFaces(_image!);
                  });
                },
                child: Text(
                  'Open Camera',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery).then((value) {
                    if (_image != null) _detectFaces(_image!);
                  });
                },
                child: Text(
                  'Upload from Gallery',
                ),
              ),
              Text('Faces in Image : ${faces.length}'),
            ],
          ),
        ),
      ),
    );
  }
}
