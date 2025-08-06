import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/pages/register/bloc/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late RegisterBloc _registerBloc;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get isPopulated =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty &&
      _confirmPasswordController.text.trim().isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return _getValidationPercentage(state) && isPopulated;
  }

  Widget _buildSuffixIcon(bool isValid, bool hasContent) {
    if (!hasContent) {
      return Icon(Icons.circle_outlined, color: Colors.grey[400], size: 20);
    }
    return Icon(
      isValid ? Icons.check_circle : Icons.error,
      color: isValid ? Colors.green : Colors.red,
      size: 20,
    );
  }

  int _getCompletionPercentage() {
    int completedFields = 0;
    int totalFields = 5;

    if (_firstNameController.text.trim().isNotEmpty) completedFields++;
    if (_lastNameController.text.trim().isNotEmpty) completedFields++;
    if (_emailController.text.trim().isNotEmpty) completedFields++;
    if (_passwordController.text.trim().isNotEmpty) completedFields++;
    if (_confirmPasswordController.text.trim().isNotEmpty) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }

  bool _getValidationPercentage(RegisterState state) {
    int validFields = 0;
    int totalFields = 5;

    if (_firstNameController.text.trim().isNotEmpty) validFields++;
    if (_lastNameController.text.trim().isNotEmpty) validFields++;
    if (state.isEmailValid && _emailController.text.trim().isNotEmpty)
      validFields++;
    if (state.isPasswordValid && _passwordController.text.trim().isNotEmpty)
      validFields++;
    if (state.passwordsMatch &&
        _confirmPasswordController.text.trim().isNotEmpty)
      validFields++;

    return validFields == totalFields;
  }

  Widget _buildRequirementItem(String text, bool isCompleted) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isCompleted ? Colors.green[700] : Colors.grey[600],
                fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.grey),
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Container(
                        width: 64, // Same total width as eye + checkmark
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 24,
                          child: _buildSuffixIcon(
                            _firstNameController.text.trim().isNotEmpty,
                            _firstNameController.text.trim().isNotEmpty,
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.grey),
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Container(
                        width: 64, // Same total width as eye + checkmark
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 24,
                          child: _buildSuffixIcon(
                            _lastNameController.text.trim().isNotEmpty,
                            _lastNameController.text.trim().isNotEmpty,
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.grey),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Container(
                        width: 64, // Same total width as eye + checkmark
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 24,
                          child: _buildSuffixIcon(
                            state.isEmailValid,
                            _emailController.text.trim().isNotEmpty,
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.grey),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            child: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 24,
                            child: _buildSuffixIcon(
                              state.isPasswordValid,
                              _passwordController.text.trim().isNotEmpty,
                            ),
                          ),
                        ],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.grey),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            child: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 24,
                            child: _buildSuffixIcon(
                              state.passwordsMatch &&
                                  _confirmPasswordController.text
                                      .trim()
                                      .isNotEmpty,
                              _confirmPasswordController.text.trim().isNotEmpty,
                            ),
                          ),
                        ],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    autocorrect: false,
                    validator: (_) {
                      return !state.passwordsMatch
                          ? 'Passwords don\'t match'
                          : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        // Requirements checklist
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requirements:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8),
                              _buildRequirementItem(
                                'First name filled',
                                _firstNameController.text.trim().isNotEmpty,
                              ),
                              _buildRequirementItem(
                                'Last name filled',
                                _lastNameController.text.trim().isNotEmpty,
                              ),
                              _buildRequirementItem(
                                'Valid email address',
                                state.isEmailValid &&
                                    _emailController.text.trim().isNotEmpty,
                              ),
                              _buildRequirementItem(
                                'Valid password (8+ chars, 1 uppercase, 1 number)',
                                state.isPasswordValid &&
                                    _passwordController.text.trim().isNotEmpty,
                              ),
                              _buildRequirementItem(
                                'Passwords match',
                                state.passwordsMatch &&
                                    _confirmPasswordController.text
                                        .trim()
                                        .isNotEmpty,
                              ),
                            ],
                          ),
                        ),
                        // Progress indicator showing completion
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Form completion: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${_getCompletionPercentage()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _getCompletionPercentage() == 100
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isRegisterButtonEnabled(state)
                                    ? Colors.orange
                                    : Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed:
                              isRegisterButtonEnabled(state)
                                  ? () => _onFormSubmitted()
                                  : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isRegisterButtonEnabled(state))
                                Icon(
                                  Icons.lock,
                                  size: 18,
                                  color: Colors.white54,
                                ),
                              if (!isRegisterButtonEnabled(state))
                                SizedBox(width: 8),
                              Text(
                                isRegisterButtonEnabled(state)
                                    ? 'Register'
                                    : 'Complete all fields',
                                style: TextStyle(
                                  color:
                                      isRegisterButtonEnabled(state)
                                          ? Colors.white
                                          : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    // Trigger a rebuild to update button state
    setState(() {});
  }

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.add(
      ConfirmPasswordChanged(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _onFormSubmitted() {
    if (_formKey.currentState!.validate()) {
      _registerBloc.add(
        Submitted(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPass: _confirmPasswordController.text,
        ),
      );
    }
  }
}
