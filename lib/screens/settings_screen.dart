import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:super_knowledge/common/user_model.dart';
import 'package:super_knowledge/utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void logout(BuildContext context) {
    Alert(
      closeFunction: () => print('cancel exit.'),
      context: context,
      type: AlertType.warning,
      title: "LOGOUT",
      desc: "Are you sure?",
      buttons: [
        DialogButton(
          child: Text(
            "COMMIT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Settings',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "ACCOUNT",
              style: headerStyle,
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('SK'),
                    ),
                    title: Text(UserModel.username),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    activeColor: mainColor,
                    value: false,
                    title: Text("Auto Login"),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
//            Text(
//              "PUSH NOTIFICATIONS",
//              style: headerStyle,
//            ),
//            Card(
//              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
//              child: Column(
//                children: <Widget>[
//                  SwitchListTile(
//                    activeColor: mainColor,
//                    value: true,
//                    title: Text("Received notification"),
//                    onChanged: (val) {},
//                  ),
//                  _buildDivider(),
//                  SwitchListTile(
//                    activeColor: mainColor,
//                    value: false,
//                    title: Text("Received newsletter"),
//                    onChanged: null,
//                  ),
//                  _buildDivider(),
//                  SwitchListTile(
//                    activeColor: mainColor,
//                    value: true,
//                    title: Text("Received Offer Notification"),
//                    onChanged: (val) {},
//                  ),
//                  _buildDivider(),
//                  SwitchListTile(
//                    activeColor: mainColor,
//                    value: true,
//                    title: Text("Received App Updates"),
//                    onChanged: null,
//                  ),
//                ],
//              ),
//            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: ()=>logout(context),
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
