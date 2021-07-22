//
//  ExpenseManagerApp.swift
//  ExpenseManager
//
//  Created by it on 22/07/2021.
//

import SwiftUI

@main
struct ExpenseManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
