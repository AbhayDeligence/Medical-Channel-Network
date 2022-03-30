import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/pages/add_badge_Screen.dart';
import 'package:news_app/pages/done.dart';
import 'package:news_app/pages/mobile_verify.dart';
import 'package:news_app/pages/sign_in.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/icons.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatefulWidget {
  final String? tag;
  SignUpPage({Key? key, this.tag}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var headlinecntrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var orgNameCtrl = TextEditingController();
  var nearMedicalCntrCtrl = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List selectedFields = [
    'NOT GIVEN',
    'Fellow of the American College of Endocrinology',
    'Doctor of Medical Science',
    'Certified Orthotist',
    'Certified Respiratory Therapy Technician',
    'Fellow of the American College of Allergy, Asthma & Immunology',
    'Licensed Dispensing Optician',
    'Physician Assistant',
    'Accredited Record Technologist',
    'American Society for Clinical Pathology',
    'Bachelor of Science',
    'Bachelor of Science in Nursing',
    'Certified Case Manager',
    'Certified Family Nurse Practitioner',
    'Chirurgiae Magister',
    'Certified Nursing Assistant',
    'Certified Nurse Midwife',
    'Clinical Nurse Specialist',
    'Certified Occupational Therapy Assistant',
    'Doctor of Nursing Science',
    'Doctor of Science',
    'Doctor of Veterinary Medicine',
    'Fellow of the American Academy of Family Physicians',
    'Fellow of the American Psychiatric Association',
    'Fellow of Critical Care Medicine',
    'Fellow of the International College of Surgeons',
    'Gerontological Nurse Practitioner',
    'Licensed Practical Nurse',
    'Licensed Vocational Nurse',
    'Master of Arts',
    'Medical Assistant (recent)',
    'Marriage and Family Therapist',
    'Master of Public Health',
    'Medical Records Librarian',
    'Medical Technologist',
    'Nurse Practitioner',
    'Occupational Therapist',
    'Orthopedic Technician, Certified',
    'Patient Access Supervisor',
    'Physical Therapist',
    'Physical Therapist Assistant',
    'Registered Dental Hygienist',
    'Registered Nurse',
    'Registered Respiratory Therapist',
    'Veterinary medical doctor',
    'Veterinary Technician',
    'Associate in Allied Health',
    'Associate of Arts in Nursing',
    'American Association for Respiratory Care Fellow',
    'Associate in Applied Science',
    'Associate of Applied Technology',
    'Associate of Arts in Teaching',
    'Applied Cognitive Psychology',
    'AIDS Certified Registered Nurse',
    'Associate\'s Degree in Nursing+ 1 variant',
    'Alternate Entry Master of Science in Nursing',
    'Associate in Medical Science',
    'Advanced Oncology Certified Nurse',
    'American Oncology Certified Nurse',
    'Advanced Oncology Certified Nurse Practitioner',
    'Advanced Project Management Certification',
    'Advanced Practice Nurse',
    'Advanced Practice Registered Nurse',
    'Associate of Science In Nursing',
    'American Society for Psychoprophylaxis in Obstetrics',
    'Athletic Trainer, Certified',
    'Bachelor of Arts',
    'Board Certified - Palliative Care Management',
    'Bachelor of Surgery',
    'Bachelor of Dental Surgery',
    'Bachelor of Dental Science',
    'Bachelor of Health Science',
    'Bachelor of Hygiene',
    'Bachelor of Medical Science',
    'Bachelor of Nursing',
    'Bachelor of Pharmacy',
    'Bachelor of Public Health Nursing',
    'Bachelor of Surgery',
    'Bachelor of Science in Education',
    'Bachelor of Science in Environmental Health',
    'Bachelor of Science in Public Health',
    'Bachelor of Social Work',
    'Bachelor of Veterinary Medicine and Science',
    'Certified Ambulatory Post-Anesthesia Nurse',
    'Certified Addiction Registered Nurse',
    'Bachelor of Surgery',
    'Chemical and Biological Engineering',
    'Certificate in Breast Imaging',
    'Certificate of Clinical Competence in Audiology',
    'Certificate of Clinical Competance in Speech language pathology',
    'Certified Continence Care Nurse',
    'Certified Childbirth Educator',
    'Certified Cancer Exercise Specialist',
    'Critical Care Nurse Specialist',
    'Certified Cardiovascular Perfusionist',
    'Certified Clinical Perfusionist',
    'Certified Critical Care Registered Nurse',
    'Critical Care Registered Nurse',
    'Certified Chiropractic Sports Physician',
    'Chiropractic Certification in Spinal Trauma',
    'Clinical Dietitian',
    'Certified Dental Assistant',
    'Certified Diabetes Educator',
    'Certified Dialysis Nurse',
    'Certified Emergency Nurse',
    'Certified Enterostomal Therapy Nurse',
    'Certified Flight Registered Nurse',
    'Certified Gastroenterology Nurse',
    'Certified Gastroenterology Registered Nurse',
    'Certified Gastroenterology Technician',
    'Bachelor of Surgery',
    'Doctor of Surgery',
    'Certified Health Education Specialist',
    'Certified Hemodialysis Nurse',
    'Certified Hospice and Palliative Nurse',
    'Certified Hemodialysis Technician (recent)',
    'Certified Infection Control Nurse',
    'Certified Licensed Practitioner Nursing, Intravenous',
    'Clinical Laboratory Specialist',
    'Certified Laboratory Technician',
    'Clinical Laboratory Technician',
    'Certified Midwife',
    'Master in Surgery',
    'Certified Medical Assistant',
    'Certified Medical Assistant, Administrative',
    'Certified Medical Assistant, Clinical',
    'Certified Medical-Surgical Registered Nurse',
    'Certified in Nursing Administration',
    'Certified in Nursing Administration, Advanced',
    'Certified Nursing Director of Long-Term Care',
    'Certified Nuclear Medicine Technologist',
    'Certified Nephrology Nurse',
    'Certified Nurse, Operating Room',
    'Certified Nurse Practitioner',
    'Community Nurse Practitioner',
    'Certified Neuroscience Registered Nurse',
    'Certified Nutrition Support Nurse',
    'Certified Ostomy Care Nurse',
    'Certified Occupational Health Nurse',
    'Certified Occupational Health Nurse-Specialty',
    'Certified Ophthalmic Medical Assistant',
    'Certified Otorhinolaryngology Nurse',
    'Certified Operating Room Nurse',
    'Certified Prosthetist',
    'Certified Post Anesthesia Nurse+ 1 variant',
    'Certified Peritoneal Dialysis Nurse',
    'Certified Pulmonary Function Technologist',
    'Certified Pediatric Nurse',
    'Certified Pediatric Nurse Practitioner+ 1 variant',
    'Certified Pediatric Oncology Nurse',
    'Certified Plastic Surgical Nurse',
    'Certified Radiologic Nurse',
    'Certified Registered Nurse Anesthetist',
    'Certified Registered Nurse First Assistant',
    'Certified Registered Nurse, First Assistant',
    'Certified Registered Hospice Nurse',
    'Certified Registered Nurse Infusion',
    'Certified Registered Nurse, Ophthalmology',
    'Certified Rehabilitation Registered Nurse - Advanced',
    'Certified Respiratory Therapist',
    'Certified School Nurse',
    'Certified Urologic Clinical Nurse Specialist',
    'Certified Urologic Nurse Practitioner',
    'Certified Urologic Registered Nurse+ 1 variant',
    'Certified Wound Care Nurse',
    'Certified Wound, Ostomy and Continence Nurse',
    'Doctor of Osteopathic Medicinerecent',
    'Dental Assistant',
    'Doctor of Chiropractic',
    'Diploma in Child Health',
    'Doctor of Surgery',
    'Diploma in Diagnostic Radiology',
    'Doctor of Dental Surgery',
    'Doctor of Dental Science',
    'Doctor of Medicine',
    'Doctor of Dental Medicine',
    'Doctor of Medical Technology',
  ];
  List initial = [];
  String? nearmedical;
  List medicalCenterNearYou = [
    'Boston',
    'Los Angeles',
    'New York',
    'Baltimore',
    'Chicago',
    'San Francisco',
    'Ann Arbor, Michigan',
    'San Jose, California',
    'Houston – Texas Medical Center',
    'Seattle',
  ];
  var checkedValue = false;
  late String email;
  late String pass;
  String? headline;
  String? name;
  String? orgName;
  List? nearMC = [];
  bool signUpStarted = false;
  bool signUpCompleted = false;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

//check domain first
  Future handleSignUpwithEmailPassword() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await AppService().checkInternet().then((hasInternet) {
        if (hasInternet == false) {
          openSnacbar(_scaffoldKey, 'no internet'.tr());
        } else {
          setState(() {
            signUpStarted = true;
          });
          sb
              .signUpwithEmailPassword(name, email, pass, orgName, sb.nearmc,
                  initial, checkedValue, headline)
              .then((_) async {
            if (sb.hasError == false) {
              sb.getTimestamp().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.guestSignout().then((value) => sb
                      .saveDataToSP()
                      .then((value) => sb.setSignIn().then((value) {
                            setState(() {
                              signUpCompleted = true;
                            });
                            afterSignUp();
                          })))));
            } else {
              setState(() {
                signUpStarted = false;
              });
              openSnacbar(_scaffoldKey, sb.errorCode);
            }
          });
        }
      });
    }
  }

  noDomainPresent() {
    if (widget.tag == null) {
      nextScreenReplace(context, AddBadgeImage());
    } else {
      Navigator.pop(context);
    }
  }

  afterSignUp() {
    if (widget.tag == null) {
      nextScreenReplace(context, MobileVerification());
      // verifymobile
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: IconButton(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.keyboard_backspace),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Text('sign up',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900))
                    .tr(),
                Text('follow the simple steps',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).secondaryHeaderColor))
                    .tr(),
                SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: '   Name',
                    hintText: 'Enter Name',
                  ),
                  validator: (String? value) {
                    if (value!.length == 0) return "Name can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter here',
                    labelText: '   Organization Name',
                  ),
                  controller: orgNameCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value!.length == 0) return "Can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      orgName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    labelText: '   Email Address',
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value!.length == 0) return "Email can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passCtrl,
                  obscureText: offsecureText,
                  decoration: InputDecoration(
                    labelText: '   Password',
                    hintText: 'Enter Password',
                    suffixIcon: IconButton(
                        icon: lockIcon,
                        onPressed: () {
                          lockPressed();
                        }),
                  ),
                  validator: (String? value) {
                    if (value!.length == 0) return "Password can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      pass = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: headlinecntrl,
                  decoration: InputDecoration(
                    labelText: '   Head Line',
                    hintText: 'CEO at Medical Channel Network',
                  ),
                  validator: (String? value) {
                    if (value!.length == 0) return "Head Line can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      headline = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: MultiSelectBottomSheetField(
                      initialChildSize: .5,
                      listType: MultiSelectListType.LIST,
                      searchable: true,
                      buttonText: Text(
                        'Credentials',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      ),
                      title: Text('Select Degree'),
                      onConfirm: (values) {
                        setState(() {
                          initial = values;
                        });
                      },
                      initialValue: initial,
                      items: selectedFields
                          .map((e) => MultiSelectItem(e, e))
                          .toList()),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              height: 600,
                              width: MediaQuery.of(context).size.width,
                              child: Consumer<SignInBloc>(
                                  builder: (context, snapshot, _) {
                                return Column(
                                    children: medicalCenterNearYou
                                        .map((e) => Expanded(
                                              child: RadioListTile<String>(
                                                  title: Text(e),
                                                  value: e,
                                                  groupValue: snapshot.nearmc,
                                                  onChanged: (v) {
                                                    snapshot.nearmc = v;
                                                    Navigator.pop(context);
                                                  }),
                                            ))
                                        .toList());
                              }));
                        });
                  },
                  child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Consumer<SignInBloc>(builder: (context, snapshot, _) {
                        return Text(snapshot.nearmc == null
                            ? '   Medical Center Near Your'
                            : snapshot.nearmc!);
                      })),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                CheckboxListTile(
                    subtitle:
                        Text('Check this if you work in this medical center.'),
                    value: checkedValue,
                    activeColor: Colors.green,
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    }),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                      child: signUpStarted == false
                          ? Text(
                              'sign up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ).tr()
                          : signUpCompleted == false
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white)
                              : Text('sign up successful!',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white))
                                  .tr(),
                      onPressed: () {
                        handleSignUpwithEmailPassword();
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('already have an account?').tr(),
                    TextButton(
                      child: Text(
                        'sign in',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ).tr(),
                      onPressed: () {
                        if (widget.tag == null) {
                          nextScreenReplace(context, SignInPage());
                        } else {
                          nextScreenReplace(
                              context,
                              SignInPage(
                                tag: 'Popup',
                              ));
                        }
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
  }

  ekfunction(value) {
    setState(() {
      nearmedical = value;
    });
  }
}
