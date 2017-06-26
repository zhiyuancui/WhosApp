//
//  Download.swift
//  WhosApp
//
//  Created by Zhiyuan Cui on 6/25/17.
//  Copyright © 2017 Zhiyuan Cui. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

//Avatar

func getAvatarFromURL(withurl: String, result: @escaping(_ image: UIImage?) -> Void) {
    
    //Download Avatar
    let url = URL(string: withurl)
    
    let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
    
    downloadQueue.async{
        let data = NSData(contentsOf: url! as URL )
        let image: UIImage!
        
        if data != nil {
            image = UIImage(data: data! as Data)
            DispatchQueue.main.async {
                result( image! )
            }
        }
    }
    
}

