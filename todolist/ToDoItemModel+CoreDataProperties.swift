//
//  ToDoItemModel+CoreDataProperties.swift
//  todolist
//
//  Created by Виктория Козырева on 25.03.2021.
//
//

import Foundation
import CoreData


extension ToDoItemModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemModel> {
        return NSFetchRequest<ToDoItemModel>(entityName: "ToDoItemModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompletion: Bool

}

extension ToDoItemModel : Identifiable {

}
