//
//  GlobalVariables.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import UIKit

// MARK: - Global Variables

let store = UserDefaults.standard
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let osVersion = UIDevice.current.systemVersion

// MARK: - Global Constants

let ALERT_PRESENT_TIME = 1
let MAX_QUESTION_COUNT = 1000
let CHART_VERTICAL_SIZE: CGFloat = 270

// MARK: - Devloper Constants

let APP_ID = "6738980588"
let DEVELOPER_ID = "1578285460"

// MARK: - Typealiases

typealias StringBoolDict = [String : Bool]

// MARK: - Config Keys

extension String {
  static let cfgIntervalTypeStates = "Config_IntervalType_BoolStates"
  
  static let cfgNotesAscending = "Config_Notes_Ascending"
  static let cfgNotesDescending = "Config_Notes_Descending"
  static let cfgNotesSimultaneously = "Config_Notes_Simultaneously"
  
  static let cfgClefTreble = "Config_Clef_Treble"
  static let cfgClefBass = "Config_Clef_Bass"
  static let cfgClefAlto = "Config_Clef_Alto"

  static let cfgHapticPressedIntervalKeyboard = "Config_Haptic_PressedIntervalKeyboard"
  static let cfgHapticAnswer = "Config_Haptic_Answer"
  static let cfgHapticWrong = "Config_Haptic_Wrong"
  
  static let cfgQuizSoundAutoplay = "Config_Quiz_SoundAutoplay"
  /// 악보 위치 (Int) - 0: 중앙, 1: 아래 2: 위
  static let cfgQuizSheetPosition = "Config_Quiz_SheetPosition"
  
  static let cfgAccidentalSharp = "Config_Accidental_Sharp"
  static let cfgAccidentalFlat = "Config_Accidental_Flat"
  static let cfgAccidentalDoubleSharp = "Config_Accidental_DoubleSharp"
  static let cfgAccidentalDoubleFlat = "Config_Accidental_DoubleFlat"
  
  static let checkInitConfigCompleted = "Check_InitConfigCompleted"
  
  static let cfgIntervalFilterCompound = "Config_IntervalFilter_Compound"
  static let cfgIntervalFilterDoublyTritone = "Config_IntervalFilter_DoublyTritone"
  
  static let cfgTimerSeconds = "Config_Timer_Seconds"
  
  static let cfgAppAutoNextMove = "Config_App_AutoNextMove"
  
  /// 다크모드 여부 (Int) - 0: 시스템, 1: 라이트 고정 2: 다크 고정
  static let cfgAppAppearance = "Config_App_Appearance"
  
  /// 리마인더 온오프?
  static let moreInfoRemindeIsOn = "MoreInfo_Reminder_IsOn"
  /// 리마인더 노티 시각 (0~23시)
  static let moreInfoReminderHour = "MoreInfo_Reminder_Hour"
  /// 리마인더 노티 시각 (0~59분)
  static let moreInfoReminderMinute = "MoreInfo_Reminder_Minute"
}

// MARK: - Tutorial Image Bundle

let TUTORIAL_IMAGES: [String : [UIImage]] =  [
  "ja": [.ja1QuizCorrectAlert, .ja2QuizCorrectView, .ja3QuizWrongAlert, .ja4QuizWrongView, .ja5Stats, .ja6Setting1, .ja7Setting2],
  "en": [.en1QuizCorrectAlert, .en2QuizCorrectView, .en3QuizWrongAlert, .en4QuizWrongView, .en5Stats, .en6Setting1, .en7Setting2],
  "ko": [.ko1QuizCorrectAlert, .ko2QuizCorrectView, .ko3QuizWrongAlert, .ko4QuizWrongView, .ko5Stats, .ko6Setting1, .ko7Setting2],
]

// MARK: - Initial config values

let INTERVAL_TYPE_STATE_FIRST = [
  "P_1": true,
  "A_1": true,
  "d_1": true,
  "AA_1": true,
  "dd_1": true,
  "M_2": true,
  "m_2": true,
  "A_2": true,
  "d_2": true,
  "AA_2": true,
  "dd_2": true,
  "M_3": true,
  "m_3": true,
  "A_3": true,
  "d_3": true,
  "AA_3": true,
  "dd_3": true,
  "P_4": true,
  "A_4": true,
  "d_4": true,
  "AA_4": true,
  "dd_4": true,
  "M_5": true,
  "m_5": true,
  "A_5": true,
  "d_5": true,
  "AA_5": true,
  "dd_5": true,
  "P_6": true,
  "A_6": true,
  "d_6": true,
  "AA_6": true,
  "dd_6": true,
  "M_7": true,
  "m_7": true,
  "A_7": true,
  "d_7": true,
  "AA_7": true,
  "dd_7": true,
  "P_8": true,
  "A_8": true,
  "d_8": true,
  "AA_8": true,
  "dd_8": true,
  "M_9": true,
  "m_9": true,
  "A_9": true,
  "d_9": true,
  "AA_9": true,
  "dd_9": true,
  "M_10": true,
  "m_10": true,
  "A_10": true,
  "d_10": true,
  "AA_10": true,
  "dd_10": true,
  "P_11": true,
  "A_11": true,
  "d_11": true,
  "AA_11": true,
  "dd_11": true,
  "M_12": true,
  "m_12": true,
  "A_12": true,
  "d_12": true,
  "AA_12": true,
  "dd_12": true,
  "P_13": true,
  "A_13": true,
  "d_13": true,
  "AA_13": true,
  "dd_13": true,
]

// MARK: - Global funcs

