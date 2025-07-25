import 'package:flutter/material.dart';
import 'package:storage_sisecam/system.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storage_sisecam/models/stock_log.dart';
import 'package:storage_sisecam/services/stock_data.dart';
import 'package:storage_sisecam/models/project.dart';
import 'package:storage_sisecam/models/user.dart';
import 'package:storage_sisecam/models/idle_product.dart';
import 'package:storage_sisecam/models/idle_product_request_log.dart';
import 'package:storage_sisecam/models/idle_product_request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StockLogAdapter());
  Hive.registerAdapter(StockDataAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(IdleProductAdapter());
  Hive.registerAdapter(IdleProductRequestLogAdapter());
  Hive.registerAdapter(IdleProductRequestAdapter());

  await Hive.openBox<IdleProduct>('idle_products');
  await Hive.openBox<IdleProductRequest>('product_requests');
  await Hive.openBox<IdleProductRequestLog>('idle_product_requests');
  await Hive.openBox<StockLog>('stock_logs');
  await Hive.openBox<StockData>('stock_data');
  await Hive.openBox<Project>('projects');
  await Hive.openBox<User>('users');
  await Hive.openBox('session');


  runApp(const System());
}

