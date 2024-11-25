//
//  GlobalVariables.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import Foundation

// MARK: - Global Variables

let store = UserDefaults.standard

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
  
  static let cfgAccidentalSharp = "Config_Accidental_Sharp"
  static let cfgAccidentalFlat = "Config_Accidental_Flat"
  static let cfgAccidentalDoubleSharp = "Config_Accidental_DoubleSharp"
  static let cfgAccidentalDoubleFlat = "Config_Accidental_DoubleFlat"
  
  static let checkInitConfigCompleted = "Check_InitConfigCompleted"
}

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
