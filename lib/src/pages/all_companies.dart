import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/services/store.dart';
import 'package:newsport/src/utils/utils.dart';


class AllCompaniesPage extends StatefulWidget {
  @override
  _AllCompaniesPageState createState() => _AllCompaniesPageState();
}

class _AllCompaniesPageState extends State<AllCompaniesPage> {


  //  navigateToCompany(DocumentSnapshot ds) {
  //   print(ds.data);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CompanyPage(
  //       ds: ds,
  //   )));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243,246,252, 1.0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color.fromRGBO(243,246,252, 1.0),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: myTheme.primaryColor,
          icon: Icon(Feather.x, color: Colors.grey), 
          onPressed: () => Navigator.pop(context)
        ),
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            icon: Icon(Feather.search, color:  Colors.grey,), 
            onPressed: () => showSearch(
              context: context, 
              delegate: DataSearch()
            )
          )
        ],
      ),
      body: getCompanies(context),
    );
  }
}