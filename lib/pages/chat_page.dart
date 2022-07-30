import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../model/advert_menu_item.dart';
import '../model/room.dart';
import '../model/message.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/report_button.dart';
import '../widgets/user_logo.dart';
import 'advert_page.dart';

class ChatPage extends StatefulWidget {
  static String routeName = '/chat';
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> _submit(AppLocalizations appLocalizations, AppService appService,
      Room room) async {
    final text = _msgController.text;

    if (text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final message = Message(
        id: '',
        roomId: room.id,
        content: text,
        userFrom: getCurrentUserId(),
        userTo: getCurrentUserId() == room.userTo ? room.userFrom : room.userTo,
        createdAt: DateTime.now(),
      );

      final response = await appService.sendMessage(message, room.advertName);
      final error = response.error;
      if (response.hasError) {
        if (!mounted) return;
        context.showErrorSnackBar(message: error!.message);
      }
    }

    _msgController.text = '';
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appService = context.read<AppService>();
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;
    final room = ModalRoute.of(context)!.settings.arguments as Room;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            UserLogo(userId: room.userFrom),
            const SizedBox(width: 5.0),
            Text(
              room.advertName.characters.take(10).toString(),
            ),
          ],
        ),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () => navigatorKey.currentState!.pushNamed(
                AdvertPage.routeName,
                arguments: AdvertMenuItem(
                    id: room.advertId,
                    name: room.advertName,
                    description: '',
                    createdAt: DateTime.now(),
                    createdBy: room.userTo)),
            icon: const Icon(Icons.open_in_new),
          )
        ],
      ),
      body: StreamBuilder<List<Message>>(
        stream: appService.getMessages(room.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.hasData) {
            final messages = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ReportButton(
                        advertId: room.id,
                        roomId: room.id,
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: messages == null
                          ? const SizedBox()
                          : ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];

                                return ChatBubble(
                                  message: message,
                                );
                              },
                            ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _msgController,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: RequiredValidator(
                              errorText: appLocalization.description_required),
                          maxLines: 5,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: appLocalization.message,
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _submit(appLocalization, appService, room),
                              icon: const Icon(Icons.send_rounded,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
