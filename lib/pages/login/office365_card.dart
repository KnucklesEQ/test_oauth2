import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:test_oauth2/widgets/my_generic_loading_indicator.dart';
import 'package:test_oauth2/widgets/my_stretchable_button.dart';

class Office365Card extends StatefulWidget {
  @override
  State<Office365Card> createState() => _Office365CardState();
}

class _Office365CardState extends State<Office365Card> {
  final double defaultBorderRadius = 3.0;
  bool isLoading = false;

  String url = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state is LoginStateStartLoadingOffice365) {
          isLoading = true;
          return;
        }

        if (state is LoginStateEndLoadingOffice365) {
          isLoading = false;
          return;
        }

        if (state is LoginStateURL) {
          url = state.url;
          return;
        }
      },
      builder: (BuildContext context, LoginState state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 430,
            height: 300,
            child: Card(
              elevation: 10,
              color: Colors.white,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyStretchableButton(
                          buttonColor: Color(0xFFDC3E15),
                          borderRadius: defaultBorderRadius,
                          onPressed: () =>
                              BlocProvider.of<LoginBloc>(context).add(
                            EventLoginOffice365ButtonPress(),
                          ),
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewXPage(url: url),
                            ),
                          ),*/
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
                                    FontAwesomeIcons.microsoft,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.0 /* 24.0 - 10dp padding */),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                              child: Text(
                                "Conectar a Office 365",
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
                  Visibility(
                    visible: isLoading,
                    child: MyGenericLoadingIndicator(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
