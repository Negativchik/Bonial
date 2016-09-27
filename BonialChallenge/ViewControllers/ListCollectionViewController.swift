//
//  ListCollectionViewController.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BrochureCellIdentifier"

class ListCollectionViewController: UICollectionViewController {
    
    var categories = [Category]() {
        didSet {
            categories.sort {
                $0.name > $1.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = APIManager().loadData(completion: { (data: Data?, response: URLResponse?) in
            if data != nil {
                self.serializeResponse(data: data!)
            }
        }) { (response: URLResponse?, error: Error) in
            print(error)
        }
    }
    
    func serializeResponse(data: Data) {
        let serializer = ResponseSerializer(data: data)
        serializer.serializeAsync(completion: { (categories: [Category]) in
            self.categories = categories
            self.collectionView?.reloadData()
        }) { (error: Error) in
            self.handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageLoader.shared.purgeCache()
    }

    // MARK: <UICollectionViewDataSource>

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].brochures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BrochureCell
    
        let category = categories[indexPath.section]
        let brochure = category.brochures[indexPath.row]
        cell.titleLabel.text = brochure.title
        cell.retailerNameLabel.text = brochure.retailerName
        
        cell.coverImageView.setImage(urlString: brochure.coverUrlString)
    
        return cell
    }

    // MARK: <UICollectionViewDelegate>


}
