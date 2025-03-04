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
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: 'zh',
              child: Text('中文'),
            ),
            DropdownMenuItem(
              value: 'pl',
              child: Text('Polski'),
            ),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              languageProvider.changeLanguage(newValue);
            }
          },
        );
      },
    );
  }
}
