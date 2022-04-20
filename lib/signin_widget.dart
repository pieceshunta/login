import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/utils.dart';

class SignInWidget extends StatefulWidget {
  SignInWidget({Key? key, required this.onClickedSignUp}) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<SignInWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignInWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'メールアドレス'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? '有効なメールアドレスを入力してください'
                          : null),
              const SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? '6文字以上のパスワードを入力してください'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: signIn,
                icon: const Icon(
                  Icons.lock_open,
                  size: 22,
                ),
                label: const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: 'アカウントを持っていませんか?',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: '会員登録',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
