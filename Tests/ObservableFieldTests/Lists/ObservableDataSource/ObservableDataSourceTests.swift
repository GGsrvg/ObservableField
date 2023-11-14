import XCTest
@testable import ObservableField

final class ObservableDataSourceTests: XCTestCase {
    typealias Section = SectionItem<String, String, String>
    
    let tableView: UITableView = UITableView(
        frame: CGRect(x: 0, y: 0, width: 100, height: 1000)
    )
    let observableDataSource = ObservableDataSource<Section>()
    var adapter: UITableViewClosureAdapter<ObservableDataSource<Section>>!
    
    override func setUp() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        adapter = UITableViewClosureAdapter(
            tableView,
            observableDataSource: observableDataSource
        ) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = row
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = row
            }
            return cell
        } titleForHeaderSectionHandler: { [weak observableDataSource] tableView, section in
            guard let observableDataSource = observableDataSource else { return nil }
            return observableDataSource[section].header
        } titleForFooterSectionHandler: { [weak observableDataSource] tableView, section in
            guard let observableDataSource = observableDataSource else { return nil }
            return observableDataSource[section].footer
        }
        tableView.dataSource = adapter
    }
    
    // base
    func testSet() {
        let section = Section(header: "Header", rows: [], footer: "Footeer")
        self.observableDataSource.set([section])
        XCTAssertEqual(self.observableDataSource.array, [section])
        XCTAssertNotEqual(self.observableDataSource.array, [section, section])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }
    
    func testReload() {
        let section = Section(header: "Header", rows: [], footer: "Footeer")
        self.observableDataSource.set([
            section
        ])
        self.observableDataSource.reload()
        XCTAssertEqual(self.observableDataSource.array, [section])
        XCTAssertNotEqual(self.observableDataSource.array, [section, section])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }
    
    // change sections
    func testAppendSection() {
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(firstSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection])
        self.observableDataSource.appendSection(secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testAppendSections() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSections([firstSection, secondSection])
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
        
    }

    // insert
    func testInsertSectionSingleAt() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, at: 0)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionSingleAfter() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, after: secondSection)
        XCTAssertEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionSingleBefore() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, before: secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionsMultiAt() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([thirdSection])
        self.observableDataSource.insertSections([firstSection, secondSection], at: 0)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionsMultiAfter() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection])
        self.observableDataSource.insertSections([secondSection, thirdSection], after: firstSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
        
    }

    func testInsertSectionsMultiBefore() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([thirdSection])
        self.observableDataSource.insertSections([firstSection, secondSection], before: thirdSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // replacing
    func testReplaceSectionAtIndex() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, thirdSection])
        self.observableDataSource.replaceSection(secondSection, at: 1)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testReplaceSectionAtElement() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, thirdSection])
        self.observableDataSource.replaceSection(secondSection, at: thirdSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // updating
    func testUpdateSection() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection])
        self.observableDataSource.updateSection(secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // removing
    func testRemoveSection() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection, thirdSection])
        self.observableDataSource.deleteSection([secondSection, thirdSection])
        XCTAssertEqual(self.observableDataSource.array, [firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testRemoveAllSections() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = Section(header: "Header", rows: [], footer: "Footer")
        let secondSection = Section(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = Section(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection, thirdSection])
        self.observableDataSource.clear()
        XCTAssertEqual(self.observableDataSource.array, [])
    }
    
    func testPerformanceLargeDiffable() throws {
        let array: [Section] = [
            Section(header: "Red", rows: ["red1", "red2", "red3", "red4", "red5"], footer: ""),
            Section(header: "Green", rows: ["green1", "green2", "green3", "green4", "green5"], footer: ""),
            Section(header: "Yellow", rows: ["yellow1", "yellow2", "yellow3", "yellow4", "yellow5"], footer: ""),
            Section(header: "Blue", rows: ["blue1", "blue2", "blue3", "blue4", "blue5"], footer: ""),
            Section(header: "Purple", rows: ["purple1", "purple2", "purple3", "purple4", "purple5"], footer: ""),
            Section(header: "White", rows: ["white1", "white2", "white3", "white4", "white5"], footer: ""),
        ]
        self.measure {
            let sortedArray = array
            self.observableDataSource.set(array)
            self.observableDataSource.setAndUpdateDiffable(sortedArray)
            XCTAssertEqual(self.observableDataSource.array, sortedArray)
        }
    }
    
    func testRow() {
        let section = Section(header: "", rows: [], footer: "")
        
        self.observableDataSource.appendSection(section)
        
        let sectionIndex = self.observableDataSource.findSectionIndex(section)!
        
        self.observableDataSource.appendRows(["2"], by: sectionIndex)
        XCTAssert(section.rows == ["2"])
        self.observableDataSource.appendRows(["4"], by: sectionIndex)
        XCTAssert(section.rows == ["2", "4"])
        self.observableDataSource.deleteRow(indexPath: IndexPath(item: 1, section: sectionIndex))
        self.observableDataSource.insertRows(["1"], by: IndexPath(item: 0, section: sectionIndex))
        XCTAssert(section.rows == ["1", "2"])
        self.observableDataSource.replaceRow("0", indexPath: IndexPath(item: 0, section: sectionIndex))
        XCTAssert(section.rows == ["0", "2"])
        self.observableDataSource.deleteRow(indexPath: IndexPath(item: 0, section: sectionIndex))
        XCTAssert(section.rows == ["2"])
    }
}
