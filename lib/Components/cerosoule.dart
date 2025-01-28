import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<Carousel> {
  final CarouselController controller = CarouselController(initialItem: 1);

  final List<String> imageUrls = [
    'https://img.freepik.com/free-photo/construction-concept-with-engineering-tools_1150-17809.jpg?t=st=1737095907~exp=1737099507~hmac=be78b1487ea944f09d602ce250908264df9e49a4d5a3a896d0c3a30c90a908c3&w=900',
    'https://img.freepik.com/free-photo/construction-concept-with-engineering-tools_1150-17809.jpg?t=st=1737095907~exp=1737099507~hmac=be78b1487ea944f09d602ce250908264df9e49a4d5a3a896d0c3a30c90a908c3&w=900',
    'https://img.freepik.com/free-photo/construction-concept-with-engineering-tools_1150-17809.jpg?t=st=1737095907~exp=1737099507~hmac=be78b1487ea944f09d602ce250908264df9e49a4d5a3a896d0c3a30c90a908c3&w=900',
    'https://img.freepik.com/free-photo/construction-concept-with-engineering-tools_1150-17809.jpg?t=st=1737095907~exp=1737099507~hmac=be78b1487ea944f09d602ce250908264df9e49a4d5a3a896d0c3a30c90a908c3&w=900',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          height: 200,
          child: CarouselView(
            itemExtent: 400,
            shrinkExtent: 200,
            // reverse: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            children: List<Widget>.generate(imageUrls.length, (int index) {
              return ImageCard(imageUrl: imageUrls[index]);
            }),
          ),
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('Image failed to load'));
          },
        ),
      ),
    );
  }
}
