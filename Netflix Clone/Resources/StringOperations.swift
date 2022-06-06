//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 6.06.2022.
//

import Foundation

extension String {
    func titleCased() -> String {
        let words = self.split(separator: " ")
        var titleCase: String = ""
        words.forEach { word in
            var strWord: String = (word + "")
            strWord = strWord.paragraphCased()
            titleCase+=strWord + " "
        }
        return titleCase.dropLast() + ""
    }
    func paragraphCased() -> String {
        self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
