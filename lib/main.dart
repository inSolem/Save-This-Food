import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:save_this_food/auth/main_page.dart';
import 'package:save_this_food/blocs/product/product_bloc.dart';
import 'package:save_this_food/pages/buyer/checkout_page.dart';
import 'package:save_this_food/pages/buyer/home_page.dart';
import 'package:save_this_food/pages/buyer/payment_page.dart';
import 'package:save_this_food/pages/buyer/product_page.dart';
import 'package:save_this_food/pages/buyer/profile_page.dart';
import 'package:save_this_food/pages/buyer/sign_in_page.dart';
import 'package:save_this_food/pages/buyer/sign_up_page.dart';
import 'package:save_this_food/pages/buyer/surplus_market_page.dart';
import 'package:save_this_food/pages/buyer/surprise_bag_page.dart';
import 'package:save_this_food/pages/buyer/will_contact_page.dart';
import 'package:save_this_food/pages/seller/enter_merchant_name_page.dart';
import 'package:save_this_food/pages/seller/list_page.dart';
import 'package:save_this_food/pages/seller/mercahnt_onboarding.dart';
import 'package:save_this_food/pages/seller/merchant_forget_password_page.dart';
import 'package:save_this_food/pages/seller/merchant_home.dart';
import 'package:save_this_food/pages/seller/merchant_sign_in_page.dart';
import 'package:save_this_food/pages/seller/merchant_surplus_market_page.dart';
import 'package:save_this_food/pages/seller/new_listing_page.dart';
import 'package:save_this_food/respositories/product/product_respository.dart';

import 'blocs/payment/payment_bloc.dart';
import 'pages/buyer/login_page.dart';
import 'pages/buyer/landing_page.dart';
import 'pages/buyer/enter_name_page.dart';

import 'pages/buyer/forget_password_page.dart';
import 'pages/seller/merchant_sign_up_page.dart';

import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  runApp(Save_This_Food());
}

class Save_This_Food extends StatelessWidget {
  const Save_This_Food({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProductBloc(
              productRepository: ProductRepository(),
            )..add(
                LoadProducts(),
              ),
          ),
          BlocProvider(
            create: (context) => PaymentBloc(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Save This Food",
            initialRoute: '/',
            routes: {
              //For Buyers
              '/': (context) => const MainPage(),
              '/landing': (context) => const LandingPage(),
              '/sign_up': (context) => const SignUpPage(),
              '/sign_in': (context) => const SignInPage(),
              '/home': (context) => HomePage(),
              '/enter_name': (context) => const EnterNamePage(),
              '/forget_password': (context) => ForgetPasswordPage(),
              '/merchant_sign_up': (context) => MerchantSignUpPage(),
              '/will_contact': (context) => WillContact(),
              '/surprise_bag': (context) => SurpriseBagPage(),
              '/surplus_market': (context) => SurplusMarketPage(),
              '/profile': (context) => ProfilePage(),
              '/product_page': (context) => ProductPage(),
              '/checkout_page': (context) => CheckoutPage(),
              '/payment_page': (context) => PaymentPage(),

              //For Sellers
              '/merchant_sign_in': (context) => MerchantSignInPage(),
              '/merchant_forget_password': (context) =>
                  MerchantForgetPasswordPage(),
              '/merchant_home': (context) => MerchantHomePage(),
              '/list': (context) => ListPage(),
              '/new_listing': (context) => NewListingPage(),
              '/merchant_surplus_market': (context) =>
                  MerchantSurplusMarketPage(),
              '/enter_merchant_name': (context) => EnterMerchantNamePage(),
              '/merchant_onboarding': (context) => MerchantOnboarding()
            }));
  }
}
