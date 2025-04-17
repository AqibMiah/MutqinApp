import Foundation
import SQLite3

class QuranDatabaseService {
    static let shared = QuranDatabaseService()
    private var db: OpaquePointer?
    private var isInitialized = false
    
    private init() {
        print("Initializing QuranDatabaseService...")
        
        // First try to find the database in the Resources directory
        if let dbPath = Bundle.main.path(forResource: "quran-metadata-ayah", ofType: "sqlite", inDirectory: "Resources") {
            print("Found database at path: \(dbPath)")
            openDatabase(at: dbPath)
        } else {
            // Fallback to root bundle
            if let dbPath = Bundle.main.path(forResource: "quran-metadata-ayah", ofType: "sqlite") {
                print("Found database in root bundle at path: \(dbPath)")
                openDatabase(at: dbPath)
            } else {
                print("Error: Database file not found in bundle")
            }
        }
    }
    
    private func openDatabase(at path: String) {
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened database connection")
            
            // Verify we can read from the database
            var statement: OpaquePointer?
            let testQuery = "SELECT COUNT(*) FROM verses"
            if sqlite3_prepare_v2(db, testQuery, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    let count = sqlite3_column_int(statement, 0)
                    print("QuranDatabaseService: Database contains \(count) verses")
                    isInitialized = true
                }
                sqlite3_finalize(statement)
            } else {
                let error = String(cString: sqlite3_errmsg(db))
                print("QuranDatabaseService: Error checking database: \(error)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error opening database: \(errmsg)")
            db = nil
        }
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
            print("Database connection closed")
        }
    }
    
    func getAyah(forSurah surahNumber: Int, ayahNum: Int) -> (arabicText: String, translation: String)? {
        print("Attempting to fetch Ayah \(ayahNum) from Surah \(surahNumber)")
        
        guard isInitialized, let db = db else {
            print("Error: Database connection is not initialized")
            return nil
        }
        
        var stmt: OpaquePointer?
        let queryString = "SELECT text FROM verses WHERE surah_number = ? AND ayah_number = ?"
        
        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing statement: \(errmsg)")
            return nil
        }
        defer {
            sqlite3_finalize(stmt)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(surahNumber))
        sqlite3_bind_int(stmt, 2, Int32(ayahNum))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            guard let textPtr = sqlite3_column_text(stmt, 0) else {
                print("Error: Null value in database for surah \(surahNumber), ayah \(ayahNum)")
                return nil
            }
            let arabicText = String(cString: textPtr)
            print("Successfully fetched Ayah. Arabic text (first 50 chars): \(String(arabicText.prefix(50)))")
            return (arabicText: arabicText, translation: "") // Translation will be added later
        } else {
            print("No Ayah found for Surah \(surahNumber), Ayah \(ayahNum)")
            return nil
        }
    }
    
    func getAyahsForSurah(_ surahNumber: Int) -> [(arabicText: String, translation: String)]? {
        print("Attempting to fetch all Ayahs for Surah \(surahNumber)")
        
        guard isInitialized, let db = db else {
            print("Error: Database connection is not initialized")
            return nil
        }
        
        var stmt: OpaquePointer?
        let queryString = "SELECT text FROM verses WHERE surah_number = ? ORDER BY ayah_number ASC"
        
        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing statement: \(errmsg)")
            return nil
        }
        defer {
            sqlite3_finalize(stmt)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(surahNumber))
        
        var results: [(arabicText: String, translation: String)] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            guard let textPtr = sqlite3_column_text(stmt, 0) else { continue }
            let arabicText = String(cString: textPtr)
            results.append((arabicText: arabicText, translation: "")) // Translation will be added later
        }
        
        print("Found \(results.count) Ayahs for Surah \(surahNumber)")
        return results.isEmpty ? nil : results
    }
} 