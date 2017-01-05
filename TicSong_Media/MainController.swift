//
//  MainController.swift
//  TicSong_Media
//
//  Created by 전한경 on 2017. 1. 3..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var startGameBtn: UIButton!
    @IBOutlet weak var juke_shootingStar: UIImageView!
    @IBOutlet weak var main_backgroundStar: UIImageView!
    var pulseEffect : LFTPulseAnimation!

    
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
        
        aniPulse(40)
        aniPulse(80)
        aniPulse(120)
        aniPulse(160)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        aniBackgroundStar(pic: main_backgroundStar)
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
    

    // 가운데 별 회전 애니메이션
    
    func aniBackgroundStar(pic : UIImageView){
        let duration = 35.0
        let delay = 0.0
        let fullRotation = CGFloat(M_PI*2)
        let options = UIViewKeyframeAnimationOptions.calculationModeLinear
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options:  options, animations: {
            UIView.setAnimationRepeatCount(Float.infinity)
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                pic.transform = CGAffineTransform(rotationAngle: (1/3) * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                pic.transform = CGAffineTransform(rotationAngle: (2/3) * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                pic.transform = CGAffineTransform(rotationAngle: (3/3) * fullRotation)
            })
            
        })
        
    }
    
    // 물 퍼지는 듯한 애니메이션

    func aniPulse(_ radius :Float){
        pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:CGFloat(radius), position:mainView.center)
        view.layer.insertSublayer(self.pulseEffect, below: juke_shootingStar.layer)
    }
    
    

    
    
    
    
 

}
