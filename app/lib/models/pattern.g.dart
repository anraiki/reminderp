// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pattern.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPatternCollection on Isar {
  IsarCollection<Pattern> get patterns => this.collection();
}

const PatternSchema = CollectionSchema(
  name: r'Pattern',
  id: 1058594736622376551,
  properties: {
    r'convexId': PropertySchema(
      id: 0,
      name: r'convexId',
      type: IsarType.string,
    ),
    r'isLocal': PropertySchema(
      id: 1,
      name: r'isLocal',
      type: IsarType.bool,
    ),
    r'moments': PropertySchema(
      id: 2,
      name: r'moments',
      type: IsarType.objectList,
      target: r'Moment',
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _patternEstimateSize,
  serialize: _patternSerialize,
  deserialize: _patternDeserialize,
  deserializeProp: _patternDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Moment': MomentSchema, r'Voice': VoiceSchema},
  getId: _patternGetId,
  getLinks: _patternGetLinks,
  attach: _patternAttach,
  version: '3.1.0+1',
);

int _patternEstimateSize(
  Pattern object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.convexId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.moments.length * 3;
  {
    final offsets = allOffsets[Moment]!;
    for (var i = 0; i < object.moments.length; i++) {
      final value = object.moments[i];
      bytesCount += MomentSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _patternSerialize(
  Pattern object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.convexId);
  writer.writeBool(offsets[1], object.isLocal);
  writer.writeObjectList<Moment>(
    offsets[2],
    allOffsets,
    MomentSchema.serialize,
    object.moments,
  );
  writer.writeString(offsets[3], object.name);
}

Pattern _patternDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Pattern();
  object.convexId = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.isLocal = reader.readBool(offsets[1]);
  object.moments = reader.readObjectList<Moment>(
        offsets[2],
        MomentSchema.deserialize,
        allOffsets,
        Moment(),
      ) ??
      [];
  object.name = reader.readString(offsets[3]);
  return object;
}

P _patternDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readObjectList<Moment>(
            offset,
            MomentSchema.deserialize,
            allOffsets,
            Moment(),
          ) ??
          []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _patternGetId(Pattern object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _patternGetLinks(Pattern object) {
  return [];
}

void _patternAttach(IsarCollection<dynamic> col, Id id, Pattern object) {
  object.id = id;
}

extension PatternQueryWhereSort on QueryBuilder<Pattern, Pattern, QWhere> {
  QueryBuilder<Pattern, Pattern, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PatternQueryWhere on QueryBuilder<Pattern, Pattern, QWhereClause> {
  QueryBuilder<Pattern, Pattern, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PatternQueryFilter
    on QueryBuilder<Pattern, Pattern, QFilterCondition> {
  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'convexId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'convexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'convexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> convexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> isLocalEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition>
      momentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension PatternQueryObject
    on QueryBuilder<Pattern, Pattern, QFilterCondition> {
  QueryBuilder<Pattern, Pattern, QAfterFilterCondition> momentsElement(
      FilterQuery<Moment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'moments');
    });
  }
}

extension PatternQueryLinks
    on QueryBuilder<Pattern, Pattern, QFilterCondition> {}

extension PatternQuerySortBy on QueryBuilder<Pattern, Pattern, QSortBy> {
  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PatternQuerySortThenBy
    on QueryBuilder<Pattern, Pattern, QSortThenBy> {
  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Pattern, Pattern, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PatternQueryWhereDistinct
    on QueryBuilder<Pattern, Pattern, QDistinct> {
  QueryBuilder<Pattern, Pattern, QDistinct> distinctByConvexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'convexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pattern, Pattern, QDistinct> distinctByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLocal');
    });
  }

  QueryBuilder<Pattern, Pattern, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension PatternQueryProperty
    on QueryBuilder<Pattern, Pattern, QQueryProperty> {
  QueryBuilder<Pattern, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Pattern, String?, QQueryOperations> convexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'convexId');
    });
  }

  QueryBuilder<Pattern, bool, QQueryOperations> isLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLocal');
    });
  }

  QueryBuilder<Pattern, List<Moment>, QQueryOperations> momentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moments');
    });
  }

  QueryBuilder<Pattern, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const VoiceSchema = Schema(
  name: r'Voice',
  id: -3781534410797180448,
  properties: {
    r'duration': PropertySchema(
      id: 0,
      name: r'duration',
      type: IsarType.double,
    ),
    r'escalationEvery': PropertySchema(
      id: 1,
      name: r'escalationEvery',
      type: IsarType.double,
    ),
    r'escalationMax': PropertySchema(
      id: 2,
      name: r'escalationMax',
      type: IsarType.double,
    ),
    r'escalationStep': PropertySchema(
      id: 3,
      name: r'escalationStep',
      type: IsarType.double,
    ),
    r'gap': PropertySchema(
      id: 4,
      name: r'gap',
      type: IsarType.double,
    ),
    r'intensity': PropertySchema(
      id: 5,
      name: r'intensity',
      type: IsarType.double,
    ),
    r'pattern': PropertySchema(
      id: 6,
      name: r'pattern',
      type: IsarType.string,
    ),
    r'repeat': PropertySchema(
      id: 7,
      name: r'repeat',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 8,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _voiceEstimateSize,
  serialize: _voiceSerialize,
  deserialize: _voiceDeserialize,
  deserializeProp: _voiceDeserializeProp,
);

int _voiceEstimateSize(
  Voice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.pattern;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _voiceSerialize(
  Voice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.duration);
  writer.writeDouble(offsets[1], object.escalationEvery);
  writer.writeDouble(offsets[2], object.escalationMax);
  writer.writeDouble(offsets[3], object.escalationStep);
  writer.writeDouble(offsets[4], object.gap);
  writer.writeDouble(offsets[5], object.intensity);
  writer.writeString(offsets[6], object.pattern);
  writer.writeLong(offsets[7], object.repeat);
  writer.writeString(offsets[8], object.type);
}

Voice _voiceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Voice();
  object.duration = reader.readDoubleOrNull(offsets[0]);
  object.escalationEvery = reader.readDoubleOrNull(offsets[1]);
  object.escalationMax = reader.readDoubleOrNull(offsets[2]);
  object.escalationStep = reader.readDoubleOrNull(offsets[3]);
  object.gap = reader.readDoubleOrNull(offsets[4]);
  object.intensity = reader.readDoubleOrNull(offsets[5]);
  object.pattern = reader.readStringOrNull(offsets[6]);
  object.repeat = reader.readLongOrNull(offsets[7]);
  object.type = reader.readString(offsets[8]);
  return object;
}

P _voiceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension VoiceQueryFilter on QueryBuilder<Voice, Voice, QFilterCondition> {
  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> durationBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'escalationEvery',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'escalationEvery',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'escalationEvery',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'escalationEvery',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'escalationEvery',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationEveryBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'escalationEvery',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'escalationMax',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'escalationMax',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'escalationMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'escalationMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'escalationMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationMaxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'escalationMax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'escalationStep',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'escalationStep',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'escalationStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'escalationStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'escalationStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> escalationStepBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'escalationStep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gap',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gap',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> gapBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gap',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intensity',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intensity',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> intensityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pattern',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pattern',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pattern',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pattern',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pattern',
        value: '',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> patternIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pattern',
        value: '',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeat',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeat',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> repeatBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Voice, Voice, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension VoiceQueryObject on QueryBuilder<Voice, Voice, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MomentSchema = Schema(
  name: r'Moment',
  id: -312284474520441917,
  properties: {
    r'offset': PropertySchema(
      id: 0,
      name: r'offset',
      type: IsarType.long,
    ),
    r'voices': PropertySchema(
      id: 1,
      name: r'voices',
      type: IsarType.objectList,
      target: r'Voice',
    )
  },
  estimateSize: _momentEstimateSize,
  serialize: _momentSerialize,
  deserialize: _momentDeserialize,
  deserializeProp: _momentDeserializeProp,
);

int _momentEstimateSize(
  Moment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.voices.length * 3;
  {
    final offsets = allOffsets[Voice]!;
    for (var i = 0; i < object.voices.length; i++) {
      final value = object.voices[i];
      bytesCount += VoiceSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _momentSerialize(
  Moment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.offset);
  writer.writeObjectList<Voice>(
    offsets[1],
    allOffsets,
    VoiceSchema.serialize,
    object.voices,
  );
}

Moment _momentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Moment();
  object.offset = reader.readLong(offsets[0]);
  object.voices = reader.readObjectList<Voice>(
        offsets[1],
        VoiceSchema.deserialize,
        allOffsets,
        Voice(),
      ) ??
      [];
  return object;
}

P _momentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readObjectList<Voice>(
            offset,
            VoiceSchema.deserialize,
            allOffsets,
            Voice(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MomentQueryFilter on QueryBuilder<Moment, Moment, QFilterCondition> {
  QueryBuilder<Moment, Moment, QAfterFilterCondition> offsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offset',
        value: value,
      ));
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> offsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offset',
        value: value,
      ));
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> offsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offset',
        value: value,
      ));
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> offsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MomentQueryObject on QueryBuilder<Moment, Moment, QFilterCondition> {
  QueryBuilder<Moment, Moment, QAfterFilterCondition> voicesElement(
      FilterQuery<Voice> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'voices');
    });
  }
}
