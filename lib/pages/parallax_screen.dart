import 'package:flutter/material.dart';

class ParallaxScreen extends StatelessWidget {
  const ParallaxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/1024',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              maxChildSize: 1,
              initialChildSize: .6,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeData.dark().scaffoldBackgroundColor,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 25,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text('Item $index'));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
