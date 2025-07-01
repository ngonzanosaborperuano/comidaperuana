import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/network/models/api_response.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/core/constants/option.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([
  ApiService,
  FirebaseAuth,
  GoogleSignIn,
  UserCredential,
  User,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  ISecureStorageService,
])
void main() {
  late UserRepository userRepository;
  late MockApiService mockApiService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockISecureStorageService mockSecureStorageService;

  setUp(() {
    mockApiService = MockApiService();
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockSecureStorageService = MockISecureStorageService();
    userRepository = UserRepository(
      apiService: mockApiService,
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
      secureStorage: mockSecureStorageService,
    );
  });

  group('loginWithGoogle', () {
    test('returns (true, "Login or registration successful") on success',
        () async {
      final mockGoogleSignInAccount = MockGoogleSignInAccount();
      final mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

            when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('test_access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('test_id_token');
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn('http://example.com/photo.jpg');
      when(mockApiService.get(
              endpoint: anyNamed('endpoint'), fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(success: true, data: {'id': 1}));
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: AuthUser.empty().toJson()));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.loginWithGoogle();

      expect(result, (true, 'Login or registration successful'));
    });
  });

  group('loginWithEmailPass', () {
    test('returns (true, "Login or registration successful") on success',
        () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn('http://example.com/photo.jpg');
      when(mockApiService.get(
              endpoint: anyNamed('endpoint'), fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(success: true, data: {'id': 1}));
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: AuthUser.empty().toJson()));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.loginWithEmailPass(AuthUser(
        email: 'test@example.com',
        contrasena: 'password',
      ));

      expect(result, (true, 'Login or registration successful'));
    });
  });

  group('login', () {
    test('returns (true, "Login or registration successful") when type is LoginWith.withUserPassword', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn('http://example.com/photo.jpg');
      when(mockApiService.get(
              endpoint: anyNamed('endpoint'), fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(success: true, data: {'id': 1}));
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: AuthUser.empty().toJson()));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.login(
        user: AuthUser(email: 'test@example.com', contrasena: 'password'),
        type: LoginWith.withUserPassword,
      );

      expect(result, (true, 'Login or registration successful'));
    });
  });

  group('signInOrRegister', () {
    test('registers user if not exists', () async {
      final user = AuthUser(email: 'new@example.com', contrasena: 'password');

      when(mockApiService.get(
              endpoint: anyNamed('endpoint'), fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(success: true, data: {'id': 0}));
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: 1));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.signInOrRegister(user);

      expect(result, (true, 'Login or registration successful'));
      verify(mockApiService.post(endpoint: 'users', body: user.toJson(), fromJson: anyNamed('fromJson'))).called(1);
    });

    test('logs in user if exists', () async {
      final user = AuthUser(email: 'existing@example.com', contrasena: 'password');

      when(mockApiService.get(
              endpoint: anyNamed('endpoint'), fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(success: true, data: {'id': 1}));
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: AuthUser.empty().toJson()));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.signInOrRegister(user);

      expect(result, (true, 'Login or registration successful'));
      verify(mockApiService.post(endpoint: 'users/login', body: user.toJson(), fromJson: anyNamed('fromJson'))).called(1);
    });
  });

  group('recoverCredential', () {
    test('returns null on success', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenAnswer((_) async => Future.value());

      final result = await userRepository.recoverCredential('test@example.com');

      expect(result, null);
    });

    test('returns error code on FirebaseAuthException', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'User not found'));

      final result = await userRepository.recoverCredential('test@example.com');

      expect(result, 'user-not-found');
    });

    test('returns generic error message on other exceptions', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
          .thenThrow(Exception('Something went wrong'));

      final result = await userRepository.recoverCredential('test@example.com');

      expect(result, 'Ocurrió un error inesperado.');
    });
  });

  group('loginWithEmail', () {
    test('returns true on successful login', () async {
      final user = AuthUser(email: 'test@example.com', contrasena: 'password');
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse<AuthUser>(
              success: true,
              data: AuthUser(
                id: 1,
                nombreCompleto: 'Test User',
                foto: 'http://example.com/photo.jpg',
                email: 'test@example.com',
                contrasena: 'password',
                sessionToken: 'test_token',
              )));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.loginWithEmail(user);

      expect(result, true);
      verify(mockSecureStorageService.saveCredentials(any)).called(1);
    });

    test('returns false on failed login', () async {
      final user = AuthUser(email: 'test@example.com', contrasena: 'password');
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: false, data: null));

      final result = await userRepository.loginWithEmail(user);

      expect(result, false);
      verifyNever(mockSecureStorageService.saveCredentials(any));
    });
  });

  group('register', () {
    test('returns true on successful registration with email/password', () async {
      final user = AuthUser(email: 'new@example.com', contrasena: 'password');
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_uid');
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: 1));
      when(mockApiService.post(
              endpoint: 'users/login',
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(
              success: true,
              data: AuthUser(
                id: 1,
                nombreCompleto: 'Test User',
                foto: 'http://example.com/photo.jpg',
                email: 'test@example.com',
                contrasena: 'password',
                sessionToken: 'test_token',
              ).toJson()));
      when(mockSecureStorageService.saveCredentials(any)).thenAnswer((_) async => Future.value());

      final result = await userRepository.register(user, type: LoginWith.withUserPassword);

      expect(result, true);
      verify(mockApiService.post(endpoint: 'users', body: anyNamed('body'), fromJson: anyNamed('fromJson'))).called(1);
      verify(mockSecureStorageService.saveCredentials(any)).called(1);
    });

    test('returns false on failed registration', () async {
      final user = AuthUser(email: 'new@example.com', contrasena: 'password');
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test_uid');
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: false, data: null));

      final result = await userRepository.register(user, type: LoginWith.withUserPassword);

      expect(result, false);
      verifyNever(mockSecureStorageService.saveCredentials(any));
    });
  });

  group('getUser', () {
    test('returns AuthUser if credentials are loaded', () async {
      final authUser = AuthUser(email: 'test@example.com', contrasena: 'password');
      when(mockSecureStorageService.loadCredentials()).thenAnswer((_) async => authUser);

      final result = await userRepository.getUser();

      expect(result, authUser);
    });

    test('returns AuthUser.empty() if no credentials are loaded', () async {
      when(mockSecureStorageService.loadCredentials()).thenAnswer((_) async => null);

      final result = await userRepository.getUser();

      expect(result, AuthUser.empty());
    });
  });

  group('logout', () {
    test('completes successfully on logout', () async {
      final authUser = AuthUser(id: 1, email: 'test@example.com', sessionToken: 'test_token');
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);
      when(mockSecureStorageService.loadCredentials()).thenAnswer((_) async => authUser);
      when(mockApiService.post(
              endpoint: anyNamed('endpoint'),
              authorization: anyNamed('authorization'),
              body: anyNamed('body'),
              fromJson: anyNamed('fromJson')))
          .thenAnswer((_) async => ApiResponse(success: true, data: {}));
      when(mockSecureStorageService.deleteCredentials()).thenAnswer((_) async => Future.value());

      await userRepository.logout();

      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockSecureStorageService.loadCredentials()).called(1);
      verify(mockApiService.post(
              endpoint: 'users/logout',
              authorization: 'test_token',
              body: {'id': 1},
              fromJson: anyNamed('fromJson')))
          .called(1);
      verify(mockSecureStorageService.deleteCredentials()).called(1);
    });
  });
}
