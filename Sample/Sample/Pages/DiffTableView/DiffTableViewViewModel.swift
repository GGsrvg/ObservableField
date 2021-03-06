//
//  DiffTableViewViewModel.swift
//  Sample
//
//  Created by Viktor on 16.06.2022.
//

import Foundation
import ObservableField

class DiffTableViewViewModel {
    
    private let originalArray = [
        "qZkhUYRnpl1VhV0x",
        "uuSWt4lgjou4gBJi",
        "TuOgY5f75MZV979I",
        "6Wb2dbnRcUvjh1i7",
        "FdZPKEjAHDUD4cPI",
        "TzZG60hhjspsSuFu",
        "vcpxAn5IfYcVSCRa",
        "Vuymd8XrpIFxd04Y",
        "3vDgxMEZsH8sSkeR",
        "XKF0jXu4iSigaYiS",
        "cMCpfyfnW6hvq1VL",
        "XRt1qlB400yiIBRX",
        "RW1mWSzl9RGUtDL6",
        "8ektigE49W5uJfBP",
        "GXkgx0VUxUFdDywn",
        "KEAdkbiRqHqcWXIS",
        "eqlDCq40wyEThfTb",
        "FDPJhobOJnTJxZqF",
        "ctglVXQlWefv8xum",
        "5qVqAzdZ8qqj6Y0P",
        "GJjpAOkeagHObhmU",
        "SbgZ8qwRYa0kE0Y6",
        "3vwebQGKUMHGzszc",
        "bEBK1H6sWLYKXV2F",
        "S0Ujp9ELnq6yNLnC",
        "0I31SgBxBxmFjs89",
        "G8stR9zunLhnkvIT",
        "DdocevK4vvNdyx5u",
        "WzGdXXVsiaqseZMY",
        "sE499wKFITKUE6Km",
        "7dc68UdXvDQFHq7Y",
        "yZ2N2Te73wEfxJIR",
        "ZQ6vgYWP2FgwISmx",
        "BXZW1mkNxMVLdy0P",
        "H11zTUzHBtuLHwBe",
        "8jTkbbMWlLVXzOh7",
        "QFUN0Wgd4JxXYxsZ",
        "2UkTfFVRZLp3S7Tn",
        "SXivfZUdFhWvegNX",
        "SmGhLaphMTd3p8oa",
        "BBCTbZJmMS9puR8Y",
        "abU0FghnGN7SFcEx",
        "nODbCTwINsaWPQHZ",
        "PcaDOT7cEYEwfDih",
        "zm66KBqGLyQBwtqk",
        "HDPxtwLkbDu2TcR0",
        "mMq9MZlDguj4d1Bj",
        "eqUko3A8VZvOYH3R",
        "xFm0GHIad7IdskDF",
        "1lWzsjTdDRfOwebt",
        "hprWdVn8vngECrRO",
        "RTWMlTJDzlqiTinA",
        "0uNp9XWhIV6Qevje",
        "hLz3998gMAeMFFbp",
        "50qRxSjy0ctFThx4",
        "pcWt3fxbQkf8IVhE",
        "bcpk8NQ36hckpndi",
        "UNVtXykc0mIOS5mH",
        "7nMIOohdl28rsXJo",
        "kWJ9ajsbxiuxTqq0",
        "2empzt9OUuRo0UDW",
        "UrbAEC8EgnARZjdz",
        "B13wmOC3mtVoWtR9",
        "dzq3xfhMk9WCSdEU",
        "zTZaEjuZUC8RSI6p",
        "Tn87pJzMCbSCLRXm",
        "01V2OBtPQbXzCOo2",
        "on6vdyM6TedQnBOb",
        "7TLfKm5WOJJtYYwr",
        "xSY2xfNjUtG89tB5",
        "KOAcBUWNed3C8H7b",
        "LmQ0JgGcEeE54dm9",
        "qGc6XrBfYsWHBOHv",
        "iZId5m2tAJKHc3X8",
        "SPYLXrZy5C2lIODX",
        "QCejRcSPt2lghX7F",
        "iVUOvt32zhM9WlUx",
        "nNS2nsRiK6Lewwdx",
        "N89tBvjK5oY7kzLY",
        "LLZeD8R3vHmffhpH",
        "yAZFkNDZ5O21Ma7O",
        "yadaLSDpToJ5xwQm",
        "TOUx8lLGkWfsa1m9",
        "vcaIVmngoiREUnXE",
        "oM6tVTPWJl9ZDeRu",
        "cQMHv5HmbM2yMy4g",
        "UWii8GQwZg8qaSGN",
        "xSTuMhSOzaMTVuBI",
        "EXHKg1wcQrR7GfsK",
        "0ttLy4ctmrcAMFDD",
        "inDpm6pNxS1uVovQ",
        "ky2LVoq6VvfAAWxa",
        "IpqKWuzACJfzn4Zw",
        "7T4IouhujUtl9Coc",
        "6nqbErqM5LpKJZtT",
        "YmnU9Wv7FM8YuV1j",
        "Rt3nUk0kbFufEcF9",
        "WC4imBwwzbgaP0gC",
        "WLonxsJuD2N2Pngk",
        "OYANzurKCcIO9VD1",
    ]
    private let newArray = [
        "Eei6TWPvss96Mhcj",
        "cU6KNXxclBfYqViP",
        "jDpL625oyFJkHHXZ",
        "BBh9ysNoZJFArHgh",
        "wzbvKHFFWsDjAMcq",
        "cyEr4GwDPT8F9xaX",
        "GnwX9Y06QdprbgFZ",
        "3FEUOYj5Tyr5d9W9",
        "HBbrvX6Rq7kAM4E9",
        "a9c4ZuchckVQxGrn",
        "SmGhLaphMTd3p8oa",
        "BBCTbZJmMS9puR8Y",
        "abU0FghnGN7SFcEx",
        "6WVPqgn7R24vwOSj",
        "Tvq3P30qTsgWhAg6",
        "KOZuNVhIv25Ql2EI",
        "angkFsrW9msNZPWz",
        "78Lw5rELNuu70AeK",
        "gJUiVk7qDnXXo3c6",
        "MqTqs62RMXWW4iTA",
        "EC7pLhlmqaIuhp9V",
        "HIWkOAdTWavmHZUs",
        "3DXMXMSfl7QBu2PA",
        "9BIka0t1QO4WO60Y",
        "pqObBYjOr2WBT2ve",
        "kqlfmFtXroszZzcM",
        "WjS6rfKMGixrdXde",
        "x2KU8SPPdCZmTaXG",
        "KEAdkbiRqHqcWXIS",
        "eqlDCq40wyEThfTb",
        "FDPJhobOJnTJxZqF",
        "ctglVXQlWefv8xum",
        "HDVFC7WPoFUHmNLO",
        "0VBfrdEK5cmPq4yO",
        "qWSu2mlF5EOIRDnn",
        "Mr8oK1rISFc4yG8E",
        "RQGjhE2unrdddh6J",
        "Z3qeAst3SH1g2dez",
        "PFLxNt36LkeXw9iw",
        "uDItkv2N2StQ0z88",
        "whLZS2oIRlNFie3H",
        "zJf9677h4HptGvNn",
        "7ilerCg7vNVcZDhe",
        "Zi7U2pGH5Cae9GaK",
        "a3TerM1UZ9ViXW3H",
        "SXJUiNs8TZzgAHSg",
        "FbashZiML2BrEMCi",
        "XSyBvGZoQIhzVf8o",
        "bTFdpcp8aF5vUgS1",
        "wrkEPQBz0GEm2hkj",
        "F2e7ZpcSggGQxqZc",
        "xU10cMNRHmUkwW4V",
        "zN3vpJy66jqtlCIT",
        "2FDXDB4OUVjBCHiS",
        "XJd4PxlEsf75jw5u",
        "XttzR3MdLGrUAyV4",
        "CBoh6weKdjX4CtzF",
        "JXRm6XssMAidJiTs",
        "OrIz1Lq0TNNUwbqH",
        "7b885kuJV17WA7g7",
        "tT294TkLidd28mdD",
        "EfaMAik9KAA11tTt",
        "vv1FyHgG8VCFHbrD",
        "TOlGUrt5HT4yLLCG",
        "gcQuzB8ikMmnGU48",
        "fQyn9yC4hbSMlDp8",
        "TIKj0hhnLLLtcIIY",
        "ayveX2wiQXTIKZh7",
        "rQjtVZu1GFXEoDrn",
        "FQmiqu9Gwt4G1hvV",
        "hfscgGTu2yfdPc4x",
        "2UlHQSsyvhT0GzGD",
        "od5xKXayKPQOYwh6",
        "NtG5U8H1rrtbRWwy",
        "RX2mOJdvVZD1a6sZ",
        "Wr4d0R1XSdm7509o",
        "xX7gNUGOv0wJr7ep",
        "QxqTnbYxQNaSiZQa",
        "esrOa7RI5jAMYugj",
        "Hh0ogtp3IIXnHfOY",
        "CiLav6puQJaqJwks",
        "XW7sAOMrxraUzWKw",
        "xbeXVD0VrHO9pnQF",
        "EatEyMu63phDObhX",
        "9g5UzzBjaoLtE43J",
        "za7W2ze2JkVO29fo",
        "AL32xmWWgD2V6Ci0",
        "EIHz7YLCKnw6qNdK",
        "z7noK2rZGmYt7VRj",
        "Am1EwzI2KnW7TBqi",
        "ZkMR6nMaeySEoKGO",
        "ubvCHyKA7N00iYHc",
        "Bwb81nzOJviY0OHD",
        "yMEgOFRzdti5BuxQ",
        "UpyyCNuXyxEygN3F",
        "9i5pSrjDYae3CDXv",
        "jHvV8x71lxmnlFts",
        "8RUYbnR3H3n7ujRZ",
        "PqTs80SeiOShRso6",
        "EmAJPqi6cK0sn5Vo",
    ]
    
    let observableArray = ObservableArray<String>()
    
    init() {
        observableArray.set(originalArray)
        self.observableArray.differ = DefaultDifferArray()
    }
    
    func setNew() {
        let startTime = CFAbsoluteTimeGetCurrent()
        self.observableArray.setAndUpdateDiffable(newArray)
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(timeElapsed) s.")
    }
}
