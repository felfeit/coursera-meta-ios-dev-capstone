//
//  Onboarding.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import SwiftUI

struct OnboardingView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""

    @State var isLoggedIn = false

    var body: some View {

        NavigationStack {
            VStack {
                secondaryWhite
                    .frame(height: 120)
                    .overlay(
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                    )

                VStack(spacing: 15) {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()

                Spacer()

                Button(action: {
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
                    {
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                        isLoggedIn = true
                    }
                }) {
                    Text("Register")
                        .font(.custom("Karla-Regular", size: 18))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryYellow)
                        .foregroundColor(primaryGreen)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            }
            .background(secondaryWhite.ignoresSafeArea())
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }
}
