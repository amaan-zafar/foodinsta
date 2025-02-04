import 'package:flutter/material.dart';
import 'package:food_insta/components/custom_app_bar.dart';
import 'package:food_insta/components/custom_background.dart';
import 'package:food_insta/components/custom_text_button.dart';
import 'package:food_insta/components/custom_card.dart';
import 'package:food_insta/controllers/ngo_list_controller.dart';
import 'package:food_insta/controllers/user_profile_controller.dart';
import 'package:food_insta/repository/ngo_list_repo.dart';
import 'package:food_insta/models/user.dart';
import 'package:food_insta/screens/auth/registeration_screen.dart';
import 'package:food_insta/theme.dart';
import 'package:provider/provider.dart';

class UserTypePage extends StatelessWidget {
  final String email;

  const UserTypePage({Key key, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  centerTitle: true,
                ),
                Consumer<UserProfileController>(
                    builder: (context, controller, child) {
                  if (controller.userTypeState == UserTypeState.Loading) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              12,
                              Styles.cardTopPadding,
                              12,
                              Styles.cardBottomPadding),
                          child: CustomAppCard(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 36, 24, 8),
                                child: Text(
                                  'Hello there! Together we can change this world, right?',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'Let’s get started by selecting the right kind of department you represent!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              _buildButton(context, 'I represent an NGO',
                                  UserType.NGO, controller),
                              SizedBox(height: 8),
                              _buildButton(context, 'I represent a Business',
                                  UserType.BUSINESS, controller),
                              SizedBox(height: 8),
                              _buildButton(context, 'I am Individual/Volunteer',
                                  UserType.INDIVIDUAL, controller),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buildButton(BuildContext context, String text, UserType userType,
      UserProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: CustomTextButton(
        color: Styles.buttonColor1,
        highlightColor: Colors.lightBlue,
        textOnButton: text,
        onPressed: () async {
          controller.setUserTypeState(UserTypeState.Loading);
          List<Ngo> ngoList = [];
          if (userType == UserType.INDIVIDUAL) {
            ngoList =
                await Provider.of<NgoListController>(context, listen: false)
                    .getNgoList();
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RegistrationForm(
                        ngoList: ngoList,
                        userType: userType,
                        email: email,
                      )));
          controller.setUserTypeState(UserTypeState.Loaded);
        },
      ),
    );
  }
}
