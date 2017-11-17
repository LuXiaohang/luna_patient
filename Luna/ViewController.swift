//
//  ViewController.swift
//  Luna
//
//  Created by Jacob Lee on 10/12/17.
//  Copyright © 2017 jacob inc. All rights reserved.
//

import UIKit
import HealthKit
import ResearchKit
import sdlrkx
import ResearchSuiteTaskBuilder

class ViewController: RKViewController {
    
    @IBOutlet weak var medicationbg: UIView!
    @IBOutlet weak var moodbg: UIView!
    @IBOutlet weak var activitybg: UIView!
    var taskBuilder: RSTBTaskBuilder!
    
    var stateHelper: UserDefaultsStateHelper!
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodbg.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        moodbg.layer.shadowColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1).cgColor;
        moodbg.layer.shadowOffset = CGSize(width: 0, height: 15)
        moodbg.layer.shadowOpacity = 0.5;
        moodbg.layer.shadowRadius = 10.0;
        moodbg.layer.cornerRadius = 5;
        
        activitybg.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        activitybg.layer.shadowColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1).cgColor;
        activitybg.layer.shadowOffset = CGSize(width: 0, height: 15)
        activitybg.layer.shadowOpacity = 0.5;
        activitybg.layer.shadowRadius = 10.0;
        activitybg.layer.cornerRadius = 5;
        
        medicationbg.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        medicationbg.layer.shadowColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1).cgColor;
        medicationbg.layer.shadowOffset = CGSize(width: 0, height: 15)
        medicationbg.layer.shadowOpacity = 0.5;
        medicationbg.layer.shadowRadius = 10.0;
        medicationbg.layer.cornerRadius = 5;
        
        // Do any additional setup after loading the view, typically from a nib.
        
        hours_slept(completion:{ (hoursRetrieved: Float) in
            let slept_hours = Int(hoursRetrieved)
            print(slept_hours)
            let slept_percent = hoursRetrieved / 24
            
            print(slept_percent)
            self.sleepingprogress.progress = slept_percent
            self.sleepinghours.text = "\(slept_hours)"
        })
        
        retrieveStepCount(completion: { (stepRetrieved: Double) in
            let intstep = Int(stepRetrieved)
            let step_percent = stepRetrieved / 10000
            print(step_percent)
            self.stepsprogress.progress = Float(step_percent)
            self.steps.text = "\(intstep)"
        })
        
        let stepGeneratorServices: [RSTBStepGenerator] = [
            PAMStepGenerator()
        ]
        
        let answerFormatGeneratorServices: [RSTBAnswerFormatGenerator] = [
            RSTBSingleChoiceStepGenerator()
        ]
        
        let elementGeneratorServices: [RSTBElementGenerator] = [
            RSTBElementListGenerator(),
            RSTBElementFileGenerator(),
            RSTBElementSelectorGenerator()
        ]
        
        self.stateHelper = UserDefaultsStateHelper()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.taskBuilder = RSTBTaskBuilder(
            stateHelper: self.stateHelper,
            elementGeneratorServices: elementGeneratorServices,
            stepGeneratorServices: stepGeneratorServices,
            answerFormatGeneratorServices: answerFormatGeneratorServices)
        
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            , HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            , HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
    }
    
    func hours_slept(completion: @escaping (_ hoursRetrieved: Float) -> Void){
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -2, to: Date())
        let endDate = calendar.date(byAdding: .day, value: -1, to: Date())
        //        let endDate = Date()
        var number = Float()
        
        let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType!, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) in
            if let result = tmpResult {
                for item in result {
                    if let sample = item as? HKCategorySample {
                        _ = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        let seconds = sample.endDate.timeIntervalSince(sample.startDate)
                        let minutes = seconds/60
                        let hours = minutes/60
                        
                        number =  Float(hours)
                        
                        print(number)
                        completion(number)
                    }
                }
            }
        }
        healthStore.execute(query)
    }
    @IBOutlet weak var sleepinghours: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    @IBOutlet weak var sleepingprogress: UIProgressView!
    @IBOutlet weak var stepsprogress: UIProgressView!
    
    func retrieveStepCount(completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //   Get the start of the day
        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)
        let yesterday = cal.date(byAdding: .day, value: -1, to: Date())
        let today = Date()
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            DispatchQueue.main.async{
                if error != nil {
                    
                    //  Something went Wrong
                    return
                }
                
                if let myResults = results{
                    myResults.enumerateStatistics(from: yesterday!, to: today) {
                        statistics, stop in
                        
                        if let quantity = statistics.sumQuantity() {
                            
                            let steps = quantity.doubleValue(for: HKUnit.count())
                            print("Steps = \(steps)")
                            completion(steps)
                        }
                    }
                }
            }
            
        }
        healthStore.execute(query)
    }
    
    @IBAction func launchPAM(_ sender: UIButton) {
        
        guard let steps = self.taskBuilder.steps(forElementFilename: "PAMTask") else { return }
        
        let task = ORKOrderedTask(identifier: "PAM identifier", steps: steps)
        
        self.launchAssessmentForTask(task)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

