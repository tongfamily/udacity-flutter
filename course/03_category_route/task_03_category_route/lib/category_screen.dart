// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:task_03_category_route/category.dart';

// TODO: Check if we need to import anything

// TODO: Define any constants
final _backgroundColor = Colors.green[100];
/// Category Screen, the destination for a route, changed from base code to be clearer
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// Was renamed to CategoryScreen While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen();

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Create a list of the eight Categories, using the names and colors
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.

    // Note how much readable this style is when you don't embed everything
    // but it require many more holding place names, here we create a
    // simple list of the custom categories and populate it
    final categories = <Category>[];

    // Now iterate through the names and fill in each list item
    for (var i = 0; i < _categoryNames.length; i++) {
      categories.add(Category(
          name: _categoryNames[i],
          color: _baseColors[i],
          iconLocation: Icons.cake));
    }
    ;

    // now use the builder to call each of the categories and place
    // them into the list
    final listView = ListView.builder(
      itemBuilder: (BuildContext context, int i) => categories[i],
      itemCount: categories.length,
    );

    // Now make a pretty AppBar
    final appBar = AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: _backgroundColor,
      title: Text(
        'Unit Convert',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
          color: _backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: listView),
    );
  }
}
