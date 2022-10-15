// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jsaos/components/error_snackbar.dart';
import 'package:jsaos/components/questionwidget.dart';
import 'package:jsaos/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  static String id = 'resultpage';

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<Map<String, String>> listOfColumns = [];
  late double avgTat;
  late double avgWt;
  late bool isCalculated = false;
  late String jsaType;
  late String processText;
  late bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    calculate();
  }

  void calculate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<double> closingTime = [];
    List processNumbers = [];
    List<String> burstTime = prefs.getStringList("burstvalues")!;
    processText = prefs.getString("noof_process")!;
    double sum = 0;
    List<double> tat = [];
    List<double> waitingTime = [];
    double totaltat = 0;
    double totalWt = 0;
    jsaType = json.decode(prefs.getString("key")!);
    setState(() {
      isInitialized = true;
    });
    burstTime.length = int.parse(processText);
    try {
      if (jsaType == 'First Come First Serve (FCFS)') {
        for (var i = 0; i < burstTime.length; i++) {
          sum += int.parse(burstTime[i]);
          closingTime.add(sum);
          tat.add(closingTime[i]);
          totaltat += tat[i];
          waitingTime.add(tat[i] - int.parse(burstTime[i]));
          totalWt += waitingTime[i];
          avgTat = totaltat / int.parse(processText);
          String inString = avgTat.toStringAsFixed(2); // '2.35'
          avgTat = double.parse(inString);
          avgWt = totalWt / int.parse(processText);
          inString = avgWt.toStringAsFixed(2); // '2.35'
          avgWt = double.parse(inString);
        }
        for (var i = 0; i < burstTime.length; i++) {
          listOfColumns.add({
            "Process": "Process ${i + 1}",
            "BT": burstTime[i],
            "CT": "${closingTime[i]}",
            "TAT": "${tat[i]}",
            "WT": "${waitingTime[i]}",
          });
        }
      } else {
        List<double> valuesInt = [];
        //print(burstTime);
        // double temp;
        for (var i = 0; i < burstTime.length; i++) {
          valuesInt.add(double.parse(burstTime[i]));
        }
        valuesInt.sort();
        for (var i = 0; i < valuesInt.length; i++) {
          final result = burstTime.indexOf("${valuesInt[i]}");
          processNumbers.add(result + 1);
          burstTime[result] = "a";
        }
        waitingTime.add(0);
        for (var i = 1; i < valuesInt.length; i++) {
          waitingTime.add(0);
          for (var j = 0; j < i; j++) {
            waitingTime[i] += valuesInt[j];
          }
          totalWt += waitingTime[i];
        }
        for (var i = 0; i < valuesInt.length; i++) {
          sum += valuesInt[i];
          closingTime.add(sum);
          tat.add(valuesInt[i] + waitingTime[i]);
          totaltat += tat[i];
        }
        avgTat = totaltat / int.parse(processText);
        String inString = avgTat.toStringAsFixed(2); // '2.35'
        avgTat = double.parse(inString);
        avgWt = totalWt / int.parse(processText);
        inString = avgWt.toStringAsFixed(2); // '2.35'
        avgWt = double.parse(inString);
        for (var i = 0; i < burstTime.length; i++) {
          listOfColumns.add({
            "Process": "Process ${processNumbers[i]}",
            "BT": "${valuesInt[i]}",
            "CT": "${closingTime[i]}",
            "TAT": "${tat[i]}",
            "WT": "${waitingTime[i]}",
          });
        }
      }
      setState(() {
        isCalculated = true;
      });
    } catch (e) {
      snackBar("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: !isInitialized
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
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
                            color: const Color(0xFF4EEF88),
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Table(listOfColumns: listOfColumns),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuestionWidget(
                                question: isCalculated
                                    ? "Average Waiting Time Of All Processes is    :"
                                    : ""),
                            Text(
                              isCalculated ? "$avgWt ms" : "",
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuestionWidget(
                                question: isCalculated
                                    ? "Average Turn Around Time Of All Processes is :"
                                    : ""),
                            Text(
                              isCalculated ? "$avgTat ms" : "",
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                          ],
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
                          onPressed: () {
                            Navigator.popAndPushNamed(context, Homepage.id);
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
    );
  }
}

class Table extends StatelessWidget {
  const Table({
    Key? key,
    required this.listOfColumns,
  }) : super(key: key);

  final List<Map<String, String>> listOfColumns;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DataTable(
        border: TableBorder.all(
          width: 0.3.h,
          borderRadius: BorderRadius.circular(3.h),
          color: Colors.black54,
        ),
        columnSpacing: 6.h,
        headingTextStyle: TextStyle(
          fontSize: 6.sp,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        dataTextStyle: TextStyle(
          fontSize: 5.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        columns: const [
          DataColumn(
            label: Text(
              'Process',
            ),
          ),
          DataColumn(
            label: Text(
              'Burst Time',
            ),
          ),
          DataColumn(
            label: Text(
              'Closing Time',
            ),
          ),
          DataColumn(
            label: Text(
              'Turn Around Time',
            ),
          ),
          DataColumn(
            label: Text(
              'Waiting Time',
            ),
          ),
        ],
        // Loops through dataColumnText, each iteration assigning the value to element
        rows: listOfColumns
            .map(
              ((element) => DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text(
                          element["Process"]!,
                        ),
                      ), //Extracting from Map element the value
                      DataCell(
                        Text(
                          element["BT"]!,
                        ),
                      ),
                      DataCell(
                        Text(
                          element["CT"]!,
                        ),
                      ),
                      DataCell(
                        Text(
                          element["TAT"]!,
                        ),
                      ),
                      DataCell(
                        Text(
                          element["WT"]!,
                        ),
                      ),
                    ],
                  )),
            )
            .toList(),
      ),
    );
  }
}
