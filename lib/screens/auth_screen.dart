import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/exceptions/Http_exception.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/screens/products_screen.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    const gradientColor = Color.fromRGBO(255, 188, 117, 1);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradientColor.withOpacity(0.5),
                  gradientColor.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-5.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  Animation<Offset>? _sliderAnimation;
  Animation<double>? _opasityAnimsation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _sliderAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _controller as AnimationController,
      ),
    );
    _opasityAnimsation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _controller as AnimationController,
      ),
    );
    // _controller!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    // _controller!.dispose();
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Okey.')),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<AuthProvider>(context, listen: false).signin(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        // Sign user up
        await Provider.of<AuthProvider>(context, listen: false).signup(
            _authData['email'] as String, _authData['password'] as String);
      }
      Navigator.of(context).popAndPushNamed(ProductsScreen.routeName);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication faild.';
      if (error.message == 'EMAIL_EXISTS') {
        errorMessage = 'email in use.';
      } else if (error.message == 'EMAIL_NOT_FOUND') {
        errorMessage = 'email not found.';
      } else if (error.message == 'INVALID_PASSWORD') {
        errorMessage = 'invalid password';
      }
      _showError(errorMessage);
    } catch (error) {
      _showError('Somesing wrong!');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? '';
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if ((value?.isEmpty ?? false) || value!.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? '';
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opasityAnimsation as Animation<double>,
                    child: SlideTransition(
                      position: _sliderAnimation as Animation<Offset>,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signup,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
