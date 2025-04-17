import Foundation

struct Surah: Identifiable {
    let id = UUID()
    let number: Int
    let name: String
    let arabicName: String
    let juz: Int
    let ayahCount: Int
    let memorizedCount: Int
} 