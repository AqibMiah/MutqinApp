import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let type: TaskType
    let ayahNumber: Int
    let isCompleted: Bool
    let isLocked: Bool
    let ayahContent: (arabicText: String, translation: String)?
    
    enum TaskType {
        case ayah
        case test
    }
}

struct MemorizationView: View {
    let surah: Surah
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAyah: Int?
    @State private var showAyahView = false
    @State private var tasks: [Task] = []
    
    private func loadTasks() {
        print("MemorizationView: Loading tasks for Surah \(surah.number) - \(surah.name)")
        var newTasks: [Task] = []
        var currentAyah = 1
        
        while currentAyah <= surah.ayahCount {
            // Add next 5 ayahs
            for i in currentAyah...min(currentAyah + 4, surah.ayahCount) {
                let ayahContent = QuranDatabaseService.shared.getAyah(forSurah: surah.number, ayahNum: i)
                print("MemorizationView: Loaded ayah \(i) content: \(ayahContent != nil ? "success" : "failed")")
                newTasks.append(Task(
                    type: .ayah,
                    ayahNumber: i,
                    isCompleted: false,
                    isLocked: i > surah.memorizedCount + 1,
                    ayahContent: ayahContent
                ))
            }
            
            // Add test after 5 ayahs (if we have more ayahs)
            if currentAyah + 4 <= surah.ayahCount {
                newTasks.append(Task(
                    type: .test,
                    ayahNumber: currentAyah + 4,
                    isCompleted: false,
                    isLocked: true,
                    ayahContent: nil
                ))
            }
            
            currentAyah += 5
        }
        
        print("MemorizationView: Loaded \(newTasks.count) tasks")
        tasks = newTasks
    }
    
    var body: some View {
        ZStack {
            Color.hex("0E5C53")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text(surah.name)
                                .font(.system(size: 20, weight: .bold))
                            Text("\(surah.memorizedCount) XP")
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
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Progress")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        ProgressBarView(progress: Double(surah.memorizedCount) / Double(surah.ayahCount))
                            .frame(height: 8)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Tasks Timeline
                    VStack(spacing: 0) {
                        if tasks.isEmpty {
                            Text("Loading tasks...")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            ForEach(tasks) { task in
                                TaskRow(task: task) {
                                    if !task.isLocked && task.type == .ayah {
                                        print("MemorizationView: Selected Ayah \(task.ayahNumber)")
                                        selectedAyah = task.ayahNumber
                                        showAyahView = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            print("MemorizationView: View appeared")
            loadTasks()
        }
        .fullScreenCover(isPresented: $showAyahView) {
            if let ayahNumber = selectedAyah {
                AyahView(surah: surah, ayahNumber: ayahNumber)
            } else {
                EmptyView()
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline circle and line
            VStack(spacing: 0) {
                Circle()
                    .fill(task.isLocked ? Color.gray.opacity(0.3) : Color.white)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 12)
            
            // Task content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Task icon and title
                    Group {
                        switch task.type {
                        case .ayah:
                            HStack {
                                Image(systemName: "book.fill")
                                Text("Ayah \(task.ayahNumber)")
                            }
                        case .test:
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Test (Ayahs \(task.ayahNumber-4)-\(task.ayahNumber))")
                            }
                        }
                    }
                    .foregroundColor(task.isLocked ? .gray : .white)
                    
                    Spacer()
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if task.isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                    } else if task.type == .ayah {
                        Button(action: action) {
                            Text("Start")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Show preview of ayah content if available
                if task.type == .ayah, let content = task.ayahContent {
                    Text(content.arabicText)
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                        .padding(.top, 4)
                }
            }
            .padding(.vertical, 16)
        }
    }
} 