import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassesScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/CreateTeamScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/View/HomeScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/PartnerSchools/View/PartnerSchoolsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/StudentPaymentDetails/View/StudentPaymentDetailsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/View/StudentsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeacherDetails/View/TeacherDetailsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsScreen.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/TeamsAulasScreen.dart';
import '../Common/Features/UserMatches/View/UserMatchesScreen.dart';
import '../Common/Model/City.dart';
import '../Common/Model/Court.dart';
import '../Common/Model/Hour.dart';
import '../Common/Model/Sport.dart';
import '../Sandfriends/Features/AppInfo/View/AppInfoScreen.dart';
import '../Sandfriends/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import '../Sandfriends/Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import '../Sandfriends/Features/Authentication/LoadLogin/View/LoadLoginScreen.dart';
import '../Sandfriends/Features/Authentication/Login/View/LoginScreen.dart';
import '../Sandfriends/Features/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import '../Sandfriends/Features/Checkout/View/CheckoutScreen.dart';
import '../Sandfriends/Features/Notifications/View/NotificationsScreen.dart';
import '../Sandfriends/Features/Onboarding/View/OnboardingScreen.dart';
import '../Sandfriends/Features/RecurrentMatchSearch/View/RecurrentMatchSearchScreen.dart';
import '../SandfriendsQuadras/Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';
import '../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../Common/Model/HourPrice/HourPriceUser.dart';
import '../Common/Features/Court/View/CourtScreen.dart';
import '../Common/Features/Match/View/MatchScreen.dart';
import '../Common/Features/UserDetails/View/UserDetailsScreen.dart';
import '../Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';

class SandfriendsAulasApp extends GenericApp {
  SandfriendsAulasApp({
    super.key,
    required super.flavor,
  });

  @override
  String get appTitle => "Sandfriends Aulas";
  @override
  Product get product => Product.SandfriendsAulas;

  @override
  Function(Uri) get handleLink => (uri) {
        String emailConfirmation = "/confirme-seu-email/";
        String match = "/partida/";
        String court = "/quadra/";
        String changePassword = '/troca-senha/'; //change password

        if (uri.path.startsWith(match)) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return LoadLoginScreen(
                  redirectUri: uri.path,
                );
              },
            ),
          );
        } else if (uri.path.startsWith(emailConfirmation)) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return EmailConfirmationScreen(
                  confirmationToken: uri.path.split(emailConfirmation)[1],
                );
              },
            ),
          );
        } else if (uri.path.startsWith(court)) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return LoadLoginScreen(
                  redirectUri: uri.path,
                );
              },
            ),
          );
        } else if (uri.path.startsWith(changePassword)) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return ChangePasswordScreen(
                  token: uri.path.split(changePassword)[1],
                  isStoreRequest: false,
                );
              },
            ),
          );
        }
        return null;
      };

  @override
  Function(Map<String, dynamic> data) get handleNotification => (data) {
        switch (data["type"]) {
          case "match":
            return handleLink(
              Uri.parse(
                "https://sandfriends.com.br/partida/${data["matchUrl"]}",
              ),
            );

          default:
            return null;
        }
      };

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        // String match = "/partida";
        // String matchSearch = "/match_search";
        // String matchSearchFilter = "/match_search_filter";
        // String recurrentMatchSearch = "/recurrent_match_search";
        String court = "/quadra/";
        String checkout = "/checkout";
        String teamDetails = "/turma";
        String match = "/partida";
        String studentPaymentDetails = "/student_payment_details";

        if (settings.name!.startsWith(court)) {
          final storeUrl = settings.name!.split(court)[1];
          final arguments = (settings.arguments ?? {}) as Map;

          return MaterialPageRoute(
            builder: (context) {
              return CourtScreen(
                storeUrl: storeUrl,
                store: arguments['store'] as StoreUser?,
                courtAvailableHours:
                    arguments['availableCourts'] as List<CourtAvailableHours>?,
                selectedHourPrice:
                    arguments['selectedHourPrice'] as HourPriceUser?,
                selectedDate: arguments['selectedDate'] as DateTime?,
                selectedWeekday: arguments['selectedWeekday'] as int?,
                selectedSport: arguments['selectedSport'] as Sport?,
                isRecurrent: arguments['isRecurrent'] as bool?,
                canMakeReservation: arguments['canMakeReservation'] ?? false,
                searchStartPeriod: arguments['searchStartPeriod'] as Hour?,
                searchEndPeriod: arguments['searchEndPeriod'] as Hour?,
              );
            },
          );
        } else if (settings.name!.startsWith(match)) {
          //match?id=123
          final matchUrl = settings.name!.split(match)[1].split("/")[1];
          return MaterialPageRoute(
            builder: (context) {
              return MatchScreen(
                matchUrl: matchUrl,
              );
            },
          );
        } else if (settings.name! == checkout) {
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return CheckoutScreen(
                  court: arguments['court'] as Court,
                  hourPrices: arguments['hourPrices'] as List<HourPriceUser>,
                  date: arguments['date'] as DateTime?,
                  weekday: arguments['weekday'] as int?,
                  sport: arguments['sport'] as Sport,
                  isRecurrent: arguments['isRecurrent'] as bool,
                  isRenovating: arguments['isRenovating'] as bool,
                );
              },
            );
          }
        } else if (settings.name! == teamDetails) {
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return TeamDetailsScreen(
                  team: arguments['team'] as Team,
                );
              },
            );
          }
        } else if (settings.name! == studentPaymentDetails) {
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return StudentPaymentDetailsScreen(
                  userClassPayment:
                      arguments['userClassPayment'] as UserClassPayment,
                );
              },
            );
          }
        }
        return null;

        // String userDetails = "/user_details";
        // String storeSearch = "/store_search";
        // String searchType = "/search_type";
        // if (settings.name! == matchSearch) {
        //   final arguments = settings.arguments as Map;

        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return MatchSearchScreen(
        //         sportId: arguments['sportId'],
        //       );
        //     },
        //   );
        // } else if (settings.name! == matchSearchFilter) {
        //   final arguments = settings.arguments as Map;

        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return MatchSearchFilterScreen(
        //         defaultCustomFilter:
        //             arguments['defaultCustomFilter'] as CustomFilter,
        //         currentCustomFilter:
        //             arguments['currentCustomFilter'] as CustomFilter,
        //         selectedCityId: arguments['selectedCityId'] as City?,
        //         hideOrderBy: arguments['hideOrderBy'] as bool?,
        //         isRecurrent: arguments['isRecurrent'] as bool,
        //       );
        //     },
        //   );
        // } else if (settings.name! == recurrentMatchSearch) {
        //   final arguments = settings.arguments as Map;

        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return RecurrentMatchSearchScreen(
        //         sportId: arguments['sportId'],
        //       );
        //     },
        //   );
        // } else if (settings.name!.startsWith(match)) {
        //   //match?id=123
        //   final matchUrl = settings.name!.split(match)[1].split("/")[1];
        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return MatchScreen(
        //         matchUrl: matchUrl,
        //       );
        //     },
        //   );
        // }  else if (settings.name! == userDetails) {
        //   Sport? initSport;
        //   UserDetailsModals initModalEnum = UserDetailsModals.None;
        //   if (settings.arguments != null) {
        //     final arguments = settings.arguments as Map;

        //     initSport = arguments['initSport'] as Sport;
        //     initModalEnum = arguments['userDetailsModal'] as UserDetailsModals;
        //   }
        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return UserDetailsScreen(
        //         initSport: initSport,
        //         initModalEnum: initModalEnum,
        //       );
        //     },
        //   );
        // } else if (settings.name! == storeSearch) {
        //   final arguments = settings.arguments as Map;

        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return StoreSearchScreen(
        //         sportId: arguments['sportId'],
        //         isRecurrent: arguments['isRecurrent'],
        //       );
        //     },
        //   );
        // } else if (settings.name! == searchType) {
        //   final arguments = settings.arguments as Map;

        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return SearchTypeScreen(
        //         isRecurrent: arguments['isRecurrent'] as bool,
        //         showReturnArrow: arguments['showReturnArrow'] ?? false,
        //       );
        //     },
        //   );
        // }
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (BuildContext context) => const LoadLoginScreen(),
        '/login_signup': (BuildContext context) => const LoginSignupScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/create_account': (BuildContext context) =>
            const CreateAccountScreen(),
        '/onboarding': (BuildContext context) => const OnboardingScreen(),
        '/home': (BuildContext context) => const HomeScreenAulas(),
        '/students': (BuildContext context) => const StudentsScreenAulas(),
        '/classes': (BuildContext context) => const ClassesScreenAulas(),
        '/teacher_details': (BuildContext context) =>
            const TeacherDetailsScreen(),
        '/class_plans': (BuildContext context) => const ClassPlansScreenAulas(),
        '/teams': (BuildContext context) => const TeamsAulasScreen(),
        '/create_team': (BuildContext context) => const CreateTeamScreen(),
        '/partner_schools': (BuildContext context) =>
            const PartnerSchoolsScreen(),
        '/recurrent_match_search': (BuildContext context) =>
            const RecurrentMatchSearchScreen(),

        '/settings': (BuildContext context) => const AppInfoScreen(),
        '/notifications': (BuildContext context) => const NotificationsScreen(),
        // '/user_matches': (BuildContext context) => const UserMatchesScreen(),
        // '/user_payments': (BuildContext context) => const OnboardingScreen(),
        // '/notifications': (BuildContext context) => const NotificationsScreen(),
        // '/rewards': (BuildContext context) => const RewardsScreen(),
        // '/rewards_user': (BuildContext context) => const RewardsUserScreen(),
        // '/open_matches': (BuildContext context) => const OpenMatchesScreen(),
        // '/recurrent_matches': (BuildContext context) =>
        //     const RecurrentMatchesScreen(),
        // '/payment': (BuildContext context) => const PaymentScreen(),
        // '/new_credit_card': (BuildContext context) =>
        //     const NewCreditCardScreen(),
      };
}
