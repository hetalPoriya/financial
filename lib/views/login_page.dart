import 'dart:async';
import 'package:financial/utils/all_images.dart';

import 'local_notify_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storeCredential = GetStorage();
  bool showLoading = false;
  String? dropdownvalue = '+91';
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //for password visibility
  bool hidePassword = true;
  String? getToken;

  Timer? _timer;
  int _counter = 0;
  late StreamController<int> _events;

  void startTimer() {
    _counter = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer!.cancel();
      //});

      _events.add(_counter);
    });
  }

  getTokenForNotification() {
    _firebaseMessaging.getToken().then((deviceToken) {
      getToken = deviceToken;
      print('Device Token $deviceToken}');
    });
  }

  //function for user login
  Future<bool?> loginUser(String phone, BuildContext context) async {
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException exception) {
          setState(() {
            showLoading = false;
          });
          Fluttertoast.showToast(msg: exception.code.toString());
          Fluttertoast.showToast(msg: 'Please try later');
          Get.back();
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showLoading = false;
          Fluttertoast.showToast(msg: "Code send to your device");
          _codeSendDialog(phone, verificationId);
        },
        verificationCompleted: (AuthCredential credential) async {
          _verificationCompleted(credential);
          //This callback would gets called when verification is done automaticlly
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: "codeAutoRetrievalTimeout");
        },
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
    return null;
  }

  @override
  initState() {
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setNotificationClick(onNotificationClick);

    Future.delayed(Duration.zero, () {
      this.firebaseCloudMessagingListeners(context);
    });
  }

  onNotificationReceive(ReceiveNotification receiveNotification) {
    print('Notification Received: ${receiveNotification.id}');
  }

  onNotificationClick(String? payLoad) {
    print('playLoad: $payLoad');
  }

  firebaseCloudMessagingListeners(BuildContext context) {
    _firebaseMessaging.getToken().then((deviceToken) {
      getToken = deviceToken;
      print("Firebase Device token: $deviceToken");
    });
    _events = new StreamController<int>();
    _events.add(60);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     final PendingDynamicLinkData? data =
  //         await FirebaseDynamicLinks.instance.getInitialLink();
  //     if (data?.link != null) {
  //       handleLink(data!.link);
  //     }
  //     FirebaseDynamicLinks.instance.onLink(
  //         onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //       final Uri deepLink = dynamicLink!.link;
  //       handleLink(deepLink);
  //     }, onError: (OnLinkErrorException e) async {
  //     });
  //   }
  // }
  // void handleLink(Uri link) async {
  // if (link != null) {
  //   final User? user = (await _auth.signInWithEmailLink(
  //     email: _emailController.text,
  //     emailLink: link.toString(),
  //   )).user;
  //   try {
  //     _login(user);
  //   } on FirebaseAuthException catch (e) {
  //     Fluttertoast.showToast(msg: e.message.toString());
  //   }
  // } else {
  //   setState(() {
  //     // _success = false;
  //   });
  // }
  // setState(() {});
  // }
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          handleLink(deepLink, _emailController.text);
          FirebaseDynamicLinks.instance.onLink(
              onSuccess: (PendingDynamicLinkData? dynamicLink) async {
            final Uri? deepLink = dynamicLink!.link;
            handleLink(deepLink!, _emailController.text);
          }, onError: (OnLinkErrorException e) async {
            print(e.message);
          });
          // Navigator.pushNamed(context, deepLink.path);
        }
      }, onError: (OnLinkErrorException e) async {
        print(e.message);
      });
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      if (deepLink != null) {
        print(deepLink.userInfo);
      }
    } catch (e) {
      print(e);
    }
  }

  void handleLink(Uri link, userEmail) async {
    if (link != null) {
      final UserCredential user =
          await FirebaseAuth.instance.signInWithEmailLink(
        email: _emailController.text,
        emailLink: link.toString(),
      );
      try {
        _login(user.user);
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.message.toString());
      }
    } else {}
  }

  _mailSendDialog() {
    Get.defaultDialog(
      //barrierDismissible: false,
      // onWillPop: () {
      //   return Future.value(false);
      // },
      title: '',
      backgroundColor: AllColors.purple,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 15.h,
              child: Image.asset(AllImages.sendMail),
            ),
            Text(
              'Check your email!',
              style: AllTextStyles.dialogStyleExtraLarge(
                  size: 22.sp, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 80.w,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Text(
                  'The login link has been sent to your email address',
                  textAlign: TextAlign.center,
                  style: AllTextStyles.dialogStyleMedium(),
                ),
              ),
            ),
            Container(
              width: 80.w,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Text(
                  _emailController.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(2.w),
    );
  }

  Future<void> _signInWithEmailAndLink() async {
    return await FirebaseAuth.instance
        .sendSignInLinkToEmail(
            email: _emailController.text,
            actionCodeSettings: ActionCodeSettings(
              url: 'https://finshark.page.link/finsharkApp',
              handleCodeInApp: true,
              androidPackageName: 'com.finshark',
              androidMinimumVersion: "1",
            ))
        .then((value) => _mailSendDialog());
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _verificationCompleted(credential);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _codeSendDialog(String phone, String verificationId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext bContext) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.all(2.w),
            title: Image.asset(
              AllImages.otpImage,
              height: 8.h,
              fit: BoxFit.contain,
            ),
            elevation: 2.0,
            backgroundColor: AllColors.purple,
            content: StreamBuilder<int>(
              stream: _events.stream,
              builder: (context, snapshot) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'OTP Verification',
                        style: AllTextStyles.dialogStyleExtraLarge(
                            size: 22.sp, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Enter the OTP send to \n${dropdownvalue.toString() + '  ' + _phoneController.text}',
                        textAlign: TextAlign.center,
                        style: AllTextStyles.dialogStyleMedium(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        width: 40.w,
                        child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            obscureText: true,
                            obscuringCharacter: '*',
                            //controller: _codeController,
                            blinkWhenObscuring: true,
                            textStyle: AllTextStyles.dialogStyleSmall(),
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              inactiveColor: Colors.white,
                              activeColor: Colors.white,
                            ),
                            //  controller: _codeController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _codeController.text = value;
                            }),
                      ),
                      snapshot.data.toString() == '0'
                          ? TextButton(
                              child: Text('Resend OTP',
                                  style: AllTextStyles.dialogStyleMedium(
                                      fontWeight: FontWeight.w700)),
                              onPressed: () {
                                setState(() {
                                  _events.add(60);
                                  startTimer();
                                });
                                _auth.verifyPhoneNumber(
                                  phoneNumber: phone,
                                  timeout: Duration(seconds: 60),
                                  verificationFailed:
                                      (FirebaseAuthException exception) {
                                    setState(() {
                                      showLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: exception.code.toString());
                                    Fluttertoast.showToast(
                                        msg: 'Please try later');
                                    Get.back();
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  },
                                  codeSent: (String verificationId,
                                      [int? forceResendingToken]) {},
                                  verificationCompleted:
                                      (AuthCredential credential) async {
                                    _verificationCompleted(credential);
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    Fluttertoast.showToast(
                                        msg: "codeAutoRetrievalTimeout");
                                  },
                                );
                              },
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AllImages.clockImage,
                                  height: 6.h,
                                  width: 6.w,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  snapshot.data.toString(),
                                  style: AllTextStyles.dialogStyleSmall(),
                                ),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 2.h, top: 2.h),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      // PhoneAuthCredential? authCredential;
                      try {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: code,
                        );
                        _verificationCompleted(credential);
                      } catch (e) {
                        // Fluttertoast.showToast(msg: e.toString());
                        Fluttertoast.showToast(msg: 'Please enter valid OTP');
                      }
                    },
                    child: Container(
                      height: 6.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          color: Colors.white),
                      child: Center(
                        child: Text('VERIFY',
                            style: AllTextStyles.dialogStyleLarge(
                              size: 16.sp,
                              color: Color(0XFF6448E8),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _verificationCompleted(AuthCredential credential) async {
    setState(() {
      _timer?.cancel();
    });
    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;
    _login(user);
  }

  _login(User? user) async {
    if (user != null) {
      Fluttertoast.showToast(msg: 'Verification Completed');
      Fluttertoast.showToast(msg: 'You are Logged In successfully');

      storeCredential.write('uId', user.uid);
      storeCredential.write('update', 0);
      storeCredential.write('level4or5innerPageViewId', 0);
      storeCredential.write('showCase', false);
      storeCredential.write('showCaseId', 0);
      CollectionReference users = FirebaseFirestore.instance.collection("User");
      users
          .doc(user.uid)
          .set({
            'credit_card_bill': 0,
            'payable_bill': 0,
            'credit_card_balance': 0,
            'level_id': 0,
            'bill_payment': 0,
            'credit_score': 0,
            'game_score': 0,
            if (user.phoneNumber != null) 'mobile_number': user.phoneNumber,
            if (user.email != null) 'mobile_number': user.email,
            'investment': 0,
            'previous_session_info': 'Level_1_setUp_page',
            'quality_of_life': 0,
            'account_balance': 0,
            'score': 0,
            'replay_level': false,
            'last_level': 'Level_1_setUp_page',
            'need': 0,
            'want': 0,
            'level_1_id': 0,
            'level_2_id': 0,
            'level_3_id': 0,
            'level_4_id': 0,
            'level_5_id': 0,
            'level_6_id': 0,
            'level_1_popQuiz_id': 0,
            'level_2_popQuiz_id': 0,
            'level_3_popQuiz_id': 0,
            'level_4_popQuiz_id': 0,
            'level_5_popQuiz_id': 0,
            'level_6_popQuiz_id': 0,
            'home_loan': 0,
            'transport_loan': 0,
            'mutual_fund': 0,
            'level_1_balance': 0,
            'level_2_balance': 0,
            'level_3_balance': 0,
            'level_4_balance': 0,
            'level_5_balance': 0,
            'level_6_balance': 0,
            'level_1_qol': 0,
            'level_2_qol': 0,
            'level_3_qol': 0,
            'level_4_qol': 0,
            'level_5_qol': 0,
            'level_6_qol': 0,
            'level_4_investment': 0,
            'level_5_investment': 0,
            'level_3_creditScore': 0,
            'user_name': '',
            'device_token': getToken
          })
          .then((value) => print('add'))
          .catchError((error) => print('$error'));

      Get.back();

      await localNotifyManager.configureLocalTimeZone();
      print('Called1');
      await localNotifyManager.scheduleNotificationForLevelOneSaturdayElevenAm();
      print('Called2');
      await localNotifyManager.scheduleNotificationForLevelOneWednesdaySevenPm();
      print('Called3');

     // await localNotifyManager.repeatNotificationLevel1();

      Get.offAllNamed('/Level1SetUp');
    } else {
      Fluttertoast.showToast(msg: "Failed to login");
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    // this.phoneNumber =  countryCode.toString();
    setState(() {
      dropdownvalue = countryCode.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: GradientText(
                    text: 'finshark',
                    style: AllTextStyles.dialogStyleExtraLarge(size: 30.sp),
                    gradient: LinearGradient(
                      colors: [
                        AllColors.login1,
                        AllColors.login2,
                        AllColors.login3,
                        AllColors.login4,
                        AllColors.login5,
                      ],
                    )),
              ),
              Container(
                child: Image.asset(
                  AllImages.login,
                  fit: BoxFit.contain,
                ),
                height: 43.h,
                width: 100.w,
              ),
              Center(
                  child: Text(
                'SIGN UP / LOGIN',
                style: AllTextStyles.dialogStyleExtraLarge(
                  fontWeight: FontWeight.w600,
                  color: AllColors.darkPurple,
                ),
              )),
              SizedBox(
                height: 2.h,
              ),
              GestureDetector(
                onTap: () {
                  GoogleSignIn().signOut().then((value) => signInWithGoogle());
                },
                child: Container(
                    width: 84.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              AllColors.blue,
                              AllColors.purple,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(2.w)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Row(
                        children: [
                          Image.asset(AllImages.googleImage,
                              fit: BoxFit.contain, height: 3.h),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            'Continue With Google',
                            style: AllTextStyles.dialogStyleSmall(),
                          )
                        ],
                      ),
                    )),
              ),

              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 26.w,
                      child: CountryCodePicker(
                        onChanged: _onCountryChange,
                        showCountryOnly: false,
                        initialSelection: 'IN',
                        // hideMainText: true,
                        favorite: ['+91', 'IN'],
                        showFlagMain: true,
                        textStyle: AllTextStyles.dialogStyleSmall(
                          color: AllColors.lightGrey,
                        ),
                        dialogSize: Size(80.w, 80.h),
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: AllColors.lightBlue2),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Container(
                      width: 56.w,
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 1.h),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                                borderSide:
                                    BorderSide(color: AllColors.lightBlue2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                                borderSide:
                                    BorderSide(color: AllColors.lightBlue2)),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: AllTextStyles.dialogStyleSmall(
                                color: AllColors.lightGrey, size: 13.sp),
                            hintText: " Enter phone number"),
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
                child: Center(
                    child: Text('OR',
                        style: AllTextStyles.dialogStyleSmall(
                          color: AllColors.lightGrey,
                        ))),
              ),
              Container(
                width: 84.w,
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 0.w),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.w)),
                          borderSide: BorderSide(color: AllColors.lightBlue2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.w)),
                          borderSide: BorderSide(color: AllColors.lightBlue)),
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: AllTextStyles.dialogStyleSmall(
                        size: 13.sp,
                        color: Colors.grey,
                      ),
                      hintText: "  Sign up with email",
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Image.asset(
                          AllImages.mailImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 2.w,
                        maxHeight: 3.h,
                      )),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'We need this information to create your account.',
                style: AllTextStyles.dialogStyleSmall(
                  fontWeight: FontWeight.w400,
                  size: 10.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              //  Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () async {
                     // await localNotifyManager.configureLocalTimeZone();
                     // await localNotifyManager.scheduleNotificationForLevelOneSaturdayElevenAm();
                     // await localNotifyManager.scheduleNotificationForLevelOneWednesdaySevenPm();

                     //await localNotifyManager.repeatNotificationLevel1();
                    // String pattern = r'^([0-9]{10})$';
                    String patternEmail =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    if (_phoneController.text.isEmpty &&
                        _emailController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please enter your phone number or email');
                    } else {
                      if (_phoneController.text.isNotEmpty &&
                          _emailController.text.isEmpty) {
                        if (dropdownvalue!.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select your country code');
                          return null;
                        }
                        if (_phoneController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter your phone number');
                          return null;
                        }
                        // else {
                        //   RegExp regExp = RegExp(pattern);
                        //   if (!regExp.hasMatch(_phoneController.text)) {
                        //     Fluttertoast.showToast(
                        //         msg: 'Please enter valid  phone number');
                        //     return null;
                        //   }
                        // }
                        if (dropdownvalue!.isNotEmpty &&
                            _phoneController.text.isNotEmpty) {
                          showLoading = true;
                          if (showLoading)
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                        backgroundColor: AllColors.blue),
                                  ],
                                );
                              },
                            );
                        }

                        final phone =
                            dropdownvalue! + _phoneController.text.trim();
                        //PhoneAuthCredential? authCredential;
                        setState(() {
                          startTimer();
                        });
                        loginUser(phone, context).then((value) {
                          showLoading = false;
                        });
                      }
                      if (_emailController.text.isNotEmpty &&
                          _phoneController.text.isEmpty) {
                        if (_emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter your email');
                          return null;
                        } else {
                          RegExp regExp = RegExp(patternEmail);
                          if (!regExp.hasMatch(_emailController.text)) {
                            Fluttertoast.showToast(
                                msg: 'Please enter valid  email ');
                            return null;
                          }
                        }

                        if (_emailController.text == 'finshark123@gmail.com') {
                          UserCredential result = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: '123456');
                          User? user = result.user;
                          _login(user);
                        } else {
                          _signInWithEmailAndLink();
                        }
                      }
                    }
                    if (_phoneController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty) {
                      // RegExp regExp = RegExp(pattern);
                      // RegExp regExpEmail = RegExp(patternEmail);
                      // if (!regExp.hasMatch(_phoneController.text)) {
                      //   Fluttertoast.showToast(
                      //       msg: 'Please enter valid  phone number');
                      //   return null;
                      // } else {
                      final phone =
                          dropdownvalue! + _phoneController.text.trim();
                      //PhoneAuthCredential? authCredential;
                      setState(() {
                        startTimer();
                      });
                      loginUser(phone, context).then((value) {
                        showLoading = false;
                      });
                      // }
                    }
                  },
                  child: Container(
                    height: 8.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AllColors.blue,
                          AllColors.purple,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Center(
                      child: Text('SEND',
                          style: AllTextStyles.dialogStyleLarge(size: 16.sp)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

// Future<void> signInwithGoogle() async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//   if (googleSignInAccount != null) {
//     final GoogleSignInAuthentication googleSignInAuthentication =
//     await googleSignInAccount.authentication;
//     final AuthCredential authCredential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);
//
//     // Getting users credential
//     UserCredential result = await _auth.signInWithCredential(authCredential);
//     User? user = result.user;
//
//     if (result != null) {
//       print('USer $user');
//       print('succes');
//     }else{
//       print('error');
//     }
//     }
//   }
}
