import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:provider/provider.dart';
import 'package:guardstar/providers/socket_provider.dart';
import 'package:guardstar/providers/sensor_data_provider.dart';
import 'package:guardstar/providers/alertsensor_data_provider.dart';
import 'package:guardstar/providers/checklistalert_data_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  // Create an instance of FlutterSecureStorage
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  Future<void> _checkLoggedIn() async {
    final token = await _secureStorage.read(key: 'token');
    if (token != null) {
      // Initialize socket connection
      final socketProvider =
          Provider.of<SocketProvider>(context, listen: false);
      final sensorDataProvider =
          Provider.of<SensorDataProvider>(context, listen: false);
      final alertsensorDataProvider =
          Provider.of<AlertSensorDataProvider>(context, listen: false);
      final checklistalertDataProvider =
          Provider.of<ChecklistAlertDataProvider>(context, listen: false);
      socketProvider.initSocket(token,
          sensorDataProvider: sensorDataProvider,
          alertsensorDataProvider: alertsensorDataProvider,
          checklistalertDataProvider: checklistalertDataProvider);

      // Token found, navigate directly to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SidebarLayout(
            token: token,
            content: HomeScreen(token: token),
            title: 'HOME',
          ),
        ),
      );
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter your username and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _showMessage("Login Successful");
        final token = responseData['token'];
        final userid = responseData['userid'];

        // Initialize socket connection
        final socketProvider =
            Provider.of<SocketProvider>(context, listen: false);
        final sensorDataProvider =
            Provider.of<SensorDataProvider>(context, listen: false);
        final alertsensorDataProvider =
            Provider.of<AlertSensorDataProvider>(context, listen: false);
        final checklistalertDataProvider =
            Provider.of<ChecklistAlertDataProvider>(context, listen: false);
        socketProvider.initSocket(token,
            sensorDataProvider: sensorDataProvider,
            alertsensorDataProvider: alertsensorDataProvider,
            checklistalertDataProvider: checklistalertDataProvider);

        // Store token securely
        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'userid', value: userid);
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SidebarLayout(
              token: token,
              content: HomeScreen(token: token),
              title: 'HOME',
            ),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showMessage(errorData['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      print(e);
      _showMessage('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2E70), // Updated background color
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.jpeg',
                  height: 100,
                ),

                const SizedBox(height: 40),

                // USERNAME TextField
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'USERNAME',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // PASSWORD TextField
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // LOGIN Button
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
