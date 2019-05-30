class ChsStrings {
  ChsStrings._();

  static const appName = "CHS Connect";
  static const me = "Hiseholuwa \u00a9";

  //auth strings
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
  static const enter_valid_email = "Please enter a valid email";
  static const enter_valid_password = "Password length should be >= 6";
  static const enter_valid_username = "Please enter valid username";
  static const enter_valid_full_name = "Please enter valid fullname";
  static const snackbar_login = "SIGN IN";
  static const snackbar_photo = "ADD PHOTO";
  static const snackbar_user_exists = "User already exists with that email";
  static const snackbar_no_photo = "Photo required";
  static const snackbar_verification =
      "Verification link has been sent to the provided email";
  static const snackbar_chk_verification = "Email has been verified";
  static const snackbar_chk_verification_err = "Email has not been verified";
  static const verification_text = "Almost there! Please verify your email.";
  static const verification_btn = "Resend Verification Email";
  static const verification_chk_btn = "Verified?";

  //Database
  static const database_users = "registeredUsers";
  static const database_app = "Main";
  static const database_app_user = "Users";
  static const database_app_feed = "Feeds";
  static const database_app_post = "Posts";
  static const database_app_comment = "Comments";
  static const default_bio = "Hi there! I'm a Connect User";

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

}
