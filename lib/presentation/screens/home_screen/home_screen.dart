import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rx_dart_example_11_firebase/blocs/app_bloc/app_bloc.dart';
import 'package:rx_dart_example_11_firebase/blocs/auth_bloc/auth_error.dart';
import 'package:rx_dart_example_11_firebase/blocs/views_bloc/current_view.dart';
import 'package:rx_dart_example_11_firebase/presentation/screens/contacts_screen/contacts_list_screen.dart';
import 'package:rx_dart_example_11_firebase/presentation/screens/login_screen/login_screen.dart';
import 'package:rx_dart_example_11_firebase/presentation/screens/contacts_screen/new_contanct_screen.dart';
import 'package:rx_dart_example_11_firebase/presentation/screens/register_screen/register_screen.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/dialogs/auth_error_dialog.dart';
import 'package:rx_dart_example_11_firebase/presentation/widgets/loading/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorSub;
  StreamSubscription<bool?>? _isLoadingSub;

  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
  }

  @override
  void dispose() {
    appBloc.dispose();
    _authErrorSub?.cancel();
    _isLoadingSub?.cancel();
    super.dispose();
  }

  void handleAuthErrors(BuildContext context) async {
    await _authErrorSub?.cancel();
    _authErrorSub = appBloc.authError.listen((event) {
      final AuthError? authError = event;
      if (authError == null) return;
      showAuthError(
        authError: authError,
        context: context,
      );
    });
  }

  void setupLoadingScreen(BuildContext context) async {
    await _isLoadingSub?.cancel();
    _isLoadingSub = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        LoadingScreen.instance.show(
          context: context,
          text: 'Loading...',
        );
      } else {
        LoadingScreen.instance.hide();
      }
    });
  }

  Widget getHomeScreen() {
    return StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginScreen(
                  login: appBloc.login,
                  goToRegisterView: appBloc.goToRegisterView,
                );
              case CurrentView.register:
                return RegisterScreen(
                  register: appBloc.register,
                  goToLoginView: appBloc.goToLoginView,
                );
              case CurrentView.contactList:
                return ContactsListScreen(
                  deleteContact: appBloc.deleteContact,
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  createNewContact: appBloc.goToCreateContactView,
                  contacts: appBloc.contacts,
                );
              case CurrentView.createContact:
                return NewContactScreen(
                  createContact: appBloc.createContact,
                  goBack: appBloc.goToContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setupLoadingScreen(context);
    return getHomeScreen();
  }
}
