//
//  Model.swift
//  table
//
//  Created by Alisa Mylnikova on 02.03.2023.
//

import UIKit

struct Model: Equatable, Hashable {

    enum Property: String {
        case one, two, three

        var color: UIColor {
            switch self {
            case .one:
                return UIColor(hex: "#B6F1C7")
            case .two:
                return UIColor(hex: "#A6CCAE")
            case .three:
                return UIColor(hex: "#8BA992")
            }
        }
    }

    var id = UUID().uuidString
    var text: String
    var property: Property

    init(property: Property = .one) {
        self.text = Model.randomString(length: 50)
        self.property = property
    }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id && lhs.property == rhs.property
    }

    static func randomString(length: Int) -> String {
          let letters = "    abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        self.init(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
