//
//  MainViewController.swift
//  Flashlight
//
//  Created by Maksym Husar  on 05.08.2021.
//

import UIKit
import ReduxCore

class MainViewController: UIViewController {
    struct Props: Equatable {
        let time: String
        let isTorchEnabled: Bool
        let onClick: Command
        let onDestroy: Command
        
        static let initial = Props(time: "", isTorchEnabled: false, onClick: .nop, onDestroy: .nop)
    }
    
    private var props = Props.initial
    
    @IBOutlet weak var switcherButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var switcherStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switcherButton.layer.shadowColor = UIColor.purple.cgColor
        switcherButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        switcherButton.layer.shadowRadius = 10.0
        switcherButton.layer.masksToBounds = false
    }

    deinit {
        props.onDestroy.perform()
    }
    
    func render(props: Props) {
        let shouldRerender = self.props != props
        self.props = props
        if shouldRerender {
            view.setNeedsLayout()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLabel.text = props.time
        switcherStateLabel.text = props.isTorchEnabled ? "ON" : "OFF"
        switcherButton.layer.shadowOpacity = props.isTorchEnabled ? 1.0 : 0.0
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        props.onClick.perform()
    }
}

