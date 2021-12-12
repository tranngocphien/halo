import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/models/image_model.dart';
import 'package:halo/models/post.dart';
import 'package:halo/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halo/screens/post/newpost/components/image.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;
  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<EditPostScreen> {
  List<XFile> _imageFileList = List<XFile>.empty(growable: true);
  XFile? _videoFile;
  var contentController = TextEditingController();
  var countLike;
  late List<ImageModel> imgs;
  var isEditImages;

  @override
  void initState() {
    contentController.text = widget.post.content;
    imgs = widget.post.image;
    isEditImages = false;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  _pickImage() async {
    final pickedFileList = await ImagePicker().pickMultiImage();
    if (pickedFileList!.isNotEmpty) {
      setState(() {
        _imageFileList.addAll(pickedFileList);
        isEditImages = true;
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
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            "Sửa bài viết",
            style: TextStyle(color: primaryColor),
          ),
        ),
        actions: [
          Container(
              margin: EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _editPost(
                        contentController.text, _imageFileList, _videoFile);
                  },
                  child: Text("Sửa")))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const ProfileAvatar(
                            size: 24.0,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.username,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              Row(children: [
                                Text(
                                  "10 phút",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.public,
                                  color: Colors.grey[500],
                                  size: 12,
                                )
                              ])
                            ],
                          ),
                        ],
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintMaxLines: 5,
                        hintText: "Bạn đang nghĩ gì"),
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: isEditImages
                        ? _imageFileList == null
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
                                })
                        : imgs.isNotEmpty
                            ? GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: imgs
                                    .map((e) => ImagePostElement(
                                        image: Image.network(
                                            "${urlFiles}/${e.name}"),
                                        iconButton: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.close),
                                        )))
                                    .toList(),
                              )
                            : Container(),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: Icon(Icons.image)),
                      IconButton(
                          onPressed: () {
                            _pickVideo();
                          },
                          icon: Icon(Icons.video_collection))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _editPost(String described, List<XFile> imageFileList, XFile? video) async {
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
      "userId": userId,
      "images": imagesByte.isEmpty ? [] : imagesByte,
      "videos": []
    };

    var body = json.encode(data);
    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.post("/posts/edit/${widget.post.id}", data: data);
    if (response.statusCode == 200) {
      print("success");
    } else {
      print("failed");
    }
  }
}
