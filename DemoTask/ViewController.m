//
//  ViewController.m
//  DemoTask
//
//  Created by admin on 21/02/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableDictionary* dict;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)myPostMethod
{
    NSString *userInfo = [NSString  stringWithFormat:@"dEmail=%@",_userNameTF.text];
    userInfo = [userInfo stringByAppendingFormat:@"&password=%@",_passwrdTF.text];
     userInfo = [userInfo stringByAppendingFormat:@"&encryptionRequired=%@",@"NO"];

    [[BHNetworkAPI sharedInstance] executePOSTRequestWithUserInfo:userInfo requestURL:URL_LOGIN Withsuccess:^(BOOL success, id  _Nonnull response) {
        NSLog(@"LoginApi::executeRequest::Success::-%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self->dict = [[NSMutableDictionary alloc]initWithDictionary:response];
            
            SecondViewController* svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
            svc.tokenStr = [self->dict objectForKey:@"token"];
            
        });
    }
    failure:^(BOOL success, NSError * _Nonnull error) {
                                                              
                                    }];
}


- (IBAction)loginActBtn:(UIButton *)sender {
   
        [self myPostMethod];
    
}
/*
 //
 //  QuestionTVC.swift
 //  TalkJobSearch
 //
 //  Created by Syed Amais on 28/12/2018.
 //  Copyright © 2018 Syed-iOS. All rights reserved.
 //
 
 import UIKit
 import SVProgressHUD
 import Speech
 import AVKit
 import AVFoundation
 import Alamofire
 
 
 class QuestionTVC: UITableViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
 
 @IBOutlet weak var jobNolabel: UILabel!
 @IBOutlet weak var companyName: UILabel!
 @IBOutlet weak var listenLabel: UILabel!
 @IBOutlet weak var questionCountLabel: UILabel!
 @IBOutlet weak var questionLabel: UILabel!
 @IBOutlet weak var switchButton: UIButton!
 @IBOutlet weak var nextButton: UIButton!
 var code: String!
 var Actionid: Int!
 var value: String!
 var actcode :String!
 var alertOkAction : Bool = false;
 var skipeOcuured = false;
 var exitOccured = false;
 var isItLast    = true;
 
 
 
 
 @IBOutlet weak var titleLabel: UILabel!
 //  var id : Int?
 var mode : String?
 var question : Question?
 var action : AuditQuestionActions?
 var selectedIndex : IndexPath?
 var preIndex : IndexPath?
 var ansId : Int?
 var ansText : String?
 var refreshBlock : ((Bool) -> Void)?
 var titleText : String?
 var questionCount = ""
 let audioEngine = AVAudioEngine()
 let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
 var request : SFSpeechAudioBufferRecognitionRequest?
 var recognitionTask : SFSpeechRecognitionTask?
 var currentSpeakingText = ""
 var isDone = false
 var isnext = false
 var isTextAnsDone = false
 var speechText = ""
 var questionID : Int?
 var testq : Int?
 var auditId : Int?
 var isFromReview = false
 var isPreviousQues = false
 var quesIds = [Int]()
 var isBackDone = false
 var comapny : String?
 var jobNo : String?
 var teststr = [String]()
 var stringImg: String!
 var skip = false
 var isskipping = false
 
 //let synthesizer = AVSpeechSynthesizer()
 override func viewDidLoad() {
 super.viewDidLoad()
 UIApplication.shared.isIdleTimerDisabled = true
 
 self.companyName.text = comapny!
 self.jobNolabel.text = jobNo!
 questionCountLabel?.layer.cornerRadius = 5
 questionCountLabel?.layer.masksToBounds = true
 // questionCountLabel?.layer.borderWidth = 1.0
 // questionCountLabel?.layer.borderColor = UIColor.lightGray.cgColor
 
 if isFromReview {
 getQuestion()
 }
 else{
 getQuestions()
 }
 if Talk5Singleton.sharedInstance.fromReview == "fromReview"{
 }else{
 Talk5Singleton.sharedInstance.fromReview.removeAll()
 }
 // self.questCompletedNumb = Int(self.questCompleted)!
 nextButton.isEnabled = false
 nextButton.alpha = 0.5
 
 self.titleLabel.text = "\(titleText ?? "")"
 if self.mode! == "audio"{
 //self.recordAndRecognizeSpeech()
 switchButton.setTitle("Switch to keyboard", for: .normal)
 }
 else{
 switchButton.setTitle("Switch to audio", for: .normal)
 }
 
 let customBackButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action:#selector(self.customBackMethod(sender:)))
 self.navigationItem.leftBarButtonItem = customBackButtonItem
 }
 
 
 @objc func customBackMethod(sender: UIBarButtonItem) {
 
 }
 
 // back button Action
 func backButtonHandler(){
 
 if let _ = speakStruct.synthesizer{
 speakStruct.synthesizer?.pauseSpeaking(at: .immediate)
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 self.disableListen()
 
 if !isFromReview {
 
 if self.question!.displayOrder! != 1 {
 
 let qID = self.question?.id!
 print("Audit id \(qID)")
 SVProgressHUD.show(withStatus: "Loading..")
 ApiRequest.getPrevioustQuesWith(quesId: qID, auditId: self.auditId) { (result, error) in
 
 if error == nil {
 self.question = result
 self.questionLabel.text = result.question!
 self.isPreviousQues = true
 self.setData()
 }
 SVProgressHUD.dismiss()
 }
 
 }
 else{
 isPreviousQues = false
 self.navigationController?.popViewController(animated: true)
 }
 }
 else{
 self.navigationController?.popViewController(animated: true)
 }
 }
 
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(true)
 
 if let _ = speakStruct.synthesizer{
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 self.disableListen()
 //Talk5Singleton.sharedInstance.fromReview.removeAll()
 }
 
 // get next question
 func getQuestion(){
 SVProgressHUD.show(withStatus: "Loading..")
 
 ApiRequest.getQuestionsWith(quesId: self.questionID!, auditId: self.auditId!) { (question, error) in
 if error == nil{
 self.question = question
 self.questionLabel.text = question.question!
 self.setData()
 }
 SVProgressHUD.dismiss()
 
 }
 
 
 
 }
 
 // getgetQuestions
 func getQuestions(){
 
 SVProgressHUD.show(withStatus: "Loading..")
 
 if NetworkReachabilityManager()!.isReachable {
 ApiRequest.getNextQuestions(id: self.auditId!) { (results, error) in
 
 if error == nil{
 self.question = results
 self.actcode = self.question!.actCode
 print(self.actcode ?? 0)
 self.Actionid = self.question!.ansI
 
 self.setData()
 if self.skip == true {
 
 let myInt2 = (self.value as NSString).integerValue
 
 if myInt2 >= self.question!.id {
 self.isskipping = true
 self.submit()
 }else{
 self.skip = false
 self.isskipping = false
 }
 
 }
 
 }
 
 SVProgressHUD.dismiss()
 }
 }
 else{
 SVProgressHUD.dismiss()
 let alert =  ApiRequest.showAlertWith(title: "Alert", message: "Please check your network")
 self.present(alert, animated: true, completion: nil)
 }
 }
 
 // reset data
 func setData(){
 if self.question?.question != "" {
 self.questionLabel.text = self.question?.question!
 self.selectedIndex = nil
 self.nextButton.isEnabled = false
 self.nextButton.alpha = 0.5
 //self.questionCount = 0
 
 //            if !isFromReview && !isPreviousQues{
 //
 //            let count = "\(String(describing: self.question!.displayOrder!)) / \(String(describing: self.questionCount))"
 //            self.questionCountLabel.text = count
 //            }
 //            else if isPreviousQues{
 //            self.questionCountLabel.text = "\(String(describing: self.question!.displayOrder!)) / \(String(describing: self.questionCount)) "
 //            }
 //            else{
 //                self.questionCountLabel.text = "\(String(describing: self.question!.displayOrder!)) / \(String(describing: self.questionCount)) "
 //
 //            }
 self.questionCountLabel.text = "\(String(describing: self.question!.displayOrder!))/\(String(describing: self.questionCount)) "
 self.isDone = false
 self.isnext = false
 self.isTextAnsDone = false
 
 var addTExt = ""
 if  self.question?.auditQuestionType == "YesNo" {
 addTExt = "      (Yes),(No)"
 }
 else if  self.question?.auditQuestionType == "YesNoNA" {
 addTExt = "(Yes),(No),(Not Applicable)"
 }
 self.speechText = addTExt
 self.currentSpeakingText =  (self.question?.question)! + addTExt
 
 if self.mode! == "audio"{
 
 self.speakString(text: self.currentSpeakingText)
 
 }
 else{
 
 }
 self.tableView.reloadData()
 
 if isFromReview || isPreviousQues {
 
 if self.question?.auditQuestionType == "YesNoNA"
 {
 if   self.question!.auditResult.answerID == 1 {
 selectRow(text: "yes")
 
 }
 else if   self.question!.auditResult.answerID == 2 {
 selectRow(text: "no")
 }
 else if   self.question!.auditResult.answerID == 3 {
 selectRow(text: "not")
 }
 }
 else if self.question?.auditQuestionType == "YesNo"
 {
 if   self.question!.auditResult.answerID == 4 {
 selectRow(text: "yes")
 }
 else if   self.question!.auditResult.answerID == 5 {
 selectRow(text: "no")
 }
 
 }
 else{
 let ans = self.question?.auditResult.answer
 writeText(text: ans ?? "")
 }
 }
 
 }
 }
 
 
 // MARK: - Table view data source
 override func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // #warning Incomplete implementation, return the number of rows
 
 var count = 0
 if  self.question?.auditQuestionType == "YesNo" {
 count = 2
 }
 else if self.question?.auditQuestionType == "YesNoNA"
 {
 count = 3
 }
 else{
 count = 1
 }
 
 return count //self.question?.auditQuestionType == "YesNo" ? 2 : 1
 }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 var cell = QuesYesNoCell() //tableView.dequeueReusableCell(withIdentifier: "yesnoCell", for: indexPath) as! QuesYesNoCell
 
 if  self.question?.auditQuestionType == "YesNo" {
 cell = tableView.dequeueReusableCell(withIdentifier: "yesnoCell", for: indexPath) as! QuesYesNoCell
 if let ques = self.question{
 let ansArr = ques.auditAnswers
 let ans = ansArr![indexPath.row]
 cell.nameLabel.text = ans.name
 cell.quesImageView?.image = UIImage(named: "emptyRadio")
 cell.nameLabel.textColor = UIColor.black
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor.clear.cgColor
 //            if isFromReview {
 //
 //                if ans.id == ques.auditResult.answerID {
 //                    cell.quesImageView?.image = UIImage(named: "fiilRadio")
 //                }
 //            }
 }
 // self.switchButton.isHidden = true
 
 }
 else if self.question?.auditQuestionType == "Text"{
 cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! QuesYesNoCell
 cell.textView?.delegate = self
 self.switchButton.isHidden = false
 if self.mode != "audio" {
 if !self.isPreviousQues{
 //cell.textView?.text = "Write your Ans"
 // cell.textView?.textColor = UIColor.lightGray
 }
 }
 //            if isFromReview{
 //
 //                //if ans.id == ques.auditResult.answerID {
 //                 cell.textView?.text = question?.auditResult.answer
 //               // }
 //            }
 
 //self.ansId = self.question?.id
 }
 else if self.question?.auditQuestionType == "YesNoNA" {
 cell = tableView.dequeueReusableCell(withIdentifier: "yesnoCell", for: indexPath) as! QuesYesNoCell
 if let ques = self.question{
 let ansArr = ques.auditAnswers
 let ans = ansArr![indexPath.row]
 cell.nameLabel.text = ans.name
 cell.quesImageView?.image = UIImage(named: "emptyRadio")
 cell.nameLabel.textColor = UIColor.black
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor.clear.cgColor
 //   self.switchButton.isHidden = true
 
 //                if isFromReview{
 //
 //                    if ans.id == ques.auditResult.answerID {
 //                        cell.quesImageView?.image = UIImage(named: "fiilRadio")
 //                    }
 //                }
 }
 }
 
 
 
 
 
 cell.selectionStyle = UITableViewCellSelectionStyle.none
 
 //        let sw = switchButton.titleLabel?.text
 //        if sw == "SWITCH TO AUDIO MODE"{
 //           // self.mode = "audio"
 //            switchButton.setTitle("SWITCH TO KEYBOARD", for: .normal)
 //            cell.isUserInteractionEnabled = false
 //        }
 //        else{
 //            //self.mode = "keyboard"
 //            switchButton.setTitle("SWITCH TO AUDIO MODE", for: .normal)
 //            cell.isUserInteractionEnabled = true
 //        }
 if self.mode == "audio"{
 cell.isUserInteractionEnabled = false
 }
 else{
 cell.isUserInteractionEnabled = true
 }
 
 
 return cell
 }
 override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
 if self.question?.auditQuestionType == "Text"{
 return 100
 }
 else{
 return 75
 
 }
 }
 
 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 if Talk5Singleton.sharedInstance.fromReview == "fromReview"{
 if self.question?.auditQuestionType != "Text" {
 
 if isFromReview || isPreviousQues{
 if let index = selectedIndex{
 let cell = tableView.cellForRow(at: index) as! QuesYesNoCell
 cell.quesImageView?.image = UIImage(named: "emptyRadio")
 cell.nameLabel.textColor = UIColor.black
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor.clear.cgColor
 }
 }
 
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.quesImageView?.image = UIImage(named: "fiilRadio")
 nextButton.isEnabled = true
 nextButton.alpha = 1
 cell.nameLabel.textColor = UIColor(displayP3Red: 44/255, green: 188/255, blue: 62/255, alpha: 1.0)
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor(displayP3Red: 44/255, green: 188/255, blue: 87/255, alpha: 1.0).cgColor
 selectedIndex = indexPath
 if let ques = self.question{
 self.ansId = ques.auditAnswers[indexPath.row].id
 }
 
 }
 }else{
 if self.question?.auditQuestionType != "Text" {
 
 if isFromReview || isPreviousQues{
 if let index = selectedIndex{
 let cell = tableView.cellForRow(at: index) as! QuesYesNoCell
 cell.quesImageView?.image = UIImage(named: "emptyRadio")
 cell.nameLabel.textColor = UIColor.black
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor.clear.cgColor
 }
 }
 
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.quesImageView?.image = UIImage(named: "fiilRadio")
 nextButton.isEnabled = true
 nextButton.alpha = 1
 cell.nameLabel.textColor = UIColor(displayP3Red: 44/255, green: 188/255, blue: 62/255, alpha: 1.0)
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor(displayP3Red: 44/255, green: 188/255, blue: 87/255, alpha: 1.0).cgColor
 selectedIndex = indexPath
 if let ques = self.question{
 self.ansId = ques.auditAnswers[indexPath.row].id
 }
 }
 //var answercode = [AuditQuestionActions]()
 let test  = self.question!.test
 var actionvalue = test?.filter { (element) -> Bool in
 //let actArr = AuditQuestionActions(json: element)
 //var okok = element as Dictionary
 if (element["answerID"].intValue == self.ansId){
 
 return true;
 }else{
 return false;
 }
 }
 
 print(actionvalue ?? 0)
 if actionvalue?.count ?? 0 > 0{
 
 var exitIndex = -1;
 for i in 0...actionvalue!.count-1 {
 self.actcode = actionvalue?[i]["actionCode"].stringValue
 if(actcode == "exit_audit"){
 exitOccured = true;
 exitIndex = i;
 }
 if(actcode == "skip_to_question"){
 exitOccured = true;
 }
 }
 
 if(exitIndex == -1){//no extifound
 for i in 0...actionvalue!.count-1 {
 self.actcode = actionvalue?[i]["actionCode"].stringValue
 self.value = actionvalue?[i]["actionValue"].stringValue
 resetSetting()
 showAction()
 }
 }else{//exit found at exitIndex
 for i in 0...exitIndex {
 self.actcode = actionvalue?[i]["actionCode"].stringValue
 self.value = actionvalue?[i]["actionValue"].stringValue
 resetSetting()
 showAction()
 }
 }
 
 
 }
 
 }
 Talk5Singleton.sharedInstance.fromReview.removeAll()
 
 }
 override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
 print("diselet \(indexPath.row)")
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.quesImageView?.image = UIImage(named: "emptyRadio")
 
 cell.nameLabel.textColor = UIColor.black
 cell.quesView.layer.borderWidth = 1.0
 cell.quesView.layer.borderColor = UIColor.clear.cgColor
 }
 
 func recordAndRecognizeSpeech(){
 
 if recognitionTask != nil {  //1
 recognitionTask?.cancel()
 recognitionTask = nil
 }
 let audioSession = AVAudioSession.sharedInstance()  //2
 do {
 try audioSession.setCategory(AVAudioSessionCategoryRecord)
 try audioSession.setMode(AVAudioSessionModeMeasurement)
 try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
 } catch {
 print("audioSession properties weren't set because of an error.")
 }
 
 if let _ = request{
 
 }
 else{
 request = SFSpeechAudioBufferRecognitionRequest()
 }
 var lastString: String = ""
 
 let node = audioEngine.inputNode //else { return }
 node.reset()
 let recordingFormat = node.outputFormat(forBus: 0)
 node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
 self.request?.append(buffer)
 }
 
 audioEngine.prepare()
 do {
 try audioEngine.start()
 } catch {
 self.sendAlert(message: "There has been an audio engine error.")
 return print(error)
 }
 
 guard let myRecognizer = SFSpeechRecognizer() else {
 self.sendAlert(message: "Speech recognition is not supported for your current locale.")
 return
 }
 if !myRecognizer.isAvailable {
 self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
 // Recognizer is not available right now
 return
 }
 
 recognitionTask = speechReconizer?.recognitionTask(with: request!, resultHandler: { result, error in
 if let result = result {
 
 let bestString = result.bestTranscription.formattedString
 // self.detectTextLabel.text = bestString
 
 for segment in result.bestTranscription.segments {
 let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
 lastString = bestString.substring(from: indexTo)
 }
 
 //self.checkForColorsSaid(resultString: lastString)
 // print(AVSpeechSynthesisVoice.speechVoices())
 print("spech text :  \(lastString)")
 if self.question?.auditQuestionType == "Text" {
 self.writeText(text: bestString)
 if self.isTextAnsDone {
 if (!self.isnext){
 self.checkForNExt(text: lastString)
 }
 else {
 self.disableListen()
 }
 }
 }
 else{
 self.checkJobNumber(text: lastString)
 }
 
 } else if let error = error {
 // self.sendAlert(message: "There has been a speech recognition error.")
 print(error)
 }
 })
 }
 
 
 
 
 func selectRow(text : String){
 if self.question?.auditQuestionType == "YesNo" {
 if text == "yes" || text == "YES" || text == "Yes" {
 isDone = true
 ansId = question!.auditAnswers[0].id
 let indexPath = IndexPath(row: 0, section: 0)
 let indexPath1 = IndexPath(row: 1, section: 0)
 tableView(tableView, didSelectRowAt: indexPath)
 tableView(tableView, didDeselectRowAt: indexPath1)
 //getNextQuest()
 }
 else if text == "no" || text == "NO" || text == "No"{
 isDone = true
 ansId = question!.auditAnswers[1].id
 let indexPath = IndexPath(row: 1, section: 0)
 let indexPath1 = IndexPath(row: 0, section: 0)
 tableView(tableView, didSelectRowAt: indexPath)
 tableView(tableView, didDeselectRowAt: indexPath1)
 //  getNextQuest()
 
 }
 }
 else if self.question?.auditQuestionType == "YesNoNA" {
 
 if text == "yes" || text == "YES" || text == "Yes" {
 isDone = true
 ansId = question!.auditAnswers[0].id
 let indexPath = IndexPath(row: 0, section: 0)
 let indexPath1 = IndexPath(row: 1, section: 0)
 let indexPath2 = IndexPath(row: 2, section: 0)
 tableView(tableView, didSelectRowAt: indexPath)
 tableView(tableView, didDeselectRowAt: indexPath1)
 tableView(tableView, didDeselectRowAt: indexPath2)
 
 }
 else if text == "no" || text == "NO" || text == "No"{
 isDone = true
 ansId = question!.auditAnswers[1].id
 let indexPath = IndexPath(row: 1, section: 0)
 let indexPath1 = IndexPath(row: 0, section: 0)
 let indexPath2 = IndexPath(row: 2, section: 0)
 tableView(tableView, didSelectRowAt: indexPath)
 tableView(tableView, didDeselectRowAt: indexPath1)
 tableView(tableView, didDeselectRowAt: indexPath2)
 // getNextQuest()
 
 }
 else  if  text == "Not Applicable" || text == "Not" || text == "not" || text == "Na" || text == "na"{
 isDone = true
 ansId = question!.auditAnswers[2].id
 let indexPath = IndexPath(row: 2, section: 0)
 let indexPath1 = IndexPath(row: 0, section: 0)
 let indexPath2 = IndexPath(row: 1, section: 0)
 tableView(tableView, didSelectRowAt: indexPath)
 tableView(tableView, didDeselectRowAt: indexPath1)
 tableView(tableView, didDeselectRowAt: indexPath2)
 //getNextQuest()
 }
 }
 }
 
 func checkJobNumber(text : String){
 if (text == ""){
 }
 else{
 if self.question?.auditQuestionType == "Text" {
 let indexPath = IndexPath(row: 0, section: 0)
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.textView.text = cell.textView.text + text
 }
 else{
 selectRow(text: text)
 //if self.skip != true {
 getNextQuest()
 //}
 
 }
 if text == "Cancel" || text == "cancel"{
 
 goback()
 
 }
 }
 }
 
 
 func writeText(text : String){
 if text != ""  {
 
 let indexPath = IndexPath(row: 0, section: 0)
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.textView.text = text
 self.ansText = cell.textView.text
 isTextAnsDone = true
 nextButton.isEnabled = true
 nextButton.alpha = 1
 self.isTextAnsDone = true
 }
 }
 
 func checkForNExt(text : String){
 if text == "Next" || text == "next"  {
 if isDone ||  self.isTextAnsDone  {
 if question!.auditQuestionType == "Text" {
 let indexPath = IndexPath(row: 0, section: 0)
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.textView.text = ""
 }
 isnext = true
 submit()
 disableListen()
 
 }
 }
 
 if text == "Cancel" || text == "cancel"{
 
 goback()
 
 }
 }
 
 // get next questons Api calling
 func getNextQuest(){
 
 if isDone ||  self.isTextAnsDone  {
 if question!.auditQuestionType == "Text" {
 let indexPath = IndexPath(row: 0, section: 0)
 let cell = tableView.cellForRow(at: indexPath) as! QuesYesNoCell
 cell.textView.text = ""
 }
 isnext = true
 let test  = self.question!.test
 var actionvalue = test?.filter { (element) -> Bool in
 //let actArr = AuditQuestionActions(json: element)
 //var okok = element as Dictionary
 if (element["answerID"].intValue == self.ansId){
 return true;
 }else{
 return false;
 }
 }
 
 print(actionvalue ?? 0)
 if actionvalue?.count ?? 0 > 0{
 self.actcode = actionvalue?[0]["actionCode"].stringValue
 self.value = actionvalue?[0]["actionValue"].stringValue
 resetSetting()
 //showAction()
 
 }else{
 submit()
 
 }
 
 disableListen()
 }
 }
 
 // single question Api calling
 func submit(){
 isPreviousQues = false
 let text = ansText == "" || ansText == nil ? "" : ansText!
 let param = [
 "id":0,
 "jobAuditID": self.auditId!,
 "userID":4,
 "questionID":self.question!.id ?? 0,
 "question":"",
 "answerID":ansId ?? 0,
 "answerName":  "",
 "answer":text,
 "skipQuestion": isskipping,
 "attachments" : teststr
 ] as [String : Any]
 
 //print(param)
 SVProgressHUD.show(withStatus: "Loading")
 Talk5Singleton.sharedInstance.imageName.removeAll()
 teststr.removeAll()
 
 if NetworkReachabilityManager()!.isReachable {
 
 ApiRequest.submitSingleQues(param: param) { (response, error) in
 
 if error == nil {
 
 if self.isFromReview {
 self.refreshBlock!((true))
 self.navigationController?.popViewController(animated: true)
 }
 else {
 let counter = self.question!.displayOrder!
 if counter  == Int(self.questionCount){
 let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewTVC") as! ReviewTVC
 controller.id = self.auditId!
 controller.mode = "audio"
 controller.companyName = self.comapny
 controller.jobNo = self.jobNo
 controller.isFromQuestionVc = true
 self.navigationController!.pushViewController(controller, animated: true)
 }
 else{
 self.getQuestions()
 }
 }
 }
 else{
 print(error ?? "error")
 }
 SVProgressHUD.dismiss()
 }
 }
 else{
 SVProgressHUD.dismiss()
 let alert =  ApiRequest.showAlertWith(title: "Alert", message: "Please check your network")
 self.present(alert, animated: true, completion: nil)
 }
 }
 
 
 func speakString(text : String){
 
 var speaker = speakStruct(text: text)
 speaker.speakString()
 speakStruct.synthesizer?.delegate = self
 
 }
 // next question Button Action
 @IBAction func nextButtonTapped(_ sender: UIButton) {
 resetSetting()
 submit()
 
 
 }
 // Alert for speech error
 func sendAlert(message: String) {
 let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 }
 // swich to the Audio and keyboard
 @IBAction func switchButtonTapped(_ sender: UIButton) {
 //  self.speechText = ""
 resetSetting()
 let sw = switchButton.titleLabel?.text
 if sw == "Switch to audio"{
 self.mode = "audio"
 //  self.speechText = self.currentSpeakingText
 self.speakString(text: self.currentSpeakingText)
 switchButton.setTitle("Switch to keyboard", for: .normal)
 }
 else{
 self.mode = "keyboard"
 switchButton.setTitle("Switch to audio", for: .normal)
 }
 self.nextButton.isEnabled = false
 self.nextButton.alpha = 0.5
 self.tableView.reloadData()
 }
 
 // for voice stopping
 func resetSetting(){
 if let _ = speakStruct.synthesizer{
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 disableListen()
 }
 // disable to the listen
 func disableListen(){
 if self.recognitionTask != nil {
 self.recognitionTask?.cancel()
 self.recognitionTask = nil
 self.request?.endAudio()
 self.request = nil
 self.audioEngine.stop()
 audioEngine.inputNode.removeTap(onBus: 0)
 }
 }
 
 // mark:- texview data source methods
 func textViewDidEndEditing(_ textView: UITextView) {
 self.ansText = textView.text
 nextButton.isEnabled = true
 nextButton.alpha = 1
 }
 // mark :- tableview datasource methods
 func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
 if text == "\n" {
 textView.resignFirstResponder()
 return false
 }
 return true
 }
 func textViewDidBeginEditing(_ textView: UITextView) {
 if textView.text == "Write your Ans" {
 textView.text = ""
 textView.textColor = UIColor.black
 }
 }
 
 func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
 if  self.question?.auditQuestionType != "Text" {
 //        if self.speechText != "" {
 //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
 //                self.disableListen()
 //            if !self.isBackDone {
 //                self.speakString(text: self.speechText)
 //                self.speechText = ""
 //            }
 //          }
 //         }
 }
 self.recordAndRecognizeSpeech()
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 
 // cancel Button Action
 @IBAction func cancelButtonTapped(_ sender: UIButton) {
 
 goback()
 }
 
 
 // back Button Action
 func goback(){
 isBackDone = true
 //self.refreshBlock!((true))
 if let _ = speakStruct.synthesizer{
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 disableListen()
 
 self.navigationController?.popViewController(animated: true)
 }
 @IBAction func backButtonTapped(_ sender: Any) {
 
 backButtonHandler()
 }
 override func viewWillAppear(_ animated: Bool) {
 
 if Talk5Singleton.sharedInstance.upload == "sucess"{
 teststr = Talk5Singleton.sharedInstance.imageName
 //self.submit()
 stringImg = teststr.joined(separator: " ")
 
 }
 }
 
 // show alert for the SingleQuestinanswer
 func showAction (){
 
 switch self.actcode{
 case "alert":
 
 let refreshAlert = UIAlertController(title: self.actcode, message: self.value, preferredStyle: UIAlertControllerStyle.alert)
 
 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
 if(self.skipeOcuured || self.exitOccured){
 
 }else{
 if(self.isItLast){
 self.isItLast = false;
 self.resetSetting()
 self.submit()
 }
 
 }
 print("Handle Ok logic here")
 }))
 
 let alertWindow = UIWindow(frame: UIScreen.main.bounds)
 alertWindow.rootViewController = UIViewController()
 //alertWindow.windowLevel = UIWindow.Level.alert + 1
 alertWindow.windowLevel = UIWindowLevel(bitPattern: 1);
 alertWindow.makeKeyAndVisible()
 alertWindow.rootViewController?.present(refreshAlert, animated: true, completion: nil)
 
 case "warning":
 let refreshAlert = UIAlertController(title:self.actcode, message: self.value, preferredStyle: UIAlertControllerStyle.alert)
 
 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
 if(self.skipeOcuured || self.exitOccured){
 
 }else{
 if(self.isItLast){
 self.isItLast = false;
 self.resetSetting()
 self.submit()
 }
 
 }
 
 print("Handle Ok logic here")
 }))
 
 let alertWindow = UIWindow(frame: UIScreen.main.bounds)
 alertWindow.rootViewController = UIViewController()
 //alertWindow.windowLevel = UIWindow.Level.alert + 1
 alertWindow.windowLevel = UIWindowLevel(bitPattern: 1);
 alertWindow.makeKeyAndVisible()
 alertWindow.rootViewController?.present(refreshAlert, animated: true, completion: nil)
 case "info":
 
 let refreshAlert = UIAlertController(title: self.actcode, message: self.value, preferredStyle: UIAlertControllerStyle.alert)
 
 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
 
 if(self.skipeOcuured || self.exitOccured){
 
 }else{
 if(self.isItLast){
 self.isItLast = false;
 self.resetSetting()
 self.submit()
 }
 
 }
 
 
 print("Handle Ok logic here")
 }))
 
 let alertWindow = UIWindow(frame: UIScreen.main.bounds)
 alertWindow.rootViewController = UIViewController()
 //alertWindow.windowLevel = UIWindow.Level.alert + 1
 alertWindow.windowLevel = UIWindowLevel(bitPattern: 1);
 alertWindow.makeKeyAndVisible()
 alertWindow.rootViewController?.present(refreshAlert, animated: true, completion: nil)
 case "add_photo":
 
 print("ADD PHoto")
 let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ImageUVC") as! ImageUVC
 
 case "Send_email":
 let refreshAlert = UIAlertController(title: self.actcode, message: self.value, preferredStyle: UIAlertControllerStyle.alert)
 
 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
 self.resetSetting()
 self.submit()
 
 print("Handle Ok logic here")
 let alertWindow = UIWindow(frame: UIScreen.main.bounds)
 alertWindow.rootViewController = UIViewController()
 //alertWindow.windowLevel = UIWindow.Level.alert + 1
 alertWindow.windowLevel = UIWindowLevel(bitPattern: 1);
 alertWindow.makeKeyAndVisible()
 alertWindow.rootViewController?.present(refreshAlert, animated: true, completion: nil)
 }))
 
 let alertWindow = UIWindow(frame: UIScreen.main.bounds)
 alertWindow.rootViewController = UIViewController()
 //alertWindow.windowLevel = UIWindow.Level.alert + 1
 alertWindow.windowLevel = UIWindowLevel(bitPattern: 1);
 alertWindow.makeKeyAndVisible()
 alertWindow.rootViewController?.present(refreshAlert, animated: true, completion: nil)
 case "exit_audit" :
 let refreshAlert = UIAlertController(title: self.actcode, message: self.value, preferredStyle: UIAlertControllerStyle.alert)
 
 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
 // self.popBack(3)
 print("Handle Ok logic here")
 }))
 self.popBack(3)
 // present(refreshAlert, animated: true, completion: nil)
 case "skip_to_question" :
 skip = true
 
 //let myInt2 = (value as NSString).integerValue
 submit()
 
 default: break
 
 }
 
 }
 func popBack(_ nb: Int) {
 if let _ = speakStruct.synthesizer{
 speakStruct.synthesizer?.stopSpeaking(at: .immediate)
 }
 
 if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
 guard viewControllers.count < nb else {
 self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
 return
 }
 }
 }
 }
 /*
 
 //             self.Actionid = self.question!.ansI
 //               if  self.ansId == Actionid{
 //                     resetSetting()
 //                    showAction()
 //                }
 //                else{
 //                    resetSetting()
 //                    submit()
 //                }
 
 */



@end
