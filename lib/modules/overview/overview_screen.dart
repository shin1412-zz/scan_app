import 'dart:io';

import 'package:contacts_app/modules/config/helper/constants.dart';
import 'package:contacts_app/modules/scan/scan_screen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/contacts-list.dart';
import 'model/contact_model.dart';

class OverviewScreen extends StatefulWidget {
  OverviewScreen({Key key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<ContactModel> contacts = [];
  List<ContactModel> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getImageFromSource(ImageSource source) async {
    PickedFile imagePicked =
        await ImagePicker().getImage(source: source, imageQuality: 50);

    setState(() {
      if (imagePicked != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ScanScreen(
                  image: File(imagePicked.path),
                )));
      }
    });
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromSource(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromSource(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.cancel),
                    title: new Text('Cancel'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange,
      Colors.pink,
      Colors.blue,
      Colors.red
    ];
    int colorIndex = 0;
    List<ContactModel> _contacts =
        (await ContactsService.getContacts()).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return new ContactModel(info: contact, color: baseColor);
    }).toList();
    setState(() {
      contacts = _contacts;
      contactsLoaded = true;
    });
  }

  filterContacts() {
    List<ContactModel> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.info.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.info.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist =
        ((isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && contacts.length > 0));
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 120,
          leading: Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: Text(
              'Contacts',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          backgroundColor: Constants.kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: BottomAppBar(
            color: Constants.kPrimaryColor,
            child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                )),
            elevation: 0),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: 'Search',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor)),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              contactsLoaded == true
                  ? // if the contacts have not been loaded yet
                  listItemsExist == true
                      ? // if we have contacts to show
                      ContactsList(
                          contacts:
                              isSearching == true ? contactsFiltered : contacts,
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            isSearching
                                ? 'No search results to show'
                                : 'No contacts exist',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ))
                  : Container(
                      // still loading contacts
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
