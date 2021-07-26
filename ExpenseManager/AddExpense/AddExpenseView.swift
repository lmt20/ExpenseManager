//
//  AddExpenseView.swift
//  ExpenseManager
//
//  Created by it on 26/07/2021.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var confirmDelete = false
    @State var showAttachSheet = false
//    @StateObject var viewModel: AddExpenseViewModel
    var body: some View {
        Text("Hello, World!")
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
