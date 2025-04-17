import SwiftUI

struct SurahsListView: View {
    @State private var searchText = ""
    
    // Complete list of surahs
    let surahs = [
        Surah(number: 1, name: "Al-Fatiha", arabicName: "الفاتحة", juz: 1, ayahCount: 7, memorizedCount: 0),
        Surah(number: 2, name: "Al-Baqarah", arabicName: "البقرة", juz: 1, ayahCount: 286, memorizedCount: 0),
        Surah(number: 3, name: "Al-Imran", arabicName: "آل عمران", juz: 3, ayahCount: 200, memorizedCount: 0),
        Surah(number: 4, name: "An-Nisa", arabicName: "النساء", juz: 4, ayahCount: 176, memorizedCount: 0),
        Surah(number: 5, name: "Al-Ma'idah", arabicName: "المائدة", juz: 6, ayahCount: 120, memorizedCount: 0),
        Surah(number: 6, name: "Al-An'am", arabicName: "الأنعام", juz: 7, ayahCount: 165, memorizedCount: 0),
        Surah(number: 7, name: "Al-A'raf", arabicName: "الأعراف", juz: 8, ayahCount: 206, memorizedCount: 0),
        Surah(number: 8, name: "Al-Anfal", arabicName: "الأنفال", juz: 9, ayahCount: 75, memorizedCount: 0),
        Surah(number: 9, name: "At-Tawbah", arabicName: "التوبة", juz: 10, ayahCount: 129, memorizedCount: 0),
        Surah(number: 10, name: "Yunus", arabicName: "يونس", juz: 11, ayahCount: 109, memorizedCount: 0),
        Surah(number: 11, name: "Hud", arabicName: "هود", juz: 11, ayahCount: 123, memorizedCount: 0),
        Surah(number: 12, name: "Yusuf", arabicName: "يوسف", juz: 12, ayahCount: 111, memorizedCount: 0),
        Surah(number: 13, name: "Ar-Ra'd", arabicName: "الرعد", juz: 13, ayahCount: 43, memorizedCount: 0),
        Surah(number: 14, name: "Ibrahim", arabicName: "إبراهيم", juz: 13, ayahCount: 52, memorizedCount: 0),
        Surah(number: 15, name: "Al-Hijr", arabicName: "الحجر", juz: 14, ayahCount: 99, memorizedCount: 0),
        Surah(number: 16, name: "An-Nahl", arabicName: "النحل", juz: 14, ayahCount: 128, memorizedCount: 0),
        Surah(number: 17, name: "Al-Isra", arabicName: "الإسراء", juz: 15, ayahCount: 111, memorizedCount: 0),
        Surah(number: 18, name: "Al-Kahf", arabicName: "الكهف", juz: 15, ayahCount: 110, memorizedCount: 0),
        Surah(number: 19, name: "Maryam", arabicName: "مريم", juz: 16, ayahCount: 98, memorizedCount: 0),
        Surah(number: 20, name: "Ta-Ha", arabicName: "طه", juz: 16, ayahCount: 135, memorizedCount: 0),
        Surah(number: 21, name: "Al-Anbiya", arabicName: "الأنبياء", juz: 17, ayahCount: 112, memorizedCount: 0),
        Surah(number: 22, name: "Al-Hajj", arabicName: "الحج", juz: 17, ayahCount: 78, memorizedCount: 0),
        Surah(number: 23, name: "Al-Mu'minun", arabicName: "المؤمنون", juz: 18, ayahCount: 118, memorizedCount: 0),
        Surah(number: 24, name: "An-Nur", arabicName: "النور", juz: 18, ayahCount: 64, memorizedCount: 0),
        Surah(number: 25, name: "Al-Furqan", arabicName: "الفرقان", juz: 19, ayahCount: 77, memorizedCount: 0),
        Surah(number: 26, name: "Ash-Shu'ara", arabicName: "الشعراء", juz: 19, ayahCount: 227, memorizedCount: 0),
        Surah(number: 27, name: "An-Naml", arabicName: "النمل", juz: 19, ayahCount: 93, memorizedCount: 0),
        Surah(number: 28, name: "Al-Qasas", arabicName: "القصص", juz: 20, ayahCount: 88, memorizedCount: 0),
        Surah(number: 29, name: "Al-Ankabut", arabicName: "العنكبوت", juz: 20, ayahCount: 69, memorizedCount: 0),
        Surah(number: 30, name: "Ar-Rum", arabicName: "الروم", juz: 21, ayahCount: 60, memorizedCount: 0),
        Surah(number: 31, name: "Luqman", arabicName: "لقمان", juz: 21, ayahCount: 34, memorizedCount: 0),
        Surah(number: 32, name: "As-Sajdah", arabicName: "السجدة", juz: 21, ayahCount: 30, memorizedCount: 0),
        Surah(number: 33, name: "Al-Ahzab", arabicName: "الأحزاب", juz: 21, ayahCount: 73, memorizedCount: 0),
        Surah(number: 34, name: "Saba", arabicName: "سبأ", juz: 22, ayahCount: 54, memorizedCount: 0),
        Surah(number: 35, name: "Fatir", arabicName: "فاطر", juz: 22, ayahCount: 45, memorizedCount: 0),
        Surah(number: 36, name: "Ya-Sin", arabicName: "يس", juz: 22, ayahCount: 83, memorizedCount: 0),
        Surah(number: 37, name: "As-Saffat", arabicName: "الصافات", juz: 23, ayahCount: 182, memorizedCount: 0),
        Surah(number: 38, name: "Sad", arabicName: "ص", juz: 23, ayahCount: 88, memorizedCount: 0),
        Surah(number: 39, name: "Az-Zumar", arabicName: "الزمر", juz: 23, ayahCount: 75, memorizedCount: 0),
        Surah(number: 40, name: "Ghafir", arabicName: "غافر", juz: 24, ayahCount: 85, memorizedCount: 0),
        Surah(number: 41, name: "Fussilat", arabicName: "فصلت", juz: 24, ayahCount: 54, memorizedCount: 0),
        Surah(number: 42, name: "Ash-Shura", arabicName: "الشورى", juz: 25, ayahCount: 53, memorizedCount: 0),
        Surah(number: 43, name: "Az-Zukhruf", arabicName: "الزخرف", juz: 25, ayahCount: 89, memorizedCount: 0),
        Surah(number: 44, name: "Ad-Dukhan", arabicName: "الدخان", juz: 25, ayahCount: 59, memorizedCount: 0),
        Surah(number: 45, name: "Al-Jathiyah", arabicName: "الجاثية", juz: 25, ayahCount: 37, memorizedCount: 0),
        Surah(number: 46, name: "Al-Ahqaf", arabicName: "الأحقاف", juz: 25, ayahCount: 35, memorizedCount: 0),
        Surah(number: 47, name: "Muhammad", arabicName: "محمد", juz: 26, ayahCount: 38, memorizedCount: 0),
        Surah(number: 48, name: "Al-Fath", arabicName: "الفتح", juz: 26, ayahCount: 29, memorizedCount: 0),
        Surah(number: 49, name: "Al-Hujurat", arabicName: "الحجرات", juz: 26, ayahCount: 18, memorizedCount: 0),
        Surah(number: 50, name: "Qaf", arabicName: "ق", juz: 26, ayahCount: 45, memorizedCount: 0),
        Surah(number: 51, name: "Adh-Dhariyat", arabicName: "الذاريات", juz: 26, ayahCount: 60, memorizedCount: 0),
        Surah(number: 52, name: "At-Tur", arabicName: "الطور", juz: 27, ayahCount: 49, memorizedCount: 0),
        Surah(number: 53, name: "An-Najm", arabicName: "النجم", juz: 27, ayahCount: 62, memorizedCount: 0),
        Surah(number: 54, name: "Al-Qamar", arabicName: "القمر", juz: 27, ayahCount: 55, memorizedCount: 0),
        Surah(number: 55, name: "Ar-Rahman", arabicName: "الرحمن", juz: 27, ayahCount: 78, memorizedCount: 0),
        Surah(number: 56, name: "Al-Waqi'ah", arabicName: "الواقعة", juz: 27, ayahCount: 96, memorizedCount: 0),
        Surah(number: 57, name: "Al-Hadid", arabicName: "الحديد", juz: 27, ayahCount: 29, memorizedCount: 0),
        Surah(number: 58, name: "Al-Mujadilah", arabicName: "المجادلة", juz: 28, ayahCount: 22, memorizedCount: 0),
        Surah(number: 59, name: "Al-Hashr", arabicName: "الحشر", juz: 28, ayahCount: 24, memorizedCount: 0),
        Surah(number: 60, name: "Al-Mumtahanah", arabicName: "الممتحنة", juz: 28, ayahCount: 13, memorizedCount: 0),
        Surah(number: 61, name: "As-Saff", arabicName: "الصف", juz: 28, ayahCount: 14, memorizedCount: 0),
        Surah(number: 62, name: "Al-Jumu'ah", arabicName: "الجمعة", juz: 28, ayahCount: 11, memorizedCount: 0),
        Surah(number: 63, name: "Al-Munafiqun", arabicName: "المنافقون", juz: 28, ayahCount: 11, memorizedCount: 0),
        Surah(number: 64, name: "At-Taghabun", arabicName: "التغابن", juz: 28, ayahCount: 18, memorizedCount: 0),
        Surah(number: 65, name: "At-Talaq", arabicName: "الطلاق", juz: 28, ayahCount: 12, memorizedCount: 0),
        Surah(number: 66, name: "At-Tahrim", arabicName: "التحريم", juz: 28, ayahCount: 12, memorizedCount: 0),
        Surah(number: 67, name: "Al-Mulk", arabicName: "الملك", juz: 29, ayahCount: 30, memorizedCount: 0),
        Surah(number: 68, name: "Al-Qalam", arabicName: "القلم", juz: 29, ayahCount: 52, memorizedCount: 0),
        Surah(number: 69, name: "Al-Haqqah", arabicName: "الحاقة", juz: 29, ayahCount: 52, memorizedCount: 0),
        Surah(number: 70, name: "Al-Ma'arij", arabicName: "المعارج", juz: 29, ayahCount: 44, memorizedCount: 0),
        Surah(number: 71, name: "Nuh", arabicName: "نوح", juz: 29, ayahCount: 28, memorizedCount: 0),
        Surah(number: 72, name: "Al-Jinn", arabicName: "الجن", juz: 29, ayahCount: 28, memorizedCount: 0),
        Surah(number: 73, name: "Al-Muzzammil", arabicName: "المزمل", juz: 29, ayahCount: 20, memorizedCount: 0),
        Surah(number: 74, name: "Al-Muddathir", arabicName: "المدثر", juz: 29, ayahCount: 56, memorizedCount: 0),
        Surah(number: 75, name: "Al-Qiyamah", arabicName: "القيامة", juz: 29, ayahCount: 40, memorizedCount: 0),
        Surah(number: 76, name: "Al-Insan", arabicName: "الإنسان", juz: 29, ayahCount: 31, memorizedCount: 0),
        Surah(number: 77, name: "Al-Mursalat", arabicName: "المرسلات", juz: 29, ayahCount: 50, memorizedCount: 0),
        Surah(number: 78, name: "An-Naba", arabicName: "النبأ", juz: 30, ayahCount: 40, memorizedCount: 0),
        Surah(number: 79, name: "An-Nazi'at", arabicName: "النازعات", juz: 30, ayahCount: 46, memorizedCount: 0),
        Surah(number: 80, name: "Abasa", arabicName: "عبس", juz: 30, ayahCount: 42, memorizedCount: 0),
        Surah(number: 81, name: "At-Takwir", arabicName: "التكوير", juz: 30, ayahCount: 29, memorizedCount: 0),
        Surah(number: 82, name: "Al-Infitar", arabicName: "الإنفطار", juz: 30, ayahCount: 19, memorizedCount: 0),
        Surah(number: 83, name: "Al-Mutaffifin", arabicName: "المطففين", juz: 30, ayahCount: 36, memorizedCount: 0),
        Surah(number: 84, name: "Al-Inshiqaq", arabicName: "الإنشقاق", juz: 30, ayahCount: 25, memorizedCount: 0),
        Surah(number: 85, name: "Al-Buruj", arabicName: "البروج", juz: 30, ayahCount: 22, memorizedCount: 0),
        Surah(number: 86, name: "At-Tariq", arabicName: "الطارق", juz: 30, ayahCount: 17, memorizedCount: 0),
        Surah(number: 87, name: "Al-A'la", arabicName: "الأعلى", juz: 30, ayahCount: 19, memorizedCount: 0),
        Surah(number: 88, name: "Al-Ghashiyah", arabicName: "الغاشية", juz: 30, ayahCount: 26, memorizedCount: 0),
        Surah(number: 89, name: "Al-Fajr", arabicName: "الفجر", juz: 30, ayahCount: 30, memorizedCount: 0),
        Surah(number: 90, name: "Al-Balad", arabicName: "البلد", juz: 30, ayahCount: 20, memorizedCount: 0),
        Surah(number: 91, name: "Ash-Shams", arabicName: "الشمس", juz: 30, ayahCount: 15, memorizedCount: 0),
        Surah(number: 92, name: "Al-Lail", arabicName: "الليل", juz: 30, ayahCount: 21, memorizedCount: 0),
        Surah(number: 93, name: "Ad-Duha", arabicName: "الضحى", juz: 30, ayahCount: 11, memorizedCount: 0),
        Surah(number: 94, name: "Ash-Sharh", arabicName: "الشرح", juz: 30, ayahCount: 8, memorizedCount: 0),
        Surah(number: 95, name: "At-Tin", arabicName: "التين", juz: 30, ayahCount: 8, memorizedCount: 0),
        Surah(number: 96, name: "Al-Alaq", arabicName: "العلق", juz: 30, ayahCount: 19, memorizedCount: 0),
        Surah(number: 97, name: "Al-Qadr", arabicName: "القدر", juz: 30, ayahCount: 5, memorizedCount: 0),
        Surah(number: 98, name: "Al-Bayyinah", arabicName: "البينة", juz: 30, ayahCount: 8, memorizedCount: 0),
        Surah(number: 99, name: "Az-Zalzalah", arabicName: "الزلزلة", juz: 30, ayahCount: 8, memorizedCount: 0),
        Surah(number: 100, name: "Al-Adiyat", arabicName: "العاديات", juz: 30, ayahCount: 11, memorizedCount: 0),
        Surah(number: 101, name: "Al-Qari'ah", arabicName: "القارعة", juz: 30, ayahCount: 11, memorizedCount: 0),
        Surah(number: 102, name: "At-Takathur", arabicName: "التكاثر", juz: 30, ayahCount: 8, memorizedCount: 0),
        Surah(number: 103, name: "Al-Asr", arabicName: "العصر", juz: 30, ayahCount: 3, memorizedCount: 0),
        Surah(number: 104, name: "Al-Humazah", arabicName: "الهمزة", juz: 30, ayahCount: 9, memorizedCount: 0),
        Surah(number: 105, name: "Al-Fil", arabicName: "الفيل", juz: 30, ayahCount: 5, memorizedCount: 0),
        Surah(number: 106, name: "Quraysh", arabicName: "قريش", juz: 30, ayahCount: 4, memorizedCount: 0),
        Surah(number: 107, name: "Al-Ma'un", arabicName: "الماعون", juz: 30, ayahCount: 7, memorizedCount: 0),
        Surah(number: 108, name: "Al-Kawthar", arabicName: "الكوثر", juz: 30, ayahCount: 3, memorizedCount: 0),
        Surah(number: 109, name: "Al-Kafirun", arabicName: "الكافرون", juz: 30, ayahCount: 6, memorizedCount: 0),
        Surah(number: 110, name: "An-Nasr", arabicName: "النصر", juz: 30, ayahCount: 3, memorizedCount: 0),
        Surah(number: 111, name: "Al-Masad", arabicName: "المسد", juz: 30, ayahCount: 5, memorizedCount: 0),
        Surah(number: 112, name: "Al-Ikhlas", arabicName: "الإخلاص", juz: 30, ayahCount: 4, memorizedCount: 0),
        Surah(number: 113, name: "Al-Falaq", arabicName: "الفلق", juz: 30, ayahCount: 5, memorizedCount: 0),
        Surah(number: 114, name: "An-Nas", arabicName: "الناس", juz: 30, ayahCount: 6, memorizedCount: 0)
    ]
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return surahs
        } else {
            return surahs.filter { surah in
                surah.name.lowercased().contains(searchText.lowercased()) ||
                surah.arabicName.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Title
                Text("Surahs")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Search Bar
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("Search Surah", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(.white)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredSurahs) { surah in
                            NavigationLink(destination: SurahDetailView(surah: surah)) {
                                ListSurahCard(surah: surah)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 70) // Add padding for tab bar
                }
            }
            .background(Color.hex("0E5C53"))
            .navigationBarHidden(true)
        }
    }
}

struct ListSurahCard: View {
    let surah: Surah
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(surah.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(surah.arabicName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Text("Juz \(surah.juz) · \(surah.ayahCount) Ayahs")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Text("\(surah.memorizedCount)/\(surah.ayahCount)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(width: geometry.size.width * CGFloat(surah.memorizedCount) / CGFloat(surah.ayahCount), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
} 