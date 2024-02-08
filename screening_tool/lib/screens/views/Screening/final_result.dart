import 'dart:convert';
import 'dart:io';

import 'package:age_calculator/age_calculator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:screening_tool/API/urlfile.dart';
import 'package:screening_tool/components/app_bar_all.dart';

import 'package:screening_tool/components/custom_button.dart';

import 'package:screening_tool/utils/colors_app.dart';
import 'package:screening_tool/utils/tropography.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;



class finalpage extends StatefulWidget {
  final patient_id;
  const finalpage({super.key,  required this.patient_id});

  @override
  State<finalpage> createState() => _finalpageState();
}

class _finalpageState extends State<finalpage> {
 @override
  void initState() {
    super.initState();
    setState(() {});
    fetch_child_detials();
    fetch_Q_A();
  }

  List length = [];
  Future fetch_Q_A() async {
    var url = questionurl;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var message = jsonDecode(response.body);
      List<dynamic> index = message[0];
      return index;

     
    }
  }

  var name, image_path;
  bool screeening_page_loading = false;
  String? Age;

  void fetch_child_detials() async {
    var data = {"patient_id": widget.patient_id};
    var url = child_info;

    final response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode == 200) {
      var message = jsonDecode(response.body);
      if (message['Status']) {
        var detials = message['pateintinfo'];
        DateTime age = DateTime.parse(detials['age']);
        setState(() {
          name = detials['child_name'];
          image_path = detials['image_path'].toString().substring(2);
          var cal = AgeCalculator.age(age);
          if (cal.years <= 0) {
            Age = cal.months.toString() + "months";
          } else {
            Age = cal.years.toString() + "yrs";
          }

          screeening_page_loading = true;
        });
      }
    }
  }


  void submit_btn() {
   
  }

  @override
  Widget build(BuildContext context) {
    print(length.length);
    return screeening_page_loading == false
        ? Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: SafeArea(child: appbar_default(title: "Screening")),
            ),
            body: Column(
              children: [
                Container(
                  width: 100.w,
                  height: 15.h,
                  //color: apple_grey,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoContextMenu(
                        previewBuilder: (BuildContext context,
                            Animation<double> animation, Widget child) {
                          return SizedBox(
                            height: 30.h,
                            width: 60.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "http://$ip/screening/$image_path",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        actions: [
                          Center(
                              child:
                                  CupertinoContextMenuAction(child: Text(name)))
                        ],
                        child: Container(
                          width: 35.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://$ip/screening$image_path"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, right: 5),
                        child: Column(
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                            Text(
                              "Age",
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, right: 10),
                        child: Column(
                          children: [
                            Text(
                              ":",
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                            Text(
                              ":",
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32, right: 10),
                        child: Column(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                            Text(
                              Age!,
                              style: TextStyle(
                                  fontFamily: 'SF-Pro-Bold', fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                FutureBuilder(
                    future: fetch_Q_A(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      var Question = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CupertinoActivityIndicator(
                          radius: 15,
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: CupertinoScrollbar(
                              child: ListView.builder(
                                itemCount: Question.length+1,
                                itemBuilder: (BuildContext context, int index){
                                 if (index == Question.length){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: custom_buttom(text: "Next",
                                     width: 35, 
                                     height: 6, 
                                     backgroundColor: submit_button,
                                      textSize: 13, 
                                      button_funcation: submit_btn, 
                                      textcolor: lightColor,
                                       fontfamily: 'SF-Pro-Bold'),
                                  );
                                 }
                                 else{
                                  var question = Question![index];
                                    var s_no = question['S.no'];
                                    var q_a = question['Questions'];
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Questionwidget(sno: s_no, Q: q_a),
                                    );
                                 }
                                })
                            ),
                          );
                        }
                      }
                      return Text("something went wrong😒");
                    })
              ],
            ),
          );
  }
}



class Questionwidget extends StatefulWidget {
  final String sno;
  final String Q;
  const Questionwidget({super.key, required this.sno, required this.Q});

  @override
  State<Questionwidget> createState() => _QuestionwidgetState();
}

class _QuestionwidgetState extends State<Questionwidget> {
  bool checkedValue_never = false;
  bool checkedValue_often = false;
  bool checkedValue_sometimes = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      height: 25.h,
      decoration: BoxDecoration(
          color: widget_color_1, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 92.w,
            height: 5.3.h,
            decoration: BoxDecoration(
              color: widget_color_1,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(
                "${widget.sno} .${widget.Q}",
                style: style_text_bold,
              ),
            ),
          ),
          CheckboxListTile(
            title: Text("NEVER"),
            activeColor: Colors.green,

            value: checkedValue_never,
            onChanged: (newValue) {
              setState(() {
                checkedValue_never = newValue!;
                checkedValue_often = false;
                checkedValue_sometimes = false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("OFTEN"),
            activeColor: Colors.orange,

            value: checkedValue_often,
            onChanged: (newValue) {
              setState(() {
                checkedValue_often = newValue!;
                checkedValue_sometimes = false;
                checkedValue_never = false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("SOMETIMES"),
            activeColor: Colors.red,

            value: checkedValue_sometimes,
            onChanged: (newValue) {
              setState(() {
                checkedValue_sometimes = newValue!;
                checkedValue_never = false;
                checkedValue_often = false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          )
        ],
      ),
    );
  }
}
