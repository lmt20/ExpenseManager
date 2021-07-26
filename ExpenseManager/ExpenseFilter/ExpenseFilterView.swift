//
//  ExpenseFilterView.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI

struct ExpenseFilterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ExpenseCD.getAllExpenseData(
                    sortBy: ExpenseCDSort.occuredOn,
                    ascending: false
    )) var expense: FetchedResults<ExpenseCD>
    
    @State var filter: ExpenseCDFilterTime = .all
    @State var showingSheet = false
    var isIncome: Bool?
    var categTag: String?
    
    
    init(isIncome: Bool? = nil, categTag: String? = nil) {
        self.isIncome = isIncome
        self.categTag = categTag
    }
    
    func getToolbarTitle() -> String {
        if let isIncome = isIncome {
            return isIncome ? "Income" : "Expense"
        } else if let tag = categTag {
            return getTransTagTitle(transTag: tag)
        }
        return "Dashboard"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    ToolbarModelView(title: getToolbarTitle(), button1Icon: IMAGE_FILTER_ICON) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    button1Method: {
                        self.showingSheet = true
                    }
                    .actionSheet(isPresented: $showingSheet) {
                        ActionSheet(title: Text("Select a filter"), buttons: [
                            .default(Text("Overall")) { filter = .all },
                            .default(Text("Last 7 days")) { filter = .week },
                            .default(Text("Last 30 days")) { filter = .month },
                            .cancel()
                        ])
                    }
                    ScrollView(showsIndicators: false) {
                        if let isIncome = isIncome {
                            Text("ExpensFilterChartView")
                                .frame(width: 350, height: 350)
                            Text("ExpenseFilterTransList")
                        }
                        
                        if let tag = categTag {
                            HStack(spacing: 8) {
                                ExpenseModelView(isIncome: true, filter: filter, categTag: tag)
                                ExpenseModelView(isIncome: false, filter: filter, categTag: tag)
                            }.frame(maxWidth: .infinity)
                            Text("ExpenseFilterTransList")
                        }
                        Spacer().frame(height: 150)
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 0)
                    
                    Spacer()
                    
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ExpenseFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseFilterView()
    }
}
