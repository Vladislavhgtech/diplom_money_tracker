import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/form_type_event.dart';
import '../blocs/events/login_event.dart';
import '../blocs/bloc/formtype_bloc.dart';
import '../blocs/bloc/login_bloc.dart';
import '../blocs/states/form_type_state.dart';
import '../blocs/states/login_state.dart';
import '../models/form_type.dart';
import '../styles/consts.dart';
import '../styles/colors.dart';
import '../widgets/loading_indicator.dart';
import 'head_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final FocusNode focusEmail = FocusNode()..addListener(() {
    setState(() {});
  });
  late final FocusNode focusPassword = FocusNode()..addListener(() {
    setState(() {});
  });


  final styleBorderFocus = UnderlineInputBorder(
    borderSide: BorderSide(
      color: customColorViolet,
    ),
  );

  final styleBorderEnable = UnderlineInputBorder(
    borderSide: BorderSide(
      color: customColorGrey,
    ),
  );

  @override
  void dispose() {
    focusEmail.dispose();
    focusPassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error.name),
                  backgroundColor: customColorViolet,
                )
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const HeadLogin(),
                    BlocBuilder<FormTypeBloc, FormTypeState>(
                        builder: (context, state) {
                      return Column(
                          children: [
                            loginDetails(state is SignIn ? FormType.signIn : FormType.signUp),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 180,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state is SignUp
                                        ? 'Уже есть аккаунт?'
                                        : 'Еще нет аккаунта? ',
                                  ),
                                  TextButton(
                                    key: const Key('buttonSignInOrSignUp'),
                                    onPressed: () {
                                      BlocProvider.of<FormTypeBloc>(context).add(
                                        FormTypeRequested(state is SignIn
                                            ? FormType.signIn
                                            : FormType.signUp),
                                      );
                                    }, // _switchForm,
                                    child: Text(
                                      state is SignUp ? 'Войти' : 'Регистрация',
                                      style: TextStyle(
                                        color: customColorViolet,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginDetails(FormType formType) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: const Key('fieldEmail'),
            controller: _emailController,
            validator: (value) {
              if (value == '') return 'Введите e-mail';
              if (!validateEmail(value ?? '')) {
                return 'Поле e-mail заполнено не корректно';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            focusNode: focusEmail,
            decoration: InputDecoration(
              labelText: 'E-mail',
              labelStyle: TextStyle(
                  color: focusEmail.hasFocus ? customColorViolet : customColorGrey),
              focusedBorder: styleBorderFocus,
              enabledBorder: styleBorderEnable,
            ),
          ),
          TextFormField(
            key: const Key('fieldPassword'),
            controller: _passwordController,
            validator: (value) {
              if (value == '') return 'Введите пароль';
              return null;
            },
            focusNode: focusPassword,
            decoration: InputDecoration(
              labelText: 'Пароль',
              labelStyle: TextStyle(
                  color: focusPassword.hasFocus ? customColorViolet : customColorGrey),
              focusedBorder: styleBorderFocus,
              enabledBorder: styleBorderEnable,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            return loginButton(state is Loading ? true : false, formType);
          }),
        ],
      ),
    );
  }

  Widget loginButton(bool isLoading, FormType formType) {
    return ElevatedButton(
      key: const Key('buttonLogin'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50.0),
        primary: isLoading ? customColorGrey : customColorViolet,
        onPrimary: customColorWhite,
        textStyle: const TextStyle(fontSize: 17),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onPressed: () {
        if (!isLoading) {
          if (_formKey.currentState!.validate()) {
            formType == FormType.signIn
                ? BlocProvider.of<LoginBloc>(context).add(
              SignInRequested(_emailController.text, _passwordController.text),
            )
                : BlocProvider.of<LoginBloc>(context).add(
              SignUpRequested(_emailController.text, _passwordController.text),
            );
          }
        }
      },
      child: isLoading
          ? const LoadingIndicator()
          : Text(formType == FormType.signIn ? 'Войти' : 'Регистрация'),
    );
  }

}
