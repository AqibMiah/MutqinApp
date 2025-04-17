import SwiftUI

struct ProgressView: View {
    // Sample data - these would be computed from actual user progress
    let ayahsMemorized = 120
    let surahsComplete = 4
    let daysStreak = 8
    let accuracy = 85
    let juzProgress = 30 // percentage
    
    // Areas for review
    let reviewAreas = [
        ReviewItem(surah: "Al-Baqarah", verse: 25, accuracy: 75),
        ReviewItem(surah: "Al-Mulk", verse: 12, accuracy: 60)
    ]
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "0E5C53")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Your Progress")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        StatCard(
                            icon: "text.book.closed.fill",
                            title: "Ayahs\nMemorized",
                            value: "\(ayahsMemorized)"
                        )
                        
                        StatCard(
                            icon: "checkmark.circle.fill",
                            title: "Surahs\nComplete",
                            value: "\(surahsComplete)"
                        )
                        
                        StatCard(
                            icon: "flame.fill",
                            title: "Days\nStreak",
                            value: "\(daysStreak)"
                        )
                        
                        StatCard(
                            icon: "star.fill",
                            title: "Accuracy",
                            value: "\(accuracy)%"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Juz Progress
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Juz Progress")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Juz 1")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                Spacer()
                                Text("\(juzProgress)%")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 16))
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * CGFloat(juzProgress) / 100, height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Areas for Review
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Areas for Review")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            ForEach(reviewAreas) { item in
                                ReviewCard(item: item)
                            }
                            
                            Button(action: {
                                // Handle review action
                            }) {
                                Text("Review These Verses")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(hex: "0E5C53"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Hadith Quote
                    VStack(spacing: 12) {
                        Text("The best of you are those who learn the Qur'an and teach it.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .italic()
                        
                        Text("- Sahih al-Bukhari")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(24)
                }
                .padding(.bottom, 16)
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 52, height: 52)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .padding(.top, 16)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
        }
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct ReviewItem: Identifiable {
    let id = UUID()
    let surah: String
    let verse: Int
    let accuracy: Int
}

struct ReviewCard: View {
    let item: ReviewItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Surah \(item.surah), Verse \(item.verse)")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("\(item.accuracy)% Accuracy")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProgressView()
} 
