import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:test_oauth2/widgets/my_stretchable_button.dart';

class GitHubCard extends StatefulWidget {
  @override
  State<GitHubCard> createState() => _GitHubCardState();
}

class _GitHubCardState extends State<GitHubCard> {
  final double defaultBorderRadius = 3.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 400,
        height: 300,
        child: Card(
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStretchableButton(
                  buttonColor: Color(0xFF000000),
                  borderRadius: defaultBorderRadius,
                  onPressed: () => BlocProvider.of<LoginBloc>(context).add(
                    EventLoginButtonPress(),
                  ),
                  centered: false,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 38.0, // 40dp - 2*1dp border
                        width: 38.0, // matches above
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.github,
                            size: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.0 /* 24.0 - 10dp padding */),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                      child: Text(
                        "Conectar a GitHub",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
