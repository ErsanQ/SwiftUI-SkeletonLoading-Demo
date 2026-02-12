//
//  ContentView.swift
//  skeleton
//
//  Created by Ersan Qaher on 12/02/2026.
//

import SwiftUI
import SwiftData

struct Article: Identifiable {
    let id = UUID()
    var title: String
}

struct ContentView: View {

    @State private var items: [Article?] = Array(repeating: nil, count: 6)

    var body: some View {
        NavigationView {
            List(items.indices, id: \.self) { index in
                if let article = items[index] {
                    RealRow(title: article.title)
                } else {
                    SkeletonRow()
                }
            }
            .navigationTitle("Articles")
        }
        .onAppear {
            loadGradually()
        }
    }

    func loadGradually() {
        for i in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                items[i] = Article(title: "Article \(i + 1)")
            }
        }
    }
}

struct RealRow: View {
    var title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 60, height: 60)

            Text(title)
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 16)
        }
        .padding(.vertical, 8)
        .redacted(reason: .placeholder)
        .shimmering(active: true)
    }
}

extension View {
    func shimmering(active: Bool) -> some View {
        self
            .overlay(
                Group {
                    if active {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        Color.white.opacity(0.6),
                                        .clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .rotationEffect(.degrees(30))
                            .offset(x: -120)
                            .animation(
                                .linear(duration: 1.2)
                                .repeatForever(autoreverses: false),
                                value: active
                            )
                    }
                }
            )
            .mask(self)
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
