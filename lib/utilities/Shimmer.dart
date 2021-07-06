import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScreen extends StatefulWidget {
  final double height;
  final double width;
  final bool vertical;
  final bool listView;
  final int itemCount;
  ShimmerScreen({this.height,this.width,this.vertical,this.listView,this.itemCount});
  @override
  _ShimmerScreenState createState() => _ShimmerScreenState();
}

class _ShimmerScreenState extends State<ShimmerScreen> {
  final bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: _enabled,
      child:widget.listView? ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: widget.vertical?Axis.vertical:Axis.horizontal??Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            margin: EdgeInsets.only(right: 10),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        itemCount: 6,
      ):GridView.count(
        physics: BouncingScrollPhysics(),
        crossAxisCount: widget.itemCount??2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        shrinkWrap: true,
        children: new List<Widget>.generate(
            10, (index) {
          return new GridTile(
              child: Stack(
                children: [
                  new Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        ),
                  ),
                  Positioned(
                      bottom: 5,
                      left: 5,
                      child: Container(height: 10,width: widget.width,color: Colors.grey,))
                ],
              ));
        }),
      ),
    );
  }
}
