import Photos

extension PhotosService {
    
    func albumTitlePredicate(title: String) -> NSPredicate {
        let format = "title = %@"
        
        return NSPredicate(format: format, title)
    }
    
    func mediaTypePredicate(_ mediaType: MediaType) -> NSPredicate? {
        
        let format = "mediaType == %d"
        
        switch mediaType {
        case .all:
            return nil
        case .image:
            return NSPredicate(
                format: format,
                PHAssetMediaType.image.rawValue
            )
        case .video:
            return NSPredicate(
                format: format,
                PHAssetMediaType.video.rawValue
            )
        }
    }
    
    func dateRangePredicate(startDate: Date, endDate: Date) -> NSPredicate {
        
        let format = "creationDate >= %@ && creationDate <= %@"
        
        return NSPredicate(
            format: format,
            startDate as CVarArg,
            endDate as CVarArg
        )
    }
    
    func screenshotExclusionPredicate() -> NSPredicate {
        let format = "!(mediaSubtypes == %d)"
        
        return NSPredicate(
            format: format,
            PHAssetMediaSubtype.photoScreenshot.rawValue
        )
    }
}
