import SwiftUI

// Add this struct before AyahView
struct AyahContent: Equatable {
    let arabicText: String
    let translation: String
}

struct AyahView: View {
    let surah: Int
    @State private var currentAyahNumber: Int
    let preloadedContent: AyahContent?
    
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var ayahContent: AyahContent?
    @State private var repeatCount = 0
    @State private var showNextButton = false
    @Environment(\.dismiss) private var dismiss
    @State private var showTest = false
    @State private var hasPassedTest = false
    
    // Add total ayahs for the surah
    private var totalAyahsInSurah: Int {
        QuranDatabaseService.shared.getNumberOfAyahs(forSurah: surah) ?? 0
    }
    
    // Check if current ayah is the last one in surah
    private var isLastAyahInSurah: Bool {
        currentAyahNumber == totalAyahsInSurah
    }
    
    // Check if we should show a test
    private var shouldShowTest: Bool {
        currentAyahNumber % 5 == 0 || isLastAyahInSurah
    }
    
    init(surah: Int, ayahNumber: Int, preloadedContent: AyahContent?) {
        self.surah = surah
        self._currentAyahNumber = State(initialValue: ayahNumber)
        self.preloadedContent = preloadedContent
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.mutqinGreen.edgesIgnoringSafeArea(.all)
            
            if showTest {
                QuranTestView(
                    surah: surah,
                    currentAyah: currentAyahNumber,
                    shouldShowTest: $showTest,
                    onTestPassed: {
                        hasPassedTest = true
                        showTest = false
                        if isLastAyahInSurah {
                            // Handle completion of surah
                            dismiss()
                        } else {
                            loadNextAyah()
                        }
                    },
                    onTestFailed: {
                        // Reset to the previous checkpoint or start of last section
                        let previousCheckpoint = isLastAyahInSurah 
                            ? ((totalAyahsInSurah - 1) / 5) * 5 // Last section start
                            : ((currentAyahNumber - 1) / 5) * 5 // Previous checkpoint
                        currentAyahNumber = previousCheckpoint
                        showTest = false
                        loadAyahContent()
                    }
                )
            } else if isLoading {
                VStack {
                    ProgressView()
                        .tint(.white)
                    Text("Loading...")
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            } else if let error = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if let content = ayahContent {
                ScrollView {
                    VStack(spacing: 0) {
                        // Counter and Progress
                        HStack {
                            Text("Repetitions: \(repeatCount)/7")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Progress circles
                            HStack(spacing: 4) {
                                ForEach(0..<7) { index in
                                    Circle()
                                        .fill(index < repeatCount ? Color.white : Color.white.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        // Surah and Ayah number indicator
                        Text("Surah \(surah) : \(currentAyahNumber)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom, 20)
                        
                        // Content Card
                        VStack(spacing: 24) {
                            // Arabic Text
                            Text(content.arabicText)
                                .font(.custom("AlQalamQuran", size: 36))
                                .foregroundColor(.mutqinGreen)
                                .multilineTextAlignment(.center)
                                .lineSpacing(12)
                                .padding(.horizontal)
                            
                            // Translation
                            if !content.translation.isEmpty {
                                Text(content.translation)
                                    .font(.body)
                                    .foregroundColor(.black.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            incrementCounter()
                        }
                        
                        // Instructions
                        Text("Tap the ayah to count repetitions")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 12)
                        
                        // Next Button
                        Button(action: loadNextAyah) {
                            HStack {
                                Text("Next Ayah")
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.mutqinGreen)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                        .disabled(!showNextButton)
                        .opacity(showNextButton ? 1.0 : 0.5)
                        .padding(.top, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            print("AyahView: View appeared for Surah \(surah), Ayah \(currentAyahNumber)")
            loadAyahContent()
        }
    }
    
    private func incrementCounter() {
        if repeatCount < 7 {
            repeatCount += 1
            if repeatCount == 7 {
                showNextButton = true
            }
        }
    }
    
    private func loadNextAyah() {
        isLoading = true
        // Reset counter and button state
        repeatCount = 0
        showNextButton = false
        hasPassedTest = false
        
        // Increment ayah number
        currentAyahNumber += 1
        
        // Check if we need to show a test
        if shouldShowTest {
            showTest = true
            isLoading = false
            return
        }
        
        // Load next ayah content
        if let nextContent = QuranDatabaseService.shared.getAyah(forSurah: surah, ayahNum: currentAyahNumber) {
            print("Loading next ayah: Surah \(surah), Ayah \(currentAyahNumber)")
            self.ayahContent = nextContent
            self.errorMessage = nil
        } else {
            print("Failed to load next ayah: Surah \(surah), Ayah \(currentAyahNumber)")
            self.errorMessage = "No more ayahs available"
            // Revert the ayah number if loading failed
            currentAyahNumber -= 1
        }
        
        isLoading = false
    }
    
    private func loadAyahContent() {
        isLoading = true
        print("AyahView: Loading content for Surah \(surah), Ayah \(currentAyahNumber)")
        
        // If we have preloaded content, use it immediately
        if let preloaded = preloadedContent {
            print("AyahView: Using preloaded content")
            self.ayahContent = preloaded
            self.isLoading = false
            return
        }
        
        // Otherwise, fetch from database
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let ayah = QuranDatabaseService.shared.getAyah(forSurah: surah, ayahNum: currentAyahNumber) {
                print("AyahView: Successfully loaded ayah from database")
                self.ayahContent = ayah
                self.errorMessage = nil
            } else {
                print("AyahView: Failed to load ayah from database")
                self.errorMessage = "Could not load Ayah content"
            }
            self.isLoading = false
        }
    }
}

// Preview provider for testing
struct AyahView_Previews: PreviewProvider {
    static var previews: some View {
        AyahView(surah: 1, ayahNumber: 1, preloadedContent: AyahContent(
            arabicText: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
            translation: "In the name of Allah, the Entirely Merciful, the Especially Merciful"
        ))
    }
}

#Preview {
    AyahView(surah: 1, ayahNumber: 1, preloadedContent: nil)
}

// Helper view for navigation buttons
struct NavigationButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
        }
    }
} 