import XCTest
@testable import ObservableField

final class ObservableDataSourceTests: XCTestCase {
    let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
    let observableDataSource = ObservableDataSource<SectionItem<String, String, String>>()
    var adapter: UITableViewClosureAdapter<ObservableDataSource<SectionItem<String, String, String>>>!
    
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

    }
    
    // base
    func testSet() {
        let section = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footeer")
        self.observableDataSource.set([
            section
        ])
        XCTAssertEqual(self.observableDataSource.array, [section])
        XCTAssertNotEqual(self.observableDataSource.array, [section, section])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }
    
    func testReload() {
        let section = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footeer")
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
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(firstSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection])
        self.observableDataSource.appendSection(secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testAppendSections() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSections([firstSection, secondSection])
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
        
    }

    // insert
    func testInsertSectionSingleAt() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, at: 0)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionSingleAfter() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, after: secondSection)
        XCTAssertEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionSingleBefore() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.appendSection(secondSection)
        self.observableDataSource.insertSection(firstSection, before: secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionsMultiAt() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([thirdSection])
        self.observableDataSource.insertSections([firstSection, secondSection], at: 0)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testInsertSectionsMultiAfter() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection])
        self.observableDataSource.insertSections([secondSection, thirdSection], after: firstSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
        
    }

    func testInsertSectionsMultiBefore() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([thirdSection])
        self.observableDataSource.insertSections([firstSection, secondSection], before: thirdSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // replacing
    func testReplaceSectionAtIndex() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, thirdSection])
        self.observableDataSource.replaceSection(secondSection, at: 1)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testReplaceSectionAtElement() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, thirdSection])
        self.observableDataSource.replaceSection(secondSection, at: thirdSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // updating
    func testUpdateSection() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection])
        self.observableDataSource.updateSection(secondSection)
        XCTAssertEqual(self.observableDataSource.array, [firstSection, secondSection])
        XCTAssertNotEqual(self.observableDataSource.array, [secondSection, firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    // removing
    func testRemoveSection() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection, thirdSection])
        self.observableDataSource.removeSection([secondSection, thirdSection])
        XCTAssertEqual(self.observableDataSource.array, [firstSection])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
        XCTAssertNotEqual(self.observableDataSource.array, [])
    }

    func testRemoveAllSections() {
        XCTAssertEqual(self.observableDataSource.array, [])
        let firstSection = SectionItem<String, String, String>(header: "Header", rows: [], footer: "Footer")
        let secondSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2"], footer: "Footer")
        let thirdSection = SectionItem<String, String, String>(header: "Header", rows: ["test1", "test2", "test3"], footer: "Footer")
        self.observableDataSource.set([firstSection, secondSection, thirdSection])
        self.observableDataSource.clear()
        XCTAssertEqual(self.observableDataSource.array, [])
        XCTAssertNotEqual(self.observableDataSource.array, [firstSection, secondSection, thirdSection])
    }
}
