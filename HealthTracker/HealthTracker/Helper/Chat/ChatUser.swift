//
//  ChatUser.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-14.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
