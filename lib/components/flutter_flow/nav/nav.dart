import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phrase_flow_components/app/home/home_page.dart';
import 'package:phrase_flow_components/app/intro_app/intro_app_widget.dart';
import 'package:phrase_flow_components/app/login_page/createaccount/createaccount_widget.dart';
import 'package:phrase_flow_components/app/login_page/login_widget.dart';
import 'package:phrase_flow_components/app/profile04/profile04_widget.dart';
import 'package:phrase_flow_components/app/profile04/update_profile/update_profile_page.dart';
import 'package:phrase_flow_components/app/services/questionary/answer_idea2/answer_idea2_widget.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_home/questionary_page.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_tipe_select_image/questionary_tipe_select_image_widget.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_type_select_option/questionary_type_select_option_widget.dart';
import 'package:phrase_flow_components/app/services/timelineatividade/timelineatividade_widget.dart';
import 'package:phrase_flow_components/app/success_page/success_page_widget.dart';
import 'package:provider/provider.dart';

import '../flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.black,
                child: Image.asset(
                  'assets/images/image-removebg-preview.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : IntroAppWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.black,
                    child: Image.asset(
                      'assets/images/image-removebg-preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : IntroAppWidget(),
          routes: [
            FFRoute(
              name: 'acompanhamenttodasatividades',
              path: 'acompanhamenttodasatividades',
              builder: (context, params) =>
                  AcompanhamenttodasatividadesWidget(),
            ),
            FFRoute(
              name: 'Profile04',
              path: 'profile04',
              builder: (context, params) => Profile04Widget(),
            ),
            FFRoute(
              name: 'SuccessPage',
              path: 'successPage',
              builder: (context, params) => SuccessPageWidget(),
            ),
            FFRoute(
              name: 'answer_idea2',
              path: 'answerIdea2',
              builder: (context, params) => AnswerIdea2Widget(),
            ),
            FFRoute(
              name: 'Timelineatividade',
              path: 'timelineatividade',
              builder: (context, params) => TimelineatividadeWidget(),
            ),
            FFRoute(
              name: 'IntroAppWidget',
              path: 'IntroAppWidget',
              builder: (context, params) => IntroAppWidget(),
            ),
            FFRoute(
              name: 'loginPage',
              path: 'loginPage',
              builder: (context, params) => LoginWidget(),
            ),
            FFRoute(
              name: 'questionaryTypeSelectOption',
              path: 'questionaryTypeSelectOption',
              builder: (context, params) => QuestionaryTypeSelectOptionWidget(),
            ),
            FFRoute(
              name: 'createaccount',
              path: 'createaccount',
              builder: (context, params) => CreateaccountWidget(),
            ),
            FFRoute(
              name: 'questionaryTipeSelectImage',
              path: 'questionaryTipeSelectImage',
              builder: (context, params) => QuestionaryTipeSelectImageWidget(),
            ),
            FFRoute(
              name: 'questionaryTypeWriteWidget',
              path: 'questionaryTypeWriteWidget',
              builder: (context, params) => QuestionarioTipos(),
            ),
            FFRoute(
              name: 'updateAccount',
              path: 'updateAccount',
              builder: (context, params) => UpdateAccount(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    List<String>? collectionNamePath,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(param, type, isList,
        collectionNamePath: collectionNamePath);
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}