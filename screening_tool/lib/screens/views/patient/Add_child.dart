import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:screening_tool/API/urlfile.dart';
import 'package:screening_tool/components/app_bar_all.dart';
import 'package:screening_tool/components/custom_button.dart';
import 'package:screening_tool/utils/colors_app.dart';
import 'package:sizer/sizer.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class add_new_child extends StatefulWidget {
  const add_new_child({super.key});

  @override
  State<add_new_child> createState() => _add_new_childState();
}

class _add_new_childState extends State<add_new_child> {
  var date;
  var width_child = 88.w;
  File? imagefile;
  var base64encode;

  TextEditingController dob_field = new TextEditingController();
  TextEditingController child_name = new TextEditingController();
  TextEditingController Parent_name = new TextEditingController();
  TextEditingController phone_no = new TextEditingController();
  TextEditingController Weight = new TextEditingController();
  TextEditingController height = new TextEditingController();
  TextEditingController Medical_con = new TextEditingController();

//get image file

  void getimage({required ImageSource source}) async {
    final file =await ImagePicker().pickImage(source: source, imageQuality: 100);
    if(file!=null) {
      final imageBytes = await file.readAsBytes();
      var base64encoder = base64Encode(imageBytes);
      setState(() {
        base64encode = base64encoder ; 
      });
    }



    if (file?.path != null) {   
      setState(() {
        imagefile = File(file!.path);
  

      });
    }
  }

  void photo_picker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    child: const Text('Camera'),
                    isDefaultAction: true,
                    onPressed: () {
                      getimage(source: ImageSource.camera);
                    }),
                CupertinoActionSheetAction(
                    child: const Text('Gallery'),
                    isDefaultAction: true,
                    onPressed: () {
                      getimage(source: ImageSource.gallery);
                    }),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ));
  }

// date picker

  void date_picker() async {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 20.h,
              child: CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      date = newDate;
                      dob_field.text = "${date.year}-${date.month}-${date.day}";
                    });
                  }));
        });
  }

  @override
  Widget build(BuildContext context) {


    void clear_field() {
      dob_field.clear();
      child_name.clear();
      Parent_name.clear();
      Weight.clear();
      height.clear();
      Medical_con.clear();
      phone_no.clear();
      setState(() {
        imagefile = null;
      });
    }



    void add_new_child() async {

      
      var child_data = {
        "id": userid,
        "child_name": child_name.text,
        "parent_name": Parent_name.text,
        "dob": dob_field.text,
        "phone_no": phone_no.text,
        "weight": Weight.text,
        "height": height.text,
        "base64Image": base64encode
      };
      var url = addchildurl;
      if (child_name.text.isNotEmpty &&
          Parent_name.text.isNotEmpty &&
          dob_field.text.isNotEmpty &&
          phone_no.text.isNotEmpty &&
          Weight.text.isNotEmpty &&
          height.text.isNotEmpty &&
          base64encode!.isNotEmpty
          )
          
          {
  final response = await http.post(Uri.parse(url),body: jsonEncode(child_data));
                      if (response.statusCode == 200) {
                      var msg;
                      msg = jsonDecode(response.body);
                        if (msg['status']){
                          Fluttertoast.showToast(
                              msg: "suceessfully added the child",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          clear_field();
                        }
                      } else {
                        print(response.body);
                      }
                    }
      else{
        Fluttertoast.showToast(
        msg: "Please Fill All The Fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        
        textColor: Colors.white,
        fontSize: 15.sp
    );
      }
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: SafeArea(
              child: appbar_default(
            title: "New Child",
          )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (imagefile == null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      photo_picker();
                    },
                    child: Container(
                      width: 30.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/default_2.jpg"))),
                    ),
                  ),
                )
              else
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      photo_picker();
                    },
                    child: Container(
                      width: 30.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(imagefile!),
                              fit: BoxFit.contain)),
                    ),
                  ),
                ),
              SizedBox(
                height: 6.h,
                width: width_child,
                child: CupertinoTextField(
                  controller: child_name,
                  placeholder: 'Full Name',
                  decoration: BoxDecoration(
                      color: widget_color,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              Gap(3.h),
              SizedBox(
                height: 6.h,
                width: width_child,
                child: CupertinoTextField(
                  controller: Parent_name,
                  placeholder: 'Parent Name',
                  decoration: BoxDecoration(
                      color: widget_color,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              Gap(3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 6.h,
                    width: 35.w,
                    child: CupertinoTextField(
                      placeholder: 'D-O-B',
                      controller: dob_field,
                      suffix: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              date_picker();
                            },
                            child: Icon(
                              CupertinoIcons.calendar,
                              color: primary_color,
                            ),
                          )),
                      decoration: BoxDecoration(
                          color: widget_color,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                    width: 38.w,
                    child: CupertinoTextField(
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          CupertinoIcons.phone,
                          color: apple_grey2,
                        ),
                      ),
                      controller: phone_no,
                      placeholder: 'Phone No',
                       keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                          color: widget_color,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
              ),
              Gap(3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 6.h,
                    width: 35.w,
                    child: CupertinoTextField(
                      controller: Weight,
                      placeholder: 'Weight (kg)',
                       keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                          color: widget_color,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                    width: 35.w,
                    child: CupertinoTextField(
                      controller: height,
                      placeholder: 'Height (in)',
                       keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                          color: widget_color,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
              ),
              Gap(2.5.h),
              Container(
                width: 85.w,
                height: 15.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget_color),
                child: CupertinoTextField(
                  placeholder: "Medical condition(Optional)",
                ),
              ),
              Gap(3.h),
              custom_buttom(
                  text: "SUBMIT",
                  width: 80,
                  height: 6,
                  backgroundColor: submit_button,
                  textSize: 15,
                  button_funcation: () {
                    add_new_child();
                  },
                  textcolor: lightColor,
                  fontfamily: 'SF-Pro-Bold')
            ],
          ),
        ));
  }
}