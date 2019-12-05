//
//  CTA_ProjectTests.swift
//  CTA-ProjectTests
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import XCTest
@testable import CTA_Project

class CTA_ProjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testTicketMasterWrapper() {
        let testTicket = TicketMasterWrapper(embedded: EventWrapper(events: [Event(name: "Disney On Ice presents Dream Big",id: "vv17jZ4wGklI9kkp", url: "https://www.ticketmaster.com/disney-on-ice-presents-dream-big-madison-wisconsin-02-08-2020/event/0700572AE85C6196", images: [ImageWrapper(url: "https://s1.ticketm.net/dam/a/776/8ba9015f-0e79-40af-8dcc-706069edb776_1044651_ARTIST_PAGE_3_2.jpg")], dates: DatesWrapper(start: Start(dateTime: "2020-02-08T17:00:00Z", localDate: "2020-02-08", localTime: "11:00:00")), priceRanges: [PriceRange(type: .standard, currency: .usd, min: 15.0, max: 75.0)])]), page: Page(totalPages: 1))
        
        XCTAssertTrue(testTicket.embedded.events[0].name == "Disney On Ice presents Dream Big")
        XCTAssertTrue(testTicket.embedded.events[0].id == "vv17jZ4wGklI9kkp")
        XCTAssertTrue(testTicket.embedded.events[0].url == "https://www.ticketmaster.com/disney-on-ice-presents-dream-big-madison-wisconsin-02-08-2020/event/0700572AE85C6196")
        XCTAssertTrue(testTicket.embedded.events[0].images[0].url == "https://s1.ticketm.net/dam/a/776/8ba9015f-0e79-40af-8dcc-706069edb776_1044651_ARTIST_PAGE_3_2.jpg")
        XCTAssertTrue(testTicket.embedded.events[0].dates.start.dateTime == "2020-02-08T17:00:00Z")
        XCTAssertTrue(testTicket.embedded.events[0].dates.start.localDate == "2020-02-08")
        XCTAssertTrue(testTicket.embedded.events[0].dates.start.localTime == "11:00:00")
        XCTAssertNotNil(testTicket.embedded.events[0].priceRanges)
        XCTAssertTrue(testTicket.page.totalPages == 1)
    }
    func testDateFormatterOnEvent() {
        let testTicket = TicketMasterWrapper(embedded: EventWrapper(events: [Event(name: "Disney On Ice presents Dream Big",id: "vv17jZ4wGklI9kkp", url: "https://www.ticketmaster.com/disney-on-ice-presents-dream-big-madison-wisconsin-02-08-2020/event/0700572AE85C6196", images: [ImageWrapper(url: "https://s1.ticketm.net/dam/a/776/8ba9015f-0e79-40af-8dcc-706069edb776_1044651_ARTIST_PAGE_3_2.jpg")], dates: DatesWrapper(start: Start(dateTime: "2020-02-08T17:00:00Z", localDate: "2020-02-08", localTime: "11:00:00")), priceRanges: [PriceRange(type: .standard, currency: .usd, min: 15.0, max: 75.0)])]), page: Page(totalPages: 1))
        
        let testFormattedDate = testTicket.embedded.events[0].getFormattedDate()
        XCTAssertTrue(testFormattedDate == "02-08-2020 12:00")
    }

}
