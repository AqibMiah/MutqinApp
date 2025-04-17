import SwiftUI

struct DashboardView: View {
    @State private var hasNotifications = true
    @State private var selectedTab = 0
    
    // Sample data
    let userName = "Ahmad"
    let streak = 7
    let memorizedAyahs = 124
    let todayTarget = 5
    let completedToday = 3
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView(userName: userName, hasNotifications: hasNotifications, streak: streak, memorizedAyahs: memorizedAyahs, todayTarget: todayTarget, completedToday: completedToday)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            
            // Surahs Tab
            SurahsListView()
                .tabItem {
                    VStack {
                        Image(systemName: "book.fill")
                        Text("Surahs")
                    }
                }
                .tag(1)
            
            // Progress Tab
            ProgressView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                }
                .tag(3)
        }
        .accentColor(.white)
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(hex: "0E5C53"))
            
            // Set the selected and unselected item colors
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
            
            // Apply the appearance
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

// Create a separate HomeView for the home tab content
struct HomeView: View {
    let userName: String
    let hasNotifications: Bool
    let streak: Int
    let memorizedAyahs: Int
    let todayTarget: Int
    let completedToday: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Assalamu'alaikum")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        Text(userName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            // Handle notifications
                        }) {
                            ZStack {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                if hasNotifications {
                                    Circle()
                                        .fill(Color(hex: "FF6B6B"))
                                        .frame(width: 8, height: 8)
                                        .offset(x: 6, y: -6)
                                }
                            }
                        }
                        
                        Button(action: {
                            // Handle settings
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Progress Section
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        // Streak Card
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            
                            Text("\(streak) Days")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Text("Streak")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Divider
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1, height: 40)
                        
                        // Ayahs Memorized Card
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "book.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            
                            Text("\(memorizedAyahs)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Text("Ayahs Memorized")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Today's Progress
                    VStack(spacing: 12) {
                        HStack {
                            Text("Today's Progress")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(completedToday)/\(todayTarget) Ayahs")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 12)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width * CGFloat(completedToday) / CGFloat(todayTarget), height: 12)
                            }
                        }
                        .frame(height: 12)
                    }
                }
                .padding(20)
                
                // Main Menu Section
                VStack(spacing: 16) {
                    // Quick Actions
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        MenuCard(
                            title: "Continue Memorizing",
                            subtitle: "Pick up where you left off",
                            icon: "book.fill"
                        )
                        .frame(height: 140)
                        
                        MenuCard(
                            title: "Review Surahs",
                            subtitle: "Practice what you know",
                            icon: "arrow.counterclockwise"
                        )
                        .frame(height: 140)
                        
                        MenuCard(
                            title: "Challenges",
                            subtitle: "Test your memory",
                            icon: "trophy.fill"
                        )
                        .frame(height: 140)
                        
                        MenuCard(
                            title: "Leaderboard",
                            subtitle: "See how you rank",
                            icon: "chart.bar.fill"
                        )
                        .frame(height: 140)
                    }
                    .padding(.horizontal, 20)
                    
                    // Recommended Surahs
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recommended for You")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(1...5, id: \.self) { index in
                                    SurahCard(
                                        surahName: "Al-Fatiha",
                                        ayahCount: 7,
                                        progress: 0.7
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .background(Color(hex: "0E5C53"))
    }
}

struct MenuCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        Button(action: {
            // Handle card tap
        }) {
            VStack(spacing: 16) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                
                // Text Stack
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
        }
    }
}

struct SurahCard: View {
    let surahName: String
    let ayahCount: Int
    let progress: Double
    
    var body: some View {
        Button(action: {
            // Handle surah selection
        }) {
            VStack(alignment: .leading, spacing: 12) {
                Text(surahName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(ayahCount) Ayahs")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
            .frame(width: 160)
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Custom corner radius shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 
