import SwiftUI
import PhotosUI

struct FrameImage: View {
    @Binding var imageData: Data?
    
    var screenImage: UIImage {
        if let data = imageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "AddPicture")!
        }
    }
    
    var aspectRatio: CGFloat
    
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @State private var showingActionSheet = false
    
    @State private var pickedImage: UIImage?
    @State private var itemSelect: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Image(uiImage: screenImage)
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .cornerRadius(13)
                .onTapGesture {
                    showingActionSheet = true
                }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Choose a photo"), buttons: [
                .default(Text("Photo Library")) {
                    isShowingImagePicker = true
                },
                .default(Text("Camera")) {
                    isShowingCamera = true
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: convertImageToImageData) {
            ImagePicker(selectedImage: $pickedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $isShowingCamera, onDismiss: convertImageToImageData) {
            ImagePicker(selectedImage: $pickedImage, sourceType: .camera)
        }
    }
    
    func convertImageToImageData() {
        imageData = pickedImage?.jpegData(compressionQuality: 0.7)
    }
}
