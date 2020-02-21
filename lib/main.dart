// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_app/MaskInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future<MaskInfo> futureMaskInfo;

  @override
  void initState() {
    super.initState();
    futureMaskInfo = fetchMaskInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taiwan Mask Info',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Taiwan Mask Info'),
        ),
        body: Center(
            child: FutureBuilder<MaskInfo>(
          future: futureMaskInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Feature> data = snapshot.data.features;
              return _maskInfoListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

ListView _maskInfoListView(List<Feature> data) {
  return ListView.separated(
      separatorBuilder: (context, index) => Divider(color: Colors.black38),
      itemCount: 100,
      itemBuilder: (context, index) {
        return _buildRow(
            data[index].properties.name,
            data[index].properties.address,
            data[index].properties.phone,
            data[index].properties.maskAdult,
            data[index].properties.maskChild);
      });
}

Widget _buildRow(
    String name, String address, String phone, int maskAdult, int maskChild) {
  return _MaskDescription(
      name: name,
      address: address,
      phone: phone,
      maskAdult: maskAdult,
      maskChild: maskChild);
}

class _MaskDescription extends StatelessWidget {
  const _MaskDescription(
      {Key key,
      this.name,
      this.address,
      this.phone,
      this.maskAdult,
      this.maskChild})
      : super(key: key);

  final String name;
  final String address;
  final String phone;
  final int maskAdult;
  final int maskChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Address: $address',
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w300),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Phone: $phone',
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w300),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Audlt Mask: $maskAdult',
            style: const TextStyle(fontSize: 14.0, color: Colors.blue),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Child Mask: $maskChild',
            style: const TextStyle(fontSize: 14.0, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

Future<MaskInfo> fetchMaskInfo() async {
  final response = await http.get(
      'https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json');
  if (response.statusCode == 200) {
    return MaskInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load mask info');
  }
}
