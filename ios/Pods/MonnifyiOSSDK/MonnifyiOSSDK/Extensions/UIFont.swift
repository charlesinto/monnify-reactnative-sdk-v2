
import UIKit

import Foundation
enum FontError: Error {
  case invalidFontFile
  case fontPathNotFound
  case initFontError
  case registerFailed
}

class GetBundle {}


extension UIFont {
    private static var fontsRegistered: Bool = false

    
    @nonobjc class var figureHeadingText: UIFont {
        return UIFont(name: "SFProText-Semibold", size: 24.0)!
    }
    
    @nonobjc class var buttonText: UIFont? {
        return UIFont(name: "SFProText-Semibold", size: 17.0)
    }
    
    @nonobjc class var headingText: UIFont {
        return UIFont(name: "SFProText-Semibold", size: 18.0)!
    }
    
    @nonobjc class var subText: UIFont {
        return UIFont(name: "SFProText-Semibold", size: 14.0)!
    }
    
    static func register(path: String, fileNameString: String, type: String) throws {
      let frameworkBundle = Bundle(for: GetBundle.self)
      guard let resourceBundleURL = frameworkBundle.path(forResource: path + "/" + fileNameString, ofType: type) else {
         throw FontError.fontPathNotFound
      }
      guard let fontData = NSData(contentsOfFile: resourceBundleURL),    let dataProvider = CGDataProvider.init(data: fontData) else {
        throw FontError.invalidFontFile
      }
      guard let fontRef = CGFont.init(dataProvider) else {
         throw FontError.initFontError
      }
      var errorRef: Unmanaged<CFError>? = nil
     guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else   {
           throw FontError.registerFailed
      }
     }
    
    static func registerFontsIfNeeded() {
        let bundle = Bundle(for: GetBundle.self)
            guard
                !fontsRegistered,
                let fontURLs = bundle.urls(forResourcesWithExtension: ".ttf", subdirectory: "")
            else { return }

            fontURLs.forEach({ CTFontManagerRegisterFontsForURL($0 as CFURL, .process, nil) })
            fontsRegistered = true
        }
    }



