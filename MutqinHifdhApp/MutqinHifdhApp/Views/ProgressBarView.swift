import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.mutqinGreen)
                    .frame(width: geometry.size.width * CGFloat(progress), height: 8)
            }
        }
        .frame(height: 8)
    }
} 