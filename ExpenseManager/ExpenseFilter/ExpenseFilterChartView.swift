//
//  ExpenseFilterChartView.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI
import CoreData

struct ExpenseFilterChartView: View {
    var isIncome: Bool
    var type: String
    var fetchRequest: FetchRequest<ExpenseCD>
    var expense: FetchedResults<ExpenseCD> { fetchRequest.wrappedValue }
    @AppStorage(UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    private func getTotalValue() -> String {
        var value = Double(0)
        for i in expense { value += i.amount }
        return "\(String(format: "%.2f", value))"
    }
    
    private func getChartModel() -> [ChartModel] {
        var transactions = [String: Double]()
        for i in expense {
            guard  let tag = i.tag else { continue }
            if let value = transactions[tag] {
                transactions[tag] = value + i.amount
            } else {
                transactions[tag] = i.amount
            }
        }
        
        var models = [ChartModel]()
        for i in transactions {
            models.append(ChartModel(transType: getTransTagTitle(transTag: i.key), transAmount: i.value))
        }
        return models
    }
    
    init(isIncome: Bool, filter: ExpenseCDFilterTime) {
        self.isIncome = isIncome
        self.type = isIncome ? TRANS_TYPE_INCOME : TRANS_TYPE_EXPENSE
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            let predicate = NSPredicate(format: "type == %@", type)
            fetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().getLast7Day()! as NSDate }
            else if filter == .month { startDate = Date().getLast30Day()! as NSDate }
            else { startDate = Date().getLast6Month()! as NSDate }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, type)
            fetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    
    var body: some View {
        Group {
            if !expense.isEmpty {
                ChartView(label: "Total \(isIncome ? "Income" : "Expense") - \(CURRENCY)\(getTotalValue())", entries: ChartModel.getTransaction(transactions: getChartModel()))
            }
        }
    }
}

struct ExpenseFilterChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseFilterChartView(isIncome: true, filter: .month)
    }
}
