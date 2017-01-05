//
//  LoginController.swift
//  TicSong_Media
//
//  Created by 전한경 on 2017. 1. 5..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var image2View: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func kakaoLoginClicked(_ sender: UIButton) {
        
        let session: KOSession = KOSession.shared();
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open(completionHandler: { (error) -> Void in
            if error != nil{
                print(error?.localizedDescription as Any) // any 원래 없어야함
            }else if session.isOpen() == true{
                KOSessionTask.meTask(completionHandler: { (profile , error) -> Void in
                    if profile != nil{
                        DispatchQueue.main.async(execute: { () -> Void in
                            let kakao : KOUser = profile as! KOUser
                            //고유 ID값
                            print(kakao.id)
                            if let value = kakao.properties["nickname"] as? String{
                                
                                self.textView.text = "nickname : \(value)\r\n"
                            }
                            if let value = kakao.properties["profile_image"] as? String{
                                self.imageView.image = UIImage(data: NSData(contentsOf: NSURL(string: value)! as URL)! as Data)
                            }
                            if let value = kakao.properties["thumbnail_image"] as? String{
                                self.image2View.image = UIImage(data: NSData(contentsOf: NSURL(string: value)! as URL)! as Data)
                            }
                        })
                    }else{
                        
                        print(error!)}
                })
            }else{
                print("isNotOpen")
            }
        })

        
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
