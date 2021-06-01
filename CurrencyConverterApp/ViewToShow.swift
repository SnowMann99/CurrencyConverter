//
//  UpdatingView.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 01.06.2021.
//

import UIKit

class ViewToShow: UIView {
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
       super.init(frame: frame)
       configureViews()
       
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
       configureViews()
   }
    
    //MARK: - Methods
    
    func getViewFromNib() -> UIView {
        return UIView()
    }
    
    func configureViews() {
        let viewFromNib = getViewFromNib()
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
       
        addSubview(viewFromNib)
        NSLayoutConstraint.activate([
            viewFromNib.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewFromNib.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewFromNib.topAnchor.constraint(equalTo: topAnchor),
            viewFromNib.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
   }
    
    func show() {
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        
        alpha = 1
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor),
            topAnchor.constraint(equalTo: window.topAnchor),
            bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }
    
    func hide() {
        isUserInteractionEnabled = true
        removeFromSuperview()
    }
}

