import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:guardstar/sidebar_layout.dart';
import 'package:guardstar/allergy_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (_allergensController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterAllergens)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _results = null;
    });
    print(widget.token);
    try {
      final results = await AllergyService.fetchAllergyResults(
          _allergensController.text.trim(), widget.token);
      setState(() {
        _results = results;
        print(_results);
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

  Widget _buildResultSection(String title, List<Object> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                (item as Map<String, dynamic>)['name'],
                style: const TextStyle(fontSize: 14),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 46.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.customerAllergy,
                      style: const TextStyle(
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
                            decoration: InputDecoration(
                              hintText: l10n.enterAllergens,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSearch,
                          child:
                              Text(_isLoading ? l10n.searching : l10n.search),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_results != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResultSection(
                        l10n.safeItems,
                        List<Object>.from(
                            _results!['dishesWithAllergens'] ?? []),
                        Colors.green,
                      ),
                      const SizedBox(height: 24),
                      _buildResultSection(
                        l10n.unsafeItems,
                        List<Object>.from(
                            _results!['dishesWithoutAllergens'] ?? []),
                        Colors.red,
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
