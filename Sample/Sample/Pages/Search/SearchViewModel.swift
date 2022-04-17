//
//  SearchViewModel.swift
//  Sample
//
//  Created by Viktor on 17.04.2022.
//

import Foundation
import ObservableField

class SearchViewModel {
    private var names: [String] = [
        "Myah Fry",
        "Wilson Fritz",
        "Kellen Blair",
        "Neil Guzman",
        "Joe Carr",
        "Keyon Valencia",
        "Roman Jordan",
        "Douglas Prince",
        "Anika Wells",
        "Lauryn Montes",
        "Dante Rogers",
        "Kaiya Roman",
        "Alonso Dodson",
        "Jonas Wood",
        "Kaelyn Jordan",
        "Mylee Huff",
        "Jermaine Haney",
        "Walter Webster",
        "Aditya Ali",
        "America Hansen",
        "Axel Travis",
        "Mireya Mack",
        "Anabella Rush",
        "Miguel Patterson",
        "Lennon Gilbert",
        "Malia Hutchinson",
        "Curtis Hinton",
        "Heaven Mathews",
        "Morgan Potts",
        "Christopher Rowe",
        "Mylie Fields",
        "Melanie Barker",
        "Kelsey Stafford",
        "Cason Duarte",
        "Tyshawn Hammond",
        "Connor Lucas",
        "Kenzie Hoffman",
        "Nathen Franco",
        "Axel Davies",
        "Liberty Morton",
        "Lilliana Ayers",
        "Tyree Cherry",
        "Kamora Frye",
        "Kaylynn Gilmore",
        "Franco Rogers",
        "Mary Flowers",
        "Matias Ayala",
        "Emilie Salinas",
        "Kamron Oneill",
        "Sebastian Dominguez",
        "Terrence Richards",
        "Lyric Hernandez",
        "Conor Bray",
        "Isabella Chambers",
        "Korbin Mays",
        "Izayah Washington",
        "Peyton Rocha",
        "Elaine Parks",
        "Raquel Stark",
        "Joselyn Shaw",
        "Erin Foley",
        "Maribel Lee",
        "Leonard James",
        "Kaitlin Peterson",
        "Vaughn Riley",
        "Itzel Sandoval",
        "Anastasia Moran",
        "Brett Ware",
        "Trent Rhodes",
        "Trent Roman",
        "Clay Raymond",
        "Serenity Lamb",
        "Amelia Gutierrez",
        "Jamya Tanner",
        "Alvaro Harrison",
        "Luz Potter",
        "Israel Shepard",
        "Nyla Case",
        "Stacy Cowan",
        "Giovanna Blackburn",
        "Gaige House",
        "Lindsey Kelly",
        "Fatima Hawkins",
        "Kaylah Hickman",
        "Jean Black",
        "Miracle Cook",
        "Gemma Riggs",
        "Adyson Carr",
        "Braelyn Diaz",
        "Alexis Arias",
        "William Townsend",
        "Edwin Stanton",
        "Jasmin Caldwell",
        "Cody Skinner",
        "Alvaro Moss",
        "Evan Richmond",
        "Yadiel Boyle",
        "Karlee Odom",
        "Karma Mckenzie",
        "Randall Adams",
    ]

    let observableSearch = ObservableField<String?>(nil)
    let observableArray = ObservableArray<String>()
    
    init() {
        self.observableArray.set(names)
        self.observableSearch.subscibe { name in
            self.filter(by: name)
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    private func filter(by name: String?) {
        let filteredNames: [String]
        
        if let name = name, !name.isEmpty {
            let lowercasedName = name.lowercased()
            filteredNames = names.filter { $0.lowercased().contains(lowercasedName) }
        } else {
            filteredNames = names
        }
        
        self.observableArray.set(filteredNames)
    }
}
