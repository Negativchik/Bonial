//
//  ListCollectionViewController.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import UIKit

private let brochureCellReuseIdentifier = "BrochureCellIdentifier"
private let categoryHeaderReuseIdentifier = "CategoryHeaderIdentifier"

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
            if let data = data {
                self.serializeResponse(data: data)
            }
        }) { (response: URLResponse?, error: Error) in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: brochureCellReuseIdentifier, for: indexPath) as! BrochureCell
    
        let category = categories[indexPath.section]
        let brochure = category.brochures[indexPath.row]
        cell.titleLabel.text = brochure.title
        cell.retailerNameLabel.text = brochure.retailerName
        
        cell.coverImageView.setImage(urlString: brochure.coverUrlString)
    
        return cell
    }

    // MARK: <UICollectionViewDelegate>
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: categoryHeaderReuseIdentifier, for: indexPath) as! CategoryHeaderView
            
            let category = categories[indexPath.section]
            headerView.titleLabel.text = category.name
            let count = category.brochures.count
            if count > 1 {
                headerView.countLabel.text = "\(count) items"
            } else {
                headerView.countLabel.text = "\(count) item"
            }
            headerView.logoImageView.setImage(urlString: category.urlString)
            
            return headerView
            
        }
        return UICollectionReusableView()
    }
}
