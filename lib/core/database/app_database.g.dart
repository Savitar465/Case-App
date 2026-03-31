// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuthCredentialsTableTable extends AuthCredentialsTable
    with TableInfo<$AuthCredentialsTableTable, AuthCredentialsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthCredentialsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hashedPasswordMeta = const VerificationMeta(
    'hashedPassword',
  );
  @override
  late final GeneratedColumn<String> hashedPassword = GeneratedColumn<String>(
    'hashed_password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordSaltMeta = const VerificationMeta(
    'passwordSalt',
  );
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
    'password_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedAccessTokenMeta =
      const VerificationMeta('encryptedAccessToken');
  @override
  late final GeneratedColumn<String> encryptedAccessToken =
      GeneratedColumn<String>(
        'encrypted_access_token',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _encryptedRefreshTokenMeta =
      const VerificationMeta('encryptedRefreshToken');
  @override
  late final GeneratedColumn<String> encryptedRefreshToken =
      GeneratedColumn<String>(
        'encrypted_refresh_token',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonUserMetadataMeta = const VerificationMeta(
    'jsonUserMetadata',
  );
  @override
  late final GeneratedColumn<String> jsonUserMetadata = GeneratedColumn<String>(
    'json_user_metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('customer'),
  );
  static const VerificationMeta _sellerIdMeta = const VerificationMeta(
    'sellerId',
  );
  @override
  late final GeneratedColumn<String> sellerId = GeneratedColumn<String>(
    'seller_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    email,
    displayName,
    hashedPassword,
    passwordSalt,
    encryptedAccessToken,
    encryptedRefreshToken,
    expiresAt,
    jsonUserMetadata,
    role,
    sellerId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_credentials_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthCredentialsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('hashed_password')) {
      context.handle(
        _hashedPasswordMeta,
        hashedPassword.isAcceptableOrUnknown(
          data['hashed_password']!,
          _hashedPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hashedPasswordMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
        _passwordSaltMeta,
        passwordSalt.isAcceptableOrUnknown(
          data['password_salt']!,
          _passwordSaltMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('encrypted_access_token')) {
      context.handle(
        _encryptedAccessTokenMeta,
        encryptedAccessToken.isAcceptableOrUnknown(
          data['encrypted_access_token']!,
          _encryptedAccessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedAccessTokenMeta);
    }
    if (data.containsKey('encrypted_refresh_token')) {
      context.handle(
        _encryptedRefreshTokenMeta,
        encryptedRefreshToken.isAcceptableOrUnknown(
          data['encrypted_refresh_token']!,
          _encryptedRefreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('json_user_metadata')) {
      context.handle(
        _jsonUserMetadataMeta,
        jsonUserMetadata.isAcceptableOrUnknown(
          data['json_user_metadata']!,
          _jsonUserMetadataMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('seller_id')) {
      context.handle(
        _sellerIdMeta,
        sellerId.isAcceptableOrUnknown(data['seller_id']!, _sellerIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  AuthCredentialsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthCredentialsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      hashedPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hashed_password'],
      )!,
      passwordSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_salt'],
      )!,
      encryptedAccessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_access_token'],
      )!,
      encryptedRefreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_refresh_token'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      ),
      jsonUserMetadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_user_metadata'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      sellerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seller_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AuthCredentialsTableTable createAlias(String alias) {
    return $AuthCredentialsTableTable(attachedDatabase, alias);
  }
}

class AuthCredentialsTableData extends DataClass
    implements Insertable<AuthCredentialsTableData> {
  final String userId;
  final String email;
  final String? displayName;
  final String hashedPassword;
  final String passwordSalt;
  final String encryptedAccessToken;
  final String? encryptedRefreshToken;
  final int? expiresAt;
  final String? jsonUserMetadata;
  final String role;
  final String? sellerId;
  final DateTime updatedAt;
  const AuthCredentialsTableData({
    required this.userId,
    required this.email,
    this.displayName,
    required this.hashedPassword,
    required this.passwordSalt,
    required this.encryptedAccessToken,
    this.encryptedRefreshToken,
    this.expiresAt,
    this.jsonUserMetadata,
    required this.role,
    this.sellerId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['hashed_password'] = Variable<String>(hashedPassword);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['encrypted_access_token'] = Variable<String>(encryptedAccessToken);
    if (!nullToAbsent || encryptedRefreshToken != null) {
      map['encrypted_refresh_token'] = Variable<String>(encryptedRefreshToken);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    if (!nullToAbsent || jsonUserMetadata != null) {
      map['json_user_metadata'] = Variable<String>(jsonUserMetadata);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || sellerId != null) {
      map['seller_id'] = Variable<String>(sellerId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AuthCredentialsTableCompanion toCompanion(bool nullToAbsent) {
    return AuthCredentialsTableCompanion(
      userId: Value(userId),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      hashedPassword: Value(hashedPassword),
      passwordSalt: Value(passwordSalt),
      encryptedAccessToken: Value(encryptedAccessToken),
      encryptedRefreshToken: encryptedRefreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedRefreshToken),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      jsonUserMetadata: jsonUserMetadata == null && nullToAbsent
          ? const Value.absent()
          : Value(jsonUserMetadata),
      role: Value(role),
      sellerId: sellerId == null && nullToAbsent
          ? const Value.absent()
          : Value(sellerId),
      updatedAt: Value(updatedAt),
    );
  }

  factory AuthCredentialsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthCredentialsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      hashedPassword: serializer.fromJson<String>(json['hashedPassword']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      encryptedAccessToken: serializer.fromJson<String>(
        json['encryptedAccessToken'],
      ),
      encryptedRefreshToken: serializer.fromJson<String?>(
        json['encryptedRefreshToken'],
      ),
      expiresAt: serializer.fromJson<int?>(json['expiresAt']),
      jsonUserMetadata: serializer.fromJson<String?>(json['jsonUserMetadata']),
      role: serializer.fromJson<String>(json['role']),
      sellerId: serializer.fromJson<String?>(json['sellerId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'hashedPassword': serializer.toJson<String>(hashedPassword),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'encryptedAccessToken': serializer.toJson<String>(encryptedAccessToken),
      'encryptedRefreshToken': serializer.toJson<String?>(
        encryptedRefreshToken,
      ),
      'expiresAt': serializer.toJson<int?>(expiresAt),
      'jsonUserMetadata': serializer.toJson<String?>(jsonUserMetadata),
      'role': serializer.toJson<String>(role),
      'sellerId': serializer.toJson<String?>(sellerId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AuthCredentialsTableData copyWith({
    String? userId,
    String? email,
    Value<String?> displayName = const Value.absent(),
    String? hashedPassword,
    String? passwordSalt,
    String? encryptedAccessToken,
    Value<String?> encryptedRefreshToken = const Value.absent(),
    Value<int?> expiresAt = const Value.absent(),
    Value<String?> jsonUserMetadata = const Value.absent(),
    String? role,
    Value<String?> sellerId = const Value.absent(),
    DateTime? updatedAt,
  }) => AuthCredentialsTableData(
    userId: userId ?? this.userId,
    email: email ?? this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    hashedPassword: hashedPassword ?? this.hashedPassword,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    encryptedAccessToken: encryptedAccessToken ?? this.encryptedAccessToken,
    encryptedRefreshToken: encryptedRefreshToken.present
        ? encryptedRefreshToken.value
        : this.encryptedRefreshToken,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    jsonUserMetadata: jsonUserMetadata.present
        ? jsonUserMetadata.value
        : this.jsonUserMetadata,
    role: role ?? this.role,
    sellerId: sellerId.present ? sellerId.value : this.sellerId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AuthCredentialsTableData copyWithCompanion(
    AuthCredentialsTableCompanion data,
  ) {
    return AuthCredentialsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      hashedPassword: data.hashedPassword.present
          ? data.hashedPassword.value
          : this.hashedPassword,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      encryptedAccessToken: data.encryptedAccessToken.present
          ? data.encryptedAccessToken.value
          : this.encryptedAccessToken,
      encryptedRefreshToken: data.encryptedRefreshToken.present
          ? data.encryptedRefreshToken.value
          : this.encryptedRefreshToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      jsonUserMetadata: data.jsonUserMetadata.present
          ? data.jsonUserMetadata.value
          : this.jsonUserMetadata,
      role: data.role.present ? data.role.value : this.role,
      sellerId: data.sellerId.present ? data.sellerId.value : this.sellerId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthCredentialsTableData(')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('encryptedAccessToken: $encryptedAccessToken, ')
          ..write('encryptedRefreshToken: $encryptedRefreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('jsonUserMetadata: $jsonUserMetadata, ')
          ..write('role: $role, ')
          ..write('sellerId: $sellerId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    email,
    displayName,
    hashedPassword,
    passwordSalt,
    encryptedAccessToken,
    encryptedRefreshToken,
    expiresAt,
    jsonUserMetadata,
    role,
    sellerId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthCredentialsTableData &&
          other.userId == this.userId &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.hashedPassword == this.hashedPassword &&
          other.passwordSalt == this.passwordSalt &&
          other.encryptedAccessToken == this.encryptedAccessToken &&
          other.encryptedRefreshToken == this.encryptedRefreshToken &&
          other.expiresAt == this.expiresAt &&
          other.jsonUserMetadata == this.jsonUserMetadata &&
          other.role == this.role &&
          other.sellerId == this.sellerId &&
          other.updatedAt == this.updatedAt);
}

class AuthCredentialsTableCompanion
    extends UpdateCompanion<AuthCredentialsTableData> {
  final Value<String> userId;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<String> hashedPassword;
  final Value<String> passwordSalt;
  final Value<String> encryptedAccessToken;
  final Value<String?> encryptedRefreshToken;
  final Value<int?> expiresAt;
  final Value<String?> jsonUserMetadata;
  final Value<String> role;
  final Value<String?> sellerId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AuthCredentialsTableCompanion({
    this.userId = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.hashedPassword = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.encryptedAccessToken = const Value.absent(),
    this.encryptedRefreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.jsonUserMetadata = const Value.absent(),
    this.role = const Value.absent(),
    this.sellerId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthCredentialsTableCompanion.insert({
    required String userId,
    required String email,
    this.displayName = const Value.absent(),
    required String hashedPassword,
    required String passwordSalt,
    required String encryptedAccessToken,
    this.encryptedRefreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.jsonUserMetadata = const Value.absent(),
    this.role = const Value.absent(),
    this.sellerId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       email = Value(email),
       hashedPassword = Value(hashedPassword),
       passwordSalt = Value(passwordSalt),
       encryptedAccessToken = Value(encryptedAccessToken),
       updatedAt = Value(updatedAt);
  static Insertable<AuthCredentialsTableData> custom({
    Expression<String>? userId,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? hashedPassword,
    Expression<String>? passwordSalt,
    Expression<String>? encryptedAccessToken,
    Expression<String>? encryptedRefreshToken,
    Expression<int>? expiresAt,
    Expression<String>? jsonUserMetadata,
    Expression<String>? role,
    Expression<String>? sellerId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (hashedPassword != null) 'hashed_password': hashedPassword,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (encryptedAccessToken != null)
        'encrypted_access_token': encryptedAccessToken,
      if (encryptedRefreshToken != null)
        'encrypted_refresh_token': encryptedRefreshToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (jsonUserMetadata != null) 'json_user_metadata': jsonUserMetadata,
      if (role != null) 'role': role,
      if (sellerId != null) 'seller_id': sellerId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthCredentialsTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? email,
    Value<String?>? displayName,
    Value<String>? hashedPassword,
    Value<String>? passwordSalt,
    Value<String>? encryptedAccessToken,
    Value<String?>? encryptedRefreshToken,
    Value<int?>? expiresAt,
    Value<String?>? jsonUserMetadata,
    Value<String>? role,
    Value<String?>? sellerId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AuthCredentialsTableCompanion(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      encryptedAccessToken: encryptedAccessToken ?? this.encryptedAccessToken,
      encryptedRefreshToken:
          encryptedRefreshToken ?? this.encryptedRefreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      jsonUserMetadata: jsonUserMetadata ?? this.jsonUserMetadata,
      role: role ?? this.role,
      sellerId: sellerId ?? this.sellerId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (hashedPassword.present) {
      map['hashed_password'] = Variable<String>(hashedPassword.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (encryptedAccessToken.present) {
      map['encrypted_access_token'] = Variable<String>(
        encryptedAccessToken.value,
      );
    }
    if (encryptedRefreshToken.present) {
      map['encrypted_refresh_token'] = Variable<String>(
        encryptedRefreshToken.value,
      );
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (jsonUserMetadata.present) {
      map['json_user_metadata'] = Variable<String>(jsonUserMetadata.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (sellerId.present) {
      map['seller_id'] = Variable<String>(sellerId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthCredentialsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('encryptedAccessToken: $encryptedAccessToken, ')
          ..write('encryptedRefreshToken: $encryptedRefreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('jsonUserMetadata: $jsonUserMetadata, ')
          ..write('role: $role, ')
          ..write('sellerId: $sellerId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SellersTableTable extends SellersTable
    with TableInfo<$SellersTableTable, SellersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SellersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeSlugMeta = const VerificationMeta(
    'storeSlug',
  );
  @override
  late final GeneratedColumn<String> storeSlug = GeneratedColumn<String>(
    'store_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bannerUrlMeta = const VerificationMeta(
    'bannerUrl',
  );
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
    'banner_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    storeName,
    storeSlug,
    description,
    logoUrl,
    bannerUrl,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sellers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SellersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_storeNameMeta);
    }
    if (data.containsKey('store_slug')) {
      context.handle(
        _storeSlugMeta,
        storeSlug.isAcceptableOrUnknown(data['store_slug']!, _storeSlugMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('banner_url')) {
      context.handle(
        _bannerUrlMeta,
        bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SellersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SellersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      )!,
      storeSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_slug'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      bannerUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}banner_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SellersTableTable createAlias(String alias) {
    return $SellersTableTable(attachedDatabase, alias);
  }
}

class SellersTableData extends DataClass
    implements Insertable<SellersTableData> {
  final String id;
  final String userId;
  final String storeName;
  final String? storeSlug;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const SellersTableData({
    required this.id,
    required this.userId,
    required this.storeName,
    this.storeSlug,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['store_name'] = Variable<String>(storeName);
    if (!nullToAbsent || storeSlug != null) {
      map['store_slug'] = Variable<String>(storeSlug);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || bannerUrl != null) {
      map['banner_url'] = Variable<String>(bannerUrl);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SellersTableCompanion toCompanion(bool nullToAbsent) {
    return SellersTableCompanion(
      id: Value(id),
      userId: Value(userId),
      storeName: Value(storeName),
      storeSlug: storeSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(storeSlug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      bannerUrl: bannerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bannerUrl),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SellersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SellersTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      storeName: serializer.fromJson<String>(json['storeName']),
      storeSlug: serializer.fromJson<String?>(json['storeSlug']),
      description: serializer.fromJson<String?>(json['description']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      bannerUrl: serializer.fromJson<String?>(json['bannerUrl']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'storeName': serializer.toJson<String>(storeName),
      'storeSlug': serializer.toJson<String?>(storeSlug),
      'description': serializer.toJson<String?>(description),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'bannerUrl': serializer.toJson<String?>(bannerUrl),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SellersTableData copyWith({
    String? id,
    String? userId,
    String? storeName,
    Value<String?> storeSlug = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> logoUrl = const Value.absent(),
    Value<String?> bannerUrl = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SellersTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    storeName: storeName ?? this.storeName,
    storeSlug: storeSlug.present ? storeSlug.value : this.storeSlug,
    description: description.present ? description.value : this.description,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    bannerUrl: bannerUrl.present ? bannerUrl.value : this.bannerUrl,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SellersTableData copyWithCompanion(SellersTableCompanion data) {
    return SellersTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      storeSlug: data.storeSlug.present ? data.storeSlug.value : this.storeSlug,
      description: data.description.present
          ? data.description.value
          : this.description,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      bannerUrl: data.bannerUrl.present ? data.bannerUrl.value : this.bannerUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SellersTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('storeName: $storeName, ')
          ..write('storeSlug: $storeSlug, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    storeName,
    storeSlug,
    description,
    logoUrl,
    bannerUrl,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SellersTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.storeName == this.storeName &&
          other.storeSlug == this.storeSlug &&
          other.description == this.description &&
          other.logoUrl == this.logoUrl &&
          other.bannerUrl == this.bannerUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class SellersTableCompanion extends UpdateCompanion<SellersTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> storeName;
  final Value<String?> storeSlug;
  final Value<String?> description;
  final Value<String?> logoUrl;
  final Value<String?> bannerUrl;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SellersTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeSlug = const Value.absent(),
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SellersTableCompanion.insert({
    required String id,
    required String userId,
    required String storeName,
    this.storeSlug = const Value.absent(),
    this.description = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       storeName = Value(storeName);
  static Insertable<SellersTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? storeName,
    Expression<String>? storeSlug,
    Expression<String>? description,
    Expression<String>? logoUrl,
    Expression<String>? bannerUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (storeName != null) 'store_name': storeName,
      if (storeSlug != null) 'store_slug': storeSlug,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SellersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? storeName,
    Value<String?>? storeSlug,
    Value<String?>? description,
    Value<String?>? logoUrl,
    Value<String?>? bannerUrl,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SellersTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      storeSlug: storeSlug ?? this.storeSlug,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (storeSlug.present) {
      map['store_slug'] = Variable<String>(storeSlug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SellersTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('storeName: $storeName, ')
          ..write('storeSlug: $storeSlug, ')
          ..write('description: $description, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellerIdMeta = const VerificationMeta(
    'sellerId',
  );
  @override
  late final GeneratedColumn<String> sellerId = GeneratedColumn<String>(
    'seller_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isTrendingMeta = const VerificationMeta(
    'isTrending',
  );
  @override
  late final GeneratedColumn<bool> isTrending = GeneratedColumn<bool>(
    'is_trending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_trending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _inStockMeta = const VerificationMeta(
    'inStock',
  );
  @override
  late final GeneratedColumn<bool> inStock = GeneratedColumn<bool>(
    'in_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingOperationMeta = const VerificationMeta(
    'pendingOperation',
  );
  @override
  late final GeneratedColumn<String> pendingOperation = GeneratedColumn<String>(
    'pending_operation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sellerId,
    name,
    description,
    category,
    unit,
    price,
    quantity,
    isTrending,
    inStock,
    rating,
    isDirty,
    pendingOperation,
    createdAt,
    updatedAt,
    syncedAt,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('seller_id')) {
      context.handle(
        _sellerIdMeta,
        sellerId.isAcceptableOrUnknown(data['seller_id']!, _sellerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sellerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_trending')) {
      context.handle(
        _isTrendingMeta,
        isTrending.isAcceptableOrUnknown(data['is_trending']!, _isTrendingMeta),
      );
    }
    if (data.containsKey('in_stock')) {
      context.handle(
        _inStockMeta,
        inStock.isAcceptableOrUnknown(data['in_stock']!, _inStockMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    if (data.containsKey('pending_operation')) {
      context.handle(
        _pendingOperationMeta,
        pendingOperation.isAcceptableOrUnknown(
          data['pending_operation']!,
          _pendingOperationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sellerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seller_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      ),
      isTrending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_trending'],
      )!,
      inStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_stock'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
      pendingOperation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_operation'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final String id;
  final String sellerId;
  final String name;
  final String? description;
  final String? category;
  final String? unit;
  final double price;
  final int? quantity;
  final bool isTrending;
  final bool inStock;
  final double? rating;
  final bool isDirty;
  final String? pendingOperation;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  final String? metadataJson;
  const ProductsTableData({
    required this.id,
    required this.sellerId,
    required this.name,
    this.description,
    this.category,
    this.unit,
    required this.price,
    this.quantity,
    required this.isTrending,
    required this.inStock,
    this.rating,
    required this.isDirty,
    this.pendingOperation,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['seller_id'] = Variable<String>(sellerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    map['is_trending'] = Variable<bool>(isTrending);
    map['in_stock'] = Variable<bool>(inStock);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || pendingOperation != null) {
      map['pending_operation'] = Variable<String>(pendingOperation);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      sellerId: Value(sellerId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      price: Value(price),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      isTrending: Value(isTrending),
      inStock: Value(inStock),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isDirty: Value(isDirty),
      pendingOperation: pendingOperation == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingOperation),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory ProductsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      sellerId: serializer.fromJson<String>(json['sellerId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      unit: serializer.fromJson<String?>(json['unit']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      isTrending: serializer.fromJson<bool>(json['isTrending']),
      inStock: serializer.fromJson<bool>(json['inStock']),
      rating: serializer.fromJson<double?>(json['rating']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      pendingOperation: serializer.fromJson<String?>(json['pendingOperation']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sellerId': serializer.toJson<String>(sellerId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'unit': serializer.toJson<String?>(unit),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int?>(quantity),
      'isTrending': serializer.toJson<bool>(isTrending),
      'inStock': serializer.toJson<bool>(inStock),
      'rating': serializer.toJson<double?>(rating),
      'isDirty': serializer.toJson<bool>(isDirty),
      'pendingOperation': serializer.toJson<String?>(pendingOperation),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  ProductsTableData copyWith({
    String? id,
    String? sellerId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    double? price,
    Value<int?> quantity = const Value.absent(),
    bool? isTrending,
    bool? inStock,
    Value<double?> rating = const Value.absent(),
    bool? isDirty,
    Value<String?> pendingOperation = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> metadataJson = const Value.absent(),
  }) => ProductsTableData(
    id: id ?? this.id,
    sellerId: sellerId ?? this.sellerId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    unit: unit.present ? unit.value : this.unit,
    price: price ?? this.price,
    quantity: quantity.present ? quantity.value : this.quantity,
    isTrending: isTrending ?? this.isTrending,
    inStock: inStock ?? this.inStock,
    rating: rating.present ? rating.value : this.rating,
    isDirty: isDirty ?? this.isDirty,
    pendingOperation: pendingOperation.present
        ? pendingOperation.value
        : this.pendingOperation,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
  );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      sellerId: data.sellerId.present ? data.sellerId.value : this.sellerId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isTrending: data.isTrending.present
          ? data.isTrending.value
          : this.isTrending,
      inStock: data.inStock.present ? data.inStock.value : this.inStock,
      rating: data.rating.present ? data.rating.value : this.rating,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      pendingOperation: data.pendingOperation.present
          ? data.pendingOperation.value
          : this.pendingOperation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('sellerId: $sellerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('isTrending: $isTrending, ')
          ..write('inStock: $inStock, ')
          ..write('rating: $rating, ')
          ..write('isDirty: $isDirty, ')
          ..write('pendingOperation: $pendingOperation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sellerId,
    name,
    description,
    category,
    unit,
    price,
    quantity,
    isTrending,
    inStock,
    rating,
    isDirty,
    pendingOperation,
    createdAt,
    updatedAt,
    syncedAt,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.sellerId == this.sellerId &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.isTrending == this.isTrending &&
          other.inStock == this.inStock &&
          other.rating == this.rating &&
          other.isDirty == this.isDirty &&
          other.pendingOperation == this.pendingOperation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.metadataJson == this.metadataJson);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<String> id;
  final Value<String> sellerId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> category;
  final Value<String?> unit;
  final Value<double> price;
  final Value<int?> quantity;
  final Value<bool> isTrending;
  final Value<bool> inStock;
  final Value<double?> rating;
  final Value<bool> isDirty;
  final Value<String?> pendingOperation;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.sellerId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isTrending = const Value.absent(),
    this.inStock = const Value.absent(),
    this.rating = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.pendingOperation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String sellerId,
    required String name,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isTrending = const Value.absent(),
    this.inStock = const Value.absent(),
    this.rating = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.pendingOperation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sellerId = Value(sellerId),
       name = Value(name);
  static Insertable<ProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? sellerId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<double>? price,
    Expression<int>? quantity,
    Expression<bool>? isTrending,
    Expression<bool>? inStock,
    Expression<double>? rating,
    Expression<bool>? isDirty,
    Expression<String>? pendingOperation,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sellerId != null) 'seller_id': sellerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (isTrending != null) 'is_trending': isTrending,
      if (inStock != null) 'in_stock': inStock,
      if (rating != null) 'rating': rating,
      if (isDirty != null) 'is_dirty': isDirty,
      if (pendingOperation != null) 'pending_operation': pendingOperation,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sellerId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? category,
    Value<String?>? unit,
    Value<double>? price,
    Value<int?>? quantity,
    Value<bool>? isTrending,
    Value<bool>? inStock,
    Value<double?>? rating,
    Value<bool>? isDirty,
    Value<String?>? pendingOperation,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<String?>? metadataJson,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isTrending: isTrending ?? this.isTrending,
      inStock: inStock ?? this.inStock,
      rating: rating ?? this.rating,
      isDirty: isDirty ?? this.isDirty,
      pendingOperation: pendingOperation ?? this.pendingOperation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sellerId.present) {
      map['seller_id'] = Variable<String>(sellerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isTrending.present) {
      map['is_trending'] = Variable<bool>(isTrending.value);
    }
    if (inStock.present) {
      map['in_stock'] = Variable<bool>(inStock.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (pendingOperation.present) {
      map['pending_operation'] = Variable<String>(pendingOperation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('sellerId: $sellerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('isTrending: $isTrending, ')
          ..write('inStock: $inStock, ')
          ..write('rating: $rating, ')
          ..write('isDirty: $isDirty, ')
          ..write('pendingOperation: $pendingOperation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryLocationsTableTable extends InventoryLocationsTable
    with TableInfo<$InventoryLocationsTableTable, InventoryLocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryLocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _managerIdMeta = const VerificationMeta(
    'managerId',
  );
  @override
  late final GeneratedColumn<String> managerId = GeneratedColumn<String>(
    'manager_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    code,
    name,
    description,
    address,
    phone,
    managerId,
    isActive,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_locations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryLocationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('manager_id')) {
      context.handle(
        _managerIdMeta,
        managerId.isAcceptableOrUnknown(data['manager_id']!, _managerIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryLocationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryLocationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      managerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manager_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $InventoryLocationsTableTable createAlias(String alias) {
    return $InventoryLocationsTableTable(attachedDatabase, alias);
  }
}

class InventoryLocationsTableData extends DataClass
    implements Insertable<InventoryLocationsTableData> {
  final String id;
  final String type;
  final String? code;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? managerId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const InventoryLocationsTableData({
    required this.id,
    required this.type,
    this.code,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.managerId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || managerId != null) {
      map['manager_id'] = Variable<String>(managerId);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  InventoryLocationsTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryLocationsTableCompanion(
      id: Value(id),
      type: Value(type),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      managerId: managerId == null && nullToAbsent
          ? const Value.absent()
          : Value(managerId),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory InventoryLocationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryLocationsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      code: serializer.fromJson<String?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      managerId: serializer.fromJson<String?>(json['managerId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'code': serializer.toJson<String?>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'managerId': serializer.toJson<String?>(managerId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  InventoryLocationsTableData copyWith({
    String? id,
    String? type,
    Value<String?> code = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> managerId = const Value.absent(),
    bool? isActive,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => InventoryLocationsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    code: code.present ? code.value : this.code,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    managerId: managerId.present ? managerId.value : this.managerId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  InventoryLocationsTableData copyWithCompanion(
    InventoryLocationsTableCompanion data,
  ) {
    return InventoryLocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      managerId: data.managerId.present ? data.managerId.value : this.managerId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryLocationsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('managerId: $managerId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    code,
    name,
    description,
    address,
    phone,
    managerId,
    isActive,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryLocationsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.managerId == this.managerId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class InventoryLocationsTableCompanion
    extends UpdateCompanion<InventoryLocationsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String?> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> managerId;
  final Value<bool> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const InventoryLocationsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.managerId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryLocationsTableCompanion.insert({
    required String id,
    required String type,
    this.code = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.managerId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       name = Value(name);
  static Insertable<InventoryLocationsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? managerId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (managerId != null) 'manager_id': managerId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryLocationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String?>? code,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? managerId,
    Value<bool>? isActive,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return InventoryLocationsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      managerId: managerId ?? this.managerId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (managerId.present) {
      map['manager_id'] = Variable<String>(managerId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryLocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('managerId: $managerId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTableTable extends EmployeesTable
    with TableInfo<$EmployeesTableTable, EmployeesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authUserIdMeta = const VerificationMeta(
    'authUserId',
  );
  @override
  late final GeneratedColumn<String> authUserId = GeneratedColumn<String>(
    'auth_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inventory_locations_table (id)',
    ),
  );
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hiredAtMeta = const VerificationMeta(
    'hiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> hiredAt = GeneratedColumn<DateTime>(
    'hired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    email,
    phone,
    authUserId,
    role,
    locationId,
    locationType,
    isActive,
    hiredAt,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('auth_user_id')) {
      context.handle(
        _authUserIdMeta,
        authUserId.isAcceptableOrUnknown(
          data['auth_user_id']!,
          _authUserIdMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('hired_at')) {
      context.handle(
        _hiredAtMeta,
        hiredAt.isAcceptableOrUnknown(data['hired_at']!, _hiredAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      authUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_user_id'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      hiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hired_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $EmployeesTableTable createAlias(String alias) {
    return $EmployeesTableTable(attachedDatabase, alias);
  }
}

class EmployeesTableData extends DataClass
    implements Insertable<EmployeesTableData> {
  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? authUserId;
  final String role;
  final String? locationId;
  final String? locationType;
  final bool isActive;
  final DateTime? hiredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const EmployeesTableData({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.authUserId,
    required this.role,
    this.locationId,
    this.locationType,
    required this.isActive,
    this.hiredAt,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || authUserId != null) {
      map['auth_user_id'] = Variable<String>(authUserId);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || locationType != null) {
      map['location_type'] = Variable<String>(locationType);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || hiredAt != null) {
      map['hired_at'] = Variable<DateTime>(hiredAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  EmployeesTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeesTableCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      authUserId: authUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(authUserId),
      role: Value(role),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      locationType: locationType == null && nullToAbsent
          ? const Value.absent()
          : Value(locationType),
      isActive: Value(isActive),
      hiredAt: hiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(hiredAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory EmployeesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeesTableData(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      authUserId: serializer.fromJson<String?>(json['authUserId']),
      role: serializer.fromJson<String>(json['role']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      locationType: serializer.fromJson<String?>(json['locationType']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      hiredAt: serializer.fromJson<DateTime?>(json['hiredAt']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'authUserId': serializer.toJson<String?>(authUserId),
      'role': serializer.toJson<String>(role),
      'locationId': serializer.toJson<String?>(locationId),
      'locationType': serializer.toJson<String?>(locationType),
      'isActive': serializer.toJson<bool>(isActive),
      'hiredAt': serializer.toJson<DateTime?>(hiredAt),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  EmployeesTableData copyWith({
    String? id,
    String? firstName,
    Value<String?> lastName = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> authUserId = const Value.absent(),
    String? role,
    Value<String?> locationId = const Value.absent(),
    Value<String?> locationType = const Value.absent(),
    bool? isActive,
    Value<DateTime?> hiredAt = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => EmployeesTableData(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName.present ? lastName.value : this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    authUserId: authUserId.present ? authUserId.value : this.authUserId,
    role: role ?? this.role,
    locationId: locationId.present ? locationId.value : this.locationId,
    locationType: locationType.present ? locationType.value : this.locationType,
    isActive: isActive ?? this.isActive,
    hiredAt: hiredAt.present ? hiredAt.value : this.hiredAt,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  EmployeesTableData copyWithCompanion(EmployeesTableCompanion data) {
    return EmployeesTableData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      authUserId: data.authUserId.present
          ? data.authUserId.value
          : this.authUserId,
      role: data.role.present ? data.role.value : this.role,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      hiredAt: data.hiredAt.present ? data.hiredAt.value : this.hiredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesTableData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('authUserId: $authUserId, ')
          ..write('role: $role, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('isActive: $isActive, ')
          ..write('hiredAt: $hiredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    email,
    phone,
    authUserId,
    role,
    locationId,
    locationType,
    isActive,
    hiredAt,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeesTableData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.authUserId == this.authUserId &&
          other.role == this.role &&
          other.locationId == this.locationId &&
          other.locationType == this.locationType &&
          other.isActive == this.isActive &&
          other.hiredAt == this.hiredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class EmployeesTableCompanion extends UpdateCompanion<EmployeesTableData> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String?> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> authUserId;
  final Value<String> role;
  final Value<String?> locationId;
  final Value<String?> locationType;
  final Value<bool> isActive;
  final Value<DateTime?> hiredAt;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const EmployeesTableCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.authUserId = const Value.absent(),
    this.role = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hiredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesTableCompanion.insert({
    required String id,
    required String firstName,
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.authUserId = const Value.absent(),
    required String role,
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hiredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       role = Value(role);
  static Insertable<EmployeesTableData> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? authUserId,
    Expression<String>? role,
    Expression<String>? locationId,
    Expression<String>? locationType,
    Expression<bool>? isActive,
    Expression<DateTime>? hiredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (authUserId != null) 'auth_user_id': authUserId,
      if (role != null) 'role': role,
      if (locationId != null) 'location_id': locationId,
      if (locationType != null) 'location_type': locationType,
      if (isActive != null) 'is_active': isActive,
      if (hiredAt != null) 'hired_at': hiredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String?>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? authUserId,
    Value<String>? role,
    Value<String?>? locationId,
    Value<String?>? locationType,
    Value<bool>? isActive,
    Value<DateTime?>? hiredAt,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return EmployeesTableCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      authUserId: authUserId ?? this.authUserId,
      role: role ?? this.role,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      isActive: isActive ?? this.isActive,
      hiredAt: hiredAt ?? this.hiredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (authUserId.present) {
      map['auth_user_id'] = Variable<String>(authUserId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (hiredAt.present) {
      map['hired_at'] = Variable<DateTime>(hiredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesTableCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('authUserId: $authUserId, ')
          ..write('role: $role, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('isActive: $isActive, ')
          ..write('hiredAt: $hiredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryStocksTableTable extends InventoryStocksTable
    with TableInfo<$InventoryStocksTableTable, InventoryStocksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryStocksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('store'),
  );
  static const VerificationMeta _quantityOnHandMeta = const VerificationMeta(
    'quantityOnHand',
  );
  @override
  late final GeneratedColumn<double> quantityOnHand = GeneratedColumn<double>(
    'quantity_on_hand',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _quantityReservedMeta = const VerificationMeta(
    'quantityReserved',
  );
  @override
  late final GeneratedColumn<double> quantityReserved = GeneratedColumn<double>(
    'quantity_reserved',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    locationId,
    locationType,
    quantityOnHand,
    quantityReserved,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_stocks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryStocksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    }
    if (data.containsKey('quantity_on_hand')) {
      context.handle(
        _quantityOnHandMeta,
        quantityOnHand.isAcceptableOrUnknown(
          data['quantity_on_hand']!,
          _quantityOnHandMeta,
        ),
      );
    }
    if (data.containsKey('quantity_reserved')) {
      context.handle(
        _quantityReservedMeta,
        quantityReserved.isAcceptableOrUnknown(
          data['quantity_reserved']!,
          _quantityReservedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId, locationId};
  @override
  InventoryStocksTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryStocksTableData(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      )!,
      quantityOnHand: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_on_hand'],
      )!,
      quantityReserved: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_reserved'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $InventoryStocksTableTable createAlias(String alias) {
    return $InventoryStocksTableTable(attachedDatabase, alias);
  }
}

class InventoryStocksTableData extends DataClass
    implements Insertable<InventoryStocksTableData> {
  final String productId;
  final String locationId;
  final String locationType;
  final double quantityOnHand;
  final double quantityReserved;
  final DateTime? updatedAt;
  const InventoryStocksTableData({
    required this.productId,
    required this.locationId,
    required this.locationType,
    required this.quantityOnHand,
    required this.quantityReserved,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['location_id'] = Variable<String>(locationId);
    map['location_type'] = Variable<String>(locationType);
    map['quantity_on_hand'] = Variable<double>(quantityOnHand);
    map['quantity_reserved'] = Variable<double>(quantityReserved);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  InventoryStocksTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryStocksTableCompanion(
      productId: Value(productId),
      locationId: Value(locationId),
      locationType: Value(locationType),
      quantityOnHand: Value(quantityOnHand),
      quantityReserved: Value(quantityReserved),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory InventoryStocksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryStocksTableData(
      productId: serializer.fromJson<String>(json['productId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      locationType: serializer.fromJson<String>(json['locationType']),
      quantityOnHand: serializer.fromJson<double>(json['quantityOnHand']),
      quantityReserved: serializer.fromJson<double>(json['quantityReserved']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'locationId': serializer.toJson<String>(locationId),
      'locationType': serializer.toJson<String>(locationType),
      'quantityOnHand': serializer.toJson<double>(quantityOnHand),
      'quantityReserved': serializer.toJson<double>(quantityReserved),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  InventoryStocksTableData copyWith({
    String? productId,
    String? locationId,
    String? locationType,
    double? quantityOnHand,
    double? quantityReserved,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => InventoryStocksTableData(
    productId: productId ?? this.productId,
    locationId: locationId ?? this.locationId,
    locationType: locationType ?? this.locationType,
    quantityOnHand: quantityOnHand ?? this.quantityOnHand,
    quantityReserved: quantityReserved ?? this.quantityReserved,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  InventoryStocksTableData copyWithCompanion(
    InventoryStocksTableCompanion data,
  ) {
    return InventoryStocksTableData(
      productId: data.productId.present ? data.productId.value : this.productId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      quantityOnHand: data.quantityOnHand.present
          ? data.quantityOnHand.value
          : this.quantityOnHand,
      quantityReserved: data.quantityReserved.present
          ? data.quantityReserved.value
          : this.quantityReserved,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryStocksTableData(')
          ..write('productId: $productId, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('quantityOnHand: $quantityOnHand, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    locationId,
    locationType,
    quantityOnHand,
    quantityReserved,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryStocksTableData &&
          other.productId == this.productId &&
          other.locationId == this.locationId &&
          other.locationType == this.locationType &&
          other.quantityOnHand == this.quantityOnHand &&
          other.quantityReserved == this.quantityReserved &&
          other.updatedAt == this.updatedAt);
}

class InventoryStocksTableCompanion
    extends UpdateCompanion<InventoryStocksTableData> {
  final Value<String> productId;
  final Value<String> locationId;
  final Value<String> locationType;
  final Value<double> quantityOnHand;
  final Value<double> quantityReserved;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const InventoryStocksTableCompanion({
    this.productId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    this.quantityOnHand = const Value.absent(),
    this.quantityReserved = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryStocksTableCompanion.insert({
    required String productId,
    required String locationId,
    this.locationType = const Value.absent(),
    this.quantityOnHand = const Value.absent(),
    this.quantityReserved = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       locationId = Value(locationId);
  static Insertable<InventoryStocksTableData> custom({
    Expression<String>? productId,
    Expression<String>? locationId,
    Expression<String>? locationType,
    Expression<double>? quantityOnHand,
    Expression<double>? quantityReserved,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (locationId != null) 'location_id': locationId,
      if (locationType != null) 'location_type': locationType,
      if (quantityOnHand != null) 'quantity_on_hand': quantityOnHand,
      if (quantityReserved != null) 'quantity_reserved': quantityReserved,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryStocksTableCompanion copyWith({
    Value<String>? productId,
    Value<String>? locationId,
    Value<String>? locationType,
    Value<double>? quantityOnHand,
    Value<double>? quantityReserved,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return InventoryStocksTableCompanion(
      productId: productId ?? this.productId,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (quantityOnHand.present) {
      map['quantity_on_hand'] = Variable<double>(quantityOnHand.value);
    }
    if (quantityReserved.present) {
      map['quantity_reserved'] = Variable<double>(quantityReserved.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryStocksTableCompanion(')
          ..write('productId: $productId, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('quantityOnHand: $quantityOnHand, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryMovementsTableTable extends InventoryMovementsTable
    with TableInfo<$InventoryMovementsTableTable, InventoryMovementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryMovementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementTypeMeta = const VerificationMeta(
    'movementType',
  );
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
    'movement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceTypeMeta = const VerificationMeta(
    'referenceType',
  );
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
    'reference_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    locationId,
    locationType,
    quantity,
    movementType,
    referenceType,
    referenceId,
    createdBy,
    occurredAt,
    notes,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_movements_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryMovementsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(
        _movementTypeMeta,
        movementType.isAcceptableOrUnknown(
          data['movement_type']!,
          _movementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
        _referenceTypeMeta,
        referenceType.isAcceptableOrUnknown(
          data['reference_type']!,
          _referenceTypeMeta,
        ),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryMovementsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryMovementsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      movementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_type'],
      )!,
      referenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_type'],
      ),
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $InventoryMovementsTableTable createAlias(String alias) {
    return $InventoryMovementsTableTable(attachedDatabase, alias);
  }
}

class InventoryMovementsTableData extends DataClass
    implements Insertable<InventoryMovementsTableData> {
  final String id;
  final String productId;
  final String? locationId;
  final String? locationType;
  final double quantity;
  final String movementType;
  final String? referenceType;
  final String? referenceId;
  final String? createdBy;
  final DateTime occurredAt;
  final String? notes;
  final DateTime? syncedAt;
  const InventoryMovementsTableData({
    required this.id,
    required this.productId,
    this.locationId,
    this.locationType,
    required this.quantity,
    required this.movementType,
    this.referenceType,
    this.referenceId,
    this.createdBy,
    required this.occurredAt,
    this.notes,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || locationType != null) {
      map['location_type'] = Variable<String>(locationType);
    }
    map['quantity'] = Variable<double>(quantity);
    map['movement_type'] = Variable<String>(movementType);
    if (!nullToAbsent || referenceType != null) {
      map['reference_type'] = Variable<String>(referenceType);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  InventoryMovementsTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryMovementsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      locationType: locationType == null && nullToAbsent
          ? const Value.absent()
          : Value(locationType),
      quantity: Value(quantity),
      movementType: Value(movementType),
      referenceType: referenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceType),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      occurredAt: Value(occurredAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory InventoryMovementsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryMovementsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      locationType: serializer.fromJson<String?>(json['locationType']),
      quantity: serializer.fromJson<double>(json['quantity']),
      movementType: serializer.fromJson<String>(json['movementType']),
      referenceType: serializer.fromJson<String?>(json['referenceType']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'locationId': serializer.toJson<String?>(locationId),
      'locationType': serializer.toJson<String?>(locationType),
      'quantity': serializer.toJson<double>(quantity),
      'movementType': serializer.toJson<String>(movementType),
      'referenceType': serializer.toJson<String?>(referenceType),
      'referenceId': serializer.toJson<String?>(referenceId),
      'createdBy': serializer.toJson<String?>(createdBy),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'notes': serializer.toJson<String?>(notes),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  InventoryMovementsTableData copyWith({
    String? id,
    String? productId,
    Value<String?> locationId = const Value.absent(),
    Value<String?> locationType = const Value.absent(),
    double? quantity,
    String? movementType,
    Value<String?> referenceType = const Value.absent(),
    Value<String?> referenceId = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
    DateTime? occurredAt,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => InventoryMovementsTableData(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    locationId: locationId.present ? locationId.value : this.locationId,
    locationType: locationType.present ? locationType.value : this.locationType,
    quantity: quantity ?? this.quantity,
    movementType: movementType ?? this.movementType,
    referenceType: referenceType.present
        ? referenceType.value
        : this.referenceType,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    occurredAt: occurredAt ?? this.occurredAt,
    notes: notes.present ? notes.value : this.notes,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  InventoryMovementsTableData copyWithCompanion(
    InventoryMovementsTableCompanion data,
  ) {
    return InventoryMovementsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('quantity: $quantity, ')
          ..write('movementType: $movementType, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdBy: $createdBy, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    locationId,
    locationType,
    quantity,
    movementType,
    referenceType,
    referenceId,
    createdBy,
    occurredAt,
    notes,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMovementsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.locationId == this.locationId &&
          other.locationType == this.locationType &&
          other.quantity == this.quantity &&
          other.movementType == this.movementType &&
          other.referenceType == this.referenceType &&
          other.referenceId == this.referenceId &&
          other.createdBy == this.createdBy &&
          other.occurredAt == this.occurredAt &&
          other.notes == this.notes &&
          other.syncedAt == this.syncedAt);
}

class InventoryMovementsTableCompanion
    extends UpdateCompanion<InventoryMovementsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> locationId;
  final Value<String?> locationType;
  final Value<double> quantity;
  final Value<String> movementType;
  final Value<String?> referenceType;
  final Value<String?> referenceId;
  final Value<String?> createdBy;
  final Value<DateTime> occurredAt;
  final Value<String?> notes;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const InventoryMovementsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.movementType = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryMovementsTableCompanion.insert({
    required String id,
    required String productId,
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    required double quantity,
    required String movementType,
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.createdBy = const Value.absent(),
    required DateTime occurredAt,
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       quantity = Value(quantity),
       movementType = Value(movementType),
       occurredAt = Value(occurredAt);
  static Insertable<InventoryMovementsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? locationId,
    Expression<String>? locationType,
    Expression<double>? quantity,
    Expression<String>? movementType,
    Expression<String>? referenceType,
    Expression<String>? referenceId,
    Expression<String>? createdBy,
    Expression<DateTime>? occurredAt,
    Expression<String>? notes,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (locationId != null) 'location_id': locationId,
      if (locationType != null) 'location_type': locationType,
      if (quantity != null) 'quantity': quantity,
      if (movementType != null) 'movement_type': movementType,
      if (referenceType != null) 'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      if (createdBy != null) 'created_by': createdBy,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (notes != null) 'notes': notes,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryMovementsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String?>? locationId,
    Value<String?>? locationType,
    Value<double>? quantity,
    Value<String>? movementType,
    Value<String?>? referenceType,
    Value<String?>? referenceId,
    Value<String?>? createdBy,
    Value<DateTime>? occurredAt,
    Value<String?>? notes,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return InventoryMovementsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      quantity: quantity ?? this.quantity,
      movementType: movementType ?? this.movementType,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      createdBy: createdBy ?? this.createdBy,
      occurredAt: occurredAt ?? this.occurredAt,
      notes: notes ?? this.notes,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('quantity: $quantity, ')
          ..write('movementType: $movementType, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdBy: $createdBy, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseHeadersTableTable extends PurchaseHeadersTable
    with TableInfo<$PurchaseHeadersTableTable, PurchaseHeadersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseHeadersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationTypeMeta = const VerificationMeta(
    'locationType',
  );
  @override
  late final GeneratedColumn<String> locationType = GeneratedColumn<String>(
    'location_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierNameMeta = const VerificationMeta(
    'supplierName',
  );
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
    'supplier_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceCodeMeta = const VerificationMeta(
    'referenceCode',
  );
  @override
  late final GeneratedColumn<String> referenceCode = GeneratedColumn<String>(
    'reference_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByEmployeeIdMeta =
      const VerificationMeta('createdByEmployeeId');
  @override
  late final GeneratedColumn<String> createdByEmployeeId =
      GeneratedColumn<String>(
        'created_by_employee_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    locationType,
    supplierName,
    referenceCode,
    createdByEmployeeId,
    purchaseDate,
    totalCost,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_headers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseHeadersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('location_type')) {
      context.handle(
        _locationTypeMeta,
        locationType.isAcceptableOrUnknown(
          data['location_type']!,
          _locationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationTypeMeta);
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
        _supplierNameMeta,
        supplierName.isAcceptableOrUnknown(
          data['supplier_name']!,
          _supplierNameMeta,
        ),
      );
    }
    if (data.containsKey('reference_code')) {
      context.handle(
        _referenceCodeMeta,
        referenceCode.isAcceptableOrUnknown(
          data['reference_code']!,
          _referenceCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_by_employee_id')) {
      context.handle(
        _createdByEmployeeIdMeta,
        createdByEmployeeId.isAcceptableOrUnknown(
          data['created_by_employee_id']!,
          _createdByEmployeeIdMeta,
        ),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseHeadersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseHeadersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      locationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_type'],
      )!,
      supplierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_name'],
      ),
      referenceCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_code'],
      ),
      createdByEmployeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_employee_id'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PurchaseHeadersTableTable createAlias(String alias) {
    return $PurchaseHeadersTableTable(attachedDatabase, alias);
  }
}

class PurchaseHeadersTableData extends DataClass
    implements Insertable<PurchaseHeadersTableData> {
  final String id;
  final String locationId;
  final String locationType;
  final String? supplierName;
  final String? referenceCode;
  final String? createdByEmployeeId;
  final DateTime purchaseDate;
  final double totalCost;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const PurchaseHeadersTableData({
    required this.id,
    required this.locationId,
    required this.locationType,
    this.supplierName,
    this.referenceCode,
    this.createdByEmployeeId,
    required this.purchaseDate,
    required this.totalCost,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['location_type'] = Variable<String>(locationType);
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    if (!nullToAbsent || referenceCode != null) {
      map['reference_code'] = Variable<String>(referenceCode);
    }
    if (!nullToAbsent || createdByEmployeeId != null) {
      map['created_by_employee_id'] = Variable<String>(createdByEmployeeId);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['total_cost'] = Variable<double>(totalCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PurchaseHeadersTableCompanion toCompanion(bool nullToAbsent) {
    return PurchaseHeadersTableCompanion(
      id: Value(id),
      locationId: Value(locationId),
      locationType: Value(locationType),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      referenceCode: referenceCode == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceCode),
      createdByEmployeeId: createdByEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByEmployeeId),
      purchaseDate: Value(purchaseDate),
      totalCost: Value(totalCost),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PurchaseHeadersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseHeadersTableData(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      locationType: serializer.fromJson<String>(json['locationType']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      referenceCode: serializer.fromJson<String?>(json['referenceCode']),
      createdByEmployeeId: serializer.fromJson<String?>(
        json['createdByEmployeeId'],
      ),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'locationType': serializer.toJson<String>(locationType),
      'supplierName': serializer.toJson<String?>(supplierName),
      'referenceCode': serializer.toJson<String?>(referenceCode),
      'createdByEmployeeId': serializer.toJson<String?>(createdByEmployeeId),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'totalCost': serializer.toJson<double>(totalCost),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PurchaseHeadersTableData copyWith({
    String? id,
    String? locationId,
    String? locationType,
    Value<String?> supplierName = const Value.absent(),
    Value<String?> referenceCode = const Value.absent(),
    Value<String?> createdByEmployeeId = const Value.absent(),
    DateTime? purchaseDate,
    double? totalCost,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PurchaseHeadersTableData(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    locationType: locationType ?? this.locationType,
    supplierName: supplierName.present ? supplierName.value : this.supplierName,
    referenceCode: referenceCode.present
        ? referenceCode.value
        : this.referenceCode,
    createdByEmployeeId: createdByEmployeeId.present
        ? createdByEmployeeId.value
        : this.createdByEmployeeId,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    totalCost: totalCost ?? this.totalCost,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PurchaseHeadersTableData copyWithCompanion(
    PurchaseHeadersTableCompanion data,
  ) {
    return PurchaseHeadersTableData(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      locationType: data.locationType.present
          ? data.locationType.value
          : this.locationType,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      referenceCode: data.referenceCode.present
          ? data.referenceCode.value
          : this.referenceCode,
      createdByEmployeeId: data.createdByEmployeeId.present
          ? data.createdByEmployeeId.value
          : this.createdByEmployeeId,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHeadersTableData(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('supplierName: $supplierName, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locationId,
    locationType,
    supplierName,
    referenceCode,
    createdByEmployeeId,
    purchaseDate,
    totalCost,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseHeadersTableData &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.locationType == this.locationType &&
          other.supplierName == this.supplierName &&
          other.referenceCode == this.referenceCode &&
          other.createdByEmployeeId == this.createdByEmployeeId &&
          other.purchaseDate == this.purchaseDate &&
          other.totalCost == this.totalCost &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class PurchaseHeadersTableCompanion
    extends UpdateCompanion<PurchaseHeadersTableData> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> locationType;
  final Value<String?> supplierName;
  final Value<String?> referenceCode;
  final Value<String?> createdByEmployeeId;
  final Value<DateTime> purchaseDate;
  final Value<double> totalCost;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PurchaseHeadersTableCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationType = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.createdByEmployeeId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseHeadersTableCompanion.insert({
    required String id,
    required String locationId,
    required String locationType,
    this.supplierName = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.createdByEmployeeId = const Value.absent(),
    required DateTime purchaseDate,
    this.totalCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       locationId = Value(locationId),
       locationType = Value(locationType),
       purchaseDate = Value(purchaseDate);
  static Insertable<PurchaseHeadersTableData> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? locationType,
    Expression<String>? supplierName,
    Expression<String>? referenceCode,
    Expression<String>? createdByEmployeeId,
    Expression<DateTime>? purchaseDate,
    Expression<double>? totalCost,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (locationType != null) 'location_type': locationType,
      if (supplierName != null) 'supplier_name': supplierName,
      if (referenceCode != null) 'reference_code': referenceCode,
      if (createdByEmployeeId != null)
        'created_by_employee_id': createdByEmployeeId,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (totalCost != null) 'total_cost': totalCost,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseHeadersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? locationId,
    Value<String>? locationType,
    Value<String?>? supplierName,
    Value<String?>? referenceCode,
    Value<String?>? createdByEmployeeId,
    Value<DateTime>? purchaseDate,
    Value<double>? totalCost,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PurchaseHeadersTableCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      supplierName: supplierName ?? this.supplierName,
      referenceCode: referenceCode ?? this.referenceCode,
      createdByEmployeeId: createdByEmployeeId ?? this.createdByEmployeeId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationType.present) {
      map['location_type'] = Variable<String>(locationType.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (referenceCode.present) {
      map['reference_code'] = Variable<String>(referenceCode.value);
    }
    if (createdByEmployeeId.present) {
      map['created_by_employee_id'] = Variable<String>(
        createdByEmployeeId.value,
      );
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHeadersTableCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('locationType: $locationType, ')
          ..write('supplierName: $supplierName, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('totalCost: $totalCost, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTableTable extends PurchaseItemsTable
    with TableInfo<$PurchaseItemsTableTable, PurchaseItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    productId,
    quantity,
    unitCost,
    totalCost,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cost'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
    );
  }

  @override
  $PurchaseItemsTableTable createAlias(String alias) {
    return $PurchaseItemsTableTable(attachedDatabase, alias);
  }
}

class PurchaseItemsTableData extends DataClass
    implements Insertable<PurchaseItemsTableData> {
  final String id;
  final String purchaseId;
  final String productId;
  final double quantity;
  final double unitCost;
  final double totalCost;
  const PurchaseItemsTableData({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_cost'] = Variable<double>(unitCost);
    map['total_cost'] = Variable<double>(totalCost);
    return map;
  }

  PurchaseItemsTableCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsTableCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitCost: Value(unitCost),
      totalCost: Value(totalCost),
    );
  }

  factory PurchaseItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitCost': serializer.toJson<double>(unitCost),
      'totalCost': serializer.toJson<double>(totalCost),
    };
  }

  PurchaseItemsTableData copyWith({
    String? id,
    String? purchaseId,
    String? productId,
    double? quantity,
    double? unitCost,
    double? totalCost,
  }) => PurchaseItemsTableData(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitCost: unitCost ?? this.unitCost,
    totalCost: totalCost ?? this.totalCost,
  );
  PurchaseItemsTableData copyWithCompanion(PurchaseItemsTableCompanion data) {
    return PurchaseItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsTableData(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('totalCost: $totalCost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, productId, quantity, unitCost, totalCost);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItemsTableData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitCost == this.unitCost &&
          other.totalCost == this.totalCost);
}

class PurchaseItemsTableCompanion
    extends UpdateCompanion<PurchaseItemsTableData> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<double> unitCost;
  final Value<double> totalCost;
  final Value<int> rowid;
  const PurchaseItemsTableCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsTableCompanion.insert({
    required String id,
    required String purchaseId,
    required String productId,
    required double quantity,
    this.unitCost = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseId = Value(purchaseId),
       productId = Value(productId),
       quantity = Value(quantity);
  static Insertable<PurchaseItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<double>? unitCost,
    Expression<double>? totalCost,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitCost != null) 'unit_cost': unitCost,
      if (totalCost != null) 'total_cost': totalCost,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseId,
    Value<String>? productId,
    Value<double>? quantity,
    Value<double>? unitCost,
    Value<double>? totalCost,
    Value<int>? rowid,
  }) {
    return PurchaseItemsTableCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('totalCost: $totalCost, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesHeadersTableTable extends SalesHeadersTable
    with TableInfo<$SalesHeadersTableTable, SalesHeadersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesHeadersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceCodeMeta = const VerificationMeta(
    'referenceCode',
  );
  @override
  late final GeneratedColumn<String> referenceCode = GeneratedColumn<String>(
    'reference_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByEmployeeIdMeta =
      const VerificationMeta('createdByEmployeeId');
  @override
  late final GeneratedColumn<String> createdByEmployeeId =
      GeneratedColumn<String>(
        'created_by_employee_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _saleDateMeta = const VerificationMeta(
    'saleDate',
  );
  @override
  late final GeneratedColumn<DateTime> saleDate = GeneratedColumn<DateTime>(
    'sale_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    referenceCode,
    customerName,
    createdByEmployeeId,
    saleDate,
    totalAmount,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_headers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalesHeadersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('reference_code')) {
      context.handle(
        _referenceCodeMeta,
        referenceCode.isAcceptableOrUnknown(
          data['reference_code']!,
          _referenceCodeMeta,
        ),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('created_by_employee_id')) {
      context.handle(
        _createdByEmployeeIdMeta,
        createdByEmployeeId.isAcceptableOrUnknown(
          data['created_by_employee_id']!,
          _createdByEmployeeIdMeta,
        ),
      );
    }
    if (data.containsKey('sale_date')) {
      context.handle(
        _saleDateMeta,
        saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta),
      );
    } else if (isInserting) {
      context.missing(_saleDateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesHeadersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesHeadersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      referenceCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_code'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      createdByEmployeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_employee_id'],
      ),
      saleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sale_date'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SalesHeadersTableTable createAlias(String alias) {
    return $SalesHeadersTableTable(attachedDatabase, alias);
  }
}

class SalesHeadersTableData extends DataClass
    implements Insertable<SalesHeadersTableData> {
  final String id;
  final String storeId;
  final String? referenceCode;
  final String? customerName;
  final String? createdByEmployeeId;
  final DateTime saleDate;
  final double totalAmount;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const SalesHeadersTableData({
    required this.id,
    required this.storeId,
    this.referenceCode,
    this.customerName,
    this.createdByEmployeeId,
    required this.saleDate,
    required this.totalAmount,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    if (!nullToAbsent || referenceCode != null) {
      map['reference_code'] = Variable<String>(referenceCode);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || createdByEmployeeId != null) {
      map['created_by_employee_id'] = Variable<String>(createdByEmployeeId);
    }
    map['sale_date'] = Variable<DateTime>(saleDate);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SalesHeadersTableCompanion toCompanion(bool nullToAbsent) {
    return SalesHeadersTableCompanion(
      id: Value(id),
      storeId: Value(storeId),
      referenceCode: referenceCode == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceCode),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      createdByEmployeeId: createdByEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByEmployeeId),
      saleDate: Value(saleDate),
      totalAmount: Value(totalAmount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SalesHeadersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesHeadersTableData(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      referenceCode: serializer.fromJson<String?>(json['referenceCode']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      createdByEmployeeId: serializer.fromJson<String?>(
        json['createdByEmployeeId'],
      ),
      saleDate: serializer.fromJson<DateTime>(json['saleDate']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'referenceCode': serializer.toJson<String?>(referenceCode),
      'customerName': serializer.toJson<String?>(customerName),
      'createdByEmployeeId': serializer.toJson<String?>(createdByEmployeeId),
      'saleDate': serializer.toJson<DateTime>(saleDate),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SalesHeadersTableData copyWith({
    String? id,
    String? storeId,
    Value<String?> referenceCode = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    Value<String?> createdByEmployeeId = const Value.absent(),
    DateTime? saleDate,
    double? totalAmount,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SalesHeadersTableData(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    referenceCode: referenceCode.present
        ? referenceCode.value
        : this.referenceCode,
    customerName: customerName.present ? customerName.value : this.customerName,
    createdByEmployeeId: createdByEmployeeId.present
        ? createdByEmployeeId.value
        : this.createdByEmployeeId,
    saleDate: saleDate ?? this.saleDate,
    totalAmount: totalAmount ?? this.totalAmount,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SalesHeadersTableData copyWithCompanion(SalesHeadersTableCompanion data) {
    return SalesHeadersTableData(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      referenceCode: data.referenceCode.present
          ? data.referenceCode.value
          : this.referenceCode,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      createdByEmployeeId: data.createdByEmployeeId.present
          ? data.createdByEmployeeId.value
          : this.createdByEmployeeId,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesHeadersTableData(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('customerName: $customerName, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('saleDate: $saleDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    referenceCode,
    customerName,
    createdByEmployeeId,
    saleDate,
    totalAmount,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesHeadersTableData &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.referenceCode == this.referenceCode &&
          other.customerName == this.customerName &&
          other.createdByEmployeeId == this.createdByEmployeeId &&
          other.saleDate == this.saleDate &&
          other.totalAmount == this.totalAmount &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class SalesHeadersTableCompanion
    extends UpdateCompanion<SalesHeadersTableData> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String?> referenceCode;
  final Value<String?> customerName;
  final Value<String?> createdByEmployeeId;
  final Value<DateTime> saleDate;
  final Value<double> totalAmount;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SalesHeadersTableCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.referenceCode = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdByEmployeeId = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesHeadersTableCompanion.insert({
    required String id,
    required String storeId,
    this.referenceCode = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdByEmployeeId = const Value.absent(),
    required DateTime saleDate,
    this.totalAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       saleDate = Value(saleDate);
  static Insertable<SalesHeadersTableData> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? referenceCode,
    Expression<String>? customerName,
    Expression<String>? createdByEmployeeId,
    Expression<DateTime>? saleDate,
    Expression<double>? totalAmount,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (referenceCode != null) 'reference_code': referenceCode,
      if (customerName != null) 'customer_name': customerName,
      if (createdByEmployeeId != null)
        'created_by_employee_id': createdByEmployeeId,
      if (saleDate != null) 'sale_date': saleDate,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesHeadersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String?>? referenceCode,
    Value<String?>? customerName,
    Value<String?>? createdByEmployeeId,
    Value<DateTime>? saleDate,
    Value<double>? totalAmount,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SalesHeadersTableCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      referenceCode: referenceCode ?? this.referenceCode,
      customerName: customerName ?? this.customerName,
      createdByEmployeeId: createdByEmployeeId ?? this.createdByEmployeeId,
      saleDate: saleDate ?? this.saleDate,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (referenceCode.present) {
      map['reference_code'] = Variable<String>(referenceCode.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (createdByEmployeeId.present) {
      map['created_by_employee_id'] = Variable<String>(
        createdByEmployeeId.value,
      );
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<DateTime>(saleDate.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesHeadersTableCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('referenceCode: $referenceCode, ')
          ..write('customerName: $customerName, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('saleDate: $saleDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesItemsTableTable extends SalesItemsTable
    with TableInfo<$SalesItemsTableTable, SalesItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    quantity,
    unitPrice,
    totalPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalesItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
    );
  }

  @override
  $SalesItemsTableTable createAlias(String alias) {
    return $SalesItemsTableTable(attachedDatabase, alias);
  }
}

class SalesItemsTableData extends DataClass
    implements Insertable<SalesItemsTableData> {
  final String id;
  final String saleId;
  final String productId;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  const SalesItemsTableData({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['total_price'] = Variable<double>(totalPrice);
    return map;
  }

  SalesItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SalesItemsTableCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      totalPrice: Value(totalPrice),
    );
  }

  factory SalesItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'totalPrice': serializer.toJson<double>(totalPrice),
    };
  }

  SalesItemsTableData copyWith({
    String? id,
    String? saleId,
    String? productId,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
  }) => SalesItemsTableData(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    totalPrice: totalPrice ?? this.totalPrice,
  );
  SalesItemsTableData copyWithCompanion(SalesItemsTableCompanion data) {
    return SalesItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesItemsTableData(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalPrice: $totalPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, productId, quantity, unitPrice, totalPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesItemsTableData &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.totalPrice == this.totalPrice);
}

class SalesItemsTableCompanion extends UpdateCompanion<SalesItemsTableData> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> totalPrice;
  final Value<int> rowid;
  const SalesItemsTableCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesItemsTableCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required double quantity,
    this.unitPrice = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       quantity = Value(quantity);
  static Insertable<SalesItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? totalPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (totalPrice != null) 'total_price': totalPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<double>? totalPrice,
    Value<int>? rowid,
  }) {
    return SalesItemsTableCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransferHeadersTableTable extends TransferHeadersTable
    with TableInfo<$TransferHeadersTableTable, TransferHeadersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferHeadersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originLocationIdMeta = const VerificationMeta(
    'originLocationId',
  );
  @override
  late final GeneratedColumn<String> originLocationId = GeneratedColumn<String>(
    'origin_location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originLocationTypeMeta =
      const VerificationMeta('originLocationType');
  @override
  late final GeneratedColumn<String> originLocationType =
      GeneratedColumn<String>(
        'origin_location_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _destinationLocationIdMeta =
      const VerificationMeta('destinationLocationId');
  @override
  late final GeneratedColumn<String> destinationLocationId =
      GeneratedColumn<String>(
        'destination_location_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _destinationLocationTypeMeta =
      const VerificationMeta('destinationLocationType');
  @override
  late final GeneratedColumn<String> destinationLocationType =
      GeneratedColumn<String>(
        'destination_location_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _requestedByEmployeeIdMeta =
      const VerificationMeta('requestedByEmployeeId');
  @override
  late final GeneratedColumn<String> requestedByEmployeeId =
      GeneratedColumn<String>(
        'requested_by_employee_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _transferDateMeta = const VerificationMeta(
    'transferDate',
  );
  @override
  late final GeneratedColumn<DateTime> transferDate = GeneratedColumn<DateTime>(
    'transfer_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    originLocationId,
    originLocationType,
    destinationLocationId,
    destinationLocationType,
    requestedByEmployeeId,
    transferDate,
    status,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_headers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferHeadersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('origin_location_id')) {
      context.handle(
        _originLocationIdMeta,
        originLocationId.isAcceptableOrUnknown(
          data['origin_location_id']!,
          _originLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originLocationIdMeta);
    }
    if (data.containsKey('origin_location_type')) {
      context.handle(
        _originLocationTypeMeta,
        originLocationType.isAcceptableOrUnknown(
          data['origin_location_type']!,
          _originLocationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originLocationTypeMeta);
    }
    if (data.containsKey('destination_location_id')) {
      context.handle(
        _destinationLocationIdMeta,
        destinationLocationId.isAcceptableOrUnknown(
          data['destination_location_id']!,
          _destinationLocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationLocationIdMeta);
    }
    if (data.containsKey('destination_location_type')) {
      context.handle(
        _destinationLocationTypeMeta,
        destinationLocationType.isAcceptableOrUnknown(
          data['destination_location_type']!,
          _destinationLocationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationLocationTypeMeta);
    }
    if (data.containsKey('requested_by_employee_id')) {
      context.handle(
        _requestedByEmployeeIdMeta,
        requestedByEmployeeId.isAcceptableOrUnknown(
          data['requested_by_employee_id']!,
          _requestedByEmployeeIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_date')) {
      context.handle(
        _transferDateMeta,
        transferDate.isAcceptableOrUnknown(
          data['transfer_date']!,
          _transferDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transferDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferHeadersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferHeadersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      originLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_location_id'],
      )!,
      originLocationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_location_type'],
      )!,
      destinationLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_location_id'],
      )!,
      destinationLocationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_location_type'],
      )!,
      requestedByEmployeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_by_employee_id'],
      ),
      transferDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transfer_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $TransferHeadersTableTable createAlias(String alias) {
    return $TransferHeadersTableTable(attachedDatabase, alias);
  }
}

class TransferHeadersTableData extends DataClass
    implements Insertable<TransferHeadersTableData> {
  final String id;
  final String originLocationId;
  final String originLocationType;
  final String destinationLocationId;
  final String destinationLocationType;
  final String? requestedByEmployeeId;
  final DateTime transferDate;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const TransferHeadersTableData({
    required this.id,
    required this.originLocationId,
    required this.originLocationType,
    required this.destinationLocationId,
    required this.destinationLocationType,
    this.requestedByEmployeeId,
    required this.transferDate,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['origin_location_id'] = Variable<String>(originLocationId);
    map['origin_location_type'] = Variable<String>(originLocationType);
    map['destination_location_id'] = Variable<String>(destinationLocationId);
    map['destination_location_type'] = Variable<String>(
      destinationLocationType,
    );
    if (!nullToAbsent || requestedByEmployeeId != null) {
      map['requested_by_employee_id'] = Variable<String>(requestedByEmployeeId);
    }
    map['transfer_date'] = Variable<DateTime>(transferDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  TransferHeadersTableCompanion toCompanion(bool nullToAbsent) {
    return TransferHeadersTableCompanion(
      id: Value(id),
      originLocationId: Value(originLocationId),
      originLocationType: Value(originLocationType),
      destinationLocationId: Value(destinationLocationId),
      destinationLocationType: Value(destinationLocationType),
      requestedByEmployeeId: requestedByEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedByEmployeeId),
      transferDate: Value(transferDate),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory TransferHeadersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferHeadersTableData(
      id: serializer.fromJson<String>(json['id']),
      originLocationId: serializer.fromJson<String>(json['originLocationId']),
      originLocationType: serializer.fromJson<String>(
        json['originLocationType'],
      ),
      destinationLocationId: serializer.fromJson<String>(
        json['destinationLocationId'],
      ),
      destinationLocationType: serializer.fromJson<String>(
        json['destinationLocationType'],
      ),
      requestedByEmployeeId: serializer.fromJson<String?>(
        json['requestedByEmployeeId'],
      ),
      transferDate: serializer.fromJson<DateTime>(json['transferDate']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'originLocationId': serializer.toJson<String>(originLocationId),
      'originLocationType': serializer.toJson<String>(originLocationType),
      'destinationLocationId': serializer.toJson<String>(destinationLocationId),
      'destinationLocationType': serializer.toJson<String>(
        destinationLocationType,
      ),
      'requestedByEmployeeId': serializer.toJson<String?>(
        requestedByEmployeeId,
      ),
      'transferDate': serializer.toJson<DateTime>(transferDate),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  TransferHeadersTableData copyWith({
    String? id,
    String? originLocationId,
    String? originLocationType,
    String? destinationLocationId,
    String? destinationLocationType,
    Value<String?> requestedByEmployeeId = const Value.absent(),
    DateTime? transferDate,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => TransferHeadersTableData(
    id: id ?? this.id,
    originLocationId: originLocationId ?? this.originLocationId,
    originLocationType: originLocationType ?? this.originLocationType,
    destinationLocationId: destinationLocationId ?? this.destinationLocationId,
    destinationLocationType:
        destinationLocationType ?? this.destinationLocationType,
    requestedByEmployeeId: requestedByEmployeeId.present
        ? requestedByEmployeeId.value
        : this.requestedByEmployeeId,
    transferDate: transferDate ?? this.transferDate,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  TransferHeadersTableData copyWithCompanion(
    TransferHeadersTableCompanion data,
  ) {
    return TransferHeadersTableData(
      id: data.id.present ? data.id.value : this.id,
      originLocationId: data.originLocationId.present
          ? data.originLocationId.value
          : this.originLocationId,
      originLocationType: data.originLocationType.present
          ? data.originLocationType.value
          : this.originLocationType,
      destinationLocationId: data.destinationLocationId.present
          ? data.destinationLocationId.value
          : this.destinationLocationId,
      destinationLocationType: data.destinationLocationType.present
          ? data.destinationLocationType.value
          : this.destinationLocationType,
      requestedByEmployeeId: data.requestedByEmployeeId.present
          ? data.requestedByEmployeeId.value
          : this.requestedByEmployeeId,
      transferDate: data.transferDate.present
          ? data.transferDate.value
          : this.transferDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferHeadersTableData(')
          ..write('id: $id, ')
          ..write('originLocationId: $originLocationId, ')
          ..write('originLocationType: $originLocationType, ')
          ..write('destinationLocationId: $destinationLocationId, ')
          ..write('destinationLocationType: $destinationLocationType, ')
          ..write('requestedByEmployeeId: $requestedByEmployeeId, ')
          ..write('transferDate: $transferDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    originLocationId,
    originLocationType,
    destinationLocationId,
    destinationLocationType,
    requestedByEmployeeId,
    transferDate,
    status,
    notes,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferHeadersTableData &&
          other.id == this.id &&
          other.originLocationId == this.originLocationId &&
          other.originLocationType == this.originLocationType &&
          other.destinationLocationId == this.destinationLocationId &&
          other.destinationLocationType == this.destinationLocationType &&
          other.requestedByEmployeeId == this.requestedByEmployeeId &&
          other.transferDate == this.transferDate &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class TransferHeadersTableCompanion
    extends UpdateCompanion<TransferHeadersTableData> {
  final Value<String> id;
  final Value<String> originLocationId;
  final Value<String> originLocationType;
  final Value<String> destinationLocationId;
  final Value<String> destinationLocationType;
  final Value<String?> requestedByEmployeeId;
  final Value<DateTime> transferDate;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const TransferHeadersTableCompanion({
    this.id = const Value.absent(),
    this.originLocationId = const Value.absent(),
    this.originLocationType = const Value.absent(),
    this.destinationLocationId = const Value.absent(),
    this.destinationLocationType = const Value.absent(),
    this.requestedByEmployeeId = const Value.absent(),
    this.transferDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransferHeadersTableCompanion.insert({
    required String id,
    required String originLocationId,
    required String originLocationType,
    required String destinationLocationId,
    required String destinationLocationType,
    this.requestedByEmployeeId = const Value.absent(),
    required DateTime transferDate,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       originLocationId = Value(originLocationId),
       originLocationType = Value(originLocationType),
       destinationLocationId = Value(destinationLocationId),
       destinationLocationType = Value(destinationLocationType),
       transferDate = Value(transferDate);
  static Insertable<TransferHeadersTableData> custom({
    Expression<String>? id,
    Expression<String>? originLocationId,
    Expression<String>? originLocationType,
    Expression<String>? destinationLocationId,
    Expression<String>? destinationLocationType,
    Expression<String>? requestedByEmployeeId,
    Expression<DateTime>? transferDate,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originLocationId != null) 'origin_location_id': originLocationId,
      if (originLocationType != null)
        'origin_location_type': originLocationType,
      if (destinationLocationId != null)
        'destination_location_id': destinationLocationId,
      if (destinationLocationType != null)
        'destination_location_type': destinationLocationType,
      if (requestedByEmployeeId != null)
        'requested_by_employee_id': requestedByEmployeeId,
      if (transferDate != null) 'transfer_date': transferDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransferHeadersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? originLocationId,
    Value<String>? originLocationType,
    Value<String>? destinationLocationId,
    Value<String>? destinationLocationType,
    Value<String?>? requestedByEmployeeId,
    Value<DateTime>? transferDate,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return TransferHeadersTableCompanion(
      id: id ?? this.id,
      originLocationId: originLocationId ?? this.originLocationId,
      originLocationType: originLocationType ?? this.originLocationType,
      destinationLocationId:
          destinationLocationId ?? this.destinationLocationId,
      destinationLocationType:
          destinationLocationType ?? this.destinationLocationType,
      requestedByEmployeeId:
          requestedByEmployeeId ?? this.requestedByEmployeeId,
      transferDate: transferDate ?? this.transferDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (originLocationId.present) {
      map['origin_location_id'] = Variable<String>(originLocationId.value);
    }
    if (originLocationType.present) {
      map['origin_location_type'] = Variable<String>(originLocationType.value);
    }
    if (destinationLocationId.present) {
      map['destination_location_id'] = Variable<String>(
        destinationLocationId.value,
      );
    }
    if (destinationLocationType.present) {
      map['destination_location_type'] = Variable<String>(
        destinationLocationType.value,
      );
    }
    if (requestedByEmployeeId.present) {
      map['requested_by_employee_id'] = Variable<String>(
        requestedByEmployeeId.value,
      );
    }
    if (transferDate.present) {
      map['transfer_date'] = Variable<DateTime>(transferDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferHeadersTableCompanion(')
          ..write('id: $id, ')
          ..write('originLocationId: $originLocationId, ')
          ..write('originLocationType: $originLocationType, ')
          ..write('destinationLocationId: $destinationLocationId, ')
          ..write('destinationLocationType: $destinationLocationType, ')
          ..write('requestedByEmployeeId: $requestedByEmployeeId, ')
          ..write('transferDate: $transferDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransferItemsTableTable extends TransferItemsTable
    with TableInfo<$TransferItemsTableTable, TransferItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transferIdMeta = const VerificationMeta(
    'transferId',
  );
  @override
  late final GeneratedColumn<String> transferId = GeneratedColumn<String>(
    'transfer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, transferId, productId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
        _transferIdMeta,
        transferId.isAcceptableOrUnknown(data['transfer_id']!, _transferIdMeta),
      );
    } else if (isInserting) {
      context.missing(_transferIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transferId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $TransferItemsTableTable createAlias(String alias) {
    return $TransferItemsTableTable(attachedDatabase, alias);
  }
}

class TransferItemsTableData extends DataClass
    implements Insertable<TransferItemsTableData> {
  final String id;
  final String transferId;
  final String productId;
  final double quantity;
  const TransferItemsTableData({
    required this.id,
    required this.transferId,
    required this.productId,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transfer_id'] = Variable<String>(transferId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    return map;
  }

  TransferItemsTableCompanion toCompanion(bool nullToAbsent) {
    return TransferItemsTableCompanion(
      id: Value(id),
      transferId: Value(transferId),
      productId: Value(productId),
      quantity: Value(quantity),
    );
  }

  factory TransferItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      transferId: serializer.fromJson<String>(json['transferId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transferId': serializer.toJson<String>(transferId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
    };
  }

  TransferItemsTableData copyWith({
    String? id,
    String? transferId,
    String? productId,
    double? quantity,
  }) => TransferItemsTableData(
    id: id ?? this.id,
    transferId: transferId ?? this.transferId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
  );
  TransferItemsTableData copyWithCompanion(TransferItemsTableCompanion data) {
    return TransferItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      transferId: data.transferId.present
          ? data.transferId.value
          : this.transferId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferItemsTableData(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transferId, productId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferItemsTableData &&
          other.id == this.id &&
          other.transferId == this.transferId &&
          other.productId == this.productId &&
          other.quantity == this.quantity);
}

class TransferItemsTableCompanion
    extends UpdateCompanion<TransferItemsTableData> {
  final Value<String> id;
  final Value<String> transferId;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<int> rowid;
  const TransferItemsTableCompanion({
    this.id = const Value.absent(),
    this.transferId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransferItemsTableCompanion.insert({
    required String id,
    required String transferId,
    required String productId,
    required double quantity,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transferId = Value(transferId),
       productId = Value(productId),
       quantity = Value(quantity);
  static Insertable<TransferItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? transferId,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transferId != null) 'transfer_id': transferId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransferItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? transferId,
    Value<String>? productId,
    Value<double>? quantity,
    Value<int>? rowid,
  }) {
    return TransferItemsTableCompanion(
      id: id ?? this.id,
      transferId: transferId ?? this.transferId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<String>(transferId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AuthCredentialsTableTable authCredentialsTable =
      $AuthCredentialsTableTable(this);
  late final $SellersTableTable sellersTable = $SellersTableTable(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $InventoryLocationsTableTable inventoryLocationsTable =
      $InventoryLocationsTableTable(this);
  late final $EmployeesTableTable employeesTable = $EmployeesTableTable(this);
  late final $InventoryStocksTableTable inventoryStocksTable =
      $InventoryStocksTableTable(this);
  late final $InventoryMovementsTableTable inventoryMovementsTable =
      $InventoryMovementsTableTable(this);
  late final $PurchaseHeadersTableTable purchaseHeadersTable =
      $PurchaseHeadersTableTable(this);
  late final $PurchaseItemsTableTable purchaseItemsTable =
      $PurchaseItemsTableTable(this);
  late final $SalesHeadersTableTable salesHeadersTable =
      $SalesHeadersTableTable(this);
  late final $SalesItemsTableTable salesItemsTable = $SalesItemsTableTable(
    this,
  );
  late final $TransferHeadersTableTable transferHeadersTable =
      $TransferHeadersTableTable(this);
  late final $TransferItemsTableTable transferItemsTable =
      $TransferItemsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    authCredentialsTable,
    sellersTable,
    productsTable,
    inventoryLocationsTable,
    employeesTable,
    inventoryStocksTable,
    inventoryMovementsTable,
    purchaseHeadersTable,
    purchaseItemsTable,
    salesHeadersTable,
    salesItemsTable,
    transferHeadersTable,
    transferItemsTable,
  ];
}

typedef $$AuthCredentialsTableTableCreateCompanionBuilder =
    AuthCredentialsTableCompanion Function({
      required String userId,
      required String email,
      Value<String?> displayName,
      required String hashedPassword,
      required String passwordSalt,
      required String encryptedAccessToken,
      Value<String?> encryptedRefreshToken,
      Value<int?> expiresAt,
      Value<String?> jsonUserMetadata,
      Value<String> role,
      Value<String?> sellerId,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AuthCredentialsTableTableUpdateCompanionBuilder =
    AuthCredentialsTableCompanion Function({
      Value<String> userId,
      Value<String> email,
      Value<String?> displayName,
      Value<String> hashedPassword,
      Value<String> passwordSalt,
      Value<String> encryptedAccessToken,
      Value<String?> encryptedRefreshToken,
      Value<int?> expiresAt,
      Value<String?> jsonUserMetadata,
      Value<String> role,
      Value<String?> sellerId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AuthCredentialsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedAccessToken => $composableBuilder(
    column: $table.encryptedAccessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedRefreshToken => $composableBuilder(
    column: $table.encryptedRefreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonUserMetadata => $composableBuilder(
    column: $table.jsonUserMetadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sellerId => $composableBuilder(
    column: $table.sellerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthCredentialsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedAccessToken => $composableBuilder(
    column: $table.encryptedAccessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedRefreshToken => $composableBuilder(
    column: $table.encryptedRefreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonUserMetadata => $composableBuilder(
    column: $table.jsonUserMetadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sellerId => $composableBuilder(
    column: $table.sellerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthCredentialsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthCredentialsTableTable> {
  $$AuthCredentialsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encryptedAccessToken => $composableBuilder(
    column: $table.encryptedAccessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encryptedRefreshToken => $composableBuilder(
    column: $table.encryptedRefreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get jsonUserMetadata => $composableBuilder(
    column: $table.jsonUserMetadata,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get sellerId =>
      $composableBuilder(column: $table.sellerId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AuthCredentialsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthCredentialsTableTable,
          AuthCredentialsTableData,
          $$AuthCredentialsTableTableFilterComposer,
          $$AuthCredentialsTableTableOrderingComposer,
          $$AuthCredentialsTableTableAnnotationComposer,
          $$AuthCredentialsTableTableCreateCompanionBuilder,
          $$AuthCredentialsTableTableUpdateCompanionBuilder,
          (
            AuthCredentialsTableData,
            BaseReferences<
              _$AppDatabase,
              $AuthCredentialsTableTable,
              AuthCredentialsTableData
            >,
          ),
          AuthCredentialsTableData,
          PrefetchHooks Function()
        > {
  $$AuthCredentialsTableTableTableManager(
    _$AppDatabase db,
    $AuthCredentialsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthCredentialsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthCredentialsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AuthCredentialsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> hashedPassword = const Value.absent(),
                Value<String> passwordSalt = const Value.absent(),
                Value<String> encryptedAccessToken = const Value.absent(),
                Value<String?> encryptedRefreshToken = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<String?> jsonUserMetadata = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> sellerId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthCredentialsTableCompanion(
                userId: userId,
                email: email,
                displayName: displayName,
                hashedPassword: hashedPassword,
                passwordSalt: passwordSalt,
                encryptedAccessToken: encryptedAccessToken,
                encryptedRefreshToken: encryptedRefreshToken,
                expiresAt: expiresAt,
                jsonUserMetadata: jsonUserMetadata,
                role: role,
                sellerId: sellerId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String email,
                Value<String?> displayName = const Value.absent(),
                required String hashedPassword,
                required String passwordSalt,
                required String encryptedAccessToken,
                Value<String?> encryptedRefreshToken = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<String?> jsonUserMetadata = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> sellerId = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AuthCredentialsTableCompanion.insert(
                userId: userId,
                email: email,
                displayName: displayName,
                hashedPassword: hashedPassword,
                passwordSalt: passwordSalt,
                encryptedAccessToken: encryptedAccessToken,
                encryptedRefreshToken: encryptedRefreshToken,
                expiresAt: expiresAt,
                jsonUserMetadata: jsonUserMetadata,
                role: role,
                sellerId: sellerId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthCredentialsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthCredentialsTableTable,
      AuthCredentialsTableData,
      $$AuthCredentialsTableTableFilterComposer,
      $$AuthCredentialsTableTableOrderingComposer,
      $$AuthCredentialsTableTableAnnotationComposer,
      $$AuthCredentialsTableTableCreateCompanionBuilder,
      $$AuthCredentialsTableTableUpdateCompanionBuilder,
      (
        AuthCredentialsTableData,
        BaseReferences<
          _$AppDatabase,
          $AuthCredentialsTableTable,
          AuthCredentialsTableData
        >,
      ),
      AuthCredentialsTableData,
      PrefetchHooks Function()
    >;
typedef $$SellersTableTableCreateCompanionBuilder =
    SellersTableCompanion Function({
      required String id,
      required String userId,
      required String storeName,
      Value<String?> storeSlug,
      Value<String?> description,
      Value<String?> logoUrl,
      Value<String?> bannerUrl,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$SellersTableTableUpdateCompanionBuilder =
    SellersTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> storeName,
      Value<String?> storeSlug,
      Value<String?> description,
      Value<String?> logoUrl,
      Value<String?> bannerUrl,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$SellersTableTableFilterComposer
    extends Composer<_$AppDatabase, $SellersTableTable> {
  $$SellersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeSlug => $composableBuilder(
    column: $table.storeSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SellersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SellersTableTable> {
  $$SellersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeSlug => $composableBuilder(
    column: $table.storeSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bannerUrl => $composableBuilder(
    column: $table.bannerUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SellersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SellersTableTable> {
  $$SellersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get storeSlug =>
      $composableBuilder(column: $table.storeSlug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get bannerUrl =>
      $composableBuilder(column: $table.bannerUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SellersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SellersTableTable,
          SellersTableData,
          $$SellersTableTableFilterComposer,
          $$SellersTableTableOrderingComposer,
          $$SellersTableTableAnnotationComposer,
          $$SellersTableTableCreateCompanionBuilder,
          $$SellersTableTableUpdateCompanionBuilder,
          (
            SellersTableData,
            BaseReferences<_$AppDatabase, $SellersTableTable, SellersTableData>,
          ),
          SellersTableData,
          PrefetchHooks Function()
        > {
  $$SellersTableTableTableManager(_$AppDatabase db, $SellersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SellersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SellersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SellersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String?> storeSlug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SellersTableCompanion(
                id: id,
                userId: userId,
                storeName: storeName,
                storeSlug: storeSlug,
                description: description,
                logoUrl: logoUrl,
                bannerUrl: bannerUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String storeName,
                Value<String?> storeSlug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> bannerUrl = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SellersTableCompanion.insert(
                id: id,
                userId: userId,
                storeName: storeName,
                storeSlug: storeSlug,
                description: description,
                logoUrl: logoUrl,
                bannerUrl: bannerUrl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SellersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SellersTableTable,
      SellersTableData,
      $$SellersTableTableFilterComposer,
      $$SellersTableTableOrderingComposer,
      $$SellersTableTableAnnotationComposer,
      $$SellersTableTableCreateCompanionBuilder,
      $$SellersTableTableUpdateCompanionBuilder,
      (
        SellersTableData,
        BaseReferences<_$AppDatabase, $SellersTableTable, SellersTableData>,
      ),
      SellersTableData,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      required String id,
      required String sellerId,
      required String name,
      Value<String?> description,
      Value<String?> category,
      Value<String?> unit,
      Value<double> price,
      Value<int?> quantity,
      Value<bool> isTrending,
      Value<bool> inStock,
      Value<double?> rating,
      Value<bool> isDirty,
      Value<String?> pendingOperation,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<String?> metadataJson,
      Value<int> rowid,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<String> id,
      Value<String> sellerId,
      Value<String> name,
      Value<String?> description,
      Value<String?> category,
      Value<String?> unit,
      Value<double> price,
      Value<int?> quantity,
      Value<bool> isTrending,
      Value<bool> inStock,
      Value<double?> rating,
      Value<bool> isDirty,
      Value<String?> pendingOperation,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<String?> metadataJson,
      Value<int> rowid,
    });

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sellerId => $composableBuilder(
    column: $table.sellerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTrending => $composableBuilder(
    column: $table.isTrending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inStock => $composableBuilder(
    column: $table.inStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sellerId => $composableBuilder(
    column: $table.sellerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTrending => $composableBuilder(
    column: $table.isTrending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inStock => $composableBuilder(
    column: $table.inStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sellerId =>
      $composableBuilder(column: $table.sellerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isTrending => $composableBuilder(
    column: $table.isTrending,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inStock =>
      $composableBuilder(column: $table.inStock, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTableTable,
          ProductsTableData,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (
            ProductsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProductsTableTable,
              ProductsTableData
            >,
          ),
          ProductsTableData,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sellerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int?> quantity = const Value.absent(),
                Value<bool> isTrending = const Value.absent(),
                Value<bool> inStock = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                sellerId: sellerId,
                name: name,
                description: description,
                category: category,
                unit: unit,
                price: price,
                quantity: quantity,
                isTrending: isTrending,
                inStock: inStock,
                rating: rating,
                isDirty: isDirty,
                pendingOperation: pendingOperation,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sellerId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int?> quantity = const Value.absent(),
                Value<bool> isTrending = const Value.absent(),
                Value<bool> inStock = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                sellerId: sellerId,
                name: name,
                description: description,
                category: category,
                unit: unit,
                price: price,
                quantity: quantity,
                isTrending: isTrending,
                inStock: inStock,
                rating: rating,
                isDirty: isDirty,
                pendingOperation: pendingOperation,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTableTable,
      ProductsTableData,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (
        ProductsTableData,
        BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>,
      ),
      ProductsTableData,
      PrefetchHooks Function()
    >;
typedef $$InventoryLocationsTableTableCreateCompanionBuilder =
    InventoryLocationsTableCompanion Function({
      required String id,
      required String type,
      Value<String?> code,
      required String name,
      Value<String?> description,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> managerId,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$InventoryLocationsTableTableUpdateCompanionBuilder =
    InventoryLocationsTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String?> code,
      Value<String> name,
      Value<String?> description,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> managerId,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$InventoryLocationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryLocationsTableTable,
          InventoryLocationsTableData
        > {
  $$InventoryLocationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EmployeesTableTable, List<EmployeesTableData>>
  _employeesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.employeesTable,
    aliasName: $_aliasNameGenerator(
      db.inventoryLocationsTable.id,
      db.employeesTable.locationId,
    ),
  );

  $$EmployeesTableTableProcessedTableManager get employeesTableRefs {
    final manager = $$EmployeesTableTableTableManager(
      $_db,
      $_db.employeesTable,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InventoryLocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryLocationsTableTable> {
  $$InventoryLocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get managerId => $composableBuilder(
    column: $table.managerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> employeesTableRefs(
    Expression<bool> Function($$EmployeesTableTableFilterComposer f) f,
  ) {
    final $$EmployeesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employeesTable,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableTableFilterComposer(
            $db: $db,
            $table: $db.employeesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InventoryLocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryLocationsTableTable> {
  $$InventoryLocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get managerId => $composableBuilder(
    column: $table.managerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryLocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryLocationsTableTable> {
  $$InventoryLocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get managerId =>
      $composableBuilder(column: $table.managerId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> employeesTableRefs<T extends Object>(
    Expression<T> Function($$EmployeesTableTableAnnotationComposer a) f,
  ) {
    final $$EmployeesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employeesTable,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.employeesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InventoryLocationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryLocationsTableTable,
          InventoryLocationsTableData,
          $$InventoryLocationsTableTableFilterComposer,
          $$InventoryLocationsTableTableOrderingComposer,
          $$InventoryLocationsTableTableAnnotationComposer,
          $$InventoryLocationsTableTableCreateCompanionBuilder,
          $$InventoryLocationsTableTableUpdateCompanionBuilder,
          (
            InventoryLocationsTableData,
            $$InventoryLocationsTableTableReferences,
          ),
          InventoryLocationsTableData,
          PrefetchHooks Function({bool employeesTableRefs})
        > {
  $$InventoryLocationsTableTableTableManager(
    _$AppDatabase db,
    $InventoryLocationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryLocationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InventoryLocationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryLocationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> managerId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryLocationsTableCompanion(
                id: id,
                type: type,
                code: code,
                name: name,
                description: description,
                address: address,
                phone: phone,
                managerId: managerId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                Value<String?> code = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> managerId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryLocationsTableCompanion.insert(
                id: id,
                type: type,
                code: code,
                name: name,
                description: description,
                address: address,
                phone: phone,
                managerId: managerId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryLocationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (employeesTableRefs) db.employeesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (employeesTableRefs)
                    await $_getPrefetchedData<
                      InventoryLocationsTableData,
                      $InventoryLocationsTableTable,
                      EmployeesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$InventoryLocationsTableTableReferences
                          ._employeesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$InventoryLocationsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).employeesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.locationId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$InventoryLocationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryLocationsTableTable,
      InventoryLocationsTableData,
      $$InventoryLocationsTableTableFilterComposer,
      $$InventoryLocationsTableTableOrderingComposer,
      $$InventoryLocationsTableTableAnnotationComposer,
      $$InventoryLocationsTableTableCreateCompanionBuilder,
      $$InventoryLocationsTableTableUpdateCompanionBuilder,
      (InventoryLocationsTableData, $$InventoryLocationsTableTableReferences),
      InventoryLocationsTableData,
      PrefetchHooks Function({bool employeesTableRefs})
    >;
typedef $$EmployeesTableTableCreateCompanionBuilder =
    EmployeesTableCompanion Function({
      required String id,
      required String firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> authUserId,
      required String role,
      Value<String?> locationId,
      Value<String?> locationType,
      Value<bool> isActive,
      Value<DateTime?> hiredAt,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$EmployeesTableTableUpdateCompanionBuilder =
    EmployeesTableCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> authUserId,
      Value<String> role,
      Value<String?> locationId,
      Value<String?> locationType,
      Value<bool> isActive,
      Value<DateTime?> hiredAt,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$EmployeesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmployeesTableTable,
          EmployeesTableData
        > {
  $$EmployeesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InventoryLocationsTableTable _locationIdTable(_$AppDatabase db) =>
      db.inventoryLocationsTable.createAlias(
        $_aliasNameGenerator(
          db.employeesTable.locationId,
          db.inventoryLocationsTable.id,
        ),
      );

  $$InventoryLocationsTableTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<String>('location_id');
    if ($_column == null) return null;
    final manager = $$InventoryLocationsTableTableTableManager(
      $_db,
      $_db.inventoryLocationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmployeesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hiredAt => $composableBuilder(
    column: $table.hiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InventoryLocationsTableTableFilterComposer get locationId {
    final $$InventoryLocationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.locationId,
          referencedTable: $db.inventoryLocationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryLocationsTableTableFilterComposer(
                $db: $db,
                $table: $db.inventoryLocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hiredAt => $composableBuilder(
    column: $table.hiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InventoryLocationsTableTableOrderingComposer get locationId {
    final $$InventoryLocationsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.locationId,
          referencedTable: $db.inventoryLocationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryLocationsTableTableOrderingComposer(
                $db: $db,
                $table: $db.inventoryLocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTableTable> {
  $$EmployeesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get hiredAt =>
      $composableBuilder(column: $table.hiredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$InventoryLocationsTableTableAnnotationComposer get locationId {
    final $$InventoryLocationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.locationId,
          referencedTable: $db.inventoryLocationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryLocationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryLocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTableTable,
          EmployeesTableData,
          $$EmployeesTableTableFilterComposer,
          $$EmployeesTableTableOrderingComposer,
          $$EmployeesTableTableAnnotationComposer,
          $$EmployeesTableTableCreateCompanionBuilder,
          $$EmployeesTableTableUpdateCompanionBuilder,
          (EmployeesTableData, $$EmployeesTableTableReferences),
          EmployeesTableData,
          PrefetchHooks Function({bool locationId})
        > {
  $$EmployeesTableTableTableManager(
    _$AppDatabase db,
    $EmployeesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> authUserId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> locationType = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> hiredAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeesTableCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                authUserId: authUserId,
                role: role,
                locationId: locationId,
                locationType: locationType,
                isActive: isActive,
                hiredAt: hiredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> authUserId = const Value.absent(),
                required String role,
                Value<String?> locationId = const Value.absent(),
                Value<String?> locationType = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> hiredAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeesTableCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                authUserId: authUserId,
                role: role,
                locationId: locationId,
                locationType: locationType,
                isActive: isActive,
                hiredAt: hiredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable: $$EmployeesTableTableReferences
                                    ._locationIdTable(db),
                                referencedColumn:
                                    $$EmployeesTableTableReferences
                                        ._locationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmployeesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTableTable,
      EmployeesTableData,
      $$EmployeesTableTableFilterComposer,
      $$EmployeesTableTableOrderingComposer,
      $$EmployeesTableTableAnnotationComposer,
      $$EmployeesTableTableCreateCompanionBuilder,
      $$EmployeesTableTableUpdateCompanionBuilder,
      (EmployeesTableData, $$EmployeesTableTableReferences),
      EmployeesTableData,
      PrefetchHooks Function({bool locationId})
    >;
typedef $$InventoryStocksTableTableCreateCompanionBuilder =
    InventoryStocksTableCompanion Function({
      required String productId,
      required String locationId,
      Value<String> locationType,
      Value<double> quantityOnHand,
      Value<double> quantityReserved,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$InventoryStocksTableTableUpdateCompanionBuilder =
    InventoryStocksTableCompanion Function({
      Value<String> productId,
      Value<String> locationId,
      Value<String> locationType,
      Value<double> quantityOnHand,
      Value<double> quantityReserved,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$InventoryStocksTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryStocksTableTable> {
  $$InventoryStocksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityReserved => $composableBuilder(
    column: $table.quantityReserved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryStocksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryStocksTableTable> {
  $$InventoryStocksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityReserved => $composableBuilder(
    column: $table.quantityReserved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryStocksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryStocksTableTable> {
  $$InventoryStocksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityOnHand => $composableBuilder(
    column: $table.quantityOnHand,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityReserved => $composableBuilder(
    column: $table.quantityReserved,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InventoryStocksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryStocksTableTable,
          InventoryStocksTableData,
          $$InventoryStocksTableTableFilterComposer,
          $$InventoryStocksTableTableOrderingComposer,
          $$InventoryStocksTableTableAnnotationComposer,
          $$InventoryStocksTableTableCreateCompanionBuilder,
          $$InventoryStocksTableTableUpdateCompanionBuilder,
          (
            InventoryStocksTableData,
            BaseReferences<
              _$AppDatabase,
              $InventoryStocksTableTable,
              InventoryStocksTableData
            >,
          ),
          InventoryStocksTableData,
          PrefetchHooks Function()
        > {
  $$InventoryStocksTableTableTableManager(
    _$AppDatabase db,
    $InventoryStocksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryStocksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryStocksTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryStocksTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> locationType = const Value.absent(),
                Value<double> quantityOnHand = const Value.absent(),
                Value<double> quantityReserved = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryStocksTableCompanion(
                productId: productId,
                locationId: locationId,
                locationType: locationType,
                quantityOnHand: quantityOnHand,
                quantityReserved: quantityReserved,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String locationId,
                Value<String> locationType = const Value.absent(),
                Value<double> quantityOnHand = const Value.absent(),
                Value<double> quantityReserved = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryStocksTableCompanion.insert(
                productId: productId,
                locationId: locationId,
                locationType: locationType,
                quantityOnHand: quantityOnHand,
                quantityReserved: quantityReserved,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryStocksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryStocksTableTable,
      InventoryStocksTableData,
      $$InventoryStocksTableTableFilterComposer,
      $$InventoryStocksTableTableOrderingComposer,
      $$InventoryStocksTableTableAnnotationComposer,
      $$InventoryStocksTableTableCreateCompanionBuilder,
      $$InventoryStocksTableTableUpdateCompanionBuilder,
      (
        InventoryStocksTableData,
        BaseReferences<
          _$AppDatabase,
          $InventoryStocksTableTable,
          InventoryStocksTableData
        >,
      ),
      InventoryStocksTableData,
      PrefetchHooks Function()
    >;
typedef $$InventoryMovementsTableTableCreateCompanionBuilder =
    InventoryMovementsTableCompanion Function({
      required String id,
      required String productId,
      Value<String?> locationId,
      Value<String?> locationType,
      required double quantity,
      required String movementType,
      Value<String?> referenceType,
      Value<String?> referenceId,
      Value<String?> createdBy,
      required DateTime occurredAt,
      Value<String?> notes,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$InventoryMovementsTableTableUpdateCompanionBuilder =
    InventoryMovementsTableCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String?> locationId,
      Value<String?> locationType,
      Value<double> quantity,
      Value<String> movementType,
      Value<String?> referenceType,
      Value<String?> referenceId,
      Value<String?> createdBy,
      Value<DateTime> occurredAt,
      Value<String?> notes,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$InventoryMovementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTableTable> {
  $$InventoryMovementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryMovementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTableTable> {
  $$InventoryMovementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryMovementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTableTable> {
  $$InventoryMovementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$InventoryMovementsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryMovementsTableTable,
          InventoryMovementsTableData,
          $$InventoryMovementsTableTableFilterComposer,
          $$InventoryMovementsTableTableOrderingComposer,
          $$InventoryMovementsTableTableAnnotationComposer,
          $$InventoryMovementsTableTableCreateCompanionBuilder,
          $$InventoryMovementsTableTableUpdateCompanionBuilder,
          (
            InventoryMovementsTableData,
            BaseReferences<
              _$AppDatabase,
              $InventoryMovementsTableTable,
              InventoryMovementsTableData
            >,
          ),
          InventoryMovementsTableData,
          PrefetchHooks Function()
        > {
  $$InventoryMovementsTableTableTableManager(
    _$AppDatabase db,
    $InventoryMovementsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryMovementsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InventoryMovementsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryMovementsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> locationType = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> movementType = const Value.absent(),
                Value<String?> referenceType = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryMovementsTableCompanion(
                id: id,
                productId: productId,
                locationId: locationId,
                locationType: locationType,
                quantity: quantity,
                movementType: movementType,
                referenceType: referenceType,
                referenceId: referenceId,
                createdBy: createdBy,
                occurredAt: occurredAt,
                notes: notes,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                Value<String?> locationId = const Value.absent(),
                Value<String?> locationType = const Value.absent(),
                required double quantity,
                required String movementType,
                Value<String?> referenceType = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                required DateTime occurredAt,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryMovementsTableCompanion.insert(
                id: id,
                productId: productId,
                locationId: locationId,
                locationType: locationType,
                quantity: quantity,
                movementType: movementType,
                referenceType: referenceType,
                referenceId: referenceId,
                createdBy: createdBy,
                occurredAt: occurredAt,
                notes: notes,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryMovementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryMovementsTableTable,
      InventoryMovementsTableData,
      $$InventoryMovementsTableTableFilterComposer,
      $$InventoryMovementsTableTableOrderingComposer,
      $$InventoryMovementsTableTableAnnotationComposer,
      $$InventoryMovementsTableTableCreateCompanionBuilder,
      $$InventoryMovementsTableTableUpdateCompanionBuilder,
      (
        InventoryMovementsTableData,
        BaseReferences<
          _$AppDatabase,
          $InventoryMovementsTableTable,
          InventoryMovementsTableData
        >,
      ),
      InventoryMovementsTableData,
      PrefetchHooks Function()
    >;
typedef $$PurchaseHeadersTableTableCreateCompanionBuilder =
    PurchaseHeadersTableCompanion Function({
      required String id,
      required String locationId,
      required String locationType,
      Value<String?> supplierName,
      Value<String?> referenceCode,
      Value<String?> createdByEmployeeId,
      required DateTime purchaseDate,
      Value<double> totalCost,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PurchaseHeadersTableTableUpdateCompanionBuilder =
    PurchaseHeadersTableCompanion Function({
      Value<String> id,
      Value<String> locationId,
      Value<String> locationType,
      Value<String?> supplierName,
      Value<String?> referenceCode,
      Value<String?> createdByEmployeeId,
      Value<DateTime> purchaseDate,
      Value<double> totalCost,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$PurchaseHeadersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseHeadersTableTable> {
  $$PurchaseHeadersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseHeadersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseHeadersTableTable> {
  $$PurchaseHeadersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseHeadersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseHeadersTableTable> {
  $$PurchaseHeadersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationType => $composableBuilder(
    column: $table.locationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PurchaseHeadersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseHeadersTableTable,
          PurchaseHeadersTableData,
          $$PurchaseHeadersTableTableFilterComposer,
          $$PurchaseHeadersTableTableOrderingComposer,
          $$PurchaseHeadersTableTableAnnotationComposer,
          $$PurchaseHeadersTableTableCreateCompanionBuilder,
          $$PurchaseHeadersTableTableUpdateCompanionBuilder,
          (
            PurchaseHeadersTableData,
            BaseReferences<
              _$AppDatabase,
              $PurchaseHeadersTableTable,
              PurchaseHeadersTableData
            >,
          ),
          PurchaseHeadersTableData,
          PrefetchHooks Function()
        > {
  $$PurchaseHeadersTableTableTableManager(
    _$AppDatabase db,
    $PurchaseHeadersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseHeadersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseHeadersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PurchaseHeadersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> locationType = const Value.absent(),
                Value<String?> supplierName = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> createdByEmployeeId = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHeadersTableCompanion(
                id: id,
                locationId: locationId,
                locationType: locationType,
                supplierName: supplierName,
                referenceCode: referenceCode,
                createdByEmployeeId: createdByEmployeeId,
                purchaseDate: purchaseDate,
                totalCost: totalCost,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String locationId,
                required String locationType,
                Value<String?> supplierName = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> createdByEmployeeId = const Value.absent(),
                required DateTime purchaseDate,
                Value<double> totalCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHeadersTableCompanion.insert(
                id: id,
                locationId: locationId,
                locationType: locationType,
                supplierName: supplierName,
                referenceCode: referenceCode,
                createdByEmployeeId: createdByEmployeeId,
                purchaseDate: purchaseDate,
                totalCost: totalCost,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseHeadersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseHeadersTableTable,
      PurchaseHeadersTableData,
      $$PurchaseHeadersTableTableFilterComposer,
      $$PurchaseHeadersTableTableOrderingComposer,
      $$PurchaseHeadersTableTableAnnotationComposer,
      $$PurchaseHeadersTableTableCreateCompanionBuilder,
      $$PurchaseHeadersTableTableUpdateCompanionBuilder,
      (
        PurchaseHeadersTableData,
        BaseReferences<
          _$AppDatabase,
          $PurchaseHeadersTableTable,
          PurchaseHeadersTableData
        >,
      ),
      PurchaseHeadersTableData,
      PrefetchHooks Function()
    >;
typedef $$PurchaseItemsTableTableCreateCompanionBuilder =
    PurchaseItemsTableCompanion Function({
      required String id,
      required String purchaseId,
      required String productId,
      required double quantity,
      Value<double> unitCost,
      Value<double> totalCost,
      Value<int> rowid,
    });
typedef $$PurchaseItemsTableTableUpdateCompanionBuilder =
    PurchaseItemsTableCompanion Function({
      Value<String> id,
      Value<String> purchaseId,
      Value<String> productId,
      Value<double> quantity,
      Value<double> unitCost,
      Value<double> totalCost,
      Value<int> rowid,
    });

class $$PurchaseItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);
}

class $$PurchaseItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTableTable,
          PurchaseItemsTableData,
          $$PurchaseItemsTableTableFilterComposer,
          $$PurchaseItemsTableTableOrderingComposer,
          $$PurchaseItemsTableTableAnnotationComposer,
          $$PurchaseItemsTableTableCreateCompanionBuilder,
          $$PurchaseItemsTableTableUpdateCompanionBuilder,
          (
            PurchaseItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $PurchaseItemsTableTable,
              PurchaseItemsTableData
            >,
          ),
          PurchaseItemsTableData,
          PrefetchHooks Function()
        > {
  $$PurchaseItemsTableTableTableManager(
    _$AppDatabase db,
    $PurchaseItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitCost = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsTableCompanion(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                quantity: quantity,
                unitCost: unitCost,
                totalCost: totalCost,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseId,
                required String productId,
                required double quantity,
                Value<double> unitCost = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsTableCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                quantity: quantity,
                unitCost: unitCost,
                totalCost: totalCost,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTableTable,
      PurchaseItemsTableData,
      $$PurchaseItemsTableTableFilterComposer,
      $$PurchaseItemsTableTableOrderingComposer,
      $$PurchaseItemsTableTableAnnotationComposer,
      $$PurchaseItemsTableTableCreateCompanionBuilder,
      $$PurchaseItemsTableTableUpdateCompanionBuilder,
      (
        PurchaseItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $PurchaseItemsTableTable,
          PurchaseItemsTableData
        >,
      ),
      PurchaseItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$SalesHeadersTableTableCreateCompanionBuilder =
    SalesHeadersTableCompanion Function({
      required String id,
      required String storeId,
      Value<String?> referenceCode,
      Value<String?> customerName,
      Value<String?> createdByEmployeeId,
      required DateTime saleDate,
      Value<double> totalAmount,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$SalesHeadersTableTableUpdateCompanionBuilder =
    SalesHeadersTableCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String?> referenceCode,
      Value<String?> customerName,
      Value<String?> createdByEmployeeId,
      Value<DateTime> saleDate,
      Value<double> totalAmount,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$SalesHeadersTableTableFilterComposer
    extends Composer<_$AppDatabase, $SalesHeadersTableTable> {
  $$SalesHeadersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesHeadersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesHeadersTableTable> {
  $$SalesHeadersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesHeadersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesHeadersTableTable> {
  $$SalesHeadersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get referenceCode => $composableBuilder(
    column: $table.referenceCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByEmployeeId => $composableBuilder(
    column: $table.createdByEmployeeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SalesHeadersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesHeadersTableTable,
          SalesHeadersTableData,
          $$SalesHeadersTableTableFilterComposer,
          $$SalesHeadersTableTableOrderingComposer,
          $$SalesHeadersTableTableAnnotationComposer,
          $$SalesHeadersTableTableCreateCompanionBuilder,
          $$SalesHeadersTableTableUpdateCompanionBuilder,
          (
            SalesHeadersTableData,
            BaseReferences<
              _$AppDatabase,
              $SalesHeadersTableTable,
              SalesHeadersTableData
            >,
          ),
          SalesHeadersTableData,
          PrefetchHooks Function()
        > {
  $$SalesHeadersTableTableTableManager(
    _$AppDatabase db,
    $SalesHeadersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesHeadersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesHeadersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesHeadersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> createdByEmployeeId = const Value.absent(),
                Value<DateTime> saleDate = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesHeadersTableCompanion(
                id: id,
                storeId: storeId,
                referenceCode: referenceCode,
                customerName: customerName,
                createdByEmployeeId: createdByEmployeeId,
                saleDate: saleDate,
                totalAmount: totalAmount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                Value<String?> referenceCode = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> createdByEmployeeId = const Value.absent(),
                required DateTime saleDate,
                Value<double> totalAmount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesHeadersTableCompanion.insert(
                id: id,
                storeId: storeId,
                referenceCode: referenceCode,
                customerName: customerName,
                createdByEmployeeId: createdByEmployeeId,
                saleDate: saleDate,
                totalAmount: totalAmount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesHeadersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesHeadersTableTable,
      SalesHeadersTableData,
      $$SalesHeadersTableTableFilterComposer,
      $$SalesHeadersTableTableOrderingComposer,
      $$SalesHeadersTableTableAnnotationComposer,
      $$SalesHeadersTableTableCreateCompanionBuilder,
      $$SalesHeadersTableTableUpdateCompanionBuilder,
      (
        SalesHeadersTableData,
        BaseReferences<
          _$AppDatabase,
          $SalesHeadersTableTable,
          SalesHeadersTableData
        >,
      ),
      SalesHeadersTableData,
      PrefetchHooks Function()
    >;
typedef $$SalesItemsTableTableCreateCompanionBuilder =
    SalesItemsTableCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required double quantity,
      Value<double> unitPrice,
      Value<double> totalPrice,
      Value<int> rowid,
    });
typedef $$SalesItemsTableTableUpdateCompanionBuilder =
    SalesItemsTableCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<double> totalPrice,
      Value<int> rowid,
    });

class $$SalesItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SalesItemsTableTable> {
  $$SalesItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesItemsTableTable> {
  $$SalesItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesItemsTableTable> {
  $$SalesItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );
}

class $$SalesItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesItemsTableTable,
          SalesItemsTableData,
          $$SalesItemsTableTableFilterComposer,
          $$SalesItemsTableTableOrderingComposer,
          $$SalesItemsTableTableAnnotationComposer,
          $$SalesItemsTableTableCreateCompanionBuilder,
          $$SalesItemsTableTableUpdateCompanionBuilder,
          (
            SalesItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $SalesItemsTableTable,
              SalesItemsTableData
            >,
          ),
          SalesItemsTableData,
          PrefetchHooks Function()
        > {
  $$SalesItemsTableTableTableManager(
    _$AppDatabase db,
    $SalesItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesItemsTableCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                totalPrice: totalPrice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required double quantity,
                Value<double> unitPrice = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesItemsTableCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                totalPrice: totalPrice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesItemsTableTable,
      SalesItemsTableData,
      $$SalesItemsTableTableFilterComposer,
      $$SalesItemsTableTableOrderingComposer,
      $$SalesItemsTableTableAnnotationComposer,
      $$SalesItemsTableTableCreateCompanionBuilder,
      $$SalesItemsTableTableUpdateCompanionBuilder,
      (
        SalesItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $SalesItemsTableTable,
          SalesItemsTableData
        >,
      ),
      SalesItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$TransferHeadersTableTableCreateCompanionBuilder =
    TransferHeadersTableCompanion Function({
      required String id,
      required String originLocationId,
      required String originLocationType,
      required String destinationLocationId,
      required String destinationLocationType,
      Value<String?> requestedByEmployeeId,
      required DateTime transferDate,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$TransferHeadersTableTableUpdateCompanionBuilder =
    TransferHeadersTableCompanion Function({
      Value<String> id,
      Value<String> originLocationId,
      Value<String> originLocationType,
      Value<String> destinationLocationId,
      Value<String> destinationLocationType,
      Value<String?> requestedByEmployeeId,
      Value<DateTime> transferDate,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$TransferHeadersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransferHeadersTableTable> {
  $$TransferHeadersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originLocationId => $composableBuilder(
    column: $table.originLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originLocationType => $composableBuilder(
    column: $table.originLocationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationLocationId => $composableBuilder(
    column: $table.destinationLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationLocationType => $composableBuilder(
    column: $table.destinationLocationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedByEmployeeId => $composableBuilder(
    column: $table.requestedByEmployeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransferHeadersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransferHeadersTableTable> {
  $$TransferHeadersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originLocationId => $composableBuilder(
    column: $table.originLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originLocationType => $composableBuilder(
    column: $table.originLocationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationLocationId => $composableBuilder(
    column: $table.destinationLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationLocationType => $composableBuilder(
    column: $table.destinationLocationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedByEmployeeId => $composableBuilder(
    column: $table.requestedByEmployeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransferHeadersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransferHeadersTableTable> {
  $$TransferHeadersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originLocationId => $composableBuilder(
    column: $table.originLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originLocationType => $composableBuilder(
    column: $table.originLocationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationLocationId => $composableBuilder(
    column: $table.destinationLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationLocationType => $composableBuilder(
    column: $table.destinationLocationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestedByEmployeeId => $composableBuilder(
    column: $table.requestedByEmployeeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$TransferHeadersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransferHeadersTableTable,
          TransferHeadersTableData,
          $$TransferHeadersTableTableFilterComposer,
          $$TransferHeadersTableTableOrderingComposer,
          $$TransferHeadersTableTableAnnotationComposer,
          $$TransferHeadersTableTableCreateCompanionBuilder,
          $$TransferHeadersTableTableUpdateCompanionBuilder,
          (
            TransferHeadersTableData,
            BaseReferences<
              _$AppDatabase,
              $TransferHeadersTableTable,
              TransferHeadersTableData
            >,
          ),
          TransferHeadersTableData,
          PrefetchHooks Function()
        > {
  $$TransferHeadersTableTableTableManager(
    _$AppDatabase db,
    $TransferHeadersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferHeadersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferHeadersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransferHeadersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> originLocationId = const Value.absent(),
                Value<String> originLocationType = const Value.absent(),
                Value<String> destinationLocationId = const Value.absent(),
                Value<String> destinationLocationType = const Value.absent(),
                Value<String?> requestedByEmployeeId = const Value.absent(),
                Value<DateTime> transferDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransferHeadersTableCompanion(
                id: id,
                originLocationId: originLocationId,
                originLocationType: originLocationType,
                destinationLocationId: destinationLocationId,
                destinationLocationType: destinationLocationType,
                requestedByEmployeeId: requestedByEmployeeId,
                transferDate: transferDate,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String originLocationId,
                required String originLocationType,
                required String destinationLocationId,
                required String destinationLocationType,
                Value<String?> requestedByEmployeeId = const Value.absent(),
                required DateTime transferDate,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransferHeadersTableCompanion.insert(
                id: id,
                originLocationId: originLocationId,
                originLocationType: originLocationType,
                destinationLocationId: destinationLocationId,
                destinationLocationType: destinationLocationType,
                requestedByEmployeeId: requestedByEmployeeId,
                transferDate: transferDate,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransferHeadersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransferHeadersTableTable,
      TransferHeadersTableData,
      $$TransferHeadersTableTableFilterComposer,
      $$TransferHeadersTableTableOrderingComposer,
      $$TransferHeadersTableTableAnnotationComposer,
      $$TransferHeadersTableTableCreateCompanionBuilder,
      $$TransferHeadersTableTableUpdateCompanionBuilder,
      (
        TransferHeadersTableData,
        BaseReferences<
          _$AppDatabase,
          $TransferHeadersTableTable,
          TransferHeadersTableData
        >,
      ),
      TransferHeadersTableData,
      PrefetchHooks Function()
    >;
typedef $$TransferItemsTableTableCreateCompanionBuilder =
    TransferItemsTableCompanion Function({
      required String id,
      required String transferId,
      required String productId,
      required double quantity,
      Value<int> rowid,
    });
typedef $$TransferItemsTableTableUpdateCompanionBuilder =
    TransferItemsTableCompanion Function({
      Value<String> id,
      Value<String> transferId,
      Value<String> productId,
      Value<double> quantity,
      Value<int> rowid,
    });

class $$TransferItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransferItemsTableTable> {
  $$TransferItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransferItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransferItemsTableTable> {
  $$TransferItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransferItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransferItemsTableTable> {
  $$TransferItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$TransferItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransferItemsTableTable,
          TransferItemsTableData,
          $$TransferItemsTableTableFilterComposer,
          $$TransferItemsTableTableOrderingComposer,
          $$TransferItemsTableTableAnnotationComposer,
          $$TransferItemsTableTableCreateCompanionBuilder,
          $$TransferItemsTableTableUpdateCompanionBuilder,
          (
            TransferItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransferItemsTableTable,
              TransferItemsTableData
            >,
          ),
          TransferItemsTableData,
          PrefetchHooks Function()
        > {
  $$TransferItemsTableTableTableManager(
    _$AppDatabase db,
    $TransferItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransferItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transferId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransferItemsTableCompanion(
                id: id,
                transferId: transferId,
                productId: productId,
                quantity: quantity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transferId,
                required String productId,
                required double quantity,
                Value<int> rowid = const Value.absent(),
              }) => TransferItemsTableCompanion.insert(
                id: id,
                transferId: transferId,
                productId: productId,
                quantity: quantity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransferItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransferItemsTableTable,
      TransferItemsTableData,
      $$TransferItemsTableTableFilterComposer,
      $$TransferItemsTableTableOrderingComposer,
      $$TransferItemsTableTableAnnotationComposer,
      $$TransferItemsTableTableCreateCompanionBuilder,
      $$TransferItemsTableTableUpdateCompanionBuilder,
      (
        TransferItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransferItemsTableTable,
          TransferItemsTableData
        >,
      ),
      TransferItemsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AuthCredentialsTableTableTableManager get authCredentialsTable =>
      $$AuthCredentialsTableTableTableManager(_db, _db.authCredentialsTable);
  $$SellersTableTableTableManager get sellersTable =>
      $$SellersTableTableTableManager(_db, _db.sellersTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$InventoryLocationsTableTableTableManager get inventoryLocationsTable =>
      $$InventoryLocationsTableTableTableManager(
        _db,
        _db.inventoryLocationsTable,
      );
  $$EmployeesTableTableTableManager get employeesTable =>
      $$EmployeesTableTableTableManager(_db, _db.employeesTable);
  $$InventoryStocksTableTableTableManager get inventoryStocksTable =>
      $$InventoryStocksTableTableTableManager(_db, _db.inventoryStocksTable);
  $$InventoryMovementsTableTableTableManager get inventoryMovementsTable =>
      $$InventoryMovementsTableTableTableManager(
        _db,
        _db.inventoryMovementsTable,
      );
  $$PurchaseHeadersTableTableTableManager get purchaseHeadersTable =>
      $$PurchaseHeadersTableTableTableManager(_db, _db.purchaseHeadersTable);
  $$PurchaseItemsTableTableTableManager get purchaseItemsTable =>
      $$PurchaseItemsTableTableTableManager(_db, _db.purchaseItemsTable);
  $$SalesHeadersTableTableTableManager get salesHeadersTable =>
      $$SalesHeadersTableTableTableManager(_db, _db.salesHeadersTable);
  $$SalesItemsTableTableTableManager get salesItemsTable =>
      $$SalesItemsTableTableTableManager(_db, _db.salesItemsTable);
  $$TransferHeadersTableTableTableManager get transferHeadersTable =>
      $$TransferHeadersTableTableTableManager(_db, _db.transferHeadersTable);
  $$TransferItemsTableTableTableManager get transferItemsTable =>
      $$TransferItemsTableTableTableManager(_db, _db.transferItemsTable);
}
