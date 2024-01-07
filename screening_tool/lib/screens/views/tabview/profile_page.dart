import 'dart:convert';


import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:screening_tool/API/urlfile.dart';
import 'package:screening_tool/components/app_bar_all.dart';
import 'package:screening_tool/components/custom_button.dart';
import 'package:screening_tool/components/custom_widget.dart';
import 'package:screening_tool/screens/auth_screens/login_page.dart';

import 'package:screening_tool/screens/views/tabview/profile/edit_profile.dart';
import 'package:screening_tool/utils/colors_app.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;




class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {

void alertdilog(){
      showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: const Text('Are sure to Logout?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context,"no");
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {

             
              
                 Navigator.of(context).pop();
                 
             
              
             
              
                
              
              
              
            },
            child: const Text('Yes'),
          ),
        
      ]),
    );

    }

  void btn_fun() {
   //alertdilog();
  }
  void editbtn(){
    Navigator.of(context).push(MaterialPageRoute(builder:(context) => edit_profile()));
  } 


@override
void initState(){
  super.initState();
  doctor_info();

  
}







var result,name,age,image_path,location,no_of_patient;
bool _loading = false;

void doctor_info() async {
    var data = {"id": userid};
    var url = doctorurl;
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(data));
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        if (message['Status']) {
         Future.delayed(Duration(milliseconds: 10), (){
          setState(() {
              result = message['doctorinfo'];
              name = result['doctor_name'];
    age = result['age'].toString();
    location = result['location'].toString();
    image_path = result['image_path'];
    no_of_patient = result['no_of_patient'];
              _loading = true;
            });

         });
  
       
        }
      }
    } catch (e) {
      CupertinoActivityIndicator(
          radius: 15.0, color: CupertinoColors.activeBlue);
    }
  }


 Future<void> _refreshon() async{
    await Future.delayed( Duration(milliseconds: 1000));
    doctor_info();

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


  

    return _loading ==false ? Center(child: CupertinoActivityIndicator(radius: 20.0),):
    
    Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: 
            
            SafeArea(child: appbar_default(title: "Profile",))),



        body: CustomMaterialIndicator(
          onRefresh: _refreshon,

          indicatorBuilder: (BuildContext context, IndicatorController controller) { 
            return Icon(Icons.health_and_safety_outlined);
           },
          child: ListView(
            children:[ Column(children: [
            
            
            
              //name card starts!!!!!!!
            
              Padding(
                padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                child: Container(
                  width: size.width.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                      color: widget_color, borderRadius: BorderRadius.circular(20)),
            
                  // inside name card startss!!!!!
            
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    // profile picture starts!!!
                    if (image_path == null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Container(
                        width: 25.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/default.jpg')),
                            shape: BoxShape.circle),
                      ),
                    )
                    else 
                    
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Container(
                        width: 25.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("http://$ip/screening$image_path")),
                            shape: BoxShape.circle),
                      ),
                    ),
            
            
                    //space
            
                    SizedBox(
                      width: 5.w,
                    ),
            
                    // detials label starts!!
            
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Name :",
                          style: TextStyle(fontSize: 17.sp, fontFamily: 'SF-Pro'),
                        ),
                        Text(
                          "Age : ",
                          style: TextStyle(fontFamily: 'SF-Pro', fontSize: 17.sp),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(
                            CupertinoIcons.location,
                            size: 28,
                            color: primary_color,
                          ),
                        )
                      ],
                    ),
            
                    // detials starts!!!!!
            
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Dr.$name",
                          style: TextStyle(fontFamily: 'SF-Pro', fontSize: 17.sp),
                        ),
                        Text(
                          "$age yrs",
                          style: TextStyle(fontFamily: 'SF-Pro', fontSize: 17.sp),
                        ),
                        Text(
                          location!=""?location:"Location",
                          style: TextStyle(fontFamily: 'SF-Pro', fontSize: 17.sp),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            
              /// button starts here  !!!!!!!
            
              custom_buttom(
                text: "Edit Profile",
                width: 70,
                textSize: 15,
                height: 6,
                backgroundColor: widget_color,
                textcolor: darkColor,
                icon: CupertinoIcons.pencil,
                button_funcation: () {
                  editbtn();
                }, fontfamily: 'SF-Pro',
              ),
            // spacer fro padding
            
              SizedBox(
                height: 8.h,
              ),
            
              /// report widget starts here !!!!!!!
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  custom_widget(
                    width: 35,
                    height: 15,
                    backgroundColor: widget_color,
                    borderradius: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          CupertinoIcons.person_2_fill,
                          size: 28,
                          color: darkColor,
                        ),
                        Text(
                          "No of Patients ",
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Bold',
                              fontSize: 12.sp,
                              color: darkColor),
                        ),
                        Text(
                          no_of_patient,
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Bold',
                              fontSize: 17,
                              color: primary_color),
                        ),
                      ],
                    ),
                  ),
                  custom_widget(
                    width: 40,
                    height: 15,
                    backgroundColor: widget_color,
                    borderradius: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          CupertinoIcons.doc_chart,
                          size: 28,
                          color: darkColor,
                        ),
                        Text(
                          "Completed Report ",
                          style: TextStyle(
                              color: darkColor,
                              fontFamily: 'SF-Pro-Bold',
                              fontSize: 12.sp),
                        ),
                        Text(
                          "100",
                          style: TextStyle(
                              color: primary_color,
                              fontFamily: 'SF-Pro-Bold',
                              fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            
              SizedBox(
                height: 15.5.h,
              ),
            
              // logut button for the page that displays
            
              custom_buttom(
                  text: "LOGOUT ",
                  width: 75,
                  height: 6.5,
                  backgroundColor: widget_color,
                  textSize: 18,
                  button_funcation: (){
                   btn_fun();
                    
                  },
                  icon: Icons.logout,
                  textcolor:redcolor, fontfamily: 'SF-Pro-Bold',)
            ]),
          ]),
        ));
  }
}