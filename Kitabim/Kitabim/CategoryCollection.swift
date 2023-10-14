//
//  CategoryCollection.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 20.03.2023.
//

import UIKit

class CategoryCollection: UICollectionView , UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        as! CategoryCell
        
        return cell
    }
    

   
}
