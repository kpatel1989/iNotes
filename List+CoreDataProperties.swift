//
//  List+CoreDataProperties.swift
//  iNotes
//
//  Created by Kartik Patel on 2017-04-20.
//  Copyright © 2017 Kartik Patel. All rights reserved.
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List");
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?

}
