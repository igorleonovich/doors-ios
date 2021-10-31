//
//  AppComponent.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 30/10/2021
//  Copyright © 2021 FT. All rights reserved.
//

import RIBs_Swift_SDK

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
