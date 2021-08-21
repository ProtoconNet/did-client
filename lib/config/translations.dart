import 'package:flutter/material.dart';
import 'package:get/get.dart';

final languageModeList = {"system": Get.deviceLocale, "korean": Locale('ko', 'KR'), "english": Locale('en', 'US')};

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'logged_in': 'logged in as @name with email @email',
          'myCertificate': 'My Certificate',
          'scanQr': 'Scan QR',
          'settings': 'Settings',
          'noImage': 'No image selected.',
          'takePicture': 'Picture',
          'pickGallery': 'Gallery',
          'noAccount': 'There are no available DID. Please join us.',
          'createWallet': 'Create Wallet',
          'createAccount': 'Create New Account',
          'importAccount': 'Import Account',
          'inputPasswordMsg': 'Input password for access your wallet.',
          'inputPasswordHintMsg': 'Input password',
          'inputPasswordLabelMsg': 'Password',
          'inputPasswordErrorNotSame': 'Error: Password and confirm password have to same',
          'confirmPasswordMsg': 'Confirm password for access your wallet.',
          'confirmPasswordHintMsg': 'Confirm password',
          'confirmPasswordLabelMsg': 'Confirm',
          'submit': 'Submit',
          'account': 'Your new DID created',
          'goToHome': 'Start',
          'login': 'Login',
          'inputPassword': 'Please enter your password',
          'enter': 'Enter',
          'incorrectPasswordTitle': 'Incorrect Password',
          'incorrectPasswordContent': 'Please Input Correct Password',
          'issue': 'issue request',
          'ok': 'OK',
        },
        'ko_KR': {
          'hello': '안녕하세요',
          'logged_in': 'logged in as @name with email @email',
          'myCertificate': '인증서',
          'scanQr': 'QR 스캔',
          'settings': '설정',
          'noImage': '이미지가 선택되지 않았습니다.',
          'takePicture': '사진',
          'pickGallery': '갤러리',
          'noAccount': 'DID가 없습니다. Mitum DID에 가입하세요',
          'createWallet': '내 지갑 만들기',
          'createAccount': '새로운 DID 생성',
          'importAccount': 'DID Key 가져오기',
          'inputPasswordMsg': '비밀번호를 입력하세요',
          'inputPasswordHintMsg': '비밀번호 입력',
          'inputPasswordLabelMsg': '비밀번호',
          'inputPasswordErrorNotSame': 'Error: 두 비밀번호 입력이 서로 다릅니다.',
          'confirmPasswordMsg': '확인 비밀번호를 입력하세요',
          'confirmPasswordHintMsg': '확인 비밀번호',
          'confirmPasswordLabelMsg': '확인',
          'submit': '제출',
          'account': 'DID가 생성되었습니다.',
          'goToHome': '시작',
          'login': '로그인',
          'inputPassword': '비밀번호를 입력하세요',
          'enter': '제출',
          'incorrectPasswordTitle': '비밀번호가 틀렸습니다',
          'incorrectPasswordContent': '올바른 비밀번호를 입력해주세요',
          'issue': '발급 신청',
          'ok': '확인',
        }
      };
  // Text('logged_in'.trParams({
  //  'name': 'John',
  //  'email': 'john@example.com'
  //  }));
}
