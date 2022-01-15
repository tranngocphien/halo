import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/profile/controller/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'components/image.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<XFile> _imageFileList = List<XFile>.empty(growable: true);
  XFile? _videoFile;
  var _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  _pickImage() async {
    final pickedFileList = await ImagePicker().pickMultiImage();
    if (pickedFileList!.isNotEmpty) {
      setState(() {
        _imageFileList = pickedFileList;
      });
    }
  }

  _pickVideo() async {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = pickedVideo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: primaryColor,
          ),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Bạn có chắc chắn muốn hủy đăng bài viết?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        title: const Center(
          child: Text(
            "Tạo bài viết",
            style: TextStyle(color: primaryColor),
          ),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    _createPost(
                        _contentController.text, _imageFileList, _videoFile);
                  },
                  child: const Text("Đăng")))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Bạn đang nghĩ gì"),
                ),
                Expanded(
                    child: _imageFileList == null
                        ? Container()
                        : GridView.builder(
                            itemCount: _imageFileList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return ImagePostElement(
                                  image: Image.file(
                                    File(_imageFileList[index].path),
                                    fit: BoxFit.contain,
                                  ),
                                  iconButton: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _imageFileList.removeAt(index);
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                    iconSize: 20,
                                  ));
                            })),
              ],
            ),
          )),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    _pickImage();
                  },
                  icon: const Icon(Icons.image)),
              IconButton(
                  onPressed: () {
                    _pickVideo();
                  },
                  icon: const Icon(Icons.video_collection))
            ],
          )
        ],
      ),
    );
  }

  _createPost(String described, List<XFile> imageFileList, XFile? video) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final userId = prefs.getString('userId') ?? "";
    List<String> imagesByte = List<String>.empty(growable: true);

    if (imageFileList.isNotEmpty) {
      List<File> listFile =
          imageFileList.map((image) => File(image.path)).toList();
      imagesByte.addAll(listFile
          .map((e) =>
              "data:image/jpeg;base64," + base64.encode(e.readAsBytesSync()))
          .toList());
    }

    File videoFile;

    Map data = {
      "described": described,
      "images": imagesByte.isEmpty ? [] : imagesByte,
      "videos": []
    };

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      var response = await dio.post("/posts/create", data: data);
      if (response.statusCode == 200) {
        const snackBar = SnackBar(
          content: Text('Đăng bài thành công'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).popAndPushNamed('/main');
        ProfileController profileController = Get.find();
        await profileController.getListUserPost(userId);
      } else {

      }

    } on DioError catch (e){
      SnackBar snackBar = const SnackBar(
        content: Text('Thêm bài viết không thành công'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

  }
}
