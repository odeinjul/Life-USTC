//
//  StudentModel.swift
//  Life@USTC (iOS)
//
//  Created by TiankaiMa on 2022/12/15.
//

import Foundation

/// Used to identify a user in the app, and construct the type accrodingly.
enum UserType: String, CaseIterable {
    case undergraduate
    case graduate
    case teacher
    case parent
    case managment

    var representingString: String {
        switch self {
        case .undergraduate:
            return "Notice; Undergraduate AAS"
        case .graduate:
            return "Notice; Graduate AAS"
        case .teacher:
            return "Notice; Teacher AAS"
        case .parent:
            return "Notice(Without CAS)"
        case .managment:
            return "Notice; Create Notice"
        }
    }
}
