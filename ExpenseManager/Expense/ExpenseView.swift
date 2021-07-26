//
//  ExpenseView.swift
//  ExpenseManager
//
//  Created by it on 23/07/2021.
//

import SwiftUI

struct ExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ExpenseCD.getAllExpenseData(sortBy: ExpenseCDSort.occuredOn, ascending: false)) var expense: FetchedResults<ExpenseCD>
    
    
    @State private var filter: ExpenseCDFilterTime = .all
    
    @State private var showOptionsSheet = false
    @State private var showFilterSheet = false
    @State private var displaySettings: Bool = false
    @State private var displayAbout: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    NavigationLink(
                        destination: Text("Setting"),
                        isActive: $displaySettings,
                        label: {}
                    )
                    NavigationLink(
                        destination: Text("About"),
                        isActive: $displayAbout,
                        label: {}
                    )
                    ToolbarModelView(
                        title: "Dashboard",
                        hasBackButton: false,
                        button1Icon: IMAGE_OPTION_ICON,
                        button2Icon: IMAGE_FILTER_ICON,
                        backButtonClick: {
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        button1Method: {
                            self.showOptionsSheet = true
                        },
                        button2Method: {
                            self.showFilterSheet = true
                        }
                    ).actionSheet(isPresented: $showFilterSheet) {
                        ActionSheet(title: Text("Select a filter"), buttons: [
                            .default(Text("Overall")) { filter = .all },
                            .default(Text("Last 7 days")) { filter = .week },
                            .default(Text("Last 30 days")) { filter = .month },
                            .cancel()
                        ])
                    }
                    ExpenseMainView(filter: filter)
                        .actionSheet(isPresented: $showOptionsSheet) {
                            ActionSheet(title: Text("Select an option"), buttons: [
                                .default(Text("About")) { self.displayAbout = true },
                                .default(Text("Setting")) {self.displaySettings = true },
                                .cancel()
                            ])
                        }
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: NavigationLazyView(AddExpenseView(viewModel: AddExpenseViewModel()))) {
                            Image("plus_icon")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                            .padding()
                            .background(Color.main_color)
                            .cornerRadius(35)
                    }
                }.padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
