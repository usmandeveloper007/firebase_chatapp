import 'package:firebase_chat_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLogin = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Obx(() => Text(isLogin.value ? "Login" : "Sign Up"))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 20),
                authController.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          if (isLogin.value) {
                            authController.login(email, password);
                          } else {
                            authController.register(email, password);
                          }
                        },
                        child: Text(isLogin.value ? "Login" : "Sign Up"),
                      ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () => isLogin.value = !isLogin.value,
                    child: Text(isLogin.value
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login"))
              ],
            )),
      ),
    );
  }
}
