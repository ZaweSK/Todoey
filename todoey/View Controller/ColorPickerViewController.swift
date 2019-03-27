//
//  CollorPickerViewController.swift
//  todoey
//
//  Created by Peter on 27/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import ChromaColorPicker
import RealmSwift
import ChameleonFramework

protocol ColorPickeControllerDelegate {
    func colorWasPicked(color: UIColor)
}

class ColorPickerViewController: UIViewController , ChromaColorPickerDelegate
{
    // MARK: - Stored Properities
    
    let realm = try! Realm()
    
    var category: Category!
    
    //MARK: - ChromaColorPicker Delegate methods
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        updateColor(for: category, with: color.hexCode)
    }
    
    
    // MAKR: - DB methods
    
    func updateColor(for category : Category, with color: String) {
        
        do {
            
            try realm.write {
                category.categoryColor = color
            }
        }catch {
            print(error)
        }
        
        animateColorChange()
    }
    
   
    // MARK: - VC life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Category color"
        
        setBackgroundColor()
        setUpColorPicker()
    }
    
    // MARK: - UIConfig Methods
    
    func animateColorChange(){
        
        guard let color = UIColor.init(hexString: category.categoryColor) else {return}
        
        guard let navBar = navigationController?.navigationBar else { return}
        
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        
        
        UIView.animate(withDuration: 1) {
            
            navBar.barTintColor = color
            
            navBar.largeTitleTextAttributes = [.foregroundColor : ContrastColorOf(color, returnFlat: true)]
            
            self.view.backgroundColor = color
        }
    }
    
    func setBackgroundColor(){
       
        guard let color = UIColor.init(hexString: category.categoryColor) else {return}

        view.backgroundColor = color.lighten(byPercentage: CGFloat(0.1))
    }
    
    func setUpColorPicker(){
     
        let colorPicker = ChromaColorPicker(frame: CGRect(x: view.bounds.width * 0.1, y: view.bounds.height * 0.3, width: view.bounds.width * 0.8, height: 300))
        colorPicker.padding = 5
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = UIColor.white
        
        colorPicker.delegate = self  //ChromaColorPickerDelegate
        
        view.addSubview(colorPicker)
    }
}
