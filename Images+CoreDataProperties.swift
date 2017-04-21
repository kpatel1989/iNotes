//
//  Images+CoreDataProperties.swift
//  iNotes
//
//  Created by Kartik Patel on 2017-04-20.
//  Copyright © 2017 Kartik Patel. All rights reserved.
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images");
    }

    @NSManaged public var image: String?
    @NSManaged public var noteId: Int32

}
