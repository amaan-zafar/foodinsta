import 'package:flutter/material.dart';
import 'package:food_insta/components/custom_app_bar.dart';
import 'package:food_insta/components/custom_icon_button.dart';
import 'package:food_insta/components/custom_card.dart';
import 'package:food_insta/components/rating_indicator.dart';
import 'package:food_insta/components/user_type_label.dart';
import 'package:food_insta/models/dark_theme_provder.dart';
import 'package:food_insta/screens/root_app/settings_page.dart';
import 'package:food_insta/theme.dart';
import 'package:food_insta/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _selectCity = false;

  final String apiUrl = "https://randomuser.me/api/?results=10";

  List<dynamic> _users = [];

  void fetchUsers() async {
    var result = await http
        .get(Uri.parse(apiUrl), headers: {"Accept": "application/json"});
    setState(() {
      _users = json.decode(result.body)['results'];
    });
  }

  String _name(dynamic user) {
    return user['name']['first'];
  }

  String _location(dynamic user) {
    return user['location']['country'];
  }

  String _age(Map<dynamic, dynamic> user) {
    return "Age: " + user['dob']['age'].toString();
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  String city = 'Patna';
  List<String> cities = ['Patna', 'Delhi', 'Patiala', 'Agra'];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar
        buildAppBar(context),
        buildCitySelector(),
        // Body
        buildBody(),
      ],
    );
  }

  buildAppBar(BuildContext context) {
    var darkThemeProvider = Provider.of<DarkThemeProvider>(context);

    return CustomAppBar(
      actions: [
        MaterialButton(
          elevation: 0.0,
          color: darkThemeProvider.darkTheme ? Styles.black2 : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onPressed: () {
            setState(() {
              _selectCity = true;
            });
          },
          child: Row(
            children: [
              Icon(
                Icons.place_rounded,
                color: Styles.iconColor,
              ),
              SizedBox(width: 4),
              Text(
                city,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Styles.iconColor),
              )
            ],
          ),
        ),
        SizedBox(width: 10),
        CustomIconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SettingsPage()));
          },
          icon: Icon(
            Icons.settings,
            color: Styles.iconColor,
          ),
        ),
      ],
    );
  }

  buildCitySelector() {
    return Visibility(
      visible: _selectCity,
      child: SizedBox(
        height: 74,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: DropdownButton<String>(
              underline: Container(),
              hint: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(city, style: Theme.of(context).textTheme.bodyText1),
              ),
              isExpanded: true,
              elevation: 0,

              // itemHeight: 56,
              // value: 'Patna',
              onChanged: (value) {
                setState(() {
                  print(value);
                  city = value;
                  _selectCity = false;
                });
              },
              items: cities.map((String value) {
                print('hi $value');
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  buildBody() {
    return Expanded(
      child: _users.length != 0
          ? RefreshIndicator(
              onRefresh: _getData,
              child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: CustomAppCard(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      _users[index]['picture']['medium']),
                                ),
                                title: Text(_name(_users[index])),
                                subtitle: Text(_location(_users[index])),
                                trailing: Column(
                                  children: [
                                    RatingIndicator(
                                      itemSize: 16,
                                      rating: 4.5,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    UserTypeLabel(
                                      label: 'Business',
                                    ),
                                  ],
                                ),
                              )),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.black,
                              child: Image.network(
                                _users[index]['picture']['large'],
                                fit: BoxFit.cover,
                              ),
                              height: 220,
                              width: double.infinity,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(MdiIcons.weight, color: Styles.iconColor),
                              SizedBox(width: 4),
                              Text(
                                '50kg',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                              ),
                              Spacer(),
                              MaterialButton(
                                color: Color(0xFFF54580),
                                highlightColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.accountGroup,
                                        color: Colors.white),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 8, 0),
                                      child: Text('36',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 13)),
                                    ),
                                    Text(
                                      'Request',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              'ajfdoiajoisdjfoiakjdjfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkjkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
