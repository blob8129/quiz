//
//  ViewController.swift
//  Quiz
//
//  Created by Andrey Volobuev on 16/06/2022.
//

import UIKit

final class StartViewController: UIViewController {

    private lazy var startButton: UIButton = { sbtn in
        sbtn.translatesAutoresizingMaskIntoConstraints = false
        sbtn.setTitle("Start", for: .normal)
        sbtn.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        sbtn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        return sbtn
    }(UIButton(type: .system))
    
    @objc func startAction() {
        let vc = GameAssembler().assemble()
        show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        addAllSubviews()
    }
    
    func addAllSubviews() {
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
