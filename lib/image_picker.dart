import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

const kImageSpacing = 10.0;//图片间距
const kImageRowSize = 3.0;//一行放几张图片
const kMaxPickImageCount = 100;//图片最大可选数量

//stful
class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  State<ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  List<XFile>? _pickedPhotoList;//缓存从系统相册中选择的图片

  //图片选取
  Future<void> _pickPhotoFromGallery() async {
    List<XFile> pickedPhotoList = await ImagePicker().pickMultiImage();
    /*
      ImagePicker帮助调起系统相册，并回调选择图片后的图片资源与本地路径
     */
    if (pickedPhotoList.isEmpty) {
      return;
    }

    setState(() {
      _pickedPhotoList = pickedPhotoList;
    });
  }

  //图片展示列表
  Widget _buildPhotosList(){
    return Padding(
      padding: const EdgeInsets.all(kImageSpacing),
      child: LayoutBuilder(//LayoutBuilder自动计算子控件占用的宽度
          builder: (BuildContext context, BoxConstraints constraints) {
            final size = (constraints.maxWidth - kImageSpacing * 2) / kImageRowSize;
            return Wrap(//Wrap自动换行布局
              spacing: kImageSpacing,
              runSpacing: kImageSpacing,
              children: [
                for (final photoXFile in _pickedPhotoList!)
                  Container(
                    clipBehavior: Clip.antiAlias, //设置裁剪方式，不然看不到圆角，这种裁剪方式渲染速度更快
                    decoration: BoxDecoration( //decoration帮助设置圆角
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Image.file(
                      File(photoXFile.path),
                      width: size,
                      height: size,
                      fit: BoxFit.cover,//照片尺寸与规定的尺寸不一致时的适配方式
                    ),
                  ),
                if (_pickedPhotoList!.length < kMaxPickImageCount)
                  GestureDetector(
                    onTap: _pickPhotoFromGallery,
                    child: Container(
                      color: Colors.black12,
                      width: size,
                      height: size,
                      child: const Icon(
                        Icons.add,
                        size: 48,
                        color: Colors.black38,
                      ),
                    ),
                  )
              ],
            );
          }
      ),
    );
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
          child: _pickedPhotoList == null
              ? Text('No Photo Selected')
              : _buildPhotosList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPhotoFromGallery,
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}