//
//  FrameImage.swift
//  PlanTio
//
//  Created by Lucas Santos on 13/05/24.
//

import SwiftUI

struct FrameImage: View {
    @Binding var imageData:Data?
    
    var screenImage: UIImage {
        if let data = imageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "AddPicture")!
        }
        
    }
        
    var aspectRatio:CGFloat
    
    @State  var isShowingImagePicker = false
    
    @State  var pickedImage:UIImage?
    
    var body: some View {
        Button {
            isShowingImagePicker = true
        } label: {
            Image(uiImage: screenImage )
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(13)
                .aspectRatio(aspectRatio, contentMode: .fill)
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: convertImageToImageData) {
            ImagePicker(selectedImage: $pickedImage, sourceType: .photoLibrary)
        }
    }
    func convertImageToImageData() {
        imageData = pickedImage?.jpegData(compressionQuality: 70)
    }
}
