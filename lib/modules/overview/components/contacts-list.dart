import 'package:contacts_app/modules/overview/model/contact_model.dart';
import 'package:flutter/material.dart';

import 'contact-avatar.dart';

class ContactsList extends StatelessWidget {
  final List<ContactModel> contacts;

  ContactsList({Key key, this.contacts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          ContactModel contact = contacts[index];

          return ListTile(
              title: Text(contact.info.displayName),
              subtitle: Text(contact.info.phones.length > 0
                  ? contact.info.phones.elementAt(0).value
                  : ''),
              leading: ContactAvatar(contact, 36));
        },
      ),
    );
  }
}
