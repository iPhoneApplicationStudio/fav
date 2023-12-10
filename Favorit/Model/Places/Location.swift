/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Location : Codable {
	let address : String?
	let census_block : String?
	let country : String?
	let cross_street : String?
	let dma : String?
	let formatted_address : String?
	let locality : String?
	let postcode : String?
	let region : String?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case census_block = "census_block"
		case country = "country"
		case cross_street = "cross_street"
		case dma = "dma"
		case formatted_address = "formatted_address"
		case locality = "locality"
		case postcode = "postcode"
		case region = "region"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		census_block = try values.decodeIfPresent(String.self, forKey: .census_block)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		cross_street = try values.decodeIfPresent(String.self, forKey: .cross_street)
		dma = try values.decodeIfPresent(String.self, forKey: .dma)
		formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
		locality = try values.decodeIfPresent(String.self, forKey: .locality)
		postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
		region = try values.decodeIfPresent(String.self, forKey: .region)
	}

}