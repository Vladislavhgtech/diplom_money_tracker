import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

import 'blocs/bloc/costs_bloc.dart';
import 'blocs/bloc/formtype_bloc.dart';
import 'blocs/bloc/profile_bloc.dart';
import 'repositories/costs_repository.dart';
import 'repositories/login_repository.dart';
import 'blocs/bloc/login_bloc.dart';
import 'blocs/bloc/tab_bloc.dart';
import 'widgets/home_page.dart';
import 'widgets/login_page.dart';
import 'styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            loginRepository: LoginRepository(firebase: FirebaseAuth.instance),
          ),
        ),
        BlocProvider<FormTypeBloc>(
          create: (_) => FormTypeBloc(),
        ),
        BlocProvider<TabBloc>(
          create: (_) => TabBloc(),
        ),
        BlocProvider<CostsBloc>(
          create: (_) => CostsBloc(
            costsRepository: CostsRepository(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Final Project',
        theme: ThemeData(
          primarySwatch: customMaterialColorViolet,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else if (snapshot.connectionState == ConnectionState.active) {
              return const LoginPage();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
