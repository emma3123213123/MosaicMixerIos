//
//  User.swift
//  MosaicMixerIos
//
//  Created by Emmanuel Olvera on 03/05/25.
//

import Foundation
import UIKit
import SwiftUI

class User: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var phone: String
    @Published var profileImage: UIImage?

    init(name: String, email: String, phone: String, password: String, profileImage: UIImage? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.phone = phone
        self.profileImage = profileImage
    }
}
