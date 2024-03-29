import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/advert_menu_item.dart';
import '../model/advert_page_view.dart';
import '../model/image_data.dart';
import '../model/room.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../utils/page_not_found_exception.dart';
import '../widgets/image_dialog.dart';
import '../widgets/report_button.dart';
import 'chat_page.dart';
import 'edit_page.dart';
import 'login_page.dart';
import 'room_page.dart';
import 'verify_email_page.dart';

class AdvertPage extends StatefulWidget {
  static String routeName = '/advert';
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  //bool _hasCallSupport = false;
  bool _isLoading = false;

  Future<AdvertPageView?> _getAdvertPageView(
      BuildContext context, AppLocalizations appLocalization, String id) async {
    try {
      return await context.read<AppService>().getAdvertPageView(id);
    } on PageNotFoundException {
      context.showErrorSnackBar(message: appLocalization.page_not_found);
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);
    }

    return null;
  }

  Future<bool> _getStatusUnReadMessages(BuildContext context) async {
    try {
      return await context
              .read<AppService>()
              .getCountUnreadMessages(getCurrentUserId()) >
          0;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> _openChat(BuildContext context, AppLocalizations appLocalization,
      AdvertMenuItem advert) async {
    if (isUnauthenticated()) {
      navigatorKey.currentState!.pushNamed(LoginPage.routeName);
      return;
    }

    if (isAuthenticated() && isEmail() == false) {
      navigatorKey.currentState!.pushNamed(VerifyEmailPage.routeName);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final appService = context.read<AppService>();

    try {
      final response =
          await appService.getRoomByAdvert(advert.id, getCurrentUserId());

      final error = response.error;
      if (response.hasError) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error!.message);
      }

      setState(() {
        _isLoading = false;
      });

      if (response.data == null || (response.data as List<dynamic>).isEmpty) {
        final newRoomResponse = await appService.createRoom(Room(
            id: '',
            advertName: advert.name,
            advertId: advert.id,
            userFrom: getCurrentUserId(),
            userTo: advert.createdBy,
            createdAt: DateTime.now()));

        if (newRoomResponse.hasError) {
          if (!mounted) return;
          context.showErrorSnackBar(message: newRoomResponse.error!.message);
          return;
        }

        if (!mounted) return;
        navigatorKey.currentState!.pushNamed(ChatPage.routeName,
            arguments: (newRoomResponse.data as List<dynamic>)
                .map((json) => Room.fromJson(json))
                .toList()
                .first);
      } else {
        if (!mounted) return;
        navigatorKey.currentState!.pushNamed(ChatPage.routeName,
            arguments: (response.data as List<dynamic>)
                .map((json) => Room.fromJson(json))
                .toList()
                .first);
      }
    } on Exception catch (_) {
      context.showErrorSnackBar(message: appLocalization.unexpected_error);

      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   await launchUrl(launchUri);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Check for phone call support.
  //   canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
  //     setState(() {
  //       _hasCallSupport = result;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final advertMenuItem =
        ModalRoute.of(context)!.settings.arguments as AdvertMenuItem;

    final appLocalization = AppLocalizations.of(context) as AppLocalizations;
    final Locale appLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(advertMenuItem.name),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        actions: [
          if (isAuthenticated() && isEmail() == true)
            FutureBuilder<bool>(
                future: _getStatusUnReadMessages(context),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return IconButton(
                      onPressed: () async {
                        await navigatorKey.currentState!
                            .pushNamed(RoomPage.routeName);

                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.notification_add,
                        color: Colors.red,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
        ],
      ),
      body: FutureBuilder<AdvertPageView?>(
          future:
              _getAdvertPageView(context, appLocalization, advertMenuItem.id),
          builder: (ctx, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final advert = snapshot.data as AdvertPageView;
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ReportButton(
                        advertId: advert.id,
                      ),
                      const SizedBox(width: 5.0),
                      if (advert.createdBy == getCurrentUserId())
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () => navigatorKey.currentState!
                              .pushReplacementNamed(EditPage.routeName,
                                  arguments: advert),
                          child: Text(appLocalization.edit),
                        ),
                    ],
                  ),
                  FutureBuilder<Uint8List?>(
                    future: context
                        .read<AppService>()
                        .getMainImage(advert.id, advert.createdBy),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: 50.w,
                          height: 50.w,
                          child: Center(
                            child: Text(appLocalization.loading),
                          ),
                        );
                      }

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
                      } else {
                        return SizedBox(
                          width: 50.w,
                          height: 50.w,
                        );
                      }
                    },
                  ),
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
                  Text(timeago.format(
                    advert.createdAt,
                    locale: appLocale.languageCode,
                  )),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     OutlinedButton(
                  //       onPressed: _hasCallSupport
                  //           ? () => _makePhoneCall(advert.phone)
                  //           : null,
                  //       child: Text(advert.phone),
                  //     ),
                  //   ],
                  // ),
                  if (advert.createdBy != getCurrentUserId())
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () => _isLoading
                            ? null
                            : _openChat(
                                context, appLocalization, advertMenuItem),
                        child: Text(appLocalization.write),
                      ),
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
                                        width: 40.w,
                                        height: 40.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        }
                        return Text(appLocalization.loading);
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
