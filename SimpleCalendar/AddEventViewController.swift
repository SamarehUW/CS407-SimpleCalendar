//
//  AddEventViewController.swift
//  SimpleCalendar
//
//  Created by Samareh Shahmohammadi on 10/15/15.
//  Copyright (c) 2015 Samareh Shahmohammadi. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    var date: NSDate?
    var events = [Event]()
    var addOrEdit: Bool?    //true for add, false for edit
    var toEdit: Int?
    
    @IBOutlet weak var addEventFor: UILabel!
    @IBOutlet weak var inputTime: UIDatePicker!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputLocation: UITextField!
    @IBOutlet weak var inputDesc: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show the date being added to at top
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        let printedDate = formatter.stringFromDate(date!)
        addEventFor.text = "Add event for " + printedDate
        updateButton.setTitle("Add", forState: UIControlState.Normal)
        
        if !addOrEdit!{
            let e = events[toEdit!]
            addEventFor.text = "Edit event for" + formatter.stringFromDate(date!)
            inputTime.date = e.date
            inputName.text = e.name
            inputLocation.text = e.location
            inputDesc.text = e.details
            updateButton.titleLabel?.text = "Update";
            updateButton.setTitle("Update", forState: UIControlState.Normal)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "doAdd" || segue.identifier == "cancelAdd"{
            // identify next controller
            let nextController = segue.destinationViewController as! CalendarViewController
            
            if segue.identifier == "doAdd" {
                // update date to reflect the time
                let calendar = NSCalendar.currentCalendar()
                var comp = NSDateComponents()
                comp.hour = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: inputTime.date).hour
                comp.minute = calendar.components(NSCalendarUnit.CalendarUnitMinute, fromDate: inputTime.date).minute
                comp.year = calendar.components(NSCalendarUnit.CalendarUnitYear, fromDate: date!).year
                comp.month = calendar.components(NSCalendarUnit.CalendarUnitMonth, fromDate: date!).month
                comp.day = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: date!).day
                date = calendar.dateFromComponents(comp)
            
                // update the list of events
                let newEvent = Event(date: date!, name: inputName.text, location: inputLocation.text, details: inputDesc.text)
                if !addOrEdit!{
                    events[toEdit!] = newEvent
                }else{
                    events.append(newEvent)
                }
            }
            
            nextController.showingDate = date!
            nextController.events = events
        }
    }

}
