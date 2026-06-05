import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/shared_widgets.dart';
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

  final _loginEmailController       = TextEditingController();
  final _loginPasswordController    = TextEditingController();
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
      context.read<RegisterUserBloc>().add(
        RegisterUser(
          email: _registerEmailController.text,
          password: _registerPasswordController.text,
        ),
      );
    }
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
              AppColors.purpleBackground,
              AppColors.purple900,
              AppColors.purpleBackground,
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
                    // ── Logo ─────────────────────────────────────────────
                    AppAvatar(
                      imageUrl: 'https://img.redbull.com/images/c_crop,x_1007,y_0,h_2646,w_1985/c_fill,w_450,h_600/q_auto,f_auto/redbullcom/2024/11/24/nrqoxx9as35r5ry8ashm/max-verstapen-2024-f1-world-champion-four',
                      size: 96,
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

                    // ── Card ─────────────────────────────────────────────
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
                          // ── Tabs ─────────────────────────────────────
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
                            height: 430,
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
                Text(
                  'Ingresá tus credenciales para acceder',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),

                AppEmailField(controller: _loginEmailController),
                const SizedBox(height: 20),

                AppPasswordField(
                  controller: _loginPasswordController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 28),

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
                    builder: (context, state) => AppButton.primary(
                      label: 'Entrar al Desafío',
                      icon: Icons.shield_rounded,
                      onPressed: state is LoginUserLoading ? null : _handleLogin,
                      isLoading: state is LoginUserLoading,
                    ),
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
              Text(
                'Creá tu cuenta de guerrero',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),

              AppEmailField(
                controller: _registerEmailController,
                focusBorderColor: AppColors.red500,
              ),
              const SizedBox(height: 20),

              AppPasswordField.register(
                controller: _registerPasswordController,
                accentColor: AppColors.red500,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              AppPasswordField.confirm(
                controller: _confirmPasswordController,
                original: _registerPasswordController,
                accentColor: AppColors.red500,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleRegister(),
              ),
              const SizedBox(height: 28),

              BlocListener<RegisterUserBloc, RegisterUserState>(
                listener: (context, state) {
                  if (state is RegisterUserSuccess) {
                    if (state.user) {
                      AppAlert.show(
                        context,
                        type: AlertType.success,
                        title: '¡Registro exitoso!',
                        message: 'Ya podés iniciar sesión.',
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
                        message: 'Intentá nuevamente.',
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
                  builder: (context, state) => AppButton.destructive(
                    label: 'Unirse al Desafío',
                    icon: Icons.security_rounded,
                    onPressed: state is RegisterUserLoading ? null : _handleRegister,
                    isLoading: state is RegisterUserLoading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}