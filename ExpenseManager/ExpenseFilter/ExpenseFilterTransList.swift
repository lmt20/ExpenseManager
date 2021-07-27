//
//  ExpenseFilterTransList.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI

struct ExpenseFilterTransList: View {
    
    var isIncome: Bool?
    var tag: String?
    var fetchRequest: FetchRequest<ExpenseCD>
    var expense: FetchedResults<ExpenseCD> { fetchRequest.wrappedValue }
    
    init(isIncome: Bool? = nil, filter: ExpenseCDFilterTime, tag: String? = nil) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            let predicate: NSPredicate!
            if let isIncome = isIncome {
                predicate = NSPredicate(format: "type == %@", (isIncome ? TRANS_TYPE_INCOME : TRANS_TYPE_EXPENSE))
            } else if let tag = tag { predicate = NSPredicate(format: "tag == %@", tag) }
            else { predicate = NSPredicate(format: "occuredOn <= %@", NSDate()) }
            fetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().getLast7Day()! as NSDate }
            else if filter == .month { startDate = Date().getLast30Day()! as NSDate }
            else { startDate = Date().getLast6Month()! as NSDate }
            let predicate: NSPredicate!
            if let isIncome = isIncome {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, (isIncome ? TRANS_TYPE_INCOME : TRANS_TYPE_EXPENSE))
            } else if let tag = tag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND tag == %@", startDate, endDate, tag)
            } else { predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate) }
            fetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    var body: some View {
        ForEach(self.fetchRequest.wrappedValue) { expenseObj in
            NavigationLink(destination: ExpenseDetailedView(expenseObj: expenseObj), label: { ExpenseTransView(expenseObj: expenseObj) })
        }
    }
}

struct ExpenseFilterTransList_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseFilterTransList(isIncome: true, filter: .all, tag: TRANS_TAG_TRANSPORT)
    }
}
