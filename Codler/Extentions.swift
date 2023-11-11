//
//  Extentions.swift
//  Codler
//
//  Created by Евгений Парфененков on 13.07.2023.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController { viewController }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
    func showPreview() -> some View {
        Preview(viewController: self).edgesIgnoringSafeArea(.all)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIFont {
    class func bold(size: Int) -> UIFont { return UIFont(name: "Helvetica Neue Bold", size: CGFloat(size)) ?? .systemFont(ofSize: CGFloat(size)) }
    class func medium(size: Int) -> UIFont { return UIFont(name: "Helvetica Neue Medium", size: CGFloat(size)) ?? .systemFont(ofSize: CGFloat(size)) }
    class func regular(size: Int) -> UIFont { return UIFont(name: "Helvetica Neue Regular", size: CGFloat(size)) ?? .systemFont(ofSize: CGFloat(size)) }
    class func light(size: Int) -> UIFont { return UIFont(name: "Helvetica Neue Light", size: CGFloat(size)) ?? .systemFont(ofSize: CGFloat(size)) }
}

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        
        guard let cgImage = cgImage?.cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : .zero, y: isPortrait ? ((size.height-size.width)/2).rounded(.down) : .zero), size: breadthSize)) else { return nil }
        
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        let format = imageRendererFormat
        format.opaque = false
        
        return UIGraphicsImageRenderer(size: bleed.size, format: format).image { context in
            UIBezierPath(ovalIn: .init(origin: .zero, size: bleed.size)).addClip()
            var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
            strokeRect.origin = .init(x: width/2, y: width/2)
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
            context.cgContext.setStrokeColor(color.cgColor)
            let line: UIBezierPath = .init(ovalIn: strokeRect)
            line.lineWidth = width
            line.stroke()
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration,
           animations: { self.alpha = 1 },
           completion: { (value: Bool) in
              if let complete = onCompletion { complete() }
           }
        )
    }
    
    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
           animations: { self.alpha = 0 },
           completion: { (value: Bool) in
               self.isHidden = true
               if let complete = onCompletion { complete() }
           }
        )
    }
    
}

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

final class CodlerLoader: UIView {

    let backView = UIView()
    let logo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(hex: "#151417FF")
        self.layer.cornerRadius = 25
        self.frame = CGRect(x: 0, y: -100, width: 100, height: 100)
        self.center.x = UIApplication.topViewController()?.view.center.x ?? .zero
//        self.frame.origin.y = UIApplication.topViewController()?.view.safeAreaLayoutGuide.layoutFrame.origin.y ?? .zero
        
        addLogo()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addLogo() {
        self.addSubview(logo)
        logo.image = UIImage(named: "ImageShortLogo")
//        logo.image = UIImage(named: "ImageShortLogo")
        logo.frame.origin.y = self.frame.origin.y + 115
        logo.frame.origin.x = 15
        logo.frame.size = CGSize(width: 70, height: 70)
    }
}

extension UIView {
    func showLoader() {
        let codlerLoader = CodlerLoader(frame: frame)
        self.addSubview(codlerLoader)
        
        UIView.animate(withDuration: 0.3, animations: {
            codlerLoader.frame.origin.y = UIApplication.topViewController()?.view.safeAreaLayoutGuide.layoutFrame.origin.y ?? .zero
        })
        codlerLoader.subviews[0].rotate360Degrees(duration: 1)
    }

    func removeLoader() {
        if let codlerLoader = UIApplication.topViewController()?.view.subviews.first(where: { $0 is CodlerLoader }) {
            UIView.animate(withDuration: 0.3, animations: {
                codlerLoader.frame.origin.y = .zero - 100
                
            }) { _ in 
                codlerLoader.removeFromSuperview()
            }
            
        }
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
//    func showAnimation(_ completionBlock: @escaping () -> Void) {
//      isUserInteractionEnabled = false
//        UIView.animate(withDuration: 0.1,
//                       delay: 0,
//                       options: .curveLinear,
//                       animations: { [weak self] in
//                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
//        }) {  (_) in
//            UIView.animate(withDuration: 0.1,
//                           delay: 0,
//                           options: .curveLinear,
//                           animations: { [weak self] in
//                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//            }) { [weak self] (_) in
//                self?.isUserInteractionEnabled = true
//                completionBlock()
//            }
//        }
//    }
}
