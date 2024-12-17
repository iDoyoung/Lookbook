import SwiftUI

struct LastYearOutfitGridView: View {
    var outfitPhotos: [OutfitPhoto]
    
    private var columns: Int {
        switch outfitPhotos.count {
        case 0: return 0
        case 1: return 1
        case 2...3: return 1
        case 4...6: return 2
        default: return 3
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                if outfitPhotos.isEmpty {
                    EmptyView()
                } else if outfitPhotos.count == 1 {
                    let asset = outfitPhotos[0].asset
                    AsyncImage(asset: asset)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    let rows = ceil(Double(min(outfitPhotos.count, 12)) / Double(columns))
                    let spacing: CGFloat = 10
                    let itemWidth = (geometry.size.width - (spacing * (CGFloat(columns) - 1))) / CGFloat(columns)
                    let itemHeight = (geometry.size.height - (spacing * (CGFloat(rows) - 1))) / CGFloat(rows)
                    
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(
                                .flexible(),
                                spacing: spacing
                            ),
                            count: columns),
                        spacing: spacing
                    ) {
                        ForEach(Array(outfitPhotos.prefix(12).enumerated()), id: \.offset) { index, photo in
                            AsyncImage(asset: photo.asset)
                                .scaledToFill()
                                .frame(
                                    width: itemWidth,
                                    height: itemHeight
                                )
                                .clipped()
                        }
                    }
                }
            }
            .padding()
            
            //FIXME: - Hard coding 수정
            VStack {
                Text("2023-12-11 2023-12-17 @ 12 photos")
                    .font(.footnote)
                Text("아래로 내려서보기")
                    .fontWeight(.semibold)
            }
            .padding(.bottom)
        }
    }
}
