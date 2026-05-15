//
//  Menu.swift
//  LittleLemon
//
//  Created by Arya Dzikra on 15/05/2026.
//

import CoreData
import SwiftUI

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Step 3: State variable untuk teks pencarian
    @State var searchText = ""

    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.custom("MarkaziText-Medium", size: 42))
                .foregroundColor(primaryYellow)

            Text("Chicago")
                .font(.custom("MarkaziText-Medium", size: 24))

            Text("Search for your favorite dish!")
                .font(.custom("Karla-Regular", size: 16))

            // Step 3: TextField untuk pencarian
            TextField("Search menu", text: $searchText)
                .padding()
                .textFieldStyle(.roundedBorder)

            // Step 2 & 5: Update FetchedObjects dengan Predicate dan Sort Descriptors
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            Text("\(dish.title ?? "") - $\(dish.price ?? "")")
                                .font(.custom("Karla-Regular", size: 18))

                            Spacer()

                            AsyncImage(url: URL(string: dish.image ?? "")) {
                                image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }

    // Step 1: Fungsi untuk mengurutkan berdasarkan nama (A-Z)
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }

    // Step 4: Fungsi untuk menyaring data berdasarkan teks pencarian
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            // Jika kosong, tampilkan semua data
            return NSPredicate(value: true)
        } else {
            // Filter berdasarkan judul yang mengandung teks (case-insensitive)
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    // Fungsi fetch data (seperti di latihan sebelumnya)
    func getMenuData() {
        PersistenceController.shared.clear()

        let urlString =
            "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in
            if let data = data {
                let decoder = JSONDecoder()
                if let menuList = try? decoder.decode(MenuList.self, from: data)
                {
                    for item in menuList.menu {
                        let newDish = Dish(context: viewContext)
                        newDish.title = item.title
                        newDish.image = item.image
                        newDish.price = item.price
                    }
                    try? viewContext.save()
                }
            }
        }
        task.resume()
    }
}
