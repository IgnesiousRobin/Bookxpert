//
//  PDFViewerViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {

    var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Balance Sheet"
        view.backgroundColor = .systemBackground
        setupPDFView()
    }

    private func setupPDFView() {
        guard let url = pdfURL else { return }

        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        view.addSubview(pdfView)

        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        DispatchQueue.global(qos: .utility).async {
            guard let url = self.pdfURL,
                  let data = try? Data(contentsOf: url),
                  let document = PDFDocument(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                pdfView.document = document
            }
        }
    }
}
