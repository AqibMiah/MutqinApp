import Foundation
import SQLite3

struct AyahData {
    let surahNumber: Int
    let ayahNumber: Int
    let text: String
    let translation: String?
    let page: Int
    let juzNumber: Int
    let hizbNumber: Int
    let rub: Int
    let descent: String?
    let sajda: Bool
}

class QuranDatabase {
    static let shared = QuranDatabase()
    private var db: OpaquePointer?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let fileURL = Bundle.main.url(forResource: "quran-metadata-ayah", withExtension: "sqlite")!
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
    }
    
    func getAyah(surah: Int, ayah: Int) -> AyahData? {
        let queryString = """
            SELECT *
            FROM ayah
            WHERE surah_number = ? AND ayah_number = ?
        """
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            print("Error preparing statement")
            return nil
        }
        
        sqlite3_bind_int(stmt, 1, Int32(surah))
        sqlite3_bind_int(stmt, 2, Int32(ayah))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let ayahData = AyahData(
                surahNumber: Int(sqlite3_column_int(stmt, 0)),
                ayahNumber: Int(sqlite3_column_int(stmt, 1)),
                text: String(cString: sqlite3_column_text(stmt, 2)),
                translation: sqlite3_column_text(stmt, 3).map { String(cString: $0) },
                page: Int(sqlite3_column_int(stmt, 4)),
                juzNumber: Int(sqlite3_column_int(stmt, 5)),
                hizbNumber: Int(sqlite3_column_int(stmt, 6)),
                rub: Int(sqlite3_column_int(stmt, 7)),
                descent: sqlite3_column_text(stmt, 8).map { String(cString: $0) },
                sajda: sqlite3_column_int(stmt, 9) == 1
            )
            
            sqlite3_finalize(stmt)
            return ayahData
        }
        
        sqlite3_finalize(stmt)
        return nil
    }
    
    func getAyahsForSurah(_ surahNumber: Int) -> [AyahData] {
        let queryString = """
            SELECT *
            FROM ayah
            WHERE surah_number = ?
            ORDER BY ayah_number
        """
        
        var stmt: OpaquePointer?
        var ayahs: [AyahData] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            print("Error preparing statement")
            return []
        }
        
        sqlite3_bind_int(stmt, 1, Int32(surahNumber))
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let ayahData = AyahData(
                surahNumber: Int(sqlite3_column_int(stmt, 0)),
                ayahNumber: Int(sqlite3_column_int(stmt, 1)),
                text: String(cString: sqlite3_column_text(stmt, 2)),
                translation: sqlite3_column_text(stmt, 3).map { String(cString: $0) },
                page: Int(sqlite3_column_int(stmt, 4)),
                juzNumber: Int(sqlite3_column_int(stmt, 5)),
                hizbNumber: Int(sqlite3_column_int(stmt, 6)),
                rub: Int(sqlite3_column_int(stmt, 7)),
                descent: sqlite3_column_text(stmt, 8).map { String(cString: $0) },
                sajda: sqlite3_column_int(stmt, 9) == 1
            )
            
            ayahs.append(ayahData)
        }
        
        sqlite3_finalize(stmt)
        return ayahs
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
} 