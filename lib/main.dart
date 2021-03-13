import 'package:flutter_web_psychotest/routes/routes.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login/loginPage.dart';
import 'services/mysql.dart';
import 'styles/string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Parse().initialize(
    parseAppId,
    parseAppUrl,
    masterKey: masterKey,
    autoSendSessionId: true,
    debug: true,
    coreStore: await CoreStoreSharedPrefsImp.getInstance(),
  );
  // Firebase initialize for build mobile app
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

// email login test : admin@mail.com
// password : admin123

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogedin;

  // Future getValidationData() async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   var obtainLogin = pref.getBool('isLogedin');
  //   setState(() {
  //     isLogedin = obtainLogin;
  //   });
  //   print('isLogedin getValidationData : $isLogedin');
  // }

  @override
  void initState() {
    // TODO: implement initState
    //   getValidationData().whenComplete(() async {
    //   setState(() {
    //     isLogedin = true;
    //   });
    //   print('isLogedin initstate getvalidation whencomplete : $isLogedin');
    //   isLogedin == true
    //       ? Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) => HomePage(
    //               user: user,
    //               username: username,
    //               loginSession: loginSession,
    //             ),
    //           ),
    //         )
    //       : LoginPage();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // materialApp with ResponsiveWrapper and Routes from responsive framework library
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1920,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        background: Container(
          color: Color(0xFFF5F5F5),
        ),
      ),
      // home: MailtoExampleApp(),
      initialRoute: Routes.home,
      onGenerateRoute: (RouteSettings settings) {
        // route app with fadethrough from responsive framework library
        return Routes.fadeThrough(
          settings,
          (context) {
            switch (settings.name) {
              case Routes.home:
                //
                return LoginPage();
                break;
              default:
                return null;
                break;
            }
          },
        );
      },
      theme: Theme.of(context).copyWith(platform: TargetPlatform.windows),
      debugShowCheckedModeBanner: false,
    );
  }
}
