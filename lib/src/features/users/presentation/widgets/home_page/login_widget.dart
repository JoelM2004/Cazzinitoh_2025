import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart'; // <-- colores desde acá
import 'package:cazzinitoh_2025/src/features/shared/widgets/app_alert.dart'; // <-- nuevo widget
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/register_user/register_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/login_user/login_user_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showPassword = false;

  final _loginEmailController    = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerEmailController    = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController  = TextEditingController();

  final _loginFormKey    = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<LoginUserBloc>().add(
        LoginUser(
          email: _loginEmailController.text,
          password: _loginPasswordController.text,
        ),
      );
    }
  }

  void _handleRegister() {
    if (_registerFormKey.currentState!.validate()) {
      final password        = _registerPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (password != confirmPassword) {
        AppAlert.show(
          context,
          type: AlertType.error,
          title: 'Error',
          message: 'Las contraseñas no coinciden',
        );
        return;
      }

      context.read<RegisterUserBloc>().add(
        RegisterUser(
          email: _registerEmailController.text,
          password: password,
        ),
      );
    }
  }

  // ─── Campos de texto reutilizables ────────────────────────────────────────
  InputDecoration _inputDecoration({
    required String hint,
    Color focusColor = AppColors.purpleBorder,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
      filled: true,
      fillColor: AppColors.purpleCardBorder.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: focusColor),
      ),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.purpleBackground, // gray-900
              AppColors.purple900,        // purple-900
              AppColors.purpleBackground, // gray-900
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo ──────────────────────────────────────────────
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(
                          color: AppColors.purpleBorder,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purpleGlow.withOpacity(0.25),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(46),
                        child: Image.network(
                          'https://img.redbull.com/images/c_crop,x_1007,y_0,h_2646,w_1985/c_fill,w_450,h_600/q_auto,f_auto/redbullcom/2024/11/24/nrqoxx9as35r5ry8ashm/max-verstapen-2024-f1-world-champion-four',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF4b5563),
                            child: const Icon(Icons.person, size: 48, color: Color(0xFF9ca3af)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Memory Trip',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Entra al gran desafío',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 32),

                    // ── Card ──────────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.purpleCard.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.purpleCardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 25,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ── Tabs ────────────────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.purpleCardBorder.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Expanded(child: _buildTab(0, 'Iniciar Sesión', AppColors.purplePrimary)),
                                const SizedBox(width: 4),
                                Expanded(child: _buildTab(1, 'Registrarse', AppColors.red700)),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 450,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildLoginTab(),
                                _buildRegisterTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Footer ────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Problemas para acceder? ',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        GestureDetector(
                          onTap: () => AppAlert.show(
                            context,
                            type: AlertType.warning,
                            title: 'Próximamente',
                            message: 'Función de recuperación no implementada',
                          ),
                          child: const Text(
                            'Recuperar cuenta',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.purpleAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Tab selector ─────────────────────────────────────────────────────────
  Widget _buildTab(int index, String label, Color activeColor) {
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (_, __) => Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _tabController.index == index ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _tabController.index == index ? Colors.white : const Color(0xFF9ca3af),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Login tab ────────────────────────────────────────────────────────────
  Widget _buildLoginTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield, color: AppColors.purpleAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Ingresa tus credenciales para acceder', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                const SizedBox(height: 24),

                // Email
                _fieldLabel('Correo Electrónico'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: _inputDecoration(hint: 'tu@email.com'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Por favor ingresa tu email';
                    if (!v.contains('@')) return 'Ingresa un email válido';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                _fieldHint('Introduce tu dirección de correo electrónico'),
                const SizedBox(height: 24),

                // Password
                _fieldLabel('Contraseña'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _loginPasswordController,
                  obscureText: !_showPassword,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: _inputDecoration(
                    hint: '••••••••',
                    suffix: IconButton(
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Por favor ingresa tu contraseña';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                _fieldHint('Introduce tu contraseña secreta'),
                const SizedBox(height: 24),

                // Botón con BlocListener
                BlocListener<LoginUserBloc, LoginUserState>(
                  listener: (context, state) {
                    if (state is LoginUserSuccess) {
                      if (state.user) {
                        AppAlert.show(
                          context,
                          type: AlertType.success,
                          title: '¡Bienvenido!',
                          message: 'Inicio de sesión exitoso',
                        );
                        Future.microtask(() {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacementNamed(AppRoutes.menu);
                        });
                      } else {
                        AppAlert.show(
                          context,
                          type: AlertType.error,
                          title: 'Acceso denegado',
                          message: 'Email o contraseña incorrectos',
                        );
                      }
                    } else if (state is LoginUserFailure) {
                      AppAlert.show(
                        context,
                        type: AlertType.error,
                        title: 'Error',
                        message: state.failure.toString(),
                      );
                    }
                  },
                  child: BlocBuilder<LoginUserBloc, LoginUserState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is LoginUserLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purplePrimary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: AppColors.purpleGlow.withOpacity(0.25),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: state is LoginUserLoading
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shield, size: 20),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Entrar al Desafío',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Register tab ─────────────────────────────────────────────────────────
  Widget _buildRegisterTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _registerFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.security, color: AppColors.red400, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Crea tu cuenta de guerrero', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
              const SizedBox(height: 24),

              // Email
              _fieldLabel('Correo Electrónico'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _registerEmailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: _inputDecoration(hint: 'tu@email.com', focusColor: AppColors.red500),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Por favor ingresa tu email';
                  if (!v.contains('@')) return 'Ingresa un email válido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              _fieldHint('Tu dirección de correo será tu identificador único'),
              const SizedBox(height: 24),

              // Password
              _fieldLabel('Contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _registerPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: _inputDecoration(hint: '••••••••', focusColor: AppColors.red500),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Por favor ingresa una contraseña';
                  if (v.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              _fieldHint('Mínimo 8 caracteres para mayor seguridad'),
              const SizedBox(height: 24),

              // Confirm Password
              _fieldLabel('Confirmar Contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: _inputDecoration(hint: '••••••••', focusColor: AppColors.red500),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Por favor confirma tu contraseña';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              _fieldHint('Debe coincidir con la contraseña anterior'),
              const SizedBox(height: 24),

              // Botón con BlocListener
              BlocListener<RegisterUserBloc, RegisterUserState>(
                listener: (context, state) {
                  if (state is RegisterUserSuccess) {
                    if (state.user) {
                      AppAlert.show(
                        context,
                        type: AlertType.success,
                        title: '¡Registro exitoso!',
                        message: 'Ya puedes iniciar sesión.',
                      );
                      _tabController.animateTo(0);
                      _registerEmailController.clear();
                      _registerPasswordController.clear();
                      _confirmPasswordController.clear();
                    } else {
                      AppAlert.show(
                        context,
                        type: AlertType.error,
                        title: 'Error en el registro',
                        message: 'Intenta nuevamente.',
                      );
                    }
                  } else if (state is RegisterUserFailure) {
                    AppAlert.show(
                      context,
                      type: AlertType.error,
                      title: 'Error',
                      message: state.failure.toString(),
                    );
                  }
                },
                child: BlocBuilder<RegisterUserBloc, RegisterUserState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state is RegisterUserLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red700,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: AppColors.red500.withOpacity(0.25),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: state is RegisterUserLoading
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.security, size: 16),
                                  SizedBox(width: 8),
                                  Text('Unirse al Desafío', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers de texto ─────────────────────────────────────────────────────
  Widget _fieldLabel(String text) => Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
      );

  Widget _fieldHint(String text) => Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
      );
}