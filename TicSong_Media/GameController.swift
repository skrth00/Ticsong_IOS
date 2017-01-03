//
//  GameController.swift
//  TicSong_Media
//
//  Created by 윤민섭 on 2017. 1. 2..
//  Copyright © 2017년 yoon. All rights reserved.
//


/* 2017.01.03
 1. 노래 리스트업 10곡 선정 V
 2. 점수 기능 (3번의 목숨이 있으며 1번에 맞추면 100점 2번에 맞추면 60점 3번에 맞추면 30점) V
 3. 아이템 (1. 3초 재생 2. 타이틀 앞 글자 제공 3. 목숨 늘려주기)
 4. 노래 맞추면 노래 재생 (stop 도 생김) + widget visible /invisible 가능 하게
 5. 라운드 개념 넣기(5곡이 한 라운드로 가정하고 라운드 중간에 종료시 점수는 무효 / 모든 점수를 합산해서 ResultController로 전송)
 6. ResultController 로 넘어갈 수 있게 prepareSegue 준비
 7. ResultController에서 unwindSegue로 값 받아서 서버로 전송하기
 8. MainController에서 서버에서 불러온 현재의 exp와 level , item 현황 등 을 제공한다.
 9. 소셜로그인 카카오톡 추가
 10. 랭킹 테이블뷰 생성하고 서버에서 불러와서 뿌리기
 */

import UIKit
import AVFoundation
class GameController: UIViewController , AVAudioPlayerDelegate {
    
    
    // MARK : 멤버 필드

    @IBOutlet weak var answer: UITextField!
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var url : String!
    var timer = Timer() // 노래 시간 설정시 사용
    var musicSec = 0
    var startTime : Double!
    
    
    //var arraySong : [String] = ["270052873","287320848","18560800","285714919","17179509","200018532","73847634","196942610","261595798","266565177"]
    //var arrayTitle : [String] = ["야생화","숨","사랑한후에","꿈","눈의꽃","해줄수없는일","안녕사랑아","동경","화신","나를넘는다"]
    
    var roundList:[(title:String,song:String,start:Int)] = []
    
    //var tempSong : Int = 0
    var hintMode: Int = 0 // 0 : 일반 재생 1 : 힌트 재생
    
    var score : Int = 0
    var life : Int = 3
    
    var item : Int = 3
    var stage : Int = 1
    
    
    //MARK : 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(roundList)
        setting(music: roundList[stage].song)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 노래를 설정하는 함수
    
    func setting(music: String){
        do {
            

            //무음에서도 들리게 해주는 부분!! 나중에 정리하면 될거 같아요 민섭님
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            setSong(name: music, time: 100)
            let fileURL = NSURL(string:url)
            let soundData = NSData(contentsOf:fileURL! as URL)
            self.audioPlayer = try AVAudioPlayer(data: soundData! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            audioPlayer.currentTime = startTime
        } catch {
            print(error)
            print("Error getting the audio file")
        }
    }
    
    

  
   

    @IBAction func Play(_ sender: UIButton) {
        hintMode = 0
        if(stage < roundList.count){
            playMusic()
            print("노래 제목 : " + roundList[stage].title)
            print("life :"+life.description)
            print("stage :"+stage.description)
            print("score :"+score.description)
        }else{
            
            print("life :"+life.description)
            print("마지막 stage :"+stage.description)
            print("최종 점수 :"+score.description)
            showToast("그만!")
        }
        
    }
    
    @IBAction func Stop(_ sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func Check(_ sender: UIButton) {
      
       if answer.text == roundList[stage].title {
            showToast("정답입니다!")
        
            nextStageInit()
        
            answer.text = ""
        
        if(life == 3){score += 100}
        else if(life == 2){score += 60}
        else if(life == 1){score += 30}
        else{score += 0}
        
        
        
        //다음 노래 준비
        if(stage < roundList.count){
            setting(music: roundList[stage].song)
        }
        
        }else if answer.text != roundList[stage].title{
            showToast("틀렸습니다!")
        
        
        
             life -= 1
        
        if(life == 0){
        
            nextStageInit()
            score += 0
            
            if(stage < roundList.count){
                setting(music: roundList[stage].song)
                print("life 0 되서 다음 스테이지 이동")
            }
            
            
        }
        
        }
    }
    
    @IBAction func Hint(_ sender: UIButton) {
        hintMode = 1
        playMusic()
    }
    
    
    // 패스 버튼
    
    @IBAction func Pass(_ sender: UIButton) {
        
        nextStageInit()
        score += 0
        
        
        if(stage < roundList.count){
            setting(music: roundList[stage].song)
            showToast("다음 스테이지 넘어감")
        }
        
        
    }
    
    func nextStageInit(){
    
        stage += 1
        life = 3
    }
    
    
    
   
    // 노래 재생 시간 설정 ( music_sec 가 초를 나타낸다 )
    
    func counter() {
        musicSec += 1
        if musicSec > 0 && hintMode == 0{
            audioPlayer.stop() // 지정한 시간이 지나면 스톱
            audioPlayer.currentTime = startTime // 노래를 처음 시작 구간으로
            timer.invalidate()   // 타이머를 다시 0초로
        }
        else if musicSec > 2 && hintMode == 1{
            audioPlayer.stop() // 지정한 시간이 지나면 스톱
            audioPlayer.currentTime = startTime // 노래를 처음 시작 구간으로
            timer.invalidate()   // 타이머를 다시 0초로
        }
        
    }
    
    // 노래제목을 설정 하는 함수
    
    func setSong(name: String,time: Double){
        url = "https://api.soundcloud.com/tracks/"+name+"/stream?client_id=59eb0488cc28a2c558ecbf47ed19f787"
        startTime = time
    }
    
    // 토스트 띄우는 함수
    
    func showToast(_ msg:String) {
        let toast = UIAlertController()
        toast.message = msg;
        
        self.present(toast, animated: true, completion: nil)
        let duration = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: duration) {
            toast.dismiss(animated: true, completion: nil)
        }
    }
    
    // 노래 재생 하는 함수
    
    func playMusic(){
        musicSec = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameController.counter), userInfo: nil, repeats:true)
        audioPlayer.play()
    }
    
  

}

