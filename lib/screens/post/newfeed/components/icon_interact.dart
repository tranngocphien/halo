// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import '../../../../constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class IconLike extends StatefulWidget {
//   var isClicked;
//   String postId;
//   final Function() onClick;
//   IconLike({
//     required this.isClicked,required this.postId, required this.onClick,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<IconLike> createState() => _IconLikeState();
// }
//
// class _IconLikeState extends State<IconLike> {
//   var isClicked;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isClicked = widget.isClicked;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//           color: isClicked?primaryColor :Colors.grey[500], shape: BoxShape.circle),
//       child: GestureDetector(
//         onTap: (){
//           likePost(widget.postId).then((value) {
//             if(value.statusCode == 200){
//               setState(() {
//                 widget.onClick;
//                 isClicked = !isClicked;
//               });
//             }
//           });
//
//         },
//         child: const Icon(
//           Icons.thumb_up,
//           color: Colors.white,
//           size: 16,
//         ),
//       ),
//     );
//   }
// }
//
// // Future<http.Response> likePost(String postId) async {
// //   var url = "${urlApi}/postLike/action/${postId}";
// //   final prefs = await SharedPreferences.getInstance();
// //   final token = prefs.getString('token') ?? "";
// //   final userId = prefs.getString('userId');
// //   Map data = {
// //     'userId': userId
// //   };
// //   return await http.post(Uri.parse(url),body: data, headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
// // }