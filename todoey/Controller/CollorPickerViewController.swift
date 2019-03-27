//
//  CollorPickerViewController.swift
//  todoey
//
//  Created by Peter on 27/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ColorPickerViewController: UIViewController , ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        print(color)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpColorPicker()
    }
    
    var category: Category!
    
    
        
    func setUpColorPicker(){
     
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.white
        
        neatColorPicker.delegate = self  //ChromaColorPickerDelegate
        
        view.addSubview(neatColorPicker)
        
    }
        
        
        
    
}
