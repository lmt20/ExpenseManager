//
//  DropdownButton.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI

struct DropdownOption: Hashable {
    var key: String
    var val: String
    
    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool  {
        return lhs.key == rhs.key
    }
}

struct DropdownOptionElement: View {
    var val: String
    var key: String
    var mainColor: Color
    var onSelect: ((_ key: String) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onSelect = onSelect {
                onSelect(self.key)
            }
        }) {
            Text(self.val)
                .foregroundColor(mainColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

struct Dropdown: View {
    
    var options: [DropdownOption]
    var onSelect: ((_ key: String) -> Void)?
    let cornerRadius: CGFloat
    let mainColor: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.options, id: \.self) { option in
                DropdownOptionElement(val: option.val, key: option.key, mainColor: mainColor, onSelect: self.onSelect)
            }
        }
        .padding(.vertical, 4)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(mainColor, lineWidth: 0)
        )
    }
}

struct DropdownButton: View {
    @Binding var shouldShowDropdown: Bool
    @Binding var displayText: String
    
    var options: [DropdownOption]
    let mainColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let buttonHeight: CGFloat
    let onSelect: ((_ key: String) -> Void)?
    
    var body: some View {
        VStack {
            Button(action: {
                self.shouldShowDropdown.toggle()
            }) {
                HStack {
                    Text(displayText).foregroundColor(mainColor)
                    Spacer()
                    Image(systemName: self.shouldShowDropdown ? "chevron.up" : "chvron.down")
                        .foregroundColor(mainColor)
                }
            }
            .padding(.horizontal)
            .cornerRadius(cornerRadius)
            .frame(height: self.buttonHeight)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
            
            VStack {
                if self.shouldShowDropdown {
                    Dropdown(options: self.options, onSelect: self.onSelect, cornerRadius: self.cornerRadius, mainColor: self.mainColor, backgroundColor: self.backgroundColor)
                }
            }
        }.animation(.spring())
    }
}

struct DropdownButton_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButton(shouldShowDropdown: Binding.constant(true), displayText: Binding.constant("Type"), options: [DropdownOption(key: "Income", val: "1"), DropdownOption(key: "Expense", val: "2")], mainColor: Color.main_color, backgroundColor: Color.secondary_color, cornerRadius: 3, buttonHeight: 25, onSelect: nil)
    }
}
