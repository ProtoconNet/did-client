import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:wallet/view/create_wallet.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.offAll(CreateWallet());
  }

  Widget _buildFullScreenImage() {
    return Image.asset(
      'assets/introduction/fullscreen.jpeg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/introduction/$assetName', width: width);
  }

  Widget _buildIcon(String assetName, [double width = 350]) {
    return Image.asset('assets/introduction/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(fontSize: 19.0);

    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Get.theme.backgroundColor,
      // pageColor: Get.theme.backgroundColor,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
            child: _buildIcon('SIT_logo_cube_colored.png', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "DID introduction",
          body: "DID는 당신의 생활을 더 안전하고 편하게 만들어줍니다.",
          image: _buildImage('img1.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "DID를 사용해보세요",
          body: "DID를 사용하면 당신의 정보를 아무데나 주지 않아도 된답니다!",
          image: _buildImage('img2.webp'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "쉬운 사용법",
          body: "누구나 사용할 수 있는 DID를 제공해 드립니다.",
          image: _buildImage('img3.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Mitum과 함께",
          body: "최고의 블록체인 Mitum과 함께 DID를 사용하세요. 순수 국내 기술로 개발된 Mitum 블록체인은 당신의 신원을 보호해줍니다.",
          image: _buildFullScreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Wiggler",
          body: "최고의 블록체인 전문가가 만드는 DID",
          image: _buildImage('img2.webp'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: Text(
              '설명 다시 보기',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "이제 DID를 시작해보세요",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('img1.jpeg'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: Text('Skip'),
      next: Icon(Icons.arrow_forward),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: EdgeInsets.all(16),
      controlsPadding: kIsWeb ? EdgeInsets.all(12.0) : EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
