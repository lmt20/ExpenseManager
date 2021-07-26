//
//  ExpenseModelView.swift
//  ExpenseManager
//
//  Created by it on 23/07/2021.
//

import SwiftUI

struct ExpenseModelView: View {
    var isIncome: Bool
    var type: String { isIncome ? TRANS_TYPE_INCOME : TRANS_TYPE_EXPENSE }
    var fetchRequest: FetchRequest<ExpenseCD>!
    var expense: FetchedResults<ExpenseCD> { fetchRequest.wrappedValue }
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    private func getTotalValue() -> String {
        var value = Double(0)
        for i in expense {
            value += i.amount
        }
        return "\(String(format: "%.2f", value))"
    }
    
    init(isIncome: Bool, filter: ExpenseCDFilterTime, categTag: String? = nil) {
        self.isIncome = isIncome
        let sortDescriptor = NSSortDescriptor(key: "occoredOn", ascending: false)
        if filter == .all {
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "type == %@ AND tag == %@", type, tag)
            } else {
                predicate = NSPredicate(format: "type == %@", type)
            }
            fetchRequest = FetchRequest<ExpenseCD>(
                entity: ExpenseCD.entity(),
                sortDescriptors: [sortDescriptor],
                predicate: predicate
            )
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week {
                startDate = Date().getLast7Day()! as NSDate
            } else if filter == .month {
                startDate = Date().getLast30Day()! as NSDate
            } else {
                startDate = Date().getLast6Month()! as NSDate
            }
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@ AND tag == %@", startDate, endDate, type, tag)
            } else {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, type)
            }
            fetchRequest = FetchRequest<ExpenseCD>(
                entity: ExpenseCD.entity(),
                sortDescriptors: [sortDescriptor],
                predicate: predicate
            )
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Image(isIncome ? "income_icon": "expense_icon" )
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(12)
            }
            HStack {
                TextView(text: type.uppercased(), type: .overline)
                    .foregroundColor(Color.init(hex: "828282"))
                Spacer()
            }.padding(.horizontal, 12)
            
            HStack {
                TextView(text: "\(CURRENCY)\(getTotalValue())", type: .h5, lineLimit: 1)
                    .foregroundColor(Color.text_primary_color)
                Spacer()
            }.padding(.horizontal, 12)
        }
        .padding(.bottom, 12)
        .background(Color.secondary_color)
        .cornerRadius(4)
    }
}

struct ExpenseModelView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseModelView(isIncome: false, filter: .all)
    }
}
