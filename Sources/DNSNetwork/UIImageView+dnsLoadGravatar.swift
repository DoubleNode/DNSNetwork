//
//  UIImageView+dnsLoadGravatar.swift
//  DNSCore
//
//  Created by Darren Ehlers on 10/7/19.
//  Copyright © 2019 DoubleNode.com. All rights reserved.
//

import Alamofire
import AlamofireImage
import DNSCore
import UIKit

public extension UIImageView {
    func dnsLoadGravatar(for email: String, then block: DNSBoolBlock?) {
        let gravatar = DNSGravatar()
        gravatar.email = email
        gravatar.size = (width > height) ? UInt(width) : UInt(height)

        gravatar.loadImage { (image) in
            guard image != nil else {
                block?(false)
                return
            }

            self.image = image
            block?(true)
        }
    }
}
