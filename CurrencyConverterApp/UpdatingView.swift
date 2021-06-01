//
//  UpdatingView.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 01.06.2021.
//

import UIKit

final class UpdatingView: ViewToShow {
    
    override func getViewFromNib() -> UIView {
        let nib = UINib(nibName: "UpdatingView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
