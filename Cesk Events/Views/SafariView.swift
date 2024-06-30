//
//  SwiftUIView.swift
//  Cesk Events
//
//  Created by iedstudent on 14/06/24.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: String
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: self.url)!)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}
