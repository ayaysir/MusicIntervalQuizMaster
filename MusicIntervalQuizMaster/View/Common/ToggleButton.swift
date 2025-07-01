//
//  ToggleButton.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 6/30/25.
//

import SwiftUI

struct ToggleButton: View {
  let title: String
  var musiqwikText: String? = nil
  var textFontSize: CGFloat = 14
  let isSelected: Bool
  var selectedTintColor: Color = .teal
  var selectedTextColor: Color = .white
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack {
        if let musiqwikText {
          Text(verbatim: musiqwikText)
            .font(.custom("Musiqwik", size: 20))
        }
        Text(title)
          .font(.system(size: musiqwikText != nil ? 10 : textFontSize))
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 4)
      .padding(.vertical, musiqwikText != nil ? 4 : 8)
      .background(isSelected ? selectedTintColor : Color.gray.opacity(0.2))
      .foregroundColor(isSelected ? selectedTextColor : .primary)
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .buttonStyle(.plain)
  }
}

struct ToggleButtonForSelectInterval: View {
  let degreeText: String
  let abbrText: String
  @Binding var isSelected: Bool
  var selectedTintColor: Color = .orange
  
  var body: some View {
    Button {
      isSelected.toggle()
    } label: {
      HStack(spacing: 4) {
        Text(degreeText)
          .font(.system(size: 14, weight: isSelected ? .semibold: .regular))
          .foregroundColor(isSelected ? .white : .primary)
        Text(abbrText)
          .font(.system(size: 12, weight: isSelected ? .semibold: .regular))
          .foregroundColor(isSelected ? .white.opacity(0.6) : .primary.opacity(0.6))
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 2)
      .padding(.vertical, 4)
      .background(isSelected ? selectedTintColor : Color.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  VStack {
    ToggleButtonForSelectInterval(
      degreeText: "완전 1도",
      abbrText: "A1",
      isSelected: .constant(true)
    )
    
    ToggleButtonForSelectInterval(
      degreeText: "완전 1도",
      abbrText: "A1",
      isSelected: .constant(false)
    )
    
    ToggleButton(
      title: "xpxp",
      isSelected: false) {
        
      }
    ToggleButton(title: "xpxp", isSelected: true) {
      
    }
    ToggleButton(
      title: "Driri",
      isSelected: true,
      selectedTintColor: .teal) {
        
      }
    ToggleButton(
      title: "높은음자리표",
      musiqwikText: "=\(Clef.treble.musiqwikText)=",
      isSelected: false) {
        
      }
    ToggleButton(
      title: "높은음자리표",
      musiqwikText: "=\(Clef.treble.musiqwikText)=",
      isSelected: true) {
        
      }
  }
}
