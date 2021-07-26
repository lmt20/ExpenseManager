//
//  ExpenseMainView.swift
//  ExpenseManager
//
//  Created by it on 23/07/2021.
//

import SwiftUI

struct ExpenseMainView: View {
    
    var filter: ExpenseCDFilterTime
    var fetchRequest: FetchRequest<ExpenseCD>
    var expense: FetchedResults<ExpenseCD> { fetchRequest.wrappedValue }
    
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    init(filter: ExpenseCDFilterTime) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        self.filter = filter
        if filter == .all {
            fetchRequest = FetchRequest<ExpenseCD>(
                entity: ExpenseCD.entity(),
                sortDescriptors: [sortDescriptor]
            )
            self.filter = filter
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
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            fetchRequest = FetchRequest<ExpenseCD>(
                entity: ExpenseCD.entity(),
                sortDescriptors: [sortDescriptor],
                predicate: predicate)
        }
    }
    
    private func getTotalBalance() -> String {
        var value = Double(0)
        for i in expense {
            if i.type == TRANS_TYPE_INCOME { value += i.amount }
            else if i.type == TRANS_TYPE_EXPENSE {
                value -= i.amount
            }
        }
        return "\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if fetchRequest.wrappedValue.isEmpty {
                VStack {
                    LottieView(animType: .empty_face)
                        .frame(width: 300, height: 300)
                    TextView(text: "No Transaction Yet!", type: .h6)
                        .foregroundColor(Color.text_primary_color)
                    TextView(text: "Add a transaction and it will show up here", type: .body_1)
                        .foregroundColor(Color.text_secondary_color)
                        .padding(.top, 2)
                }.padding(.horizontal)
            } else {
                VStack(spacing: 16) {
                    TextView(text: "TOTAL BAlANCE", type: .overline)
                        .foregroundColor(Color.init(hex: "828282"))
                        .padding(.top, 30)
                    TextView(text: "\(CURRENCY)\(getTotalBalance())", type: .h5)
                        .foregroundColor(Color.text_primary_color)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.secondary_color)
                .cornerRadius(4)
                
                HStack(spacing: 8) {
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: true))) {
                        ExpenseModelView(isIncome: true, filter: filter)
                    }
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: false))) {
                        ExpenseModelView(isIncome: false, filter: filter)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer().frame(height: 16)
                
                HStack {
                    TextView(text: "Recent Transaction", type: .subtitle_1)
                        .foregroundColor(Color.text_primary_color)
                    Spacer()
                }.padding(4)
                
                ForEach(self.fetchRequest.wrappedValue) { expenseObj in
                    NavigationLink(destination: Text("ExpenseDetailView")) {
                        ExpenseTransView(expenseObj: expenseObj)
                    }
                }
            }
            Spacer().frame(height: 150)
        }
        .padding(.horizontal, 8).padding(.top, 0)
    }
}

