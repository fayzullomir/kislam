import 'dart:io';

double get appBarHeight => Platform.isIOS ? 56 : 56;

double get bottomBarHeight => Platform.isIOS ? 64 : 64;

double get tabBarHeight => Platform.isIOS ? 42 : 42;

double get defaultBottomPadding => Platform.isIOS ? 64 : 42;
