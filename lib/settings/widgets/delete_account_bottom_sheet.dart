import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sirvice_app/authentication/authentication_provider.dart';
import 'package:sirvice_app/global/utils.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'package:sirvice_app/notifications/notification_provider.dart';
import 'package:sirvice_app/presence/presence_provider.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  @override
  _DeleteAccountBottomSheetState createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  var _password = '';

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthenticationProvider>().isLoading;
    final loc = Localization.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              size: 50,
              color: Theme.of(context).errorColor,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(16),
              child: Text(
                'By permanently deleting your account all data will be removed and can not be restored. Only delete your account if you are sure you wont need the data stored later!',
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  _password = val;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: (_password.isEmpty || isLoading)
                  ? null
                  : () async => onPressHandler(
                      context: context,
                      action: () async {
                        // unsubscribe from all topics
                        await context
                            .read<NotificationProvider>()
                            .unsubscribeFromAllTopics();
                        // remove presence
                        await context.read<PresenceProvider>().removePresence();
                        return context
                            .read<AuthenticationProvider>()
                            .deleteUser(_password);
                      },
                      popScreenAfter: true,
                      errorMessage:
                          'Error occured while trying to delete account',
                      successMessage: 'Successfully deleted account'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text(loc.getTranslatedValue('delete_account_btn_text')),
            ),
          ],
        ),
      ),
    );
  }
}
