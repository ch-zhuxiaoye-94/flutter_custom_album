import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

//stful
class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  State<ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  File? _pickedImage;//缓存从系统相册中选择的图片
  Future<void> _pickedImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    /*
      ImagePicker帮助调起系统相册，并回调选择图片后的图片资源与本地路径
     */
    if (pickedFile == null) {
      return;
    }

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
  }

  Future<XFile> _compressImage(File image) async{
    //返回压缩文件的文件描述信息
    final compressImage = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        //这里填绝对路径
        '${image.path}_compress.jpg'
    );
    return compressImage!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Demo'),
      ),
      body: Center(
          child: _pickedImage == null
              ? Text('No Image Selected')
              : Image.file(_pickedImage!)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickedImageFromGallery,
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}