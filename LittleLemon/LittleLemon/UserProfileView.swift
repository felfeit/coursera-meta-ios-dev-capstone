//
//  UserProfileView.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import SwiftUI

struct UserProfileView: View {
    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)

    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack(spacing: 20) {

            Text("Personal information")
                .font(.custom("MarkaziText-Medium", size: 30))
                .foregroundColor(secondaryBlack)

            Image("Profile")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 10) {
                Text("First Name: \(firstName ?? "")")
                Text("Last Name: \(lastName ?? "")")
                Text("Email: \(email ?? "")")
            }
            .font(.custom("Karla-Regular", size: 18))
            .padding()

            Button(action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .font(.custom("Karla-Regular", size: 18))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryYellow)
                    .foregroundColor(primaryGreen)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(secondaryWhite.ignoresSafeArea())
    }
}
