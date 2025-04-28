import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // height: double.infinity,
      height: SizeConfig.screenHeight * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 100, color: Colors.redAccent),
          SizedBox(height: 20),
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Center(
              child: Text(
                'This app need internet to work so please connect to the internet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
