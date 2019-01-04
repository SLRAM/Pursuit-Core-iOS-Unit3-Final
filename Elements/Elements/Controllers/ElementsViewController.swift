//
//  ViewController.swift
//  Elements
//
//  Created by Alex Paul on 12/31/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

class ElementsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var elements = [ElementData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchElements()
    }

    private func fetchElements() {
        ElementAPIClient.getElements { (appError, getElements) in
            if let appError = appError {
                print(appError.errorMessage())
            } else if let getElements = getElements {
                self.elements = getElements
            }
        }
    }

}

extension ElementsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell", for: indexPath) as? ElementCell
            else { fatalError("error getting element cell") }
        var elementToSetUp = elements[indexPath.row]
        cell.elementName.text = elementToSetUp.name
        cell.elementInfo.text = "\(elementToSetUp.symbol)(\(elementToSetUp.number)) \(elementToSetUp.atomicMass)"

        let imageUrl =  ElementAPIClient.getElementImage(num: elementToSetUp.number)
        
        if let image = ImageHelper.shared.image(forKey: imageUrl as NSString) {
            cell.elementImage.image = image
        } else {
            ImageHelper.shared.fetchImage(urlString: imageUrl) { (appError, image) in
                if let appError = appError {
                    print(appError.errorMessage())
                } else if let image = image {
                        cell.elementImage.image = image
                    
                }
            }
        
        
        
//        ElementAPIClient.getElementImage(number: elementToSetUp.number) { (appError, element) in
//            if let appError = appError {
//                print(appError.errorMessage())
//            } else {
//                if let imageUrl = url {
//                    if let image = ImageClient.getImage(StringURL: imageUrl) {
//                        self.imageView.image = image
//                    }
//                }
//            }
//        }
        
        
        
        
        
        
        
        
        
        }
        return cell
    }
}

extension ElementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
