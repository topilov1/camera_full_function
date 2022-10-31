import 'dart:io';

import 'package:camera_full_function/zoom.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  ImagePicker image = ImagePicker();
  String? newimage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            // imageni zoom va on tapda yaqin qilish
            child: GestureDetector(
              onTap: (() {
                showDialog(
                  context: context,
                  builder: (_) => const Info(link: 'assets/image.png'),
                );
              }),
              // defoltni image
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Image(
                  image: AssetImage("assets/image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // share image
          shareImage(context),

          // save image in url image
          Center(
            child: ElevatedButton(
              onPressed: (() async {
                _saveNetworkImage();
              }),
              child: const Text('Save'),
            ),
          ),
          Center(
            child: Container(
                color: Colors.grey,
                width: 200,
                height: 200,
                child: file == null
                    ? const Icon(Icons.image)
                    : Image.file(file!, fit: BoxFit.cover)
                // child: Text(),
                ),
          ),

          // galareyadan rasim yuklap iu ga qoyish
          Center(
            child: MaterialButton(
              onPressed: (() {
                getgall();
                rasimgaOLishVASaveQilish;
              }),
              color: Colors.red,
              child: const Text('from gallery'),
            ),
          ),

          // kamerada rasimga olip telefonga saqlamasdan rasmni ui ga qoyish
          Center(
            child: MaterialButton(
              onPressed: (() {
                getcam();
              }),
              color: Colors.green,
              child: const Text('from camera'),
            ),
          ),

          // Camera save gallery
          rasimgaOLishVASaveQilish(image, context),
        ],
      ),
    );
  }

  Widget shareImage(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () async {
          // api dan kegan url ni olish hozrgi api ay shu defoltni;
          final uri = Uri.parse(
              'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554__340.png');

          final respose = await http.get(uri);

          // ignore: use_build_context_synchronously
          final box = context.findRenderObject() as RenderBox?;

          // url nima qaytarishi yani bu urli tashlanganida unda numa bolsa shuni qaytaradi
          Share.share(
              "https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554__340.png",
              // subject ga olinhan rasimni urelni qoyamza
              subject:
                  "https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554__340.png",
              // kerak
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
        },
        icon: const Icon(Icons.share_rounded),
      ),
    );
  }

  Widget rasimgaOLishVASaveQilish(
    ImagePicker picker,
    BuildContext context,
  ) {
    return Center(
      child: Container(
        color: Colors.blueAccent,
        child: TextButton(
          onPressed: (() async {
            await picker.pickImage(source: ImageSource.camera)

                // XFile shu filedan rasimni olish  ----> recordedImage ga
                .then((XFile? recordedImage) {
              recordedImage!.path.toString;

              // path joylashgan joyi  saqlavoti
              GallerySaver.saveImage(recordedImage.path).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rasim Galareyaga saqlandi'),
                  ),
                );
              });
            });
          }),
          child: const Text(
            'rasimga olip galler ga sev qlish uchun',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  getcam() async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.camera);
    file = File(img!.path);
    setState(() {});
  }

  getgall() async {
    // ignore: deprecated_member_use
    var img = await image.getImage(source: ImageSource.gallery);
    file = File(img!.path);
    setState(() {});
  }

// save image
  void _saveNetworkImage() async {
    String path =
        'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        // pasdan save boldi dp yozuv chiqish uchun
        const SnackBar(
          content: Text('Rasim Galareyaga saqlandi'),
        ),
      );
    });
  }
}
