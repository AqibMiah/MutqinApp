import SwiftUI
import SQLite3

struct SurahHeaderView: View {
    let surah: Surah
    
    var body: some View {
        VStack(spacing: 8) {
            Text(surah.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(surah.arabicName)
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Juz \(surah.juz) · \(surah.ayahCount) Ayahs")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 32)
    }
}

struct ProgressCardView: View {
    let surah: Surah
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.headline)
                .foregroundColor(.gray)
            
            let progress = Double(surah.memorizedCount) / Double(surah.ayahCount)
            ProgressBarView(progress: progress)
            
            Text("\(Int(progress * 100))% Memorized")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct MemorizeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Start Memorizing")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.hex("0E5C53"))
                .cornerRadius(12)
        }
    }
}

struct SurahDetailView: View {
    let surah: Surah
    @State private var showMemorizationView = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SurahHeaderView(surah: surah)
                ProgressCardView(surah: surah)
                MemorizeButton {
                    showMemorizationView = true
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.mutqinGreen)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showMemorizationView) {
            NavigationView {
                MemorizationView(surah: surah)
            }
        }
    }
} 