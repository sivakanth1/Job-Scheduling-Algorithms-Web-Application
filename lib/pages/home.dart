// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:jsaos/pages/inputpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  static String id = 'homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String dropdownvalue = 'First Come First Serve (FCFS)';
  Object? jsa = 'First Come First Serve (FCFS)';
  var items = [
    'First Come First Serve (FCFS)',
    'Shortest Job First (SJF)',
  ];

  @override
  void initState() {
    super.initState();
    if (SizerUtil.deviceType == DeviceType.mobile ||
        SizerUtil.deviceType == DeviceType.tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'JOB SEQUENCE SCHEDULING ALGORITHMS OPERATING SYSTEM',
                        textStyle: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 150),
                      ),
                    ],
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Flexible(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 10.0,
                      runSpacing: 20.0,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select any one Job Sequencing algorithm:',
                          style: TextStyle(fontSize: 6.sp),
                        ),
                        DropdownButton<String>(
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(
                                  color: Color(0xFF4EEF88),
                                ),
                              ),
                            );
                          }).toList(),
                          elevation: 20,
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          style: TextStyle(
                              fontSize: 6.sp, fontWeight: FontWeight.w500),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              jsa = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.redAccent;
                        }
                        return null;
                      }),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString("key", json.encode(jsa));
                      Navigator.pushNamed(context, InputPage.id);
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 7.sp, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
