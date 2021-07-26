//
//  AuthenticateView.swift
//  ExpenseManager
//
//  Created by it on 22/07/2021.
//

import SwiftUI
import LocalAuthentication

struct AuthenticateView: View {
    @State private var didAuthenticate = false
    @State private var showAlert = false
    @State private var alertMsg = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ExpenseView().navigationBarBackButtonHidden(true),
                    isActive: $didAuthenticate,
                    label: {}
                )
                Color.primary_color.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack() {
                    Spacer()
                    Image("pie_icon")
                        .resizable()
                        .frame(width: 120, height: 120)
                    TextView(text: "\(APP_NAME) is locked", type: .body_1)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                        .foregroundColor(Color.text_primary_color)
                        .accentColor(Color.text_primary_color)
                    Button(action: authenticate, label: {
                        HStack {
                            Spacer()
                            TextView(text: "Unlock", type: .button)
                                .foregroundColor(Color.main_color)
                            Spacer()
                        }
                    })
                    .frame(height: 25)
                    .padding().background(Color.secondary_color)
                    .cornerRadius(4)
                    .foregroundColor(Color.text_primary_color)
                    .accentColor(Color.text_primary_color)
                    Spacer()
                }
                .padding(.horizontal)
                .ignoresSafeArea(.all)
                .onAppear(perform: {
                    self.authenticate()
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock \(APP_NAME)"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success { self.didAuthenticate = true }
                    else { alertMsg = authenticationError?.localizedDescription ?? "Error"; showAlert = true }
                }
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Please authenticate yourself to unlock \(APP_NAME)"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success { self.didAuthenticate = true }
                    else { alertMsg = authenticationError?.localizedDescription ?? "Error"; showAlert = true }
                }
            }
        }
    }
}

struct AuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateView()
    }
}
