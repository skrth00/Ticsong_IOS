//
//  MainController.swift
//  TicSong_Media
//
//  Created by 전한경 on 2017. 1. 3..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    var arraySong : [String] = ["270052873","287320848","18560800","285714919","17179509","200018532","73847634","196942610","261595798","266565177"]
    var arrayTitle : [String] = ["야생화","숨","사랑한후에","꿈","눈의꽃","해줄수없는일","안녕사랑아","동경","화신","나를넘는다"]
    
    func random() -> Int {
        let random = Int(arc4random_uniform(UInt32(arraySong.count)))
        return random
    }
    
    func makeList() -> [(title:String,song:String,start:Int)]{
        
        var list:[(title:String,song:String,start:Int)] = []
        var indexList:[Int] = []
        var index = 0
        
        while indexList.count != 5 {
            index = random()
            if(!indexList.contains(index)){
                indexList.append(index)
                list.append((title:arrayTitle[index],song:arraySong[index],start:100))
                
            }
        }
        
        //print(indexList)
        return list
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startGameBtn(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "MainToGameSegue", sender: self)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        
        
        if segue.identifier == "MainToGameSegue"
        {
        
            let destination = segue.destination as! GameController
            destination.roundList = makeList()
        }
        
    }
    
    
 

}
