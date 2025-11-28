import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (_) => TaskProvider(),
          update: (_, authProvider, taskProvider) {
            taskProvider ??= TaskProvider();
            taskProvider.updateAuth(authProvider);
            return taskProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
