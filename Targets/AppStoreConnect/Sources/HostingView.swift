//
//  HostingView.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation
import SwiftUI
#if os(macOS)
public typealias PlatformViewType = NSView
#elseif !os(watchOS)
import UIKit
public typealias PlatformViewType = UIView
#endif

#if !os(watchOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
open class HostingView<Content> : PlatformViewType where Content : View {
    #if os(macOS)
    typealias HostingController = NSHostingController
    #else
    typealias HostingController = UIHostingController
    #endif
    private let hostingVC: HostingController<Content>
    public var rootView: Content {
        get { return hostingVC.rootView }
        set { hostingVC.rootView = newValue }
    }
    
    public init(rootView: Content) {
        self.hostingVC = HostingController(rootView: rootView)
        super.init(frame: .zero)
        addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                   hostingVC.view.topAnchor.constraint(equalTo: self.topAnchor),
                   hostingVC.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                   hostingVC.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                   hostingVC.view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                   ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
