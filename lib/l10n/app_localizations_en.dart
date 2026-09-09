// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get okAction => 'OK';

  @override
  String get profileLoadFailedGeneric => 'Couldn\'t load the profile';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get gameStatusWantToPlay => 'Want to Play';

  @override
  String get gameStatusPlaying => 'Playing';

  @override
  String get gameStatusCompleted => 'Completed';

  @override
  String get gameStatusDropped => 'Dropped';

  @override
  String get gameStatusPaused => 'Paused';

  @override
  String get platformNotSpecified => 'Not specified';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailNotConfirmed =>
      'You need to confirm your email before signing in.';

  @override
  String get errorEmailExists => 'An account with this email already exists.';

  @override
  String get errorWeakPassword => 'The password is too weak.';

  @override
  String get errorSamePassword =>
      'The new password must be different from the current one.';

  @override
  String get errorRateLimited =>
      'You\'ve made too many requests in a row. Wait a moment and try again.';

  @override
  String get errorSignupDisabled => 'Sign-up isn\'t available right now.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorDuplicateRecord => 'A record with this data already exists.';

  @override
  String get errorMissingRequiredData => 'Required data is missing.';

  @override
  String get errorReferencedNotFound => 'The referenced item doesn\'t exist.';

  @override
  String get errorPermissionDenied => 'You don\'t have permission to do this.';

  @override
  String get errorOperationFailed =>
      'Couldn\'t complete the operation. Please try again.';

  @override
  String get errorFileTooLarge => 'The file is too large.';

  @override
  String get errorUploadFailed =>
      'Couldn\'t upload the file. Please try again.';

  @override
  String get errorServerOperationFailed =>
      'Couldn\'t complete the operation on the server.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorNotAuthenticated => 'User not authenticated.';

  @override
  String get errorCannotFriendSelf =>
      'You can\'t send a friend request to yourself.';

  @override
  String get errorFriendshipAlreadyExists =>
      'A relationship with this user already exists.';

  @override
  String get errorDeleteAccountGeneric => 'Couldn\'t delete the account.';

  @override
  String get errorSaveGameGeneric => 'Couldn\'t save the game.';

  @override
  String get actionStartedPlayingPrefix => 'is playing ';

  @override
  String get actionCompletedPrefix => 'completed ';

  @override
  String get actionDroppedPrefix => 'dropped ';

  @override
  String get actionReviewPrefix => 'posted a review of ';

  @override
  String get actionAddedToLibrarySuffix => ' to their library';

  @override
  String get actionAddedToLibraryVerb => 'added ';

  @override
  String get actionShelfPublishedPrefix => 'published the shelf ';

  @override
  String get friendshipFormedConnector => 'and ';

  @override
  String get friendshipFormedSuffix => 'are now friends! 🎉';

  @override
  String get friendshipFormedUnknownFriend => 'someone';

  @override
  String get reviewNotFound => 'Couldn\'t find the review.';

  @override
  String get reviewLoadFailedPrefix => 'Couldn\'t load the review: ';

  @override
  String get seeReview => 'See review';

  @override
  String get activityAppBarTitle => 'Activity';

  @override
  String get emptyFeed => 'No activity yet.';

  @override
  String get newActivityAvailable => 'New activity available';

  @override
  String get activityLoadFailedPrefix => 'Couldn\'t load the activity: ';

  @override
  String get loadMoreFailedPrefix => 'Couldn\'t load more activity: ';

  @override
  String get refreshFailedPrefix => 'Couldn\'t refresh the activity: ';

  @override
  String get navHome => 'Home';

  @override
  String get navLlamp => 'Discover';

  @override
  String get navSocial => 'Social';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionAccept => 'Accept';

  @override
  String get actionReject => 'Reject';

  @override
  String get actionLogout => 'Sign out';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionSeeMore => 'See more';

  @override
  String get friendshipAdd => 'Add friend';

  @override
  String get friendshipRequestSent => 'Request sent';

  @override
  String get friendshipFriends => 'Friends';

  @override
  String get appName => 'GameShelf';

  @override
  String get passwordRequirementsTitle => 'The password must have:';

  @override
  String get passwordReqMinLength => 'At least 8 characters';

  @override
  String get passwordReqUppercase => 'An uppercase letter';

  @override
  String get passwordReqLowercase => 'A lowercase letter';

  @override
  String get passwordReqNumber => 'A number';

  @override
  String get passwordReqSymbol => 'A symbol';

  @override
  String get loginEmailOrNicknameLabel => 'Email or username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginForgotPassword => 'I forgot my password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get loginAboutLink => 'About GameShelf';

  @override
  String get loginNoUserWithNickname => 'No user was found with this nickname.';

  @override
  String get loginEnterEmailToReset =>
      'Enter your email to reset your password.';

  @override
  String get loginResetEmailSentTitle => 'Check your email';

  @override
  String get loginResetEmailSentBody =>
      'We\'ve sent you a link to reset your password. Check your inbox and also your spam folder.';

  @override
  String get loginResetEmailFailed => 'Couldn\'t send the email';

  @override
  String get registerNicknameLabel => 'Nickname';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerEmptyFields => 'Fill in all the fields.';

  @override
  String get registerUserCreationFailed => 'Couldn\'t create the user.';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get registerLegalPrefix => 'By creating an account, you accept the ';

  @override
  String get registerLegalAnd => ' and the ';

  @override
  String get registerLegalSuffix => '.';

  @override
  String get forgotEnterEmail => 'Enter your email.';

  @override
  String get forgotEmailFailedPrefix => 'Couldn\'t send the email: ';

  @override
  String get forgotTitle => 'Recover password';

  @override
  String get forgotBody =>
      'Enter your email and we\'ll send you a link to create a new password.';

  @override
  String get forgotEmailLabel => 'Email';

  @override
  String get forgotSubmit => 'Send email';

  @override
  String get forgotBackToLogin => 'Back to login';

  @override
  String get forgotSentTitle => 'Check your email';

  @override
  String get forgotSentBody =>
      'We\'ve sent you a link to reset your password to:';

  @override
  String get resetAppBarTitle => 'Reset password';

  @override
  String get resetTitle => 'New password';

  @override
  String get resetBody => 'Enter a new password for your account.';

  @override
  String get resetNewPasswordLabel => 'New password';

  @override
  String get resetConfirmPasswordLabel => 'Repeat the password';

  @override
  String get resetPasswordMismatch => 'The passwords don\'t match.';

  @override
  String get resetSubmit => 'Change password';

  @override
  String get resetBackToLogin => 'Back to sign in';

  @override
  String get resetLinkExpired =>
      'The recovery link has expired. Request the password change again.';

  @override
  String get resetSuccessTitle => 'Password updated';

  @override
  String get resetSuccessBody =>
      'Your password has been changed successfully. You can now sign in with the new password.';

  @override
  String get resetSuccessButton => 'Sign in';

  @override
  String get resetFailedPrefix => 'Couldn\'t change the password: ';

  @override
  String get confirmEmailTitle => 'Confirm your email';

  @override
  String get confirmEmailSentTo => 'We\'ve sent a confirmation email to:';

  @override
  String get confirmEmailInstructions =>
      'Open the email and click the link to activate your account.';

  @override
  String get confirmEmailBackToLogin => 'Back to sign in';

  @override
  String get callbackVerifying => 'Verifying the account...';

  @override
  String get callbackFailedTitle => 'Couldn\'t verify the link.';

  @override
  String get callbackUnknownError => 'Unknown error';

  @override
  String get callbackBackToLogin => 'Back to login';

  @override
  String get addToLibrarySheetTitle => 'Add to GameShelf';

  @override
  String get addToLibraryFailedPrefix =>
      'Couldn\'t add the game to the library: ';

  @override
  String get igdbLabel => 'IGDB';

  @override
  String get myReviewTitle => 'My review';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get editAction => 'Edit';

  @override
  String get addToLibraryAction => 'Add to library';

  @override
  String get platformLabel => 'Platform';

  @override
  String get confirmDatesTitle => 'When?';

  @override
  String get confirmCompletedTitle => 'Game completed';

  @override
  String get dateStartedLabel => 'Start date';

  @override
  String get dateCompletedLabel => 'Completion date';

  @override
  String get dateDroppedLabel => 'Drop date';

  @override
  String get datePausedLabel => 'Pause date';

  @override
  String get dateResumedLabel => 'Resume date';

  @override
  String get rateDialogTitle => 'Rate this game';

  @override
  String get rateFailedPrefix => 'Couldn\'t save the rating: ';

  @override
  String editTitle(String gameTitle) {
    return 'Edit $gameTitle';
  }

  @override
  String get statusTitle => 'Status';

  @override
  String get myRatingTitle => 'My rating';

  @override
  String get markAsFavorite => 'Mark as favorite';

  @override
  String get hoursPlayedTitle => 'Hours played';

  @override
  String get hoursSuffix => 'hours';

  @override
  String get reviewHint => 'Write your opinion...';

  @override
  String get saveAction => 'Save';

  @override
  String get gameSearchHint => 'Search games...';

  @override
  String get searchEmptyPrompt => 'Search for a game to get started';

  @override
  String get sortDateAdded => 'Date added';

  @override
  String get sortDatePlayed => 'Date you played it';

  @override
  String get sortHoursPlayed => 'Hours played';

  @override
  String get sortStatus => 'Status';

  @override
  String get sortTitle => 'Title (A-Z)';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get defaultNickname => 'GameShelf';

  @override
  String get titleSuffix => '\'s GameShelf';

  @override
  String get gamesCountSuffix => 'games';

  @override
  String get homeSearchHint => 'Search my library...';

  @override
  String get searchCloseTooltip => 'Close search';

  @override
  String get homeFilterLibrary => 'Library';

  @override
  String get homeFilterDropped => 'Dropped';

  @override
  String get filterWishlist => 'Wishlist';

  @override
  String get emptyLibraryTitle => 'Your library is empty';

  @override
  String get emptyLibrarySubtitle =>
      'Add games and start building your collection.';

  @override
  String get emptyDroppedTitle => 'No dropped games';

  @override
  String get emptyDroppedSubtitle =>
      'Games you decide to drop will appear here.';

  @override
  String get emptyWishlistTitle => 'You have no pending games';

  @override
  String get emptyWishlistSubtitle => 'Add games you\'d like to play later.';

  @override
  String get emptySearchTitle => 'No games found';

  @override
  String get emptySearchSubtitle => 'Try a different search term.';

  @override
  String get loadErrorPrefix => 'Error: ';

  @override
  String get deleteGameTitle => 'Delete game';

  @override
  String get deleteGameBodyPrefix => 'Do you want to remove ';

  @override
  String get deleteGameBodySuffix => ' from your library?';

  @override
  String get addGameTooltip => 'Add game';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get favoriteAddedMessage => 'Added to favorites';

  @override
  String get favoriteRemovedMessage => 'Removed from favorites';

  @override
  String get favoriteNotCompletedMessage =>
      'Only completed games can be marked as favorites';

  @override
  String get favoriteUpdateFailedPrefix => 'Couldn\'t update the favorite: ';

  @override
  String get favoriteConfirmAddBody =>
      'Do you want to add this game to your favorites?';

  @override
  String get favoriteConfirmRemoveBody =>
      'Do you want to remove this game from your favorites?';

  @override
  String get favoriteConfirmAddAction => 'Add to favorites';

  @override
  String get favoriteConfirmRemoveAction => 'Remove from favorites';

  @override
  String get contactEmail => 'contacte@gameshelfapp.net';

  @override
  String get lastUpdated => 'Last updated: September 2026.';

  @override
  String get privacyTitle => 'Privacy policy';

  @override
  String get privacyIntro =>
      'This policy explains what personal data GameShelf collects, for what purpose, and what rights you have over it, in accordance with Regulation (EU) 2016/679 (GDPR) and Spanish Organic Law 3/2018 on Data Protection and Digital Rights Guarantee (LOPDGDD).';

  @override
  String get privacySection1Title => '1. Data controller';

  @override
  String get privacySection1Body =>
      'Jordi Bertomeu Primo, as the owner and developer of GameShelf, is the controller responsible for processing the data described in this policy.\nContact: contacte@gameshelfapp.net';

  @override
  String get privacySection2Title => '2. What data we collect';

  @override
  String get privacySection2Bullet1 =>
      'Registration data: email and password (the password is stored encrypted, never in plain text).';

  @override
  String get privacySection2Bullet2 =>
      'Profile data: nickname, bio, and profile photo.';

  @override
  String get privacySection2Bullet3 =>
      'Service usage data: your game library, statuses (playing, completed, etc.), ratings, hours played, and reviews you write.';

  @override
  String get privacySection2Bullet4 =>
      'Social data: friend requests and relationships with other users, and the activity generated from your library (to show it to your friends).';

  @override
  String get privacySection3Title => '3. Purpose of processing';

  @override
  String get privacySection3Bullet1 =>
      'To create and manage your account and enable the use of the app\'s features (library, game search, social features).';

  @override
  String get privacySection3Bullet2 =>
      'To send you emails strictly necessary for the service: account confirmation and password recovery.';

  @override
  String get privacySection3Body =>
      'The legal basis for this processing is the performance of the service contract you accept when creating an account (art. 6.1.b GDPR).';

  @override
  String get privacySection4Title => '4. Who we share data with';

  @override
  String get privacySection4Bullet1 =>
      'Supabase Inc., as data processor: hosts the database, authentication, and files (such as profile photos) on servers located in the European Union.';

  @override
  String get privacySection4Bullet2 =>
      'IGDB (owned by Twitch/Amazon), as the video game catalog provider: only receives the text you enter when searching for a game, never personal data from your account.';

  @override
  String get privacySection4Body =>
      'We don\'t share, sell, or transfer your data to third parties for advertising purposes.';

  @override
  String get privacySection5Title => '5. How long we keep it';

  @override
  String get privacySection5Body =>
      'For as long as you keep your account active. You can permanently delete your account at any time from \"Edit profile → Delete account\"; doing so erases your profile, library, friendships, and activity with no possibility of recovery.';

  @override
  String get privacySection6Title => '6. Your rights';

  @override
  String get privacySection6Body1 =>
      'You have the right to access, rectify, erase, restrict, or object to the processing of your data, and to data portability. You can exercise most of these rights directly from the app (editing your profile or deleting your account) or by writing to us at contacte@gameshelfapp.net.';

  @override
  String get privacySection6Body2 =>
      'You also have the right to file a complaint with the Spanish Data Protection Agency (www.aepd.es) if you believe the processing of your data doesn\'t comply with the regulations.';

  @override
  String get privacySection7Title => '7. Security';

  @override
  String get privacySection7Body =>
      'Connections are encrypted (HTTPS) and the database applies access rules (Row Level Security) so that each user can only read and modify their own private data.';

  @override
  String get privacySection8Title => '8. Minors';

  @override
  String get privacySection8Body =>
      'GameShelf is not directed at minors under 14. We do not knowingly collect data from minors under that age.';

  @override
  String get privacySection9Title => '9. Changes to this policy';

  @override
  String get privacySection9Body =>
      'We may update this policy to adapt it to legal or service changes. We\'ll notify you within the app if the changes are significant.';

  @override
  String get cookiesTitle => 'Cookie policy';

  @override
  String get cookiesNoThirdPartyTitle =>
      'GameShelf doesn\'t use third-party cookies';

  @override
  String get cookiesNoThirdPartyBody =>
      'GameShelf doesn\'t use advertising, tracking, or analytics cookies of any kind. We don\'t track you across websites or share your behavior with third parties for commercial purposes.';

  @override
  String get cookiesEssentialTitle => 'Essential technical storage';

  @override
  String get cookiesEssentialBody1 =>
      'To keep you signed in, the app stores a session token (authentication token) in your browser\'s local storage, managed by our authentication provider (Supabase). This storage is strictly necessary for the app to work (so you don\'t have to sign in every time) and isn\'t used for any other purpose.';

  @override
  String get cookiesEssentialBody2 =>
      'Since this is technically necessary storage rather than tracking or advertising cookies, the app doesn\'t show a cookie consent banner.';

  @override
  String get cookiesFutureChangesTitle => 'Future changes';

  @override
  String get cookiesFutureChangesBody =>
      'If we were to add analytics or advertising tools requiring non-essential cookies in the future, we\'ll update this policy and, if required by law, ask for your consent before enabling them.';

  @override
  String get cookiesContactTitle => 'Contact';

  @override
  String get cookiesContactBody =>
      'If you have questions about this policy, write to us at contacte@gameshelfapp.net.';

  @override
  String get aboutTitle => 'About GameShelf';

  @override
  String get aboutAppName => 'GameShelf';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutDescription =>
      'GameShelf is a social app for gamers that lets you track your video game library: log what you\'re playing, mark your favorites, write reviews, share your activity with friends, and discover new games.';

  @override
  String get aboutDeveloperTitle => 'Developer';

  @override
  String get aboutDeveloperName => 'Jordi Bertomeu Primo';

  @override
  String get aboutDeveloperBio =>
      'Full stack and video game developer who built this web app in his spare time out of pure need and love for video games.';

  @override
  String get aboutDeveloperPortfolioLabel => 'See portfolio';

  @override
  String get aboutDeveloperPortfolioUrl =>
      'https://jordi110398.github.io/portfolio/';

  @override
  String get aboutDevelopmentTitle => 'About the development';

  @override
  String get aboutDevelopmentBody =>
      'Much of GameShelf\'s code was written with the help of artificial intelligence tools. The idea, design, and every decision behind the project are original: AI helped write it, but the intent behind GameShelf is honest and genuinely built for gamers.';

  @override
  String get aboutContactTitle => 'Contact';

  @override
  String get aboutCatalogDataTitle => 'Game catalog data';

  @override
  String get aboutCatalogDataBody =>
      'Game information (titles, covers, descriptions) comes from IGDB.';

  @override
  String get aboutLegalDocumentsTitle => 'Legal documents';

  @override
  String get installAppTitle => 'Install the app';

  @override
  String get installAppSubtitle => 'Add GameShelf to your phone\'s home screen';

  @override
  String get installAppDialogTitle => 'How to install it';

  @override
  String get installAppDialogBody =>
      'On Safari (iPhone/iPad): tap the Share icon and select \"Add to Home Screen\".\n\nOn your computer\'s browser or Chrome/Edge for Android: look for the install icon in the address bar, or the \"Install GameShelf\" option in the menu (⋮).';

  @override
  String get installAppAcceptedMessage =>
      'GameShelf has been added to your home screen!';

  @override
  String get llampAppBarTitle => 'Discover';

  @override
  String get sectionRecommendations => 'Recommendations for you';

  @override
  String get emptyRecommendationsNoFriends =>
      'Add friends to start getting personalized recommendations.';

  @override
  String get emptyRecommendationsNoData =>
      'Play and rate some games so we can recommend more to you.';

  @override
  String get sectionFriendsShelves => 'Your friends\' shelves';

  @override
  String get emptyFriendsShelves =>
      'Your friends haven\'t published any shelves yet.';

  @override
  String get myShelvesAction => 'My shelves';

  @override
  String get llampLoadFailedPrefix => 'Couldn\'t load Discover: ';

  @override
  String get myShelvesTitle => 'My shelves';

  @override
  String get emptyMyShelves =>
      'You haven\'t created any shelves yet. Create one to organize the games you want to highlight.';

  @override
  String get newShelfAction => 'New shelf';

  @override
  String get newShelfDialogTitle => 'New shelf';

  @override
  String get shelfTitleHint => 'Shelf name';

  @override
  String get pinnedBadge => 'Pinned to profile';

  @override
  String get publishedBadge => 'Published to Discover';

  @override
  String get deleteShelfTitle => 'Delete shelf';

  @override
  String deleteShelfBody(String title) {
    return 'Are you sure you want to delete the shelf \"$title\"? This action can\'t be undone.';
  }

  @override
  String get createShelfFailedPrefix => 'Couldn\'t create the shelf: ';

  @override
  String get deleteShelfFailedPrefix => 'Couldn\'t delete the shelf: ';

  @override
  String get editShelfTitle => 'Edit shelf';

  @override
  String get pinToProfileTitle => 'Pin to profile';

  @override
  String get pinToProfileSubtitle =>
      'It will show on your profile (only one at a time).';

  @override
  String get publishToLlampTitle => 'Publish to Discover';

  @override
  String get publishToLlampSubtitle =>
      'Your friends will see it on the Discover tab.';

  @override
  String get addGameAction => 'Add game';

  @override
  String get pickGameSheetTitle => 'Choose a game from your library';

  @override
  String get shelfFullMessage => 'This shelf already has 8 games.';

  @override
  String get emptyLibraryForShelf =>
      'You don\'t have any games in your library yet.';

  @override
  String get allGamesAlreadyInShelf =>
      'You\'ve already added all the games from your library to this shelf.';

  @override
  String get renameFailedPrefix => 'Couldn\'t change the name: ';

  @override
  String get pinFailedPrefix => 'Couldn\'t pin the shelf: ';

  @override
  String get unpinFailedPrefix => 'Couldn\'t unpin the shelf: ';

  @override
  String get publishFailedPrefix => 'Couldn\'t publish the shelf: ';

  @override
  String get addGameFailedPrefix => 'Couldn\'t add the game: ';

  @override
  String get removeGameFailedPrefix => 'Couldn\'t remove the game: ';

  @override
  String get notificationAppBarTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get emptyList => 'You don\'t have any notifications yet.';

  @override
  String get notificationLoadFailedPrefix =>
      'Couldn\'t load the notifications: ';

  @override
  String get listFriendRequest => 'sent you a friend request';

  @override
  String get listFriendAccepted => 'accepted your friend request';

  @override
  String get listActivityLikePrefix => 'liked your activity about ';

  @override
  String get listActivityLikeUnknownGame => 'a game';

  @override
  String get bannerFriendRequestSuffix => 'sent you a friend request';

  @override
  String get bannerFriendAcceptedSuffix => 'accepted your request';

  @override
  String get bannerActivityLikeSuffix => 'gave a star';

  @override
  String get bannerActivityLikeGamePrefix => ' to ';

  @override
  String get profileLoadFailedPrefix => 'Couldn\'t load the profile: ';

  @override
  String get sendRequestFailedPrefix => 'Couldn\'t send the request: ';

  @override
  String get acceptRequestFailedPrefix => 'Couldn\'t accept the request: ';

  @override
  String get rejectRequestFailedPrefix => 'Couldn\'t reject the request: ';

  @override
  String get removeFriendFailedPrefix => 'Couldn\'t remove the friend: ';

  @override
  String get removeFriendTitle => 'Remove friend?';

  @override
  String removeFriendBody(String nickname) {
    return 'Do you want to remove @$nickname from your friends?';
  }

  @override
  String get editProfileTooltip => 'Edit profile';

  @override
  String get shareProfileTooltip => 'Share profile';

  @override
  String get logoutTooltip => 'Sign out';

  @override
  String get noReviewsYet => 'You haven\'t written any reviews yet.';

  @override
  String seeAllReviews(int count) {
    return 'See all reviews ($count)';
  }

  @override
  String get statGames => 'Games';

  @override
  String get statCompleted => 'Completed';

  @override
  String get statReviews => 'Reviews';

  @override
  String get statHours => 'Hours';

  @override
  String get myReviewsTitle => 'My reviews';

  @override
  String get completedTitle => 'Completed';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String gameshelfOf(String nickname) {
    return '$nickname\'s GameShelf';
  }

  @override
  String get profileFilterLibrary => 'Library';

  @override
  String get profileFilterDropped => 'Dropped';

  @override
  String get filterWantToPlay => 'Want to play';

  @override
  String get emptyGamesDropped => 'This user has no dropped games.';

  @override
  String get emptyGamesWantToPlay => 'This user has no pending games.';

  @override
  String get emptyGamesPlaying => 'This user has no games in progress.';

  @override
  String get emptyGamesCompleted => 'This user has no completed games.';

  @override
  String get emptyGamesPaused => 'This user has no paused games.';

  @override
  String get emptyGamesAny => 'This user has no games yet.';

  @override
  String get editAppBarTitle => 'Edit profile';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get cropAvatarTitle => 'Adjust the photo';

  @override
  String get cropFailedMessage => 'Couldn\'t crop the image.';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Tell us something about yourself...';

  @override
  String get emailLabel => 'Email';

  @override
  String get saving => 'Saving...';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get informationTitle => 'Information';

  @override
  String get securityTitle => 'Security';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordSubtitle => 'Update your account\'s password';

  @override
  String get dangerZoneTitle => 'Danger zone';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently delete your account and your data';

  @override
  String get deleteAccountDialogTitle => 'Delete account?';

  @override
  String get deleteAccountDialogBody =>
      'This action is permanent. Your profile, library, reviews, friendships, and activity will be deleted.';

  @override
  String get deleteAccountFailedPrefix => 'Couldn\'t delete the account: ';

  @override
  String get changePasswordDialogTitle => 'Change password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get repeatPasswordLabel => 'Repeat the password';

  @override
  String get passwordRequirementsIntro => 'The password must have:';

  @override
  String get reqMinLength => 'At least 8 characters';

  @override
  String get reqUppercase => 'An uppercase letter';

  @override
  String get reqLowercase => 'A lowercase letter';

  @override
  String get reqNumber => 'A number';

  @override
  String get reqSymbol => 'A symbol';

  @override
  String get passwordsDontMatch => 'The passwords don\'t match.';

  @override
  String get changePasswordSuccess => 'Password changed successfully.';

  @override
  String get changePasswordFailedPrefix => 'Couldn\'t change the password: ';

  @override
  String get changeAction => 'Change';

  @override
  String get shareAppBarTitle => 'Share profile';

  @override
  String get shareQrCaption => 'Scan to find me on GameShelf';

  @override
  String get shareDownloadAction => 'Download image';

  @override
  String get shareDownloadedMessage => 'Image downloaded.';

  @override
  String get shareGenerateFailedPrefix => 'Couldn\'t generate the image: ';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsAppBarTitle => 'Settings';

  @override
  String get settingsEditProfileSubtitle =>
      'Nickname, bio, photo, password, and account';

  @override
  String get shelfStyleSectionTitle => 'Aesthetics';

  @override
  String get shelfStyleSectionSubtitle =>
      'The wood color defines the look of the whole app and your shelves.';

  @override
  String get shelfLightsLabel => 'Lights';

  @override
  String get shelfLightsNeon => 'Neon';

  @override
  String get shelfLightsBulbs => 'Bulbs';

  @override
  String get shelfWoodLabel => 'Wood color';

  @override
  String get shelfWoodWalnut => 'Walnut';

  @override
  String get shelfWoodOak => 'Oak';

  @override
  String get shelfWoodEbony => 'Ebony';

  @override
  String get shelfWoodCherry => 'Cherry';

  @override
  String get shelfWoodBirch => 'Birch';

  @override
  String get shelfDecorationLabel => 'Decoration';

  @override
  String get shelfDecorationHint => 'You can choose more than one.';

  @override
  String get shelfDecorationNone => 'None';

  @override
  String get shelfDecorationPoppy => 'Poppy';

  @override
  String get shelfDecorationCactus => 'Cactus';

  @override
  String get shelfDecorationAzalea => 'Azalea';

  @override
  String get shelfCoverStyleLabel => 'Game covers';

  @override
  String get shelfCoverStylePlain => 'Plain';

  @override
  String get shelfCoverStyleCartridge => 'Cartridge';

  @override
  String get shelfStyleChangeFailedPrefix =>
      'Couldn\'t change the aesthetics: ';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageCatalan => 'Catalan';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChangeFailedPrefix => 'Couldn\'t change the language: ';

  @override
  String get changePasswordPageTitle => 'Change password';

  @override
  String get fillAllFields => 'Fill in all the fields.';

  @override
  String get passwordMinLength6 =>
      'The password must have at least 6 characters.';

  @override
  String get passwordUpdatedSuccess => 'Password updated successfully.';

  @override
  String get newPasswordFieldLabel => 'New password';

  @override
  String get repeatPasswordFieldLabel => 'Repeat password';

  @override
  String get updating => 'Updating...';

  @override
  String get socialAppBarTitle => 'Social';

  @override
  String get socialSearchHint => 'Search users...';

  @override
  String get searchUsersFailedPrefix => 'Couldn\'t search for users: ';

  @override
  String get loadSocialFailedPrefix => 'Couldn\'t load social data: ';

  @override
  String get emptyFriendsTitle => 'You don\'t have any friends yet';

  @override
  String get emptyFriendsSubtitle =>
      'Search for other GameShelf users to add them.';

  @override
  String get emptySearchResults => 'No users found';

  @override
  String get sectionRequests => 'Requests';

  @override
  String get sectionFriends => 'Friends';

  @override
  String get sectionActivitySummary => 'Activity summary';

  @override
  String get seeMore => 'See more';

  @override
  String get reviewOfPrefix => 'Review of ';
}
