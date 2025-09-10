import 'package:flutter/material.dart';

class CurrencyRegionsScreen extends StatelessWidget {
  const CurrencyRegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Regions')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://img.freepik.com/free-vector/illustration-usa-flag_53876-18165.jpg?size=626&ext=jpg&ga=GA1.1.1890433774.1683978738&semt=ais',
                      width: 50,
                      height: 40,
                      // fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 14),
                    // it was 18 px as font size before
                    Text('United States (\$)', style: textTheme.titleMedium),
                    const Spacer(),
                    Icon(Icons.done, color: theme.appBarTheme.backgroundColor),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const Divider(height: 0),
            ],
          );
        },
      ),
    );
  }
}
