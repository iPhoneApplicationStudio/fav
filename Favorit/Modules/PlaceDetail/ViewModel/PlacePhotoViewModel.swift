//
//  PlacePhotoViewModel.swift
//  Favorit
//
//  Created by Abhinay Maurya on 11/01/24.
//

import Foundation
import Lightbox

protocol PlacePhotoProtocol: AnyObject {
    var numberOfPhotos: Int { get }
    
    init(photoURLs: [String]?)
    func getAllLightBoxImages() -> [LightboxImage]?
    func photoURLFor(index: Int) -> String?
}

class PlacePhotoViewModel: PlacePhotoProtocol {
    private var photoURLs: [String]?
    
    required init(photoURLs: [String]?) {
        self.photoURLs = photoURLs
    }
    
    var numberOfPhotos: Int {
        return photoURLs?.count ?? 0
    }
    
    func getAllLightBoxImages() -> [LightboxImage]? {
        guard let photos = photoURLs,
              photos.count > 0 else {
            return nil
        }
        
        var images = [LightboxImage]()
        for index in 0..<photos.count {
            if let url = URL(string: photos[index]) {
                images.append(LightboxImage(imageURL: url))
            }
        }
        
        return images
    }
    
    func photoURLFor(index: Int) -> String? {
        guard let photoURLs,
              index >= 0,
              index < photoURLs.count else {
            return nil
        }
        
        return photoURLs[index]
    }
}
