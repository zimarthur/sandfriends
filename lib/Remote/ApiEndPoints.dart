class ApiEndPoints {
  //SANDFIRENDS
  static const String loginUser = "/LoginUser";
  static const String thirdPartyLogin = "/ThirdPartyAuthUser";
  static const String validateTokenUser = "/ValidateTokenUser";
  static const String emailConfirmation = "/EmailConfirmationUser";

  static const String changePasswordRequest = "/ChangePasswordRequestUser";

  static const String createAccountUser = "/AddUser";
  static const String addUserInfo = "/AddUserInfo";
  static const String addUserCreditCard = "/AddUserCreditCard";
  static const String deleteUserCreditCard = "/DeleteUserCreditCard";
  static const String getUserInfo = "/GetUserInfo";
  static const String updateUserInfo = "/UpdateUser";
  static const String removeUser = "/RemoveUser";
  static const String setUserNotifications = "/SetUserNotifications";

  static const String getUserMatches = "/GetUserMatches";

  static const String getAllCities = "/GetAllCities";
  static const String getAvailableCities = "/GetAvailableCities";

  static const String sendFeedback = "/SendFeedback";

  static const String getStore = "/GetStore";
  static const String getStoreOperationDays = "/GetStoreOperationHours";

  static const String searchCourts = "/SearchCourts";
  static const String searchStores = "/SearchStores";
  static const String matchReservation = "/MatchReservation";

  static const String searchRecurrentCourts = "/SearchRecurrentCourts";
  static const String recurrentMatchReservation = "/RecurrentMatchReservation";
  static const String recurrentMonthAvailableHours =
      "/RecurrentMonthAvailableHours";
  static const String validateCoupon = "/ValidateCoupon";

  static const String getMatchInfo = "/GetMatchInfo";
  static const String saveCreatorNotes = "/SaveCreatorNotes";
  static const String invitationResponse = "/InvitationResponse";
  static const String removeMatchMember = "/RemoveMatchMember";
  static const String cancelMatchUser = "/CancelMatch";
  static const String leaveMatch = "/LeaveMatch";
  static const String joinMatch = "/JoinMatch";
  static const String saveOpenMatch = "/SaveOpenMatch";

  static const getUserRewards = "/UserRewardsHistory";

  static const getClassesInfo = "/GetClassesInfo";

  //AULAS

  static const String getTeacherInfo = "/GetTeacherInfo";

  static const String addClassPlan = "/AddTeacherClassPlan";
  static const String deleteClassPlan = "/DeleteTeacherClassPlan";
  static const String editClassPlan = "/EditTeacherClassPlan";

  static const String addTeam = "/AddTeam";
  static const String joinTeam = "/JoinTeam";
  static const String sendMemberResponse = "/SendMemberResponse";

  static const String schoolInvitationResponse = "/SchoolInvitationResponse";

  //SANDFRIENDS QUADRAS
  //login
  static const String loginEmployee = "/EmployeeLogin";
  static const String validateTokenEmployee = "/ValidateEmployeeAccessToken";

  //create account
  static const String createAccountStore = "/AddStore";

  //new password
  static const String forgotPassword = "/ChangePasswordRequestEmployee";
  static const String changePasswordValidateTokenEmployee =
      "/ValidateChangePasswordTokenEmployee";
  static const String changePasswordEmployee = "/ChangePasswordEmployee";

  static const String changePasswordValidateTokenUser =
      "/ValidateChangePasswordTokenUser";
  static const String changePasswordUser = "/ChangePasswordUser";

  //email confirmation
  static const String emailConfirmationStore = "/EmailConfirmationEmployee";
  static const String emailConfirmationUser = "/EmailConfirmationUser";

  //settings
  static const String updateStoreInfo = "/UpdateStoreInfo";
  static const String validateNewEmployeeToken = "/ValidateNewEmployeeEmail";
  static const String addEmployee = "/AddEmployee";
  static const String changeEmployeeAdmin = "/SetEmployeeAdmin";
  static const String renameEmployee = "/RenameEmployee";
  static const String removeEmployee = "/RemoveEmployee";
  static const String allowNotifications = "/AllowNotificationsEmployee";
  static const String deleteAccountEmployee = "/DeleteAccountEmployee";

  static const String createAccountEmployee = "/AddEmployeeInformation";

  //myCourts
  static const String addCourt = "/AddCourt";
  static const String removeCourt = "/RemoveCourt";
  static const String saveCourtChanges = "/SaveCourtChanges";

  //calendar
  static const String updateMatchesList = "/UpdateMatchesList";
  static const String blockHour = "/BlockHour";
  static const String unblockHour = "/UnblockHour";
  static const String recurrentBlockHour = "/RecurrentBlockHour";
  static const String recurrentUnblockHour = "/RecurrentUnblockHour";
  static const String cancelMatchEmployee = "/CancelMatchEmployee";
  static const String cancelRecurrentMatch = "/CancelRecurrentMatchEmployee";

  //rewards
  static const String searchCustomRewards = "/SearchCustomRewards";
  static const String sendUserRewardCode = "/SendUserRewardCode";
  static const String userRewardSelected = "/UserRewardSelected";

  //finances
  static const String searchCustomMatches = "/SearchCustomMatches";

  //players
  static const String addStorePlayer = "/AddStorePlayer";
  static const String editStorePlayer = "/EditStorePlayer";
  static const String deleteStorePlayer = "/DeleteStorePlayer";

  //coupons
  static const String addCoupon = "/AddCoupon";
  static const String enableDisableCoupon = "/EnableDisableCoupon";

  //schools
  static const String addSchool = "/AddSchool";
  static const String editSchool = "/EditSchool";
  static const String addSchoolTeacher = "/AddSchoolTeacher";
}
