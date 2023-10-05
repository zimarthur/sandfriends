class ApiEndPoints {
  final String login = "/LoginUser";
  final String thirdPartyLogin = "/ThirdPartyAuthUser";
  final String validateToken = "/ValidateTokenUser";
  final String emailConfirmation = "/EmailConfirmationUser";

  final String changePasswordRequest = "/ChangePasswordRequestUser";

  final String createAccount = "/AddUser";
  final String addUserInfo = "/AddUserInfo";
  final String addUserCreditCard = "/AddUserCreditCard";
  final String deleteUserCreditCard = "/DeleteUserCreditCard";
  final String getUserInfo = "/GetUserInfo";
  final String updateUserInfo = "/UpdateUser";
  final String removeUser = "/RemoveUser";

  final String getUserMatches = "/GetUserMatches";

  final String getAllCities = "/GetAllCities";
  final String getAvailableCities = "/GetAvailableCities";

  final String sendFeedback = "/SendFeedback";

  final String searchCourts = "/SearchCourts";
  final String matchReservation = "/MatchReservation";

  final String searchRecurrentCourts = "/SearchRecurrentCourts";
  final String recurrentMatchReservation = "/RecurrentMatchReservation";
  final String recurrentMonthAvailableHours = "/RecurrentMonthAvailableHours";

  final String getMatchInfo = "/GetMatchInfo";
  final String saveCreatorNotes = "/SaveCreatorNotes";
  final String invitationResponse = "/InvitationResponse";
  final String removeMatchMember = "/RemoveMatchMember";
  final String cancelMatch = "/CancelMatch";
  final String leaveMatch = "/LeaveMatch";
  final String joinMatch = "/JoinMatch";
  final String saveOpenMatch = "/SaveOpenMatch";

  final getUserRewards = "/UserRewardsHistory";
}
