import 'package:auto_route/auto_route.dart';
import 'package:flutter_todo_application/routes/guard/auth_guard.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        /// Initial Route
        AutoRoute(page: HomeRoute.page, initial: true),

        /// Login Route
        AutoRoute(page: LoginRoute.page),

        /// Protected Route
        AutoRoute(page: ToDoHome.page, guards: [AuthGuard()]),
      ];
}
