//
//  FrameImage.swift
//  PlanTio
//
//  Created by Lucas Santos on 13/05/24.
//

import SwiftUI
import PhotosUI
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
    @State  var itemSelect:PhotosPickerItem?
    var body: some View {
//        Button {
//            isShowingImagePicker = true
//        } label: {
        PhotosPicker(selection: $itemSelect, matching: .images) {
            Image(uiImage: screenImage )
                .resizable()
                .scaledToFill()
                .frame(height: 250)
//                .aspectRatio( 0.5, contentMode: .fit)
//
                .cornerRadius(13)
//                .aspectRatio(aspectRatio, contentMode: .fill)
        }
        .onChange(of: itemSelect) { oldValue, newValue in
            print(newValue)
            Task{ @MainActor in
                guard let newValue else{
                    return
                }
                guard let data = try? await newValue.loadTransferable(type: Data.self) else{
                    return
                }
                //            let image = UIImage(data: data)
                self.imageData = data
            }
        }
//        }
//        .sheet(isPresented: $isShowingImagePicker, onDismiss: convertImageToImageData) {
//            ImagePicker(selectedImage: $pickedImage, sourceType: .photoLibrary)
//        }
    }
    func convertImageToImageData() {
        imageData = pickedImage?.jpegData(compressionQuality: 70)
    }
}
