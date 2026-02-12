// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTriggerCollection on Isar {
  IsarCollection<Trigger> get triggers => this.collection();
}

const TriggerSchema = CollectionSchema(
  name: r'Trigger',
  id: 3731394540989434652,
  properties: {
    r'at': PropertySchema(
      id: 0,
      name: r'at',
      type: IsarType.dateTime,
    ),
    r'convexId': PropertySchema(
      id: 1,
      name: r'convexId',
      type: IsarType.string,
    ),
    r'every': PropertySchema(
      id: 2,
      name: r'every',
      type: IsarType.string,
    ),
    r'patternId': PropertySchema(
      id: 3,
      name: r'patternId',
      type: IsarType.long,
    ),
    r'times': PropertySchema(
      id: 4,
      name: r'times',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _triggerEstimateSize,
  serialize: _triggerSerialize,
  deserialize: _triggerDeserialize,
  deserializeProp: _triggerDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _triggerGetId,
  getLinks: _triggerGetLinks,
  attach: _triggerAttach,
  version: '3.1.0+1',
);

int _triggerEstimateSize(
  Trigger object,
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
  {
    final value = object.every;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _triggerSerialize(
  Trigger object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.at);
  writer.writeString(offsets[1], object.convexId);
  writer.writeString(offsets[2], object.every);
  writer.writeLong(offsets[3], object.patternId);
  writer.writeLong(offsets[4], object.times);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

Trigger _triggerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Trigger();
  object.at = reader.readDateTime(offsets[0]);
  object.convexId = reader.readStringOrNull(offsets[1]);
  object.every = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.patternId = reader.readLongOrNull(offsets[3]);
  object.times = reader.readLongOrNull(offsets[4]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _triggerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _triggerGetId(Trigger object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _triggerGetLinks(Trigger object) {
  return [];
}

void _triggerAttach(IsarCollection<dynamic> col, Id id, Trigger object) {
  object.id = id;
}

extension TriggerQueryWhereSort on QueryBuilder<Trigger, Trigger, QWhere> {
  QueryBuilder<Trigger, Trigger, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TriggerQueryWhere on QueryBuilder<Trigger, Trigger, QWhereClause> {
  QueryBuilder<Trigger, Trigger, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Trigger, Trigger, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterWhereClause> idBetween(
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
}

extension TriggerQueryFilter
    on QueryBuilder<Trigger, Trigger, QFilterCondition> {
  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> atEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> atGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> atLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> atBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdEqualTo(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdGreaterThan(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdLessThan(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdBetween(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdStartsWith(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdEndsWith(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdContains(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdMatches(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> convexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'every',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'every',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'every',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'every',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'every',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'every',
        value: '',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> everyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'every',
        value: '',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'patternId',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'patternId',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'patternId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'patternId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> patternIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'patternId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'times',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'times',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'times',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'times',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'times',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> timesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'times',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TriggerQueryObject
    on QueryBuilder<Trigger, Trigger, QFilterCondition> {}

extension TriggerQueryLinks
    on QueryBuilder<Trigger, Trigger, QFilterCondition> {}

extension TriggerQuerySortBy on QueryBuilder<Trigger, Trigger, QSortBy> {
  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByEvery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'every', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByEveryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'every', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'times', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByTimesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'times', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TriggerQuerySortThenBy
    on QueryBuilder<Trigger, Trigger, QSortThenBy> {
  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByEvery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'every', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByEveryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'every', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'times', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByTimesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'times', Sort.desc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Trigger, Trigger, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TriggerQueryWhereDistinct
    on QueryBuilder<Trigger, Trigger, QDistinct> {
  QueryBuilder<Trigger, Trigger, QDistinct> distinctByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'at');
    });
  }

  QueryBuilder<Trigger, Trigger, QDistinct> distinctByConvexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'convexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trigger, Trigger, QDistinct> distinctByEvery(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'every', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trigger, Trigger, QDistinct> distinctByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'patternId');
    });
  }

  QueryBuilder<Trigger, Trigger, QDistinct> distinctByTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'times');
    });
  }

  QueryBuilder<Trigger, Trigger, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TriggerQueryProperty
    on QueryBuilder<Trigger, Trigger, QQueryProperty> {
  QueryBuilder<Trigger, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Trigger, DateTime, QQueryOperations> atProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'at');
    });
  }

  QueryBuilder<Trigger, String?, QQueryOperations> convexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'convexId');
    });
  }

  QueryBuilder<Trigger, String?, QQueryOperations> everyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'every');
    });
  }

  QueryBuilder<Trigger, int?, QQueryOperations> patternIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'patternId');
    });
  }

  QueryBuilder<Trigger, int?, QQueryOperations> timesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'times');
    });
  }

  QueryBuilder<Trigger, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
