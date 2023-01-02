import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tp_flutter_3/constants.dart';
import 'package:tp_flutter_3/login_screen.dart';

import 'items_list_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  var supabaseKey = dotenv.env['SUPABASE_KEY'].toString();
  var supabaseUrl = dotenv.env['SUPABASE_URL'].toString();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final currentSession = supabase.auth.currentSession;
  final user = supabase.auth.currentUser;

  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    if (currentSession != null && user != null) {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Material App
      debugShowCheckedModeBanner: false,
      title: "Login App",
      home: _isAuthenticated ? const ItemsListScreen() : const LoginScreen(),
    );
  }
}
