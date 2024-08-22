
import 'package:benchmark_estimate/view/splash/splash_services.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices services = SplashServices();


  // bool _rememberMe = false;
  // Future<void> _getRememberMe() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool rememberMe = prefs.getBool('rememberMe') ?? false;
  //   setState(() {
  //     _rememberMe = rememberMe;
  //   });
  //   if (rememberMe) {
  //     String? sessionToken = prefs.getString('sessionToken');
  //     if (sessionToken != null) {
  //       try {
  //         await auth.signInWithCustomToken(sessionToken);
  //         Navigator.pushNamed(
  //           context,
  //           RouteName.navBar,
  //
  //         );
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //     else{
  //       Navigator.pushNamed(context, RouteName.login);
  //     }
  //   }
  // }

  // SplashServices services = SplashServices();
  // void getRememberMe()async{
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   bool? rememberMe = sp.getBool('rememberMe');
  //   if (rememberMe != true){
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavigationBarH(name: ' ', image: ' ',)));
  //   }
  //   else{
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginView()));
  //
  //   }
  //
  // }
  @override
  void initState() {
    services.isLogin(context);
    // Timer(Duration(seconds: 3), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
    //
    // });
//   getRememberMe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child:Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: SvgPicture.asset(logo),
              ),
              const Text('Benchmark Estimate', style:
              // GoogleFonts.
              TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: whiteColor,
                fontFamily: 'Sansita'
              ),
        )
            ],
          ),
        ),
      ),
    );
  }
}
