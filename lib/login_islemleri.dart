import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foru/manager/manager_homepage.dart';
import 'package:flutter_foru/user/user_homepage.dart';
import 'package:flutter_foru/uye_ol.dart';

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController sifrecontroller = TextEditingController();
  String _email ="";
  String _password = "";
  Color color1 = const Color(0xFFEA4C4D);
  Color color2 = const Color(0xFFEDB758);
  var girisKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        debugPrint('Giriş yapmış bir kullanıcı yok!');
      } else{
        debugPrint('Giriş Yapmış bir kullanıcı var Email: ${_auth.currentUser.email}');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color1,color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
        ),
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: girisKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 120),
              //Email giriş
              TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "E mail",
                  labelText: "E mail",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  // standart hali
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (String girilenVeri){
                  if (!(girilenVeri.contains("@gmail.com")|| girilenVeri.contains("@hotmail.com") || girilenVeri.contains("@outlook.com") || girilenVeri.contains("@bil.omu.edu.tr"))){
                    return "Lütfen geçerli bir e mail giriniz";
                  }else {
                    return null;
                  }
                },
                onSaved: (girilenEmail){
                  if(girilenEmail.isEmpty){
                    debugPrint("durum if e düstü!!!!");
                    //_showDialog();
                  }
                  _email = girilenEmail;
                },
              ),
              SizedBox(height: 10),
              //Şifre Giriş
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Colors.white,
                  hintText: "Şifre",
                  labelText: "Şifre",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),

                ),
                validator: (String girilenVeri){
                  if(girilenVeri.length <= 6 ){
                    return "Şifre 6 karakterden az olamaz";
                  }else{
                    return null;
                  }
                },
                onSaved: (girilenSifre){
                  _password = girilenSifre;
                },

              ),
              SizedBox(height: 10),
              // GirişButonu
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.purple),
                ),
                icon: Icon(Icons.arrow_forward,color: Colors.white,),
                label: Text("Giriş Yap",style: TextStyle(color: Colors.white),),
                color: Colors.purple,
                onPressed: _emailSifreKullaniciGirisyap,
              ),
              //Üye ol Butonu
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    side: BorderSide(color: Colors.purple),
                  ),
                  icon: Icon(Icons.person,color: Colors.white,),
                  label: Text("Üye Ol",style: TextStyle(color: Colors.white),),
                  color: Colors.purple,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UyeOl(_auth)));
                  }
                  ),
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    side: BorderSide(color: Colors.purple),
                  ),
                  icon: Icon(Icons.lock,color: Colors.white,),
                  label: Text("Şifremi Unuttum",style: TextStyle(color: Colors.white),),
                  color: Colors.purple,
                  onPressed: (){}
                  ),
              // cıkıs yap
              RaisedButton(
                child: Text("Çıkış Yap"),
                onPressed: _cikisYap,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _emailSifreKullaniciGirisyap() async {
    girisKey.currentState.save();
    //debugPrint("save methodu calisti amaa ???");
    try {
      // eger giriş yapmış kullanıcı yoksa
      if (_auth.currentUser == null) {
        // Yönetici kontolü
        _firebaseFirestore.collection("yönetici").get().then((gelenVeri) async {
          //debugPrint("Okunması istenen değer: " + gelenVeri.docs[0].data().toString());
          for(int i= 0; i<gelenVeri.docs.length; i++){
            if((gelenVeri.docs[i].data()['Email']).toString() == _email){
              User _oturumAcanYonetici = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;
              //debugPrint("Login Sayfası oturum açan yonetici email:  "+ _oturumAcanYonetici.email);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerHomePage(firebaseAuthManager: _auth)));
            }
          }
        });

        // Uye kontrolü
        _firebaseFirestore.collection("users").get().then((gelenVeri) async {
          for(int i=0; i< gelenVeri.docs.length; i++){
            if(gelenVeri.docs[i].data()['Email'].toString() == _email){
              User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;
              debugPrint(_oturumAcanUser.toString());
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage(firebaseAuthUser: _auth,)));
            }
          }
        });
      } else {
        // giriş yapmış bir kullanıcı
        debugPrint("Zaten giriş yapmış bir kullanıcı var");
      }
    } catch (e) {
      debugPrint("Oturum Açarken HATA!:" + e.toString());
    }

  }


  void _cikisYap() async {
    try {
      // sistemde kullanıcı varsa çıkış yap
      if (_auth.currentUser != null) {
        debugPrint("${_auth.currentUser.email} sistemden çıkıyor");
        await _auth.signOut();
      } else {
        // sistemde zaten bir kullanıcı yoksa sorun yok
        debugPrint("Zaten oturum açmış bir kullanıcı yok");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
