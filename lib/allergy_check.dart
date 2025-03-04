import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:guardstar/allergy_service.dart';

class AllergyCheckPage extends StatefulWidget {
  final String token;

  const AllergyCheckPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _AllergyCheckPageState createState() => _AllergyCheckPageState();
}

class _AllergyCheckPageState extends State<AllergyCheckPage> {
  final TextEditingController _allergensController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _results;

  Future<void> _handleSearch() async {
    if (_allergensController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter allergens to check')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _results = null;
    });

    try {
      final results = await AllergyService.fetchAllergyResults(
          _allergensController.text.trim());
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget _buildResultSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                item,
                style: const TextStyle(fontSize: 14),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergy Check'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CUSTOMER ALLERGY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _allergensController,
                            decoration: const InputDecoration(
                              hintText: 'Enter allergens',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSearch,
                          child: Text(_isLoading ? 'Searching...' : 'Search'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Results Section
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_results != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResultSection(
                        'RESULTS NOT INCLUDING ALLERGY INGREDIENT',
                        List<String>.from(_results!['safeItems'] ?? []),
                      ),
                      const SizedBox(height: 24),
                      _buildResultSection(
                        'RESULTS INCLUDING ALLERGY INGREDIENT',
                        List<String>.from(_results!['unsafeItems'] ?? []),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _allergensController.dispose();
    super.dispose();
  }
}
