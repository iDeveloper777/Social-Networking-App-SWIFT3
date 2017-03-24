//
//  AllMacros.swift
//  My-Mo
//
//  Created by iDeveloper on 10/11/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import SwiftyJSON
import MBProgressHUD

let SLIDE_MENU_STYLE = 2
// MainScreen Height&Width
let Main_Screen_Height = UIScreen.main.bounds.size.height
let Main_Screen_Width = UIScreen.main.bounds.size.width

let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
let COMMON = Common()
let IMAGEPROCESSING = ImageProcessing()
let FIREBASEMODULE = FirebaseModule()

let USER = User()
let DATAKEEPER = DataKeeper()
let prefs = UserDefaults.standard


//let mainframe = (UIScreen.main.applicationFrame)
let mainframe = UIScreen.main.bounds
let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_RETINA = (UIScreen.main.scale >= 2.0)
let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))
let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6PLUS = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
let IS_IPAD_1 = (IS_IPHONE && SCREEN_MAX_LENGTH == 1024.0)
let IS_IPAD_2 = (IS_IPHONE && SCREEN_MAX_LENGTH == 1366.0)


//Alert
let kAppName = "My-Mo"
let kMain = "Main"
let kHostView = "Host"
let kMyMoView = "MYMO"
let kHostHistory = "HostHistory"
let kJoinView = "Join"
let kF_FView = "F&F"
let kViewLogin = "Login"
let kViewSignUp = "SignUp"
let kProfile = "Profile";
let kSettingsView = "Settings"
let kPrefsKey = "userProfile"

let kViewForgotPassword = "ForgotPassword"
let kNetworksNotAvailvle = "Please Check your Internet Connection"
let kEnterValidEmail =  "Please Enter Valid Email Address"
let kEnterEmail = "Please Enter Email Address"
let kConfirmEmail = "Please Confirm Email Address"
let kEnterUserName = "Please Enter User Name"
let kEnterName = "Please Enter Your Name"
let kEnterPassword = "Please Enter Password"
let kEnterMobile = "Please Enter Your Mobile Phone Number"
let kEnterCorrectPassword = "Please Enter your Password It should be minimum 8 characters"
let kEnterUsernameOrPassword = "Please enter your User name Or Password"
let kConfirmPassword = "Please Confirm Your Password"
let kEnterComment = "Please Enter Comment"
let kErrorComment = "Failed. Please try again"
let kErrorOtherComment = "Can't delete other's comment."
let kErrorUsername = "This username was already used. Please choose anther one."
let kLoginNoUserFailed = "This username was not registered."
let kVerifiedEmail = "Please verify your email first."
let kSuccessResetPassword = "New password was sent successfully. Please check your email"
let kErrorResetPassword = "Failed. Please try again"

let kContactError = "Can't get contacts from your phone book. Please try again."

let kInvalidNO = "Please provide valid No"
let kLoginFailed = "Login Failed"
let kSignUpRequest = "We are unable to Sign up Please Try Latter .."
let kSignUpSuccess = "You are registered successfully. Please check your email"
let kLoginRequest = "Sorry unable to login Please try Latter.."
let kOkButton = "Ok"
let kEmailNotMatch = "Email does not match"
let kMandatory = "Please fill both Fields"
let kResetPassword = "Password reset succesfully Email sent to your Register Email Address "
let kimageMotive = "keyMotiveImage"


//user stored data
let kPrefsStatus = "userstatus"
let kPrefsOptionalUsername = "optionalUsername"
let kPrefsReallUsername = "reallUsername"
let kPrefsMobile = "userMobile"
let kPrefsEmail = "userEmail"
let kPrefsUserPassword = "userPassword"
let kPresUserId = "userId"
let kPrefsHistory = "UserHistory"
let kPrefsWhoCanSee = "whoCanSee"
let kPrefsNotifications = "notification"
let kUserPic = "UserProfilePicture"
let kPrefsAllowFriendsToFind = "allow_friend_to_search"
let kPrefsNoOfBlockedUsers = "blockedUsers"
let kPrefsConversatioin = "Conversation"
let kPrefsWhoCanDM = "DM"
let kPrefsUserCountry = "UserCountry"
let kPrefsUserState = "UserState"

//end of user prefrences
let kPrefsHistory3 = "3 days"
let kPrefsHistory5 = "5 days"
let kPrefsHistory7 = "1 week"
let kEveryOne = "Everyone"
let kFriends = "Friends"
let kNobody = "Nobody"

let kSettingLocation: [String] = ["Everyone", "Friends", "Nobody"]
let kSettingDirectMessage: [String] = ["Everyone", "Friends", "Nobody"]
let kSettingClearConversation: [String] = ["NONE", "3 DAYS", "5 DAYS", "1 WEEK", "CLEAR CONVERSATION"]
let kSettingClearHostHistory: [String] = ["NONE", "3 DAYS", "5 DAYS", "1 WEEK", "CLEAR HOST HISTORY"]

let kShare_With: [String] = ["", "Public", "Friends", "Custom"]
//font
let kBoldFont = "Helvetica-Bold"
let kNormalFont = "Helvetica"

//Host History

let kHistoryContentsHeight = 325
let kHistoryImageHeight = 210
let kHistoryCommentHeight = 60


//Notifications
let kNoti_Refresh_Host_History = "reload_Host_History"
let kNoti_Show_Home_BadgeNumber = "show_Home_BadgeNumber"
let kNoti_Hide_Home_BadgeNumber = "hide_Home_BadgeNumber"

