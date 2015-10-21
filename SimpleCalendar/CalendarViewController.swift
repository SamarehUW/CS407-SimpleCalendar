//
//  CalendarViewController.swift
//  SimpleCalendar
//
//  Created by Samareh Shahmohammadi on 10/15/15.
//  Copyright (c) 2015 Samareh Shahmohammadi. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var events = [Event]()
    var dateSpecificEvents = [Event]()
    var showingDate = NSDate()
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet var datePicked: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicked.date = showingDate
        myTable.rowHeight = UITableViewAutomaticDimension
        myTable.estimatedRowHeight = 20
        updateSubset()
    }

    
    @IBAction func dateChanged(sender: AnyObject) {
        updateSubset()
        //sort the table
    }
    
    func sortEvents(event1: Event, event2: Event) -> Bool{
        return event1.date.compare(event2.date) == NSComparisonResult.OrderedAscending
    }
    
    func updateSubset(){
        dateSpecificEvents.removeAll(keepCapacity: false)
        if events.count > 0{
            for i in 0...events.count-1{
                if events.count > 0{
                    let calendar = NSCalendar.currentCalendar()
                    let d1 = calendar.components(.CalendarUnitDay, fromDate: events[i].date).day
                    let m1 = calendar.components(.CalendarUnitMonth, fromDate: events[i].date).month
                    let y1 = calendar.components(.CalendarUnitYear, fromDate: events[i].date).year
                    let d2 = calendar.components(.CalendarUnitDay, fromDate: datePicked.date).day
                    let m2 = calendar.components(.CalendarUnitMonth, fromDate: datePicked.date).month
                    let y2 = calendar.components(.CalendarUnitYear, fromDate: datePicked.date).year
                    if (d1 == d2 && m1 == m2 && y1 == y2){
                        dateSpecificEvents.append(events[i])
                    }
                }
            }
            // sort the dates
            dateSpecificEvents = sorted(dateSpecificEvents, sortEvents)
        }
        myTable.reloadData()
        
    }
    
    // TableViewSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSpecificEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let thisEvent = dateSpecificEvents[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! customCell
        cell.nameLabel.text = thisEvent.name
        cell.locationLabel.text = thisEvent.location
        cell.descriptionLabel.text = thisEvent.details
        let eventTime = formatter.stringFromDate(thisEvent.date)
        cell.timeLabel.text = eventTime
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let deletedRow = dateSpecificEvents[indexPath.row]
        events.removeAtIndex(findEvent(deletedRow))
        updateSubset()
    }
    
    func findEvent(goal: Event) -> Int{
        for i in 0...events.count-1{
            let e = events[i]
            if e.name == goal.name && e.location == goal.location && e.date == goal.date{
                return i;
            }
        }
        return 0;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "callAdd" || segue.identifier == "editExisting" {
            let nextController = segue.destinationViewController as! AddEventViewController
            nextController.events = events
            nextController.date = datePicked.date
            if segue.identifier == "callAdd"{
                nextController.addOrEdit = true
            } else {
                nextController.addOrEdit = false
                if let indexPath = myTable.indexPathForSelectedRow() {
                    nextController.toEdit = findEvent(dateSpecificEvents[indexPath.row])
                }
            }
        }
    }
}


