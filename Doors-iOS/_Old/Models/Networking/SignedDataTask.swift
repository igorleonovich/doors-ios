//
//  SignedRequest.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation
import JWTDecode

extension URLSessionTask {
    
    func signedResume(core: OldCore) {
        checkAndTryToRefreshAccessToken(core: core) { error in
            if let error = error {
                print(error)
            } else {
                self.resume()
            }
        }
    }
    
    func checkAndTryToRefreshAccessToken(core: OldCore, _ completion: @escaping (Swift.Error?) -> Void) {
        do {
            guard let accessToken = try core.authManager.secureStoreWithGenericPwd.getValue(for: "accessToken") else { return }
            let jwt = try decode(jwt: accessToken)
            if jwt.expired {
                // Maybe TODO: Add ~5 sec before expiration check
                core.authManager.refreshToken { optionalError in
                    completion(optionalError)
                }
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }
}
