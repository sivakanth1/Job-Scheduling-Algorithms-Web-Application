// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jsaos/components/questionwidget.dart';
import 'package:jsaos/pages/resultpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  static String id = 'inputpage';

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final processTextController = TextEditingController();
  final burstTimeTextController = TextEditingController();
  late String burstTimeText;
  late String processText;
  late bool isEnteredAll = true;
  late bool isInitialized = false;
  late int remaining;
  late int enteredValues;
  late String jsaType;

  @override
  void initState() {
    super.initState();
    getData1();
  }

  void getData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jsaType = json.decode(prefs.getString("key")!);
    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: !isInitialized
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3.h),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            jsaType,
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFd57103),
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Row(
                            children: [
                              const QuestionWidget(
                                question: 'Enter Total Number of Processes : ',
                              ),
                              SizedBox(
                                height: 11.h,
                                width: 20.w,
                                child: Center(
                                  child: TextField(
                                    controller: processTextController,
                                    cursorHeight: 3.h,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onChanged: (value) {
                                      //Do something with the user input.
                                      processText = value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.orange)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.orange)),
                                      labelStyle:
                                          const TextStyle(color: Colors.red),
                                      hintStyle:
                                          const TextStyle(color: Colors.red),
                                      labelText: 'Enter no.of Processes',
                                      hintText: 'Enter Integer value only',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            children: [
                              const QuestionWidget(
                                question:
                                    "Enter Burst For All Processes        : ",
                              ),
                              SizedBox(
                                height: 11.h,
                                width: 20.w,
                                child: Center(
                                  child: TextField(
                                    controller: burstTimeTextController,
                                    cursorHeight: 3.h,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onChanged: (value) {
                                      //Do something with the user input.
                                      burstTimeText = value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.orange)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.orange)),
                                      labelStyle:
                                          const TextStyle(color: Colors.red),
                                      hintStyle:
                                          const TextStyle(color: Colors.red),
                                      labelText:
                                          'Enter Burst Time of all Processes (space separated)',
                                      hintText:
                                          'Enter Integer values with space separated only',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          isEnteredAll
                              ? const Text("")
                              : Text(
                                  '''
                            Total No.of Processes You Have Entered is $processText
                            But You only entered burst times for $enteredValues process
                            Please Enter $remaining Process Burst Time To calculate.
                            ''',
                                  style: TextStyle(
                                    fontSize: 5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.redAccent;
                                } else if (states
                                    .contains(MaterialState.focused)) {
                                  return Colors.redAccent;
                                }
                                return null;
                              }),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final List<String> values =
                                  burstTimeText.split(" ");
                              final int noOfProcess = int.parse(processText);
                              if (values.length < noOfProcess) {
                                setState(() {
                                  remaining = noOfProcess - (values.length);
                                  enteredValues = values.length;
                                  isEnteredAll = false;
                                });
                              } else {
                                prefs.setStringList("burstvalues", values);
                                prefs.setString("noof_process", processText);
                                processTextController.clear();
                                burstTimeTextController.clear();
                                Navigator.pushNamed(context, ResultPage.id);
                              }
                            },
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 7.sp, fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
