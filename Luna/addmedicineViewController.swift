//
//  addmedicineViewController.swift
//  Luna
//
//  Created by 卢晓航 on 2017/11/16.
//  Copyright © 2017年 jacob inc. All rights reserved.
//

import UIKit

class addmedicineViewController: UIViewController {

    @IBOutlet weak var pm: UIButton!
    @IBOutlet weak var am: UIButton!
    var checkbox = UIImage(named:"checked_checkbox")
    var uncheckbox = UIImage(named:"check")
    var isboxchecked : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkam(_ sender: Any) {
        if(isboxchecked==true){
            isboxchecked=false
        }else{
            isboxchecked=true
        }
        if(isboxchecked==true){
            am.setImage(checkbox, for: UIControlState.normal)
            pm.setImage(uncheckbox, for: UIControlState.normal)
        }else{
            am.setImage(uncheckbox, for: UIControlState.normal)
            pm.setImage(checkbox, for: UIControlState.normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
