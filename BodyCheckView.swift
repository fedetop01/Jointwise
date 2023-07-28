//
//  BodyCheckView.swift
//  Jointwise
//
//  Created by Biagio Marra on 14/03/23.
//

import UIKit
import SwiftUI
import ResearchKit
import CareKit
import CareKitStore

class BodyCheckView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Body2"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let selectedPartsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Imposta il numero massimo di righe a 0 per consentire un numero illimitato di righe
        label.lineBreakMode = .byWordWrapping // Abilita il wrap del testo

        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var selectedOption: UIButton?
    
    private let sizeButton : CGFloat = 35.0
    
    
    public let hipR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "HipR"
        return checkbox
    }()
    
    public let hipL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "HipL"
        return checkbox
    }()
    
    public let wristR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "WristR"
        return checkbox
    }()
    
    public let wristL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "WristL"
        return checkbox
    }()
    
    public let handR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "HandR"
        return checkbox
    }()
    
    public let handL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "HandL"
        return checkbox
    }()
    
    public let neck: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "Neck"
        return checkbox
    }()
    
    public let elbowR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "ElbowR"
        return checkbox
    }()
    
    public let elbowL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "ElbowL"
        return checkbox
    }()
    
    public let shoulderR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "ShoulderR"
        return checkbox
    }()
    
    public let shoulderL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "ShoulderL"
        return checkbox
    }()
    
    public let kneeR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "KneeR"
        return checkbox
    }()
    
    public let kneeL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "KneeL"
        return checkbox
    }()
    
    public let feetR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "FeetR"
        return checkbox
    }()
    
    public let feetL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "FeetL"
        return checkbox
    }()
    
    public let ankleR: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "AnkleR"
        return checkbox
    }()
    
    public let ankleL: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        checkbox.accessibilityLabel = "AnkleL"
        return checkbox
    }()
    
    lazy var buttons: [UIButton] = {
        return [self.hipR,self.hipL, self.handR, self.handL, self.neck, self.elbowR, self.elbowL, self.shoulderR, self.shoulderL, self.kneeR, self.kneeL, self.feetR, self.feetL, self.ankleR, self.ankleL, self.wristL, self.wristR]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(hipR)
        addSubview(hipL)
        addSubview(handR)
        addSubview(handL)
        addSubview(neck)
        addSubview(elbowR)
        addSubview(elbowL)
        addSubview(shoulderL)
        addSubview(shoulderR)
        addSubview(kneeL)
        addSubview(kneeR)
        addSubview(feetL)
        addSubview(feetR)
        addSubview(wristR)
        addSubview(wristL)
        addSubview(ankleR)
        addSubview(ankleL)
        
        addSubview(selectedPartsLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.1),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.1),
            
            hipR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 28),
            hipR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            hipR.widthAnchor.constraint(equalToConstant: sizeButton),
            hipR.heightAnchor.constraint(equalToConstant: sizeButton),
            
            hipL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -28),
            hipL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            hipL.widthAnchor.constraint(equalToConstant: sizeButton),
            hipL.heightAnchor.constraint(equalToConstant: sizeButton),
            
            wristR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 55),
            wristR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -9),
            wristR.widthAnchor.constraint(equalToConstant: 28),
            wristR.heightAnchor.constraint(equalToConstant: 28),
            
            wristL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -55),
            wristL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -9),
            wristL.widthAnchor.constraint(equalToConstant: 28),
            wristL.heightAnchor.constraint(equalToConstant: 28),
            
            handR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 52),
            handR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 17),
            handR.widthAnchor.constraint(equalToConstant: 33),
            handR.heightAnchor.constraint(equalToConstant: 33),
            
            handL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -52),
            handL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 17),
            handL.widthAnchor.constraint(equalToConstant: 33),
            handL.heightAnchor.constraint(equalToConstant: 33),
            
            neck.centerXAnchor.constraint(equalTo: centerXAnchor),
            neck.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -170),
            neck.widthAnchor.constraint(equalToConstant: sizeButton),
            neck.heightAnchor.constraint(equalToConstant: sizeButton),
            
            elbowR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 58),
            elbowR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -67),
            elbowR.widthAnchor.constraint(equalToConstant: sizeButton),
            elbowR.heightAnchor.constraint(equalToConstant: sizeButton),
            
            elbowL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -58),
            elbowL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -67),
            elbowL.widthAnchor.constraint(equalToConstant: sizeButton),
            elbowL.heightAnchor.constraint(equalToConstant: sizeButton),
            
            shoulderR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 52),
            shoulderR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -143),
            shoulderR.widthAnchor.constraint(equalToConstant: sizeButton),
            shoulderR.heightAnchor.constraint(equalToConstant: sizeButton),
            
            shoulderL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -52),
            shoulderL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -143),
            shoulderL.widthAnchor.constraint(equalToConstant: sizeButton),
            shoulderL.heightAnchor.constraint(equalToConstant: sizeButton),
            
            kneeR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 34),
            kneeR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100),
            kneeR.widthAnchor.constraint(equalToConstant: sizeButton),
            kneeR.heightAnchor.constraint(equalToConstant: sizeButton),
            
            kneeL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -34),
            kneeL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100),
            kneeL.widthAnchor.constraint(equalToConstant: sizeButton),
            kneeL.heightAnchor.constraint(equalToConstant: sizeButton),
            
            feetR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 59),
            feetR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 228),
            feetR.widthAnchor.constraint(equalToConstant: sizeButton),
            feetR.heightAnchor.constraint(equalToConstant: sizeButton),
            
            feetL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -59),
            feetL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 228),
            feetL.widthAnchor.constraint(equalToConstant: sizeButton),
            feetL.heightAnchor.constraint(equalToConstant: sizeButton),
            
            ankleR.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 40),
            ankleR.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 199),
            ankleR.widthAnchor.constraint(equalToConstant: 33),
            ankleR.heightAnchor.constraint(equalToConstant: 33),
            
            ankleL.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -40),
            ankleL.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 199),
            ankleL.widthAnchor.constraint(equalToConstant: 33),
            ankleL.heightAnchor.constraint(equalToConstant: 33),

            // Imposta i vincoli dell'etichetta
            selectedPartsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedPartsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            selectedPartsLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -20)

            
        ])
    }
    
//     @objc func checkBoxTapped(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            sender.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//            selectedPartsLabel.text = getSelectedPartsString()
//        } else {
//            sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
//            selectedPartsLabel.text = getSelectedPartsString()
//        }
//
//         // Aggiorna il testo dell'etichetta
//         selectedPartsLabel.text = getSelectedPartsString()
//    }

    @objc func checkBoxTapped(_ sender: UIButton) {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                sender.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    //            selectedPartsLabel.text = getSelectedPartsString()
            } else {
                sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
    //            selectedPartsLabel.text = getSelectedPartsString()
            }

             // Aggiorna il testo dell'etichetta
             selectedPartsLabel.text = getSelectedPartsString()
        }    
    
    func getSelectedPartsString() -> String {
        var selectedParts: [String] = []
        if hipR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right hip")
        }
        if hipL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left hip")
        }
        if wristR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right wrist")
        }
        if wristL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left wrist")
        }
        if handR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right hand and fingers")
        }
        if handL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left hand and fingers")
        }
        if neck.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Neck")
        }
        if shoulderL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left shoulder")
        }
        if shoulderR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right shoulder")
        }
        if elbowL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left elbow")
        }
        if elbowR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right elbow")
        }
        if kneeL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left knee")
        }
        if kneeR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right knee")
        }
        if ankleL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left ankle")
        }
        if ankleR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right ankle")
        }
        if feetL.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Left foot and toes")
        }
        if feetR.backgroundImage(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
            selectedParts.append("Right foot and toes")
        }
        
        
        
        let selectedPartsString = selectedParts.joined(separator: ", ")
        return selectedPartsString
    }

    
    public func WhatIsSelected() -> [String?] {
        
        var BodyPartSelected = [String?]()
        
        for b in buttons {
            if(b.isSelected == true){
                
                BodyPartSelected.append(b.accessibilityLabel)
            }
        }
        
        
        
        return BodyPartSelected
    }
    
}


