import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityRow extends StatefulWidget {

  ActivityRow({this.activityInstance});
  final Widget activityInstance;

  @override
  State<ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<ActivityRow> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 14),
          SizedBox(width: 10),
          Text(widget.activityInstance.toStringShort(), style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Container()),
          TextButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.activityInstance),
            );
          } ,
              child: Icon(Icons.arrow_forward_ios_outlined, size: 14)),
        ],
      ),
    );
  }
}