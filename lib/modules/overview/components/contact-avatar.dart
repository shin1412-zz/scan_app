import 'package:contacts_app/modules/overview/model/contact_model.dart';
import 'package:contacts_app/components/get-color-gradient.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  ContactAvatar(this.contact, this.size);
  final ContactModel contact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
        child: (contact.info.avatar != null && contact.info.avatar.length > 0)
            ? CircleAvatar(
                backgroundImage: MemoryImage(contact.info.avatar),
              )
            : CircleAvatar(
                child: Text(contact.info.initials(),
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.transparent));
  }
}
