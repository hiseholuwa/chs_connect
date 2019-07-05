class ChsStrings {
  ChsStrings._();

  static const appName = "CHS Connect";
  static const me = "Hiseholuwa \u00a9";


  //general auth strings
  static const enter_username_hint = "Username";
  static const enter_full_name_hint = "Full Name";
  static const enter_email_hint = "Email Address";
  static const enter_password_hint = "Password";
  static const login = "Login to my Account";
  static const login_email = "Sign In with Email";
  static const login_google = "Sign In with Google";
  static const log_out = "Log Out";
  static const register = "Need a new Account?";
  static const create = "Create a new Account";
  static const sign_in = "Already have an Account?";
  static const forgot = "Forgot Password?";
  static const recover = "Recover Password";
  static const back = "Sign In";
  static const enter_valid_email = "Please enter a valid email";
  static const enter_valid_password = "Password length should be >= 6";
  static const enter_valid_username = "Please enter a valid username";
  static const enter_valid_phone = "Please enter a valid phone number";
  static const enter_valid_bio = "Please enter a valid bio";
  static const enter_valid_full_name = "Please enter a valid fullname";
  static const snackbar_login = "SIGN IN";
  static const snackbar_photo = "ADD PHOTO";
  static const snackbar_user_exists = "User already exists with that email";
  static const snackbar_no_photo = "Photo required";
  static const snackbar_verification =
      "Verification link has been sent to the provided email";
  static const snackbar_reset =
      "Reset link has been sent to the provided email";
  static const snackbar_chk_verification = "Email has been verified";
  static const snackbar_chk_verification_err = "Email has not been verified";
  static const snackbar_chk_extra_err = "Please complete all fields";
  static const snackbar_reset_err = "Reset link not sent to email";
  static const verification_text = "Almost there! Please verify your email.";
  static const verification_btn = "Resend Verification Email";
  static const verification_chk_btn = "Check Verification";

  //Two Devices Auth Resolve
  static const auth_alert_title = "Uh oh 😲";
  static const auth_alert_text1 = "Looks like you're already signed in to another device.";
  static const auth_alert_text2 = "Press \"Continue\" to sign in on this device instead.";
  static const auth_alert_text3 = "Press \"Cancel\" to stop.";
  static const auth_alert_btn1 = "Cancel 😒";
  static const auth_alert_btn2 = "Continue 😘";

  //VerifyScreen
  static String verifyScreenText1(name) => "This is the last gotcha I promise $name! 😅";
  static const verify_screen_text2 = "Please check your email for the link.";
  static const verify_screen_text3 = "Didn't get it?";
  static const verify_screen_text4 = "Verified?";

  //ExtraScreen
  static const extra_screen_prefix_init = "234";
  static String extraScreenAppbarName(name) => "Hi $name 😍";
  static const extra_screen_username = "Username:";
  static const extra_screen_username_hint = "Username...";
  static const extra_screen_phone = "Phone:";
  static const extra_screen_phone_hint = "(123) 456-7890";
  static const extra_screen_phone_init = "ng";
  static const extra_screen_bd = "Birthday:";
  static const extra_screen_bd_init = "May 28";
  static const extra_screen_bio = "Bio:";
  static const extra_screen_bio_hint = "Psalms 19:1";
  static const extra_screen_text = "Almost there.... 😎";
  static const extra_screen_continue = "Continue";
  static const january = "January";
  static const february = "February";
  static const march = "March";
  static const april = "April";
  static const may = "May";
  static const june = "June";
  static const july = "July";
  static const august = "August";
  static const september = "September";
  static const october = "October";
  static const november = "November";
  static const december = "December";
  static const extra_screen_username_snackbar = "Username exists already 😭! Choose another.";

  //MapScreen
  static const map_alert_title = "Ummm... 😬";
  static const map_alert_text1 = "Your location is needed to show this page.";
  static const map_alert_text2 = "Press \"Continue\" to give the NSA..sorry CHS Connect access to your location.";
  static const map_alert_text3 = "Press \"Cancel\" to stop and receive a tinfoil hat.";
  static const map_alert_btn1 = "Cancel ⛔";
  static const map_alert_btn2 = "Continue 😎";
  static const map_ask_text = "This page is only for the elite 😛. Click the button below to join.";
  static const map_ask_btn = "I WANT ACCESS 😩!";



  //Database
  static const database_app_user = "user";
  static const database_app_username = "username";
  static const database_app_token = "token";

  //storage
  static const avatarRef = "User Avatar";

  //MainPages
  static const feedPage = "Feed";
  static const no_feed = "Follow someone to see their posts on your feed";
  static const chatPage = "Chat";
  static const statusPage = "Status";
  static const accountPage = "Account";

  //errors
  static const connection_error = "Connection error - Check your internet";
  static const g_cancelled = "SIGN_IN_CANCELLED";
  static const g_cancelled_msg = "The sign in was cancelled by user";
  static const g_cip = "SIGN_IN_CURRENTLY_IN_PROGRESS";
  static const g_cip_msg = "A sign in process is currently in progress";
  static const g_failed = "SIGN_IN_FAILED";
  static const g_failed_msg = "Sign In attmept didn't succeed with the current account";
  static const g_network = "NETWORK_ERROR";
  static const g_network_msg = "A network error occured. Check your internet connection";
  static const g_invalid = "INVALID_ACCOUNT";
  static const g_invalid_msg = "Account name specified is invalid";
  static const g_auth_req = "SIGN_IN_REQUIRED";
  static const g_auth_req_msg = "Sign In to connect to the service";
//  static const f_invalid_token = "SIGN_IN_REQUIRED";
//  static const f_invalid_token_msg = "Sign In to connect to the service";
//  static const g_auth_req = "SIGN_IN_REQUIRED";
//  static const g_auth_req_msg = "Sign In to connect to the service";
//  static const g_auth_req = "SIGN_IN_REQUIRED";
//  static const g_auth_req_msg = "Sign In to connect to the service";
//  static const g_auth_req = "SIGN_IN_REQUIRED";
//  static const g_auth_req_msg = "Sign In to connect to the service";


  //Themes
  static const rochester = "Rochester";
  static const work_sans = "Work Sans";
  static const dark_mode = "Dark Mode";
  static const custom_theme = "Custom Theme";
  static const accent_color = "Accent Color";
  static const primary_color = "Primary Color";
  static const scaffold_color = "Scaffold Color";
  static const icon_color = "Icons Color";
  static const bkg_color = "Background Color";
  static const text1_color = "Text One Color";
  static const text2_color = "Text Two Color";
  static const text3_color = "Text Three Color";


}
