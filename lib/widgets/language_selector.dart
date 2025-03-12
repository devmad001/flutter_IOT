import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return DropdownButton<String>(
          value: languageProvider.currentLocale.languageCode,
          onChanged: (String? newValue) {
            if (newValue != null) {
              languageProvider.changeLanguage(newValue);
            }
          },
          items: const [
            DropdownMenuItem<String>(
              value: 'en',
              child: Text('English'),
            ),
            DropdownMenuItem<String>(
              value: 'zh',
              child: Text('中文'),
            ),
            DropdownMenuItem<String>(
              value: 'pl',
              child: Text('Polski'),
            ),
            DropdownMenuItem<String>(
              value: 'it',
              child: Text('Italiano'),
            ),
            DropdownMenuItem<String>(
              value: 'tr',
              child: Text('Türkçe'),
            ),
          ],
        );
      },
    );
  }
}
