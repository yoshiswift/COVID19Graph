import Foundation
import NIO
import SotoDynamoDB
import AsyncKit

struct MPrefectureController: DynamoDBController {
    typealias Model = MPrefecture
    
    let db: DynamoDB
    
    init(db: DynamoDB) {
        self.db = db
    }
    
    func get(
        _ ym: String,
        _ prefectureName: String
    ) -> EventLoopFuture<Model> {
        get(
            .init(
                key: [
                    Model.DynamoDBField.ym: .s(ym),
                    Model.DynamoDBField.prefectureName: .s(prefectureName)
                ],
                tableName: Model.tableName
            )
        )
    }
    
    func create(
        ym: String,
        prefectureName: String,
        positive: String,
        peopleTested: String,
        hospitalized: String,
        serious: String,
        discharged: String,
        deaths: String,
        effectiveReproductionNumber: String
    ) -> EventLoopFuture<Model> {
        create(
            .init(
                ym: ym,
                prefectureName: prefectureName,
                positive: positive,
                peopleTested: peopleTested,
                hospitalized: hospitalized,
                serious: serious,
                discharged: discharged,
                deaths: deaths,
                effectiveReproductionNumber: effectiveReproductionNumber
            )
        )
    }
    
    func update(
        ym: String,
        prefectureName: String,
        positive: String,
        peopleTested: String,
        hospitalized: String,
        serious: String,
        discharged: String,
        deaths: String,
        effectiveReproductionNumber: String
    ) -> EventLoopFuture<Model> {
        let input = DynamoDB.UpdateItemInput(
            expressionAttributeNames: [
                "#positive": Model.DynamoDBField.positive,
                "#peopleTested": Model.DynamoDBField.peopleTested,
                "#hospitalized": Model.DynamoDBField.hospitalized,
                "#serious": Model.DynamoDBField.serious,
                "#discharged": Model.DynamoDBField.discharged,
                "#deaths": Model.DynamoDBField.deaths,
                "#effectiveReproductionNumber": Model.DynamoDBField.effectiveReproductionNumber,
                "#updatedAt": Model.DynamoDBField.updatedAt
            ],
            expressionAttributeValues: [
                ":positive": .s(positive),
                ":peopleTested": .s(peopleTested),
                ":hospitalized": .s(hospitalized),
                ":serious": .s(serious),
                ":discharged": .s(discharged),
                ":deaths": .s(deaths),
                ":effectiveReproductionNumber": .s(effectiveReproductionNumber),
                ":updatedAt": .s(Date().iso8601)
            ],
            key: [
                Model.DynamoDBField.ym: .s(ym),
                Model.DynamoDBField.prefectureName: .s(prefectureName)
            ],
            returnValues: .allNew,
            tableName: Model.tableName,
            updateExpression: """
                SET \
                #positive = :positive, \
                #peopleTested = :peopleTested, \
                #hospitalized = :hospitalized, \
                #serious = :serious, \
                #discharged = :discharged, \
                #deaths = :deaths, \
                #effectiveReproductionNumber = :effectiveReproductionNumber, \
                #updatedAt = :updatedAt
            """
        )
        
        return db.updateItem(input).flatMap { _ in self.get(ym, prefectureName) }
    }
    
    func delete(
        _ ym: String,
        _ prefectureName: String
    ) -> EventLoopFuture<Void> {
        db
            .deleteItem(
                .init(
                    key: [
                        Model.DynamoDBField.ym: .s(ym),
                        Model.DynamoDBField.prefectureName: .s(prefectureName)
                    ],
                    tableName: Model.tableName
                )
            )
            .map { _ in }
    }
}

// 新規 or 更新を判断してから保存
extension MPrefectureController {
    func add(
        ym: String,
        prefectureName: String,
        positive: String,
        peopleTested: String,
        hospitalized: String,
        serious: String,
        discharged: String,
        deaths: String,
        effectiveReproductionNumber: String
    ) -> EventLoopFuture<Model> {
        db
            .getItem(
                .init(
                    key: [
                        Model.DynamoDBField.ym: .s(ym),
                        Model.DynamoDBField.prefectureName: .s(prefectureName)
                    ],
                    tableName: Model.tableName
                )
            )
            .flatMap { output in
                if let _ = output.item {
                    return update(
                        ym: ym,
                        prefectureName: prefectureName,
                        positive: positive,
                        peopleTested: peopleTested,
                        hospitalized: hospitalized,
                        serious: serious,
                        discharged: discharged,
                        deaths: deaths,
                        effectiveReproductionNumber: effectiveReproductionNumber
                    )
                } else {
                    return create(
                        ym: ym,
                        prefectureName: prefectureName,
                        positive: positive,
                        peopleTested: peopleTested,
                        hospitalized: hospitalized,
                        serious: serious,
                        discharged: discharged,
                        deaths: deaths,
                        effectiveReproductionNumber: effectiveReproductionNumber
                    )
                }
            }
    }
}
