//
//  HomeTable.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 20.03.2023.
//

import UIKit

class HomeTable: UITableView , UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            return cell
        
    }
    

    

}
