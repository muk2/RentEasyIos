//
//  DashboardView.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/22/25.
//

import SwiftUI

struct Listing: Identifiable {
    let id: Int
    let title: String
    let price: String
    let image: String
}

let sampleListings: [Listing] = [
    .init(id: 1, title: "🏡 Cozy 2BR Apartment in NYC", price: "$2,300/mo", image: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800"),
    .init(id: 2, title: "🌇 Modern Loft in LA", price: "$3,100/mo", image: "https://images.unsplash.com/photo-1501183638710-841dd1904471?w=800"),
    .init(id: 3, title: "🌴 Beachside Condo in Miami", price: "$2,800/mo", image: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800")
]

struct DashboardView: View {
    @State private var listings = sampleListings
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            Text("🎉 RentEasy Listings").font(.largeTitle).padding()

            ZStack {
                // Show cards from last to first so top card is swipeable
                ForEach(listings) { listing in
                    SwipeableCard(listing: listing) { liked in
                        print(liked ? "Liked!" : "Disliked!")
                        // Remove card when swiped
                        if let index = listings.firstIndex(where: { $0.id == listing.id }) {
                            listings.remove(at: index)
                        }
                    }
                    .padding(8)
                }
            }
            .frame(height: 450)

            Button("🚪 Logout") {
                UserDefaults.standard.removeObject(forKey: "access_token")
                isLoggedIn = false
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    DashboardView(
        isLoggedIn: .constant(true)
    )
}
