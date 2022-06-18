import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/advert_menu_item.dart';
import '../model/advert_page_view.dart';
import '../model/image_data.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/image_dialog.dart';
import 'edit_page.dart';

class AdvertPage extends StatefulWidget {
  static String routeName = '/advert';
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  bool _hasCallSupport = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final advertMenuItem =
        ModalRoute.of(context)!.settings.arguments as AdvertMenuItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(advertMenuItem.name),
      ),
      body: FutureBuilder<AdvertPageView>(
          future:
              context.read<AppService>().getAdvertPageView(advertMenuItem.id),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final advert = snapshot.data as AdvertPageView;
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  if (advert.createdBy == getCurrentUserId())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(EditPage.routeName,
                                  arguments: advert),
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  FutureBuilder<Uint8List?>(
                      future: context
                          .read<AppService>()
                          .getMainImage(advert.id, advert.createdBy),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.memory(
                                (snapshot.data as Uint8List),
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.cover,
                              ),
                            ],
                          );
                        }
                        return const Text('Loading');
                      }),
                  Text(advert.categoryName),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      advert.name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(timeago.format(advert.createdAt)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      advert.description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('${advert.cityName} \\ ${advert.address}'),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: !_hasCallSupport
                            ? () => setState(() {
                                  _makePhoneCall(
                                      '${advert.phoneCode}${advert.phone}');
                                })
                            : null,
                        child: Text('${advert.phoneCode} ${advert.phone}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FutureBuilder<List<ImageData>>(
                      future: context
                          .read<AppService>()
                          .getImages(advert.id, advert.createdBy),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return Wrap(
                            children: [
                              ...snapshot.data!.map((imageData) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) =>
                                                ImageDialog(imageData.image));
                                      },
                                      child: Image.memory(
                                        imageData.image,
                                        width: 45.w,
                                        height: 45.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }
                        return const Text('Loading');
                      }),
                  const SizedBox(height: 30),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
