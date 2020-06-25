//
//  UIImageView+dnsLoadGravatar.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetwork
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
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
