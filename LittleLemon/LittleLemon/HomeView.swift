//
//  HomeView.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import CoreData
import SwiftUI

struct HomeView: View {
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            MenuView()
                .environment(
                    \.managedObjectContext,
                    persistence.container.viewContext
                )
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
