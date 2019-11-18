//
//  DNSGravatar.swift
//  DNSCore
//
//  Created by Darren Ehlers on 10/7/19.
//  Copyright © 2019 DoubleNode.com. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

public typealias DNSImageBlock = (UIImage?) -> Void

public class DNSGravatar {
    let baseUrl = "https://gravatar.com/avatar"

    public enum Rating {
        // swiftlint:disable:next identifier_name
        case g, pg, r, x
    }
    public enum Default {
        case none404, mysteryMan, identicon, monsterId, wavatar, retro, blank
    }

    public var email: String?
    public var size: UInt?  // default size = 80
    public var rating: Rating = .g
    public var defaultType: Default = .mysteryMan
    public var forceDefault: Bool = false

    public var gravatarUrl: URL {
        return generateUrl()
    }

    public func loadImage(block: DNSImageBlock?) {
        AF.request(gravatarUrl).responseImage { (response) in
            guard response.error == nil else {
                block?(nil)
                return
            }

            do {
                block?(try response.result.get())
            } catch {
                
            }
        }
    }

    func generateUrl() -> URL {
        let avatarId = email?.dnsMD5() ?? "00000000000000000000000000000000"

        return buildUrl("/\(avatarId)?")
    }

    func buildUrl(_ avatarUrl: String) -> URL {
        var urlString = baseUrl + avatarUrl

        if size != nil {
            urlString += "&size=\(size!)"
        }

        urlString += "&rating=\(rating)"

        switch defaultType {
        case .none404:      urlString += "&default=404"
        case .mysteryMan:   urlString += "&default=mm"
        case .identicon:    urlString += "&default=identicon"
        case .monsterId:    urlString += "&default=monsterid"
        case .wavatar:      urlString += "&default=wavatar"
        case .retro:        urlString += "&default=retro"
        case .blank:        urlString += "&default=blank"
        }

        if forceDefault {
            urlString += "&forcedefault=y"
        }

        return URL(string: urlString)!
    }
}
