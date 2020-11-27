import Foundation
import SotoDynamoDB

// prefectures.csv
struct Prefecture: DynamoDBModelWithTable {
    
    static let tableName: String = "prefectures"
    
    var date: String = ""
    var prefectureNameID: String = ""
    var positive: String = ""
    var peopleTested: String = ""
    var hospitalized: String = ""
    var serious: String = ""
    var discharged: String = ""
    var deaths: String = ""
    var effectiveReproductionNumber: String = ""
    
    var createdAt: Date?
    var updatedAt: Date?
    
    struct DynamoDBField {
        static let date = "date"
        static let prefectureNameID = "prefecture_name_id"
        static let positive = "positive"
        static let peopleTested = "people_tested"
        static let hospitalized = "hospitalized"
        static let serious = "serious"
        static let discharged = "discharged"
        static let deaths = "deaths"
        static let effectiveReproductionNumber = "ern"
        
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
    }
}

extension Prefecture {
    init(dic: [String: DynamoDB.AttributeValue]) throws {
        if
            let dateAtValue = dic[DynamoDBField.date],
            case let .s(date) = dateAtValue,
            !date.isEmpty
        {
            self.date = date
        }
        
        if
            let prefectureNameIDAtValue = dic[DynamoDBField.prefectureNameID],
            case let .s(prefectureNameID) = prefectureNameIDAtValue,
            !prefectureNameID.isEmpty
        {
            self.prefectureNameID = prefectureNameID
        }
        
        if
            let positiveAtValue = dic[DynamoDBField.positive],
            case let .s(positive) = positiveAtValue,
            !positive.isEmpty
        {
            
            self.positive = positive
        }
        
        if
            let peopleTestedAtValue = dic[DynamoDBField.peopleTested],
            case let .s(peopleTested) = peopleTestedAtValue,
            !peopleTested.isEmpty
        {
            self.peopleTested = peopleTested
        }
        
        if
            let hospitalizedAtValue = dic[DynamoDBField.hospitalized],
            case let .s(hospitalized) = hospitalizedAtValue,
            !hospitalized.isEmpty
        {
            self.hospitalized = hospitalized
        }
        
        if
            let seriousAtValue = dic[DynamoDBField.serious],
            case let .s(serious) = seriousAtValue,
            !serious.isEmpty
        {
            self.serious = serious
        }
        
        if
            let dischargedAtValue = dic[DynamoDBField.discharged],
            case let .s(discharged) = dischargedAtValue,
            !discharged.isEmpty
        {
            self.discharged = discharged
        }
        
        if
            let deathsAtValue = dic[DynamoDBField.deaths],
            case let .s(deaths) = deathsAtValue,
            !deaths.isEmpty
        {
            self.deaths = deaths
        }
        
        if
            let effectiveReproductionNumberAtValue = dic[DynamoDBField.effectiveReproductionNumber],
            case let .s(effectiveReproductionNumber) = effectiveReproductionNumberAtValue,
            !effectiveReproductionNumber.isEmpty
        {
            self.effectiveReproductionNumber = effectiveReproductionNumber
        }
        
        if
            let createdAtValue = dic[DynamoDBField.createdAt],
            case let .s(createdAtValueString) = createdAtValue,
            let createdAt = Utils.iso8601Formatter.date(from: createdAtValueString)
        {
            self.createdAt = createdAt
        }
        
        if
            let updatedAtValue = dic[DynamoDBField.updatedAt],
            case let .s(updatedAtValueString) = updatedAtValue,
            let updatedAt = Utils.iso8601Formatter.date(from: updatedAtValueString)
        {
            self.updatedAt = updatedAt
        }
    }
}

extension Prefecture {
    var dynamoDbDictionary: [String: DynamoDB.AttributeValue] {
        var dic: [String: DynamoDB.AttributeValue] = [:]
        
        if !date.isEmpty {
            dic[DynamoDBField.date] = .s(date)
        }
        if !prefectureNameID.isEmpty {
            dic[DynamoDBField.prefectureNameID] = .s(prefectureNameID)
        }
        if !positive.isEmpty {
            dic[DynamoDBField.positive] = .s(positive)
        }
        if !peopleTested.isEmpty {
            dic[DynamoDBField.peopleTested] = .s(peopleTested)
        }
        if !hospitalized.isEmpty {
            dic[DynamoDBField.hospitalized] = .s(hospitalized)
        }
        if !serious.isEmpty {
            dic[DynamoDBField.serious] = .s(serious)
        }
        if !discharged.isEmpty {
            dic[DynamoDBField.discharged] = .s(discharged)
        }
        if !deaths.isEmpty {
            dic[DynamoDBField.deaths] = .s(deaths)
        }
        if !effectiveReproductionNumber.isEmpty {
            dic[DynamoDBField.effectiveReproductionNumber] = .s(effectiveReproductionNumber)
        }
        
        return dic
    }
}

extension Prefecture {
    static var attributeDefinitions: [DynamoDB.AttributeDefinition] {
        [
            .init(attributeName: DynamoDBField.date, attributeType: .s),
            .init(attributeName: DynamoDBField.prefectureNameID, attributeType: .s),
        ]
    }
    
    static var keySchema: [DynamoDB.KeySchemaElement] {
        [
            .init(attributeName: DynamoDBField.date, keyType: .hash),
            .init(attributeName: DynamoDBField.prefectureNameID, keyType: .range),
        ]
    }
}