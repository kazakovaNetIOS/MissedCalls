//
//  AppDelegate.swift
//  MissedCalls
//
//  Created by Natalia Kazakova on 27.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)

    guard let navVC = MissedCallsViewController.storyboardInstance(),
          let missedCallsVC = navVC.topViewController as? MissedCallsViewController else {
      fatalError("Can't start application")
    }

    let downloadManager = DownloadManager(networkService: NetworkService(),
                                          parser: MissedCallsParser(),
                                          fileStrorage: FileStorage())
    missedCallsVC.viewModel = MissedCallsViewModel(downloadManager: downloadManager)

    window.rootViewController = navVC
    self.window = window
    window.makeKeyAndVisible()

    return true
  }
}

