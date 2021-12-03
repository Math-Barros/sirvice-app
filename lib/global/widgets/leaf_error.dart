import 'package:flutter/material.dart';
import 'package:sirvice_app/localization/localization.dart';

class LeafError extends StatelessWidget {
  final Function reload;
  final dynamic args;

  LeafError(this.reload, [this.args]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/developer_activity.png'),
          SizedBox(height: 20),
          Text(Localization.of(context).getTranslatedValue('error_msg')),
          SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => (args == null) ? reload() : reload(args),
            icon: Icon(Icons.refresh_rounded),
            label:
                Text(Localization.of(context).getTranslatedValue('error_msg')),
          )
        ],
      ),
    );
  }
}
