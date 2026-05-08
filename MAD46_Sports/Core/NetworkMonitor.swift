//
//  NetworkMonitor.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 08/05/2026.
//

import Foundation
import Alamofire

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let reachabilityManager = NetworkReachabilityManager()

    var isConnected: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    private init() {}
}
