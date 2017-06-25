//
//  RecentViewController.swift
//  WhosApp
//
//  Created by Zhiyuan Cui on 6/25/17.
//  Copyright © 2017 Zhiyuan Cui. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
        
    var recents:[NSDictionary] = []
    
    
    var firstLoad: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RecentTableViewCell
        
        let recent = recents[ indexPath.row ]
        
        
        return cell
    }
    
    //MARK: UITableview Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: IBAction
    @IBAction func AddBtnPressed(_ sender: Any) {
    }
    
    
    //MARK: Load Recents
    func loadRecents() {
        firebase.child(kRECENT).queryOrdered(byChild: kUSERID).observe(.value, with: {
            snapshot in
            
            self.recents.removeAll()
            
            if snapshot.exists() {
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray ).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])

            
                for recent in sorted {
                    let currentRecent = recent as! NSDictionary
                    self.recents.append( currentRecent )
                }
            }
            
        })
    }
    
}
