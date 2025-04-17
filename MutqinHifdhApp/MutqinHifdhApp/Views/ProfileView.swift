import SwiftUI

struct Achievement {
    let icon: String
    let title: String
    let description: String
    let progress: Double
    let isCompleted: Bool
}

struct ProfileView: View {
    let userName = "Ahmed Mohammad"
    let userType = "Hifdh Student"
    
    let achievements = [
        Achievement(
            icon: "star.fill",
            title: "First Steps",
            description: "Memorize your first surah",
            progress: 1.0,
            isCompleted: true
        ),
        Achievement(
            icon: "flame.fill",
            title: "5 Day Streak",
            description: "Practice for 5 days in a row",
            progress: 0.8,
            isCompleted: false
        ),
        Achievement(
            icon: "book.fill",
            title: "100 Ayahs",
            description: "Memorize 100 ayahs",
            progress: 0.65,
            isCompleted: false
        ),
        Achievement(
            icon: "trophy.fill",
            title: "First Juz",
            description: "Complete memorization of first Juz",
            progress: 0.3,
            isCompleted: false
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.hex("0E5C53")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with Settings
                        HStack {
                            Text("Profile")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                // Handle settings
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Profile Card
                        VStack(spacing: 16) {
                            // Profile Image
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.white)
                            }
                            
                            // Name and Title
                            VStack(spacing: 4) {
                                Text(userName)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(userType)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            // Edit Profile Button
                            Button(action: {
                                // Handle edit profile
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.and.pencil")
                                    Text("Edit Profile")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(24)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Achievements Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(achievements, id: \.title) { achievement in
                                    AchievementCard(achievement: achievement)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Preferred Surahs Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Preferred Surahs")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                PreferredSurahRow(
                                    surahName: "Al-Fatiha",
                                    versesCount: "7 verses",
                                    progress: 100
                                )
                                
                                PreferredSurahRow(
                                    surahName: "Al-Ikhlas",
                                    versesCount: "4 verses",
                                    progress: 85
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isCompleted ? Color.white : Color.white.opacity(0.1))
                    .frame(width: 56, height: 56)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.isCompleted ? Color.hex("0E5C53") : .white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(achievement.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * achievement.progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct PreferredSurahRow: View {
    let surahName: String
    let versesCount: String
    let progress: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Surah Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "book.fill")
                    .foregroundColor(.white)
            }
            
            // Surah Info
            VStack(alignment: .leading, spacing: 4) {
                Text(surahName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(versesCount)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Progress
            Text("\(progress)%")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
} 