import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

class NewListingPage extends StatefulWidget {
  @override
  State<NewListingPage> createState() {
    return _NewListingPageState();
  }
}

// final user = FirebaseAuth.instance.currentUser;

Future<dynamic>? sellerDetails(String key) async {
  late Map<String, dynamic> sellerRecords;
  await FirebaseFirestore.instance
      .collection("SellerDetails")
      .doc("nufc@gmail.com")
      // .doc("seller@gmail.com")
      // .doc("${user?.email}")
      .get()
      .then((DocumentSnapshot doc) {
    sellerRecords = doc.data() as Map<String, dynamic>;
  });
  return sellerRecords[key];
}

class _NewListingPageState extends State<NewListingPage> {
  List<bool> isSelected = [false, false, false];

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 30)));
  String? _setUnit;

  bool lockName = false;
  bool lockUnit = false;

  final _formKey = GlobalKey<FormState>();
  // final _businessNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _nameController = TextEditingController();
  final __collectionDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  // final _labelDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  var imgLink;

  @override
  void initState() {
    __collectionDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _setUnit = 'unit';
    // _labelDateController.text = "";
    _descriptionController.text = "Delicious food\nUsed-By:";

    super.initState();
  }

  @override
  void dispose() {
    // _businessNameController.dispose();
    _categoryController.dispose();
    _nameController.dispose();
    __collectionDateController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    // _labelDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String generateListingID() {
    Random _rnd = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(4, (index) => _chars[_rnd.nextInt(_chars.length)])
        .join();
  }

  //Adding data to Firebase
  Future addListing() async {
    String address = await sellerDetails("address");
    String location = await sellerDetails("location");
    String logo = await sellerDetails("logo");
    String name = await sellerDetails("name");

    // print(address);
    // print(location);
    // print(logo);

    isDisplayNull();
    final collectionDate =
        DateFormat("dd-MM-yyyy").parse(__collectionDateController.text);

    final collectionDay = collectionDate.day;
    final collectionMonth = collectionDate.month;
    final collectionYear = collectionDate.year;
    final collectionStartHour = startTime.hour;
    final collectionStartMin = startTime.minute;

    FirebaseFirestore.instance
        .collection("allListings")
        .doc(generateListingID())
        .set({
      // "businessName": _businessNameController.text.trim(),
      "listingImage": imgLink,
      "category": _categoryController.text.trim(),
      "listingName": _nameController.text.trim(),
      "startTime": DateTime(collectionYear, collectionMonth, collectionDay,
          startTime.hour, startTime.minute),
      "endTime": DateTime(collectionYear, collectionMonth, collectionDay,
          endTime.hour, endTime.minute),
      "quantityAvailable": int.tryParse(_quantityController.text.trim()),
      "unitOfMeasurement": _unitController.text.trim(),
      "price": double.tryParse(_priceController.text.trim()),
      "description": _descriptionController.text.trim(),

      "address": "$address",
      "businessLocation": "$location",
      "businessName": "$name",
      "businessLogo": "$logo"
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeInString = startTime.format(context).toString();
    final timePlus30InString = endTime.format(context).toString();
    // final todayDate = DateTime.now();

    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Container(
                height: 30.h,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: displayImage != null
                          ? Image.file(
                              displayImage!,
                            )
                          : defaultFoodPhoto(),
                    ),
                  ),

                  Positioned(
                      bottom: 1,
                      child: Container(
                        height: 30.h,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      )),

                  //Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 25.sp,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 15,
                    left: 30,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 21.sp,
                              backgroundColor: Color(0xFF556B2F),
                              child: FutureBuilder(
                                future: sellerDetails("logo"),
                                builder: (context, snapshot) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage("${snapshot.data}"),
                                    backgroundColor: Colors.white,
                                    radius: 20.sp,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.sp,
                            ),
                            FutureBuilder(
                                future: sellerDetails("name"),
                                builder: (context, snapshot) {
                                  return Text(
                                    "${snapshot.data}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 20,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) => bottomSheet());
                      },
                      child: Icon(
                        Icons.camera_alt,
                        size: 25.sp,
                      ),
                    ),
                  ),
                ]),
              ),

              SizedBox(
                height: 4.h,
              ),

              //Listing Type
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "What listing type?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: ToggleButtons(
                  isSelected: isSelected,
                  fillColor: Color.fromRGBO(239, 228, 212, 1),
                  borderColor: Color.fromRGBO(239, 228, 212, 0),
                  children: <Widget>[
                    //Surprise Bag
                    Padding(
                      padding: EdgeInsets.all(7.sp),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Color(0xFF556B2F),
                            size: 25.sp,
                          ),
                          Text(
                            "Surprise bag",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Color(0xFF556B2F),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Misfit Produce
                    Padding(
                      padding: EdgeInsets.all(7.sp),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage("assets/img/Misfit.png"),
                            height: 25.sp,
                            width: 40.sp,
                          ),
                          Text(
                            "Misfit Produce",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Color(0xFF556B2F),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Surplus Produce
                    Padding(
                      padding: EdgeInsets.all(7.sp),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage("assets/img/Surplus.png"),
                            height: 25.sp,
                            width: 40.sp,
                          ),
                          Text(
                            "Surplus produce",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              color: Color(0xFF556B2F),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  onPressed: (int newIndex) {
                    setState(() {
                      for (int index = 0; index < isSelected.length; index++) {
                        if (index == newIndex) {
                          isSelected[index] = true;
                        } else {
                          isSelected[index] = false;
                        }
                      }
                      //Surpise Bag
                      if (newIndex == 0) {
                        _categoryController.text = "Surprise Bag";
                        _nameController.text = "Surprise Bag";
                        lockName = true;
                        _unitController.text = "Bag";
                        _setUnit = "Bag";
                        lockUnit = true;
                        //Misfit Produce
                      } else if (newIndex == 1) {
                        _categoryController.text = "Misfit Produce";
                        _nameController.text = "";
                        lockName = false;
                        _unitController.text = "";
                        _setUnit = "unit";
                        lockUnit = false;
                        //Surplus produce
                      } else if (newIndex == 2) {
                        _categoryController.text = "Surplus Produce";
                        _nameController.text = "";
                        lockName = false;
                        _unitController.text = "";
                        _setUnit = "unit";
                        lockUnit = false;
                      }
                    });
                  },
                ),
              ),
              //^^^Listing Type^^^
              //Item name - for misfit and surplus
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Item name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  enabled: !lockName,
                  controller: _nameController,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF556B2F)),
                    ),
                    hintText: "What product are you selling?",
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter product name";
                    }
                    return null;
                  },
                ),
              ),
              //^^^Item name - for misfit and surplus^^^
              //Item category - for surprise bag
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 20),
              //     child: Text(
              //       "Item category",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 15.sp,
              //       ),
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.all(20),
              //   child: TextFormField(
              //     style: TextStyle(
              //       fontSize: 12.sp,
              //     ),
              //     decoration: const InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.black),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFF556B2F)),
              //       ),
              //       hintText: "Bread & pastries",
              //       filled: true,
              //     ),
              //   ),
              // ),
              //^^^Item category - for surprise bag^^^
              //Collection date
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Set collection date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: __collectionDateController,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF556B2F)),
                    ),
                    labelText: "Enter Date",
                    filled: true,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      setState(() {
                        __collectionDateController.text =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                      });
                    } else {}
                  },
                ),
              ),
              //^^^Collection date^^^
              //Collection Time
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Set collection time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),

              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From:",
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(
                          width: 100.sp,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF556B2F)),
                              ),
                              hintText: "$timeInString",
                              filled: true,
                            ),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                              );

                              if (newTime == null) return;
                              setState(() {
                                startTime = newTime;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    "To",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End:",
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(
                          width: 100.sp,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF556B2F)),
                              ),
                              // hintText: "$hoursPlus30:$minutesPlus30",
                              hintText: "$timePlus30InString",
                              filled: true,
                            ),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                              );

                              if (newTime == null) return;
                              setState(() {
                                endTime = newTime;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //^^^Collection Time^^^

              //Quantity
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.sp),
                          child: Text(
                            "Quantity:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 70.sp,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _quantityController,
                            onChanged: (text) => {},
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF556B2F)),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter available quantity";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.sp),
                          child: Text(
                            "Unit of measurement:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 165.sp,
                          child: TextFormField(
                            enabled: !lockUnit,
                            controller: _unitController,
                            onChanged: (value) => setState(() {
                              _setUnit = value;
                            }),
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            decoration: const InputDecoration(
                              hintText: "unit",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF556B2F)),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter unit of measurement (bag, kg, g, etc)";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //^^^Quantity^^^
              //Set Price
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                      child: Text(
                        "Set Price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$ ",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100.sp,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            controller: _priceController,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF556B2F)),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter price";
                              }
                              return null;
                            },
                          ),
                        ),
                        _setUnit == ""
                            ? Text(
                                " / unit",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "  / $_setUnit",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                  ],
                ),
              ),
              //^^^Set Price^^^
              //Label date
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.symmetric(vertical: 5.sp),
              //         child: Text(
              //           "Label date",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 15.sp,
              //           ),
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           SizedBox(
              //             width: 100.sp,
              //             child: TextFormField(
              //               // controller: _priceController,
              //               onChanged: (text) => {},
              //               style: TextStyle(
              //                 fontSize: 12.sp,
              //               ),
              //               decoration: const InputDecoration(
              //                 hintText: "Use-by",
              //                 enabledBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(color: Colors.black),
              //                 ),
              //                 focusedBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(color: Color(0xFF556B2F)),
              //                 ),
              //                 filled: true,
              //               ),
              //             ),
              //           ),
              //           Text(
              //             " : ",
              //             style: TextStyle(
              //                 fontSize: 15.sp, fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(
              //             width: 150.sp,
              //             child: TextFormField(
              //               controller: _labelDateController,
              //               style: TextStyle(
              //                 fontSize: 12.sp,
              //               ),
              //               decoration: const InputDecoration(
              //                 enabledBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(color: Colors.black),
              //                 ),
              //                 focusedBorder: OutlineInputBorder(
              //                   borderSide: BorderSide(color: Color(0xFF556B2F)),
              //                 ),
              //                 labelText: "Enter Date",
              //                 filled: true,
              //               ),
              //               readOnly: true,
              //               onTap: () async {
              //                 DateTime? pickedDate = await showDatePicker(
              //                     context: context,
              //                     initialDate: DateTime.now(),
              //                     firstDate: DateTime.now(),
              //                     lastDate: DateTime(2100));

              //                 if (pickedDate != null) {
              //                   print(pickedDate);

              //                   String formattedDate =
              //                       DateFormat('dd-MM-yyyy').format(pickedDate);
              //                   setState(() {
              //                     _labelDateController.text = formattedDate;
              //                   });
              //                 } else {}
              //               },
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              //^^^Label date^^^

              //Product Description
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.sp),
                        child: Text(
                          "Product Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: 100.sp,
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF556B2F)),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _descriptionController.text = "Delicious food";
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //^^^Product Description^^^

              SizedBox(
                height: 20.sp,
              ),

              //List button
              TextButton(
                onPressed: (() {
                  if (_formKey.currentState!.validate()) {
                    addListing();
                    Navigator.pop(context);
                    showAlertDialog(context);
                  }
                }),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: const Color(0xFF546B2F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20.h),
                  child: Text(
                    "List",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ),

              SizedBox(
                height: 20.sp,
              ),
            ]),
          ),
        )),
      ));
    });
  }

  //Image stuff
  File? displayImage;
  UploadTask? uploadTask;

  Future pickImage(ImageSource source) async {
    try {
      var imageTemp;
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      imageTemp = File(image.path);
      setState(() {
        displayImage = imageTemp;
        uploadPic();
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future uploadPic() async {
    final path = 'files/${displayImage!}';
    final file = File(displayImage!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    imgLink = urlDownload;
    // }
  }

  void isDisplayNull() {
    if (displayImage == null) {
      imgLink =
          "https://firebasestorage.googleapis.com/v0/b/savethisfood.appspot.com/o/files%2FFile%3A%20'%2FUsers%2Fnglinjie%2FLibrary%2FDeveloper%2FCoreSimulator%2FDevices%2FB33116D7-A7A7-4593-90C0-A2A780F07388%2Fdata%2FContainers%2FData%2FApplication%2F5355ACE6-76B8-4872-9B52-004F5718B7BA%2Ftmp%2FFood.png?alt=media&token=9709d44f-84ae-462e-aae6-558175bc99ca";
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: 500.sp,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        const Text(
          "Upload product picture",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Column(
                children: [Icon(Icons.camera), Text("Camera")],
              ),
              onTap: () {
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(
              width: 80,
            ),
            GestureDetector(
              child: Column(
                children: [Icon(Icons.image), Text("Gallery")],
              ),
              onTap: () {
                pickImage(ImageSource.gallery);
              },
            )
          ],
        )
      ]),
    );
  }

  Widget defaultFoodPhoto() {
    return const Image(
      image: AssetImage("assets/img/Food.png"),
    );
  }

  //^^^Image Stuff^^^

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("The item is successfully listed"),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
