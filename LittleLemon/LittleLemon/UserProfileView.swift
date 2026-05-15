//
//  UserProfileView.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import SwiftUI

struct UserProfileView: View {
    // Step 4: Constants dari UserDefaults
    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)

    // Step 5: Environment variable untuk navigasi
    @Environment(\.presentationMode) var presentation

    var body: some View {
        // Step 2: VStack sebagai container utama
        VStack(spacing: 20) {
            // Judul halaman
            Text("Personal information")
                .font(.custom("MarkaziText-Medium", size: 30))
                .foregroundColor(secondaryBlack)

            // Step 3: Profile Image
            // Pastikan Anda telah menambahkan "profile-image-placeholder" di Assets
            Image("Profile")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())

            // Step 4: Menampilkan data user
            VStack(alignment: .leading, spacing: 10) {
                Text("First Name: \(firstName ?? "")")
                Text("Last Name: \(lastName ?? "")")
                Text("Email: \(email ?? "")")
            }
            .font(.custom("Karla-Regular", size: 18))
            .padding()

            // Step 5: Button Logout
            Button(action: {
                // Set login status menjadi false
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                // Dismiss view untuk kembali ke Onboarding
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

            // Membuat item mulai dari atas
            Spacer()
        }
        .padding()
        .background(secondaryWhite.ignoresSafeArea())
    }
}
