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
    @State var searchText = ""
    @State var selectedCategory = ""

    let categories = ["Starters", "Mains", "Desserts"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                Spacer()
                Image("profile-image-placeholder")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            VStack(alignment: .leading, spacing: 5) {
                Text("Little Lemon")
                    .font(.custom("MarkaziText-Medium", size: 42))
                    .foregroundColor(primaryYellow)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Chicago")
                            .font(.custom("MarkaziText-Medium", size: 26))
                            .foregroundColor(.white)

                        Text(
                            "We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."
                        )
                        .font(.custom("Karla-Regular", size: 16))
                        .foregroundColor(.white)

                    }
                    Spacer()
                    Image("Hero image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 130)
                        .cornerRadius(16)
                }

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search menu", text: $searchText)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 10)
            }
            .padding()
            .background(primaryGreen)

            VStack(alignment: .leading, spacing: 10) {
                Text("Order for Delivery")
                    .font(.custom("Karla-Bold", size: 18))
                    .padding([.horizontal, .top])

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                // Toggle filter logic
                                if selectedCategory == category.lowercased() {
                                    selectedCategory = ""
                                } else {
                                    selectedCategory = category.lowercased()
                                }
                            }) {
                                Text(category)
                                    .font(.custom("Karla-Bold", size: 16))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .background(
                                        selectedCategory
                                            == category.lowercased()
                                            ? primaryYellow
                                            : Color.gray.opacity(0.15)
                                    )
                                    .foregroundColor(primaryGreen)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Divider().padding(.top, 10)
            }

            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: [
                    NSSortDescriptor(
                        key: "title",
                        ascending: true,
                        selector: #selector(NSString.localizedStandardCompare)
                    )
                ]
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(dish.title ?? "").bold()
                                    .font(.custom("Karla-Bold", size: 18))

                                Text(dish.descriptionText ?? "")
                                    .font(.custom("Karla-Regular", size: 14))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)

                                Text("$\(dish.price ?? "0").00")
                                    .font(.custom("Karla-Bold", size: 16))
                                    .foregroundColor(primaryGreen)
                            }
                            Spacer()
                            AsyncImage(url: URL(string: dish.image ?? "")) {
                                image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 85, height: 85)
                            .cornerRadius(8)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            getMenuData()
        }
    }

    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(
                NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            )
        }

        if !selectedCategory.isEmpty {
            predicates.append(
                NSPredicate(format: "category == %@", selectedCategory)
            )
        }

        return predicates.isEmpty
            ? NSPredicate(value: true)
            : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    func getMenuData() {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        let count = (try? viewContext.count(for: fetchRequest)) ?? 0

        if count > 0 { return }

        let urlString =
            "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let menuList = try? decoder.decode(MenuList.self, from: data)
                {
                    for item in menuList.menu {
                        let newDish = Dish(context: viewContext)
                        newDish.title = item.title
                        newDish.image = item.image
                        newDish.price = item.price
                        newDish.descriptionText = item.description
                        newDish.category = item.category.lowercased()
                    }
                    try? viewContext.save()
                }
            }
        }.resume()
    }
}
