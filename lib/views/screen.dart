import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_compress_crop_image/helpers/image_helper.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text(
          'Test',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile != null
                  ? Container(
                      width: size.width,
                      height: 600,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        image: DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: 30),
              TextButton(
                onPressed: () async {
                  print('Choose image');
                  var image = await ImageHelper.getFromGallery();
                  setState(() {
                    image != null ? imageFile = image : imageFile = imageFile;
                  });
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(size.width, 60),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: Colors.amber[800],
                ),
                child: Text(
                  'Choose image',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
