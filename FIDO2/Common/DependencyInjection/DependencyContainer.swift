//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Moya
@preconcurrency import Swinject
@preconcurrency import SwinjectAutoregistration

let dependencyContainer = DependencyProvider.shared.container

final class DependencyProvider: Sendable {
	static let shared = DependencyProvider()

	let container = Container()

	private init() {
		registerDependencies()
	}

	private func registerDependencies() {
		// MARK: Common

		container.autoregister(ConfigurationLoader.self, initializer: ConfigurationLoaderImpl.init).inObjectScope(.container)

		// MARK: ViewModels

		container.autoregister(HomeScreenViewModel.self, initializer: HomeScreenViewModel.init).inObjectScope(.transient)

		// MARK: Services

		container.autoregister(AuthorizationService.self, initializer: AuthorizationServiceImpl.init).inObjectScope(.weak)

		// MARK: UseCases

		container.autoregister(StartAuthorizationUseCase.self, initializer: StartAuthorizationUseCaseImpl.init).inObjectScope(.transient)
		container.autoregister(CompleteAuthorizationUseCase.self, initializer: CompleteAuthorizationUseCaseImpl.init).inObjectScope(.transient)

		// MARK: Repositories

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
