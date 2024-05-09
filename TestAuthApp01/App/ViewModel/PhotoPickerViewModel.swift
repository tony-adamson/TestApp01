//
//  PhotoPickerViewModel.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data)?.fixedOrientation() else {
                    throw URLError(.badServerResponse)
                }
                
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
    }
    
    func generatePreviews(for image: UIImage) -> [UIImage] {
        let filters = ["CIColorInvert", "CISepiaTone", "CIPhotoEffectNoir", "CIPhotoEffectChrome", "CIPhotoEffectInstant", "CIPhotoEffectTransfer", "CIPhotoEffectFade", "CIMotionBlur", "CIGaussianBlur", "CIBloom"]
        
        var previews: [UIImage] = []
        
        for filterName in filters {
            let ciImage = CIImage(image: image)
            let filter = CIFilter(name: filterName)
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            if let output = filter?.outputImage, let cgImage = CIContext().createCGImage(output, from: output.extent) {
                previews.append(UIImage(cgImage: cgImage))
            } else {
                previews.append(image)
            }
        }
        return previews
    }
    
    func saveImageToGallery() {
        guard let image = selectedImage else {
            print("No image to save")
            return
        }
        
        // Check authorize status
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // Save image in gallery
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    if let error = error {
                        print("Ошибка сохранения изображения: \(error.localizedDescription)")
                    } else {
                        print("Изображение успешно сохранено")
                    }
                }
            } else {
                print("Доступ к фотогалерее запрещен")
            }
        }
    }
    
}

extension UIImage {
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != .up else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
