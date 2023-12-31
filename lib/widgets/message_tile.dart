import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe})
      : super(key: key);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0:24,
          right: widget.sentByMe ? 24:0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17,left: 20, right: 20),
        decoration: BoxDecoration(
            color: widget.sentByMe ? const Color(0xffE5F9FF) : Colors.white,
            borderRadius: widget.sentByMe ? const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )
                :const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0.2,
                  blurRadius: 5,
                  offset: const Offset(0.0, 5.0)
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: -0.5),),
            const SizedBox(height: 8,),
            Text(widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );
  }
}
