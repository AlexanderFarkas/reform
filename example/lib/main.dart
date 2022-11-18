import 'package:reform/reform.dart';
import 'package:example/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: BlocProvider(
              create: (context) => MainCubit(),
              child: BlocBuilder<MainCubit, MainState>(
                builder: (context, state) {
                  final cubit = context.watch<MainCubit>();
                  return ReformScope(
                    shouldShowError: (field, fieldState) =>
                        state.isSubmittedOnce || fieldState.wasEverUnfocused,
                    child: Column(
                      children: [
                        state.usernameField.builder(
                          builder: (context, controller, errorText) =>
                              TextField(
                            controller: controller,
                            decoration: InputDecoration(errorText: errorText),
                            onChanged: cubit.onUsernameChanged,
                          ),
                        ),
                        state.passwordField.builder(
                          builder: (context, controller, error) => TextField(
                            controller: controller,
                            decoration: InputDecoration(errorText: error),
                            onChanged: cubit.onPasswordChanged,
                          ),
                        ),
                        state.repeatPasswordField.builder(
                          builder: (context, controller, error) => TextField(
                            controller: controller,
                            decoration: InputDecoration(errorText: error),
                            onChanged: cubit.onRepeatPasswordChanged,
                          ),
                        ),
                        state.ageField.builder(
                          builder: (context, value, error) => Row(
                            children: [
                              ElevatedButton(
                                onPressed: cubit.onAgeDecrement,
                                child: Text("-"),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "$value",
                                      textAlign: TextAlign.center,
                                    ),
                                    if (error != null)
                                      Text(
                                        "$error",
                                        style: TextStyle(color: Colors.red),
                                      )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: cubit.onAgeIncrement,
                                child: Text("+"),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: cubit.submit,
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
