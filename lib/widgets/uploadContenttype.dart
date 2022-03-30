import 'package:flutter/material.dart';

class UploadType extends StatefulWidget {
  final Widget? icon;
  final String? type;
  final VoidCallback? ontap;

  UploadType({this.icon, this.type, this.ontap});
  @override
  State<UploadType> createState() => _UploadTypeState();
}

class _UploadTypeState extends State<UploadType> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.ontap!,
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [widget.icon!, Text(widget.type!)],
          ),
        ),
      ),
    );
  }
}
