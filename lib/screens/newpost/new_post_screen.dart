import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/newpost/components/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<XFile>? _imageFileList;
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
            Navigator.pop(context);
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
              margin: EdgeInsets.all(8),
              child: ElevatedButton(onPressed: () {
                _createPost(_contentController.text, _imageFileList, _videoFile);
              }, child: Text("Đăng")))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Bạn đang nghĩ gì"),
                ),
                Expanded(
                    child: _imageFileList == null
                        ? Container()
                        : GridView.builder(
                            itemCount: _imageFileList!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return ImageItem(
                                  image: Image.file(
                                    File(_imageFileList![index].path),
                                    fit: BoxFit.contain,
                                  ),
                                  iconButton: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _imageFileList!.removeAt(index);
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
    );
  }

  _createPost(
      String described, List<XFile>? imageFileList, XFile? video) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    List<File> listFile =
         imageFileList!.map((image) => File(image.path)).toList();
    File videoFile;

    List<String> imagesByte = listFile.map((e) =>"data:image/jpeg;base64,"+ base64.encode(e.readAsBytesSync())).toList();
    print(imagesByte.toString());
    print(imagesByte.length);
    Map data = {
      'described': described,
      'image': imagesByte
    };

    // var request = http.MultipartRequest("Post", Uri.parse("http://192.168.1.9:8000/api/v1/posts/create"));
    // for(var image in _imageFileList!){
    //     request.files.add(await http.MultipartFile.fromPath("images", image.path));
    // }
    //
    // request.fields["described"] = described;
    //
    // Map<String, String> headers = {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $token"
    // };
    //
    // request.headers.addAll(headers);
    //
    // var jsonResponse = null;

    var response = await http.post(
        Uri.parse("${urlApi}posts/create"),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'},
        body: data);
    if(response.statusCode == 200){
      print("success");
    }
  }
}
