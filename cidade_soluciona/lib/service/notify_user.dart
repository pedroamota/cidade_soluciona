import 'package:flutter/material.dart';

import '../components/components_style.dart';

class NotifyUser {
  static showScackbar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  static showPopUp(context, message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          title: Text(
            message,
            style: ComponentsStyle.text,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: const Color.fromARGB(255, 239, 7, 96),
                width: MediaQuery.of(context).size.height * .4,
                height: 5,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Ok',
                  style: ComponentsStyle.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
