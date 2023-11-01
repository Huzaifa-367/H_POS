import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/phone.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../Authentication/login_form.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String buttonText = 'Next';

  List<Map<String, dynamic>> getSlider({required BuildContext context}) {
    List<Map<String, dynamic>> sliderList = [
      {
        "icon": 'images/onboard1.png',
        "title": lang.S.of(context).easyToUseThePos,
        "description": lang.S.of(context).easytheusedesciption,
      },
      {
        "icon": 'images/onboard2.png',
        "title": lang.S.of(context).choseYourFeature,
        "description": lang.S.of(context).choseyourfeatureDesciption,
      },
      {
        "icon": 'images/onboard3.png',
        "title": lang.S.of(context).allBusinessSolutions,
        "description": lang.S.of(context).allBusinessolutionDescrip,
      },
    ];
    return sliderList;
  }

  List<Map<String, dynamic>> sliderList = [];

  @override
  Widget build(BuildContext context) {
    sliderList = getSlider(context: context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () {
                const LoginForm(
                        //isEmailLogin: true,
                        )
                    .launch(context);
                // const SignInScreen().launch(context);
                // Navigator.pushNamed(context, '/signIn');
              },
              child: Text(
                lang.S.of(context).skip,
                style: GoogleFonts.jost(
                  fontSize: 20.0,
                  color: Constants.kMainColor,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            height: 550,
            width: context.width(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  itemCount: sliderList.length,
                  controller: pageController,
                  onPageChanged: (int index) =>
                      setState(() => currentIndexPage = index),
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(sliderList[index]['icon'],
                            fit: BoxFit.fill,
                            width: context.width() - 100,
                            height: context.width() - 100),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            sliderList[index]['title'].toString(),
                            style: GoogleFonts.jost(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // ignore: sized_box_for_whitespace
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            width: context.width(),
                            child: Text(
                              sliderList[index]['description'].toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: GoogleFonts.jost(
                                fontSize: 15.0,
                                color: kGreyTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          DotIndicator(
            currentDotSize: 25,
            dotSize: 6,
            pageController: pageController,
            pages: sliderList,
            indicatorColor: Constants.kMainColor,
            unselectedIndicatorColor: Colors.grey,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10),
            child: ButtonGlobal(
              iconWidget: null,
              buttontext: lang.S.of(context).next,
              iconColor: Colors.white,
              buttonDecoration: kButtonDecoration.copyWith(
                  color: Constants.kMainColor,
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              onPressed: () {
                setState(
                  () {
                    currentIndexPage < 2
                        ? pageController.nextPage(
                            duration: const Duration(microseconds: 1000),
                            curve: Curves.bounceInOut)
                        : const LoginForm(
                                //isEmailLogin: true,
                                )
                            .launch(context);
                    // : const SignInScreen().launch(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
