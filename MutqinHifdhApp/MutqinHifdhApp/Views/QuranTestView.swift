import SwiftUI

struct QuranTest {
    let questionAyah: AyahContent
    let options: [AyahContent]
    let correctIndex: Int
}

struct QuranTestView: View {
    let surah: Int
    let currentAyah: Int
    @Binding var shouldShowTest: Bool
    var onTestPassed: () -> Void
    var onTestFailed: () -> Void
    
    @State private var selectedOption: Int?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var test: QuranTest?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.mutqinGreen.edgesIgnoringSafeArea(.all)
            
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else if let test = test {
                VStack(spacing: 24) {
                    // Progress Header
                    HStack {
                        Button(action: { shouldShowTest = false }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "flame")
                            .foregroundColor(.white)
                        Text("5")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    // Progress Bar
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 4)
                            .overlay(
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width * (Double(currentAyah % 5) / 5.0), height: 4)
                                    .animation(.easeInOut, value: currentAyah),
                                alignment: .leading
                            )
                    }
                    .frame(height: 4)
                    .padding(.horizontal)
                    
                    // Question Card
                    VStack(spacing: 20) {
                        Text("What comes after this ayah?")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(test.questionAyah.arabicText)
                            .font(.custom("AlQalamQuran", size: 28))
                            .foregroundColor(.mutqinGreen)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                    .padding(.horizontal)
                    
                    // Options
                    VStack(spacing: 12) {
                        ForEach(0..<test.options.count, id: \.self) { index in
                            Button(action: { selectOption(index) }) {
                                Text(test.options[index].arabicText)
                                    .font(.custom("AlQalamQuran", size: 24))
                                    .foregroundColor(optionTextColor(for: index))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(optionBackground(for: index))
                                    .cornerRadius(12)
                            }
                            .disabled(showResult)
                        }
                    }
                    .padding(.horizontal)
                    
                    if showResult {
                        // Result Message
                        VStack(spacing: 16) {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(isCorrect ? .green : .red)
                            
                            Text(isCorrect ? "Well done!" : "Try again!")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            if !isCorrect {
                                Text("90% accuracy")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Button(action: handleContinue) {
                                HStack {
                                    Text(isCorrect ? "Continue" : "Re-listen")
                                    if !isCorrect {
                                        Image(systemName: "arrow.clockwise")
                                    }
                                }
                                .foregroundColor(.mutqinGreen)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding(.top, 44)
            }
        }
        .onAppear(perform: loadTest)
    }
    
    private func loadTest() {
        isLoading = true
        
        // Get the current ayah
        guard let currentAyahContent = QuranDatabaseService.shared.getAyah(forSurah: surah, ayahNum: currentAyah) else {
            return
        }
        
        // Get the next few ayahs for options
        var options: [AyahContent] = []
        var correctIndex = 0
        
        // Get the correct next ayah
        if let correctAyah = QuranDatabaseService.shared.getAyah(forSurah: surah, ayahNum: currentAyah + 1) {
            options.append(correctAyah)
        }
        
        // Get some other ayahs as wrong options
        for offset in [-2, 2, 3] {
            if let ayah = QuranDatabaseService.shared.getAyah(forSurah: surah, ayahNum: currentAyah + offset),
               ayah.arabicText != options[0].arabicText {
                options.append(ayah)
            }
        }
        
        // Shuffle the options but remember the correct index
        let shuffledOptions = options.shuffled()
        correctIndex = shuffledOptions.firstIndex(where: { $0.arabicText == options[0].arabicText }) ?? 0
        
        test = QuranTest(
            questionAyah: currentAyahContent,
            options: shuffledOptions,
            correctIndex: correctIndex
        )
        
        isLoading = false
    }
    
    private func selectOption(_ index: Int) {
        guard let test = test else { return }
        selectedOption = index
        showResult = true
        isCorrect = index == test.correctIndex
    }
    
    private func optionBackground(for index: Int) -> Color {
        guard let selected = selectedOption, showResult else {
            return selectedOption == index ? .white : .white.opacity(0.9)
        }
        
        if index == test?.correctIndex {
            return .green.opacity(0.2)
        }
        if index == selected && !isCorrect {
            return .red.opacity(0.2)
        }
        return .white.opacity(0.9)
    }
    
    private func optionTextColor(for index: Int) -> Color {
        guard let selected = selectedOption, showResult else {
            return selectedOption == index ? .mutqinGreen : .black
        }
        
        if index == test?.correctIndex {
            return .green
        }
        if index == selected && !isCorrect {
            return .red
        }
        return .black
    }
    
    private func handleContinue() {
        if isCorrect {
            onTestPassed()
        } else {
            onTestFailed()
        }
    }
} 