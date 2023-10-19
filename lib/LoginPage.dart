

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';



class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  String eemail="";
  String ppassword="";





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.center,
                    child: Image.asset('assets/shield.png'),
                  ),
                ),
              ),

              Text(
                "Crime Reporting System",
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text("Admin Login",style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400), // Limit the width
                  child: TextField(
                    controller: emailcontroller,



                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                    ),
                    style: TextStyle(color: Colors.blue),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400), // Limit the width
                  child: TextField(
                    controller: passwordcontroller,

                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                    ),
                    style: TextStyle(color: Colors.blue),
                    obscureText: true,
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedbutton(context: context, height: 45, width: 0.14, label: "Login", route: Dashboard(), Buttoncolor: Colors.green[600]!, Textcolor: Colors.white, radius: 8.0,cat:1,EmailController: emailcontroller,PasswordController: passwordcontroller,email: eemail,password: ppassword),
                  SizedBox(width: 20,),

                ],
              ),







            ],
          ),
        ),
      ),
    );
  }
}

Widget CustomElevatedbutton ({
  required BuildContext context,
  required double height,
  required double width,
  required String label,
  required Widget route,
  required Color Buttoncolor,
  required Color Textcolor,
  required double radius,
  required int cat,
  required TextEditingController EmailController, // New parameter for email controller
  required TextEditingController PasswordController, // New parameter for password controller
  required String email, // New parameter for email
  required String password,

}){
  return SizedBox(
      width:  MediaQuery.of(context).size.width*width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if(cat==1){
            email=EmailController.text;
            password=PasswordController.text;
            Checker(email,password,context);









          }
          else if(cat==2){

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => route));
          }



        }, child: Text(label,style: TextStyle(
          fontSize: 18,
          color: Textcolor,
          fontWeight: FontWeight.bold



      ),),

        style: ElevatedButton.styleFrom(
          primary:  Buttoncolor,
          onPrimary: Textcolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),

        ),
      ));
}

void Checker(String email, String passowrd , BuildContext context) {

  if(email.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a valid email address.' ,textAlign: TextAlign.center, style: TextStyle(color:  Colors.white,),),
        backgroundColor: Colors.red,
      ),
    );



  }
  else if(passowrd.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a password.' ,textAlign: TextAlign.center, style: TextStyle(color:  Colors.white,),),
        backgroundColor: Colors.red,
      ),
    );
  } else if(passowrd.length<8) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wrong Password' ,textAlign: TextAlign.center, style: TextStyle(color:  Colors.white,),),
        backgroundColor: Colors.red,
      ),
    );
  }
  else {

    // Loginuser(email: email ,password:passowrd);

    loginuser(email,passowrd ,context);


  }





}

Future<void> loginuser(String email, String pasword,BuildContext context) async {

  try {

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pasword,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully logged in.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // You can choose your preferred color
      ),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard()));

  }
  catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$e" ,textAlign: TextAlign.center, style: TextStyle(color:  Colors.white,),),
        backgroundColor: Colors.red,
      ),
    );





  }









}