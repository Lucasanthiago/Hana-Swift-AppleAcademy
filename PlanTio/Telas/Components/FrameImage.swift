import SwiftUI
import PhotosUI

struct FrameImage: View {
    @Binding var imageData: Data?
    @Binding var plantType: String
    
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
        Image(uiImage: screenImage)
            .resizable()
            .scaledToFill()
            .frame(alignment: .center)
            .onTapGesture {
                showingActionSheet = true
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
            .fullScreenCover(isPresented: $isShowingImagePicker, onDismiss: convertImageToImageData) {
                ImagePicker(selectedImage: $pickedImage, sourceType: .photoLibrary)
                    .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $isShowingCamera, onDismiss: convertImageToImageData) {
                ImagePicker(selectedImage: $pickedImage, sourceType: .camera)
                    .edgesIgnoringSafeArea(.all)
            }
            .onChange(of: pickedImage) { newImage in
                if let newImage = newImage {
                    convertImageToImageData()
                    analyzeImage(newImage)
                }
            }
    }
    
    func convertImageToImageData() {
        imageData = pickedImage?.jpegData(compressionQuality: 0.7)
    }
    
    func analyzeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Unable to convert image to data")
            return
        }
        
        let apiKey = "***CHAVE-REMOVIDA***"
        let url = URL(string: "https://api.plant.id/v2/identify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
        
        let payload: [String: Any] = [
            "images": [imageData.base64EncodedString()],
            "organs": ["leaf"]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            print("Error creating JSON payload")
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let suggestions = jsonResponse["suggestions"] as? [[String: Any]],
                   let firstSuggestion = suggestions.first,
                   let plantDetails = firstSuggestion["plant_details"] as? [String: Any],
                   let plantName = plantDetails["scientific_name"] as? String {
                    DispatchQueue.main.async {
                        self.plantType = plantName
                    }
                } else {
                    print("Unexpected response format")
                }
            } catch {
                print("Error parsing response: \(error.localizedDescription)")
            }
        }.resume()
    }
}
