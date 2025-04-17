import SwiftUI

struct AyahView: View {
    let surah: Surah
    let ayahNumber: Int
    @Environment(\.dismiss) private var dismiss
    @State private var ayahContent: (arabicText: String, translation: String)?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color.hex("0E5C53")
                .ignoresSafeArea()
            
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Text("Loading Ayah \(ayahNumber) from Surah \(surah.name)...")
                        .foregroundColor(.white)
                        .padding(.top)
                }
            } else if let content = ayahContent {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            Button(action: { 
                                print("AyahView: Dismiss button tapped")
                                dismiss() 
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text(surah.name)
                                    .font(.system(size: 20, weight: .bold))
                                Text("Ayah \(ayahNumber)")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Placeholder to maintain centering
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.clear)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        // Arabic Text Card
                        VStack(spacing: 16) {
                            Text(content.arabicText)
                                .font(.custom("AmiriQuran", size: 32, relativeTo: .title))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.vertical, 32)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Translation Card (if available)
                        if !content.translation.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Translation")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text(content.translation)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        // Navigation Buttons
                        HStack(spacing: 16) {
                            if ayahNumber > 1 {
                                Button(action: {
                                    loadAyah(number: ayahNumber - 1)
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(22)
                                }
                            }
                            
                            Spacer()
                            
                            if ayahNumber < surah.ayahCount {
                                Button(action: {
                                    loadAyah(number: ayahNumber + 1)
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(22)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text(errorMessage ?? "Could not load ayah content")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            print("AyahView: View appeared for Surah: \(surah.number), Ayah: \(ayahNumber)")
            loadAyah(number: ayahNumber)
        }
    }
    
    private func loadAyah(number: Int) {
        print("AyahView: Loading ayah \(number)")
        isLoading = true
        errorMessage = nil
        
        // Simulate a small delay to prevent UI flicker
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let content = QuranDatabaseService.shared.getAyah(forSurah: surah.number, ayahNum: number) {
                print("AyahView: Successfully loaded ayah content")
                print("AyahView: Arabic text length: \(content.arabicText.count)")
                self.ayahContent = content
            } else {
                print("AyahView: Failed to load ayah content")
                self.errorMessage = "Could not load Ayah \(number) from Surah \(surah.name).\nPlease make sure the database is properly included in the app."
            }
            isLoading = false
        }
    }
} 