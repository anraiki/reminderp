// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReminderCollection on Isar {
  IsarCollection<Reminder> get reminders => this.collection();
}

const ReminderSchema = CollectionSchema(
  name: r'Reminder',
  id: -8566764253612256045,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'convexId': PropertySchema(
      id: 1,
      name: r'convexId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'listId': PropertySchema(
      id: 3,
      name: r'listId',
      type: IsarType.long,
    ),
    r'overrides': PropertySchema(
      id: 4,
      name: r'overrides',
      type: IsarType.objectList,
      target: r'Override',
    ),
    r'patternId': PropertySchema(
      id: 5,
      name: r'patternId',
      type: IsarType.long,
    ),
    r'triggerId': PropertySchema(
      id: 6,
      name: r'triggerId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _reminderEstimateSize,
  serialize: _reminderSerialize,
  deserialize: _reminderDeserialize,
  deserializeProp: _reminderDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'Override': OverrideSchema,
    r'Moment': MomentSchema,
    r'Voice': VoiceSchema
  },
  getId: _reminderGetId,
  getLinks: _reminderGetLinks,
  attach: _reminderAttach,
  version: '3.1.0+1',
);

int _reminderEstimateSize(
  Reminder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.body;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.convexId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.overrides.length * 3;
  {
    final offsets = allOffsets[Override]!;
    for (var i = 0; i < object.overrides.length; i++) {
      final value = object.overrides[i];
      bytesCount += OverrideSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _reminderSerialize(
  Reminder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeString(offsets[1], object.convexId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.listId);
  writer.writeObjectList<Override>(
    offsets[4],
    allOffsets,
    OverrideSchema.serialize,
    object.overrides,
  );
  writer.writeLong(offsets[5], object.patternId);
  writer.writeLong(offsets[6], object.triggerId);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

Reminder _reminderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Reminder();
  object.body = reader.readStringOrNull(offsets[0]);
  object.convexId = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.listId = reader.readLongOrNull(offsets[3]);
  object.overrides = reader.readObjectList<Override>(
        offsets[4],
        OverrideSchema.deserialize,
        allOffsets,
        Override(),
      ) ??
      [];
  object.patternId = reader.readLongOrNull(offsets[5]);
  object.triggerId = reader.readLongOrNull(offsets[6]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _reminderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readObjectList<Override>(
            offset,
            OverrideSchema.deserialize,
            allOffsets,
            Override(),
          ) ??
          []) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reminderGetId(Reminder object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reminderGetLinks(Reminder object) {
  return [];
}

void _reminderAttach(IsarCollection<dynamic> col, Id id, Reminder object) {
  object.id = id;
}

extension ReminderQueryWhereSort on QueryBuilder<Reminder, Reminder, QWhere> {
  QueryBuilder<Reminder, Reminder, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReminderQueryWhere on QueryBuilder<Reminder, Reminder, QWhereClause> {
  QueryBuilder<Reminder, Reminder, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Reminder, Reminder, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterWhereClause> idBetween(
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

extension ReminderQueryFilter
    on QueryBuilder<Reminder, Reminder, QFilterCondition> {
  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'convexId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdEqualTo(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdGreaterThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdLessThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdBetween(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdStartsWith(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdEndsWith(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdContains(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdMatches(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> convexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'convexId',
        value: '',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'listId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'listId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> listIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition>
      overridesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> overridesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition>
      overridesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition>
      overridesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition>
      overridesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition>
      overridesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'overrides',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'patternId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'patternId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdGreaterThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdLessThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> patternIdBetween(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggerId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggerId',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> triggerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> updatedAtBetween(
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

extension ReminderQueryObject
    on QueryBuilder<Reminder, Reminder, QFilterCondition> {
  QueryBuilder<Reminder, Reminder, QAfterFilterCondition> overridesElement(
      FilterQuery<Override> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'overrides');
    });
  }
}

extension ReminderQueryLinks
    on QueryBuilder<Reminder, Reminder, QFilterCondition> {}

extension ReminderQuerySortBy on QueryBuilder<Reminder, Reminder, QSortBy> {
  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByTriggerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByTriggerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReminderQuerySortThenBy
    on QueryBuilder<Reminder, Reminder, QSortThenBy> {
  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByConvexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByConvexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'convexId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByPatternIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByTriggerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerId', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByTriggerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerId', Sort.desc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Reminder, Reminder, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReminderQueryWhereDistinct
    on QueryBuilder<Reminder, Reminder, QDistinct> {
  QueryBuilder<Reminder, Reminder, QDistinct> distinctByBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByConvexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'convexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listId');
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByPatternId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'patternId');
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByTriggerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerId');
    });
  }

  QueryBuilder<Reminder, Reminder, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ReminderQueryProperty
    on QueryBuilder<Reminder, Reminder, QQueryProperty> {
  QueryBuilder<Reminder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Reminder, String?, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<Reminder, String?, QQueryOperations> convexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'convexId');
    });
  }

  QueryBuilder<Reminder, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Reminder, int?, QQueryOperations> listIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listId');
    });
  }

  QueryBuilder<Reminder, List<Override>, QQueryOperations> overridesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overrides');
    });
  }

  QueryBuilder<Reminder, int?, QQueryOperations> patternIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'patternId');
    });
  }

  QueryBuilder<Reminder, int?, QQueryOperations> triggerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerId');
    });
  }

  QueryBuilder<Reminder, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OverrideSchema = Schema(
  name: r'Override',
  id: -4385280431483496772,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'moment': PropertySchema(
      id: 1,
      name: r'moment',
      type: IsarType.object,
      target: r'Moment',
    ),
    r'momentOffset': PropertySchema(
      id: 2,
      name: r'momentOffset',
      type: IsarType.long,
    )
  },
  estimateSize: _overrideEstimateSize,
  serialize: _overrideSerialize,
  deserialize: _overrideDeserialize,
  deserializeProp: _overrideDeserializeProp,
);

int _overrideEstimateSize(
  Override object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.length * 3;
  {
    final value = object.moment;
    if (value != null) {
      bytesCount +=
          3 + MomentSchema.estimateSize(value, allOffsets[Moment]!, allOffsets);
    }
  }
  return bytesCount;
}

void _overrideSerialize(
  Override object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeObject<Moment>(
    offsets[1],
    allOffsets,
    MomentSchema.serialize,
    object.moment,
  );
  writer.writeLong(offsets[2], object.momentOffset);
}

Override _overrideDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Override();
  object.action = reader.readString(offsets[0]);
  object.moment = reader.readObjectOrNull<Moment>(
    offsets[1],
    MomentSchema.deserialize,
    allOffsets,
  );
  object.momentOffset = reader.readLong(offsets[2]);
  return object;
}

P _overrideDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectOrNull<Moment>(
        offset,
        MomentSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OverrideQueryFilter
    on QueryBuilder<Override, Override, QFilterCondition> {
  QueryBuilder<Override, Override, QAfterFilterCondition> actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> momentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moment',
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> momentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moment',
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> momentOffsetEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'momentOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition>
      momentOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'momentOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> momentOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'momentOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<Override, Override, QAfterFilterCondition> momentOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'momentOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OverrideQueryObject
    on QueryBuilder<Override, Override, QFilterCondition> {
  QueryBuilder<Override, Override, QAfterFilterCondition> moment(
      FilterQuery<Moment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'moment');
    });
  }
}
