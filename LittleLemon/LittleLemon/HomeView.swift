//
//  HomeView.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import SwiftUI
import CoreData

struct HomeView: View {
    // Step 4: Persistence constant
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            MenuView()
                .environment(
                    \.managedObjectContext,
                    persistence.container.viewContext
                )  // Pass viewContext
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
