//
//  AppDelegate.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/5/20.
//  Copyright © 2020 FT. All rights reserved.
//

import RxSwift
import UIKit
import RIBs_Swift_SDK

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    public typealias ViewController = UIViewController
    public typealias NavigationController = UINavigationController
    public typealias AlertController = UIAlertController
    public typealias AlertAction = UIAlertAction
    public typealias Color = UIColor
    public typealias Button = UIButton
    public typealias View = UIView
    public typealias TextField = UITextField
#elseif os(macOS)
    import Cocoa
    public typealias ViewController = NSViewController
    public typealias Color = NSColor
    public typealias Button = NSButton
    public typealias View = NSView
    public typealias TextField = NSTextField
#endif

/// Game app delegate.
@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The window.
    public var window: UIWindow?

    /// Tells the delegate that the launch process is almost done and the app is almost ready to run.
    ///
    /// - parameter application: Your singleton app object.
    /// - parameter launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of
    ///   this dictionary may be empty in situations where the user launched the app directly. For information about
    ///   the possible keys in this dictionary and how to handle them, see Launch Options Keys.
    /// - returns: false if the app cannot handle the URL resource or continue a user activity, otherwise return true.
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let result = RootBuilder(dependency: AppComponent()).build()
        let launchRouter = result.launchRouter
        self.launchRouter = launchRouter
        urlHandler = result.urlHandler
        launchRouter.launch(from: window)

        return true
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        urlHandler?.handle(url)
        return true
    }
    
    // MARK: - Private

    private var launchRouter: LaunchRouting?
    private var urlHandler: UrlHandler?
}

protocol UrlHandler: AnyObject {
    func handle(_ url: URL)
}
