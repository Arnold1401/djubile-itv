import 'dart:async';

import 'package:djubli/class/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'globals.dart' as glenv;

class DetailCarPromotion extends StatefulWidget {
  final Car car;
  const DetailCarPromotion({required this.car, Key? key}) : super(key: key);

  @override
  _DetailCarPromotionState createState() => _DetailCarPromotionState();
}

class _DetailCarPromotionState extends State<DetailCarPromotion> {
  TextEditingController _commentController = TextEditingController();
  int qtyComment = 0;
  String newComment = "-";
  bool isVisible = false;

  //connect to server
  final IO.Socket socket = IO.io(glenv.ipnumber, <String, dynamic>{
    'transports': ['websocket'],
  });
  Timer? timer1;
  Timer? timer2;

  @override
  void initState() {
    super.initState();
    //socket
    socket.connect();
    print("room skrg" + widget.car.id.toString());
    socket.emit("join_room", widget.car.id);
    socket.on("receive_message", (message) {
      print(message["message"]);

      setState(() {
        newComment = message["message"];
        qtyComment += 1;
        comments.add(message["message"]);
      });
      timer1 = Timer(Duration(seconds: 1), () {
        setState(() {
          isVisible = true;
        });
      });
      timer2 = Timer(Duration(seconds: 5), () {
        setState(() {
          isVisible = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    timer1?.cancel();
    timer2?.cancel();
    //disconnecting socket

    socket.disconnect();
    socket.emit("leave_room", widget.car.id);
    socket.off("receive_message");
    super.dispose();
  }

  final List<String> comments = [];

  void _showToast(BuildContext context) {
    Flushbar(
      message: 'new: $newComment',
      duration: Duration(seconds: 1),
      backgroundColor: Colors.black54,
      icon: Icon(
        Icons.comment,
        color: Colors.white,
      ),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
                child: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index]),
                  );
                }),
          )
        ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.carName),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Image.network(widget.car.carPicture)),
          Container(
            padding: EdgeInsets.only(left: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Car Name : ${widget.car.carName}"),
                Text("Description : ${widget.car.description}"),
                Text("Price : ${widget.car.price}"),
                Text("Address : ${widget.car.Address}"),
                Text("Mileage : ${widget.car.mileage}"),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 2),
                  child: Container(
                    width: double.infinity,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${newComment}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    // color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${qtyComment} Comment',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => {_showBottomSheet(context)},
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hoverColor: Colors.black,
                              // fillColor: Colors.grey[600],
                              hintText: 'Add a comment',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            String comment = _commentController.text;

                            socket.emit("send_message",
                                {"room": widget.car.id, "message": comment});
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
