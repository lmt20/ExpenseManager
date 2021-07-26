//
//  ExpenseTransView.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI

struct ExpenseTransView: View {
    
    @ObservedObject var expenseObj: ExpenseCD
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    func getTransAmountString() -> String {
        return "\(expenseObj.type == TRANS_TYPE_INCOME ? "+" : "-")\(CURRENCY)\(expenseObj.amount)"
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: NavigationLazyView(ExpenseFilterView(categTag: expenseObj.tag))) {
                Image(getTransTagIcon(transTag: expenseObj.tag ?? ""))
                    .resizable().frame(width: 24, height: 24).padding(16)
                    .background(Color.primary_color).cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    TextView(text: expenseObj.title ?? "", type: .subtitle_1, lineLimit: 1)
                        .foregroundColor(Color.text_primary_color)
                    Spacer()
                    TextView(text: getTransAmountString(), type: .subtitle_1, lineLimit: 1)
                        .foregroundColor(expenseObj.type == TRANS_TYPE_INCOME ? Color.main_green : Color.main_red)
                }
                HStack {
                    TextView(text: getTransTagTitle(transTag: expenseObj.tag ?? ""), type: .body_2)
                        .foregroundColor(Color.text_primary_color)
                    Spacer()
                    TextView(text: getDateFormatter(date: expenseObj.occuredOn, format: "MMM dd, yyyy"), type: .body_2)
                        .foregroundColor(Color.text_primary_color)
                }
            }.padding(.leading, 4)
            
            Spacer()
            
        }.padding(8).background(Color.secondary_color).cornerRadius(4)
    }
}
