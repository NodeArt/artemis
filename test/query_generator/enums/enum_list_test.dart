import 'package:artemis/generator/data.dart';
import 'package:artemis/schema/graphql.dart';
import 'package:test/test.dart';

import '../../helpers.dart';

void main() {
  group('On enum list', () {
    test(
      'Enums as lists are generated correctly',
      () async => testGenerator(
        query: query,
        libraryDefinition: libraryDefinition,
        generatedFile: generatedFile,
        typedSchema: schema,
      ),
    );
  });
}

const query = r'''
query custom {
  q {
    le
  }
}
''';

final schema = GraphQLSchema(
    queryType: GraphQLType(name: 'QueryRoot', kind: GraphQLTypeKind.OBJECT),
    types: [
      GraphQLType(name: 'MyEnum', kind: GraphQLTypeKind.ENUM, enumValues: [
        GraphQLEnumValue(name: 'A'),
        GraphQLEnumValue(name: 'B'),
      ]),
      GraphQLType(
        name: 'QueryResponse',
        kind: GraphQLTypeKind.OBJECT,
        fields: [
          GraphQLField(
              name: 'le',
              type: GraphQLType(
                  kind: GraphQLTypeKind.LIST,
                  ofType:
                      GraphQLType(name: 'MyEnum', kind: GraphQLTypeKind.ENUM))),
        ],
      ),
      GraphQLType(
        name: 'QueryRoot',
        kind: GraphQLTypeKind.OBJECT,
        fields: [
          GraphQLField(
              name: 'q',
              type: GraphQLType(
                  name: 'QueryResponse', kind: GraphQLTypeKind.OBJECT)),
        ],
      ),
    ]);

final libraryDefinition = LibraryDefinition(basename: r'query', queries: [
  QueryDefinition(
      queryName: r'custom',
      queryType: r'Custom$QueryRoot',
      classes: [
        EnumDefinition(
            name: r'Custom$QueryRoot$QueryResponse$MyEnum',
            values: [r'A', r'B', r'ARTEMIS_UNKNOWN']),
        ClassDefinition(
            name: r'Custom$QueryRoot$QueryResponse',
            properties: [
              ClassProperty(
                  type: r'List<Custom$QueryRoot$QueryResponse$MyEnum>',
                  name: r'le',
                  isOverride: false,
                  isNonNull: false,
                  isResolveType: false)
            ],
            factoryPossibilities: {},
            typeNameField: r'__typename',
            isInput: false),
        ClassDefinition(
            name: r'Custom$QueryRoot',
            properties: [
              ClassProperty(
                  type: r'Custom$QueryRoot$QueryResponse',
                  name: r'q',
                  isOverride: false,
                  isNonNull: false,
                  isResolveType: false)
            ],
            factoryPossibilities: {},
            typeNameField: r'__typename',
            isInput: false)
      ],
      generateHelpers: false,
      suffix: r'Query')
]);

const generatedFile = r'''// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import 'package:meta/meta.dart';
part 'query.g.dart';

@JsonSerializable(explicitToJson: true)
class Custom$QueryRoot$QueryResponse with EquatableMixin {
  Custom$QueryRoot$QueryResponse();

  factory Custom$QueryRoot$QueryResponse.fromJson(Map<String, dynamic> json) =>
      _$Custom$QueryRoot$QueryResponseFromJson(json);

  List<Custom$QueryRoot$QueryResponse$MyEnum> le;

  @override
  List<Object> get props => [le];
  Map<String, dynamic> toJson() => _$Custom$QueryRoot$QueryResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Custom$QueryRoot with EquatableMixin {
  Custom$QueryRoot();

  factory Custom$QueryRoot.fromJson(Map<String, dynamic> json) =>
      _$Custom$QueryRootFromJson(json);

  Custom$QueryRoot$QueryResponse q;

  @override
  List<Object> get props => [q];
  Map<String, dynamic> toJson() => _$Custom$QueryRootToJson(this);
}

enum Custom$QueryRoot$QueryResponse$MyEnum {
  A,
  B,
  ARTEMIS_UNKNOWN,
}
''';
