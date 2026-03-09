//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Moya
@preconcurrency import Swinject
@preconcurrency import SwinjectAutoregistration

/// Global convenience accessor for the shared Swinject container.
let dependencyContainer = DependencyProvider.shared.container

/// Bootstraps and owns the Swinject dependency injection container.
///
/// Call `DependencyProvider.shared.container` (or the `dependencyContainer` shorthand)
/// to resolve dependencies anywhere in the app.
final class DependencyProvider: Sendable {
	static let shared = DependencyProvider()

	let container = Container()

	private init() {
		registerDependencies()
	}

	private func registerDependencies() {
		// MARK: Common
		// Singleton — configuration is read once and cached.
		container.autoregister(ConfigurationLoader.self, initializer: ConfigurationLoaderImpl.init).inObjectScope(.container)

		// MARK: ViewModels
		// Transient — a new view model is created each time the view appears.
		container.autoregister(HomeScreenViewModel.self, initializer: HomeScreenViewModel.init).inObjectScope(.transient)

		// MARK: Services
		// Weak singleton — must outlive the ASAuthorizationController delegate callback lifecycle.
		container.autoregister(AuthorizationService.self, initializer: AuthorizationServiceImpl.init).inObjectScope(.weak)

		// MARK: UseCases
		// Transient — each request gets a fresh use case instance.
		container.autoregister(StartAuthorizationUseCase.self, initializer: StartAuthorizationUseCaseImpl.init).inObjectScope(.transient)
		container.autoregister(CompleteAuthorizationUseCase.self, initializer: CompleteAuthorizationUseCaseImpl.init).inObjectScope(.transient)
		container.autoregister(IntrospectUseCase.self, initializer: IntrospectUseCaseImpl.init).inObjectScope(.transient)

		// MARK: Repositories
		// Transient — each use case gets its own repository instance.
		container.autoregister(Fido2Repository.self, initializer: Fido2RepositoryImpl.init).inObjectScope(.transient)

		// MARK: Network

		container.register(AccessTokenPlugin.self) { resolver in
			AccessTokenPlugin { _ in (try? (resolver ~> ConfigurationLoader.self).config.accessToken) ?? "" }
		}
		container.register(NetworkLoggerPlugin.self) { _ in
			let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
			return NetworkLoggerPlugin(configuration: loggerConfig)
		}

		// MARK: DataSources

		container.register(MoyaProvider<AuthenticationCloud>.self) { resolver in
			MoyaProvider<AuthenticationCloud>(plugins: [resolver ~> AccessTokenPlugin.self, resolver ~> NetworkLoggerPlugin.self])
		}.inObjectScope(.transient)

		container.autoregister(AuthenticationCloudDataSource.self, initializer: AuthenticationCloudDataSourceImpl.init).inObjectScope(.transient)
	}
}
