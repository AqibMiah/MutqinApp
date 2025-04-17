import Foundation
import SQLite3

class QuranDatabaseService {
    static let shared = QuranDatabaseService()
    private var db: OpaquePointer?
    private let queue = DispatchQueue(label: "com.mutqin.database")
    private var isInitialized = false
    private let databasePath: String
    
    private init() {
        print("Initializing QuranDatabaseService...")
        
        // First check if database exists in the Resources directory
        if let resourcePath = Bundle.main.path(forResource: "quran-metadata-ayah", ofType: "sqlite", inDirectory: "Resources") {
            self.databasePath = resourcePath
            print("Found database in Resources: \(resourcePath)")
        } else if let bundlePath = Bundle.main.path(forResource: "quran-metadata-ayah", ofType: "sqlite") {
            // Fallback to root bundle
            self.databasePath = bundlePath
            print("Found database in bundle: \(bundlePath)")
        } else {
            print("ERROR: Database file not found in Resources or bundle")
            self.databasePath = ""
            return
        }
        
        initializeDatabase()
    }
    
    private func initializeDatabase() {
        queue.sync {
            guard !isInitialized else { return }
            
            print("Opening database at path: \(databasePath)")
            
            // Verify file exists
            guard FileManager.default.fileExists(atPath: databasePath) else {
                print("ERROR: Database file does not exist at path: \(databasePath)")
                return
            }
            
            // Try to open database
            if sqlite3_open(databasePath, &db) == SQLITE_OK {
                print("Successfully opened database connection")
                isInitialized = verifyDatabaseContents()
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("ERROR opening database: \(errorMessage)")
                sqlite3_close(db)
                db = nil
            }
        }
    }
    
    private func verifyDatabaseContents() -> Bool {
        guard let db = db else {
            print("ERROR: Database connection not initialized")
            return false
        }
        
        // Verify verses table exists and has content
        let queryString = "SELECT COUNT(*) FROM verses"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK else {
            print("ERROR: Could not prepare verification query")
            return false
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let count = sqlite3_column_int(statement, 0)
            print("Database initialized successfully. Total verses: \(count)")
            return count > 0
        } else {
            print("ERROR: Could not verify database contents")
            return false
        }
    }
    
    deinit {
        queue.sync {
            if db != nil {
                sqlite3_close(db)
                print("Database connection closed")
            }
        }
    }
    
    func getAyah(forSurah surahNum: Int, ayahNum: Int) -> AyahContent? {
        return queue.sync { () -> AyahContent? in
            guard isInitialized, let db = db else {
                print("ERROR: Database not properly initialized")
                return nil
            }
            
            print("QuranDatabaseService: Fetching Ayah \(ayahNum) from Surah \(surahNum)")
            
            let queryString = """
                SELECT text 
                FROM verses 
                WHERE surah_number = ? AND ayah_number = ?
                LIMIT 1
            """
            
            print("QuranDatabaseService: Preparing query: \(queryString)")
            
            var statement: OpaquePointer?
            
            guard sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("QuranDatabaseService: Error preparing statement: \(errorMessage)")
                return nil
            }
            
            defer {
                sqlite3_finalize(statement)
            }
            
            print("QuranDatabaseService: Binding parameters: surah=\(surahNum), ayah=\(ayahNum)")
            
            // Bind parameters
            sqlite3_bind_int(statement, 1, Int32(surahNum))
            sqlite3_bind_int(statement, 2, Int32(ayahNum))
            
            // Execute query
            let stepResult = sqlite3_step(statement)
            print("QuranDatabaseService: Query step result: \(stepResult)")
            
            if stepResult == SQLITE_ROW {
                guard let arabicText = sqlite3_column_text(statement, 0) else {
                    print("QuranDatabaseService: No text found in result row")
                    return nil
                }
                
                let arabic = String(cString: arabicText)
                
                print("QuranDatabaseService: Successfully fetched Ayah. Arabic text length: \(arabic.count)")
                return AyahContent(arabicText: arabic, translation: "") // No translation in current schema
            }
            
            print("QuranDatabaseService: No Ayah found for Surah \(surahNum), Ayah \(ayahNum)")
            return nil
        }
    }
    
    func getAyahsForSurah(_ surahNum: Int) -> [AyahContent] {
        return queue.sync { () -> [AyahContent] in
            guard isInitialized, let db = db else {
                print("ERROR: Database not properly initialized")
                return []
            }
            
            print("Fetching all Ayahs for Surah \(surahNum)")
            var ayahs: [AyahContent] = []
            
            let queryString = """
                SELECT text 
                FROM verses 
                WHERE surah_number = ? 
                ORDER BY ayah_number
            """
            
            var statement: OpaquePointer?
            
            guard sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Error preparing statement: \(errorMessage)")
                return []
            }
            
            defer {
                sqlite3_finalize(statement)
            }
            
            sqlite3_bind_int(statement, 1, Int32(surahNum))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let arabicText = String(cString: sqlite3_column_text(statement, 0))
                ayahs.append(AyahContent(arabicText: arabicText, translation: "")) // No translation in current schema
            }
            
            print("Found \(ayahs.count) Ayahs for Surah \(surahNum)")
            return ayahs
        }
    }
    
    func getNumberOfAyahs(forSurah surah: Int) -> Int? {
        var statement: OpaquePointer?
        var count: Int?
        
        let query = "SELECT COUNT(*) FROM quran_text WHERE surah = ?;"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(surah))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        
        sqlite3_finalize(statement)
        return count
    }
} 