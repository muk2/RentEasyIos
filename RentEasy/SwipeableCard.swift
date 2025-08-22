//
//  SwipeableCard.swift
//  RentEasy
//
//  Created by Mukund Chanchlani on 8/22/25.
//

import SwiftUI


struct SwipeableCard: View {
    let listing: Listing
    let onSwipe: (Bool) -> Void  // true = liked, false = disliked

    @State private var offset = CGSize.zero
    @GestureState private var isDragging = false

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: listing.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .scaledToFill()
            .frame(width: 300, height: 400)
            .clipped()
            .cornerRadius(16)
            .shadow(radius: 5)

            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(listing.title).font(.headline)
                    Text(listing.price).font(.subheadline).foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(16)
            }
        }
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / 10))) // tilt effect
        .gesture(
            DragGesture()
                .updating($isDragging) { value, state, _ in
                    state = true
                }
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    if abs(offset.width) > 100 {
                        // Swipe detected
                        onSwipe(offset.width > 0) // true if liked
                    } else {
                        // snap back
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
        .animation(.interactiveSpring(), value: offset)
    }
}

#Preview {
    SwipeableCard(
        listing: Listing(id: 1, title: "🏡 Cozy 2BR Apartment in NYC", price: "$2,300/mo", image: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800"),
        onSwipe: { liked in
            print(liked ? "Liked!" : "Disliked!")
        }
    )
}
