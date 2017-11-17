//
//  MedicationViewController.swift
//  Luna
//
//  Created by 卢晓航 on 2017/11/16.
//  Copyright © 2017年 jacob inc. All rights reserved.
//

import UIKit
struct medicineData {
    let cell:Int!
    let name:String!
    let time:String!
    let dosage:String!
    let frequency:String!
}
class MedicationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arrayofcelldata = [medicineData]()
    var list=["a","b"]
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:"cell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayofcelldata = [medicineData(cell:1,name:"Zyprexa",time:"10:am",dosage:"10mg",frequency:"once daily"),medicineData(cell:2,name:"Abilify",time:"5:pm",dosage:"10mg",frequency:"once daily")]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
