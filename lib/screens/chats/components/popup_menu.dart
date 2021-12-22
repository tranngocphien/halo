import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/icons/icons.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(8, 52),
      child: Container(
        height: 30,
        width: 30,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      onSelected: (value) {
        switch (value) {
          case 'createGroup':
            Navigator.pushNamed(context, '/createGroup');
            break;
          case 'addFriend':
            Navigator.pushNamed(context, '/searchFriend');
            break;
          case 'scanQR':
            break;
          case 'zaloCalendar':
            break;
          case 'loginHistory':
            break;
          case 'myCloud':
            break;
          case 'createCallGroup':
            break;
        }
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.group_add_outlined, color: subtitleColor),
            SizedBox(width: 15),
            Text('Tạo nhóm'),
          ]),
          value: 'createGroup',
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.person_add_outlined, color: subtitleColor),
            SizedBox(width: 15),
            Text('Thêm bạn'),
          ]),
          value: 'addFriend',
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Qrcode.qrcode, color: subtitleColor),
            SizedBox(width: 15),
            Text('Quét mã QR'),
          ]),
          value: 'scanQR',
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.date_range, color: subtitleColor),
            SizedBox(width: 15),
            Text('Lịch Zalo'),
          ]),
          value: 'zaloCalendar',
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.desktop_windows, color: subtitleColor),
            SizedBox(width: 15),
            Text('Lịch sử đăng nhập'),
          ]),
          value: 'loginHistory',
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.cloud_queue, color: subtitleColor),
            SizedBox(width: 15),
            Text('Cloud của tôi'),
          ]),
          value: 'myCloud',
        ),
        PopupMenuItem(
          child: Row(children: const [
            Icon(Icons.videocam_outlined, color: subtitleColor),
            SizedBox(width: 15),
            Text('Tạo cuộc gọi nhóm'),
          ]),
          value: 'createCallGroup',
        ),
      ],
    );
  }
}
