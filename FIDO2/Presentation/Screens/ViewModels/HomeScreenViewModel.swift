//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine
import Moya
import Foundation

final class HomeScreenViewModel: ObservableObject {
	@Published var isLoading = false
	@Published var errorTitle: String?
	@Published var errorMessage: String?
	@Published var isEnrollSuccessful: Bool = false
	@Published var appConfiguration: AppConfiguration?
	@Published var username: String = ""

	private var cancellables: Set<AnyCancellable> = []
	private let enrollUseCase: EnrollUseCase

	init(enrollUseCase: EnrollUseCase? = nil) {
		self.enrollUseCase = enrollUseCase ?? {
			// TODO: Replace with actual token retrieval logic
			let tempToken = "<insert_token_here>"
			let authPlugin = AccessTokenPlugin { _ in tempToken }
			let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
			let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
			let provider = MoyaProvider<Fireball>(plugins: [authPlugin, networkLogger])
			return EnrollUseCaseImpl(fido2Repository: Fido2RepositoryImpl(fireballDataSource: FireballDataSource(provider: provider), fido2AuthenticationManager: Fido2AuthenticationManagerImpl()))
		}()
	}

	func loadConfiguration() {
		isLoading = true
		_Concurrency.Task {
			do {
				let config = try await ConfigurationLoaderImpl.shared.get()
				await MainActor.run {
					self.appConfiguration = config
				}
				// TODO find better place for this
				Fireball.appConfig = appConfiguration
				await MainActor.run {
					self.isLoading = false
				}
			} catch {
				await MainActor.run {
					self.isLoading = false
				}
				print("Error loading configuration: \(error)")
				self.errorTitle = "Configuration Error"
				self.errorMessage = error.localizedDescription
			}
		}
	}

	func register() {
		isLoading = true
		enrollUseCase.execute(username: username)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] completion in
				self?.isLoading = false
				if case .failure(let error) = completion {
					print("Error during enrollment: \(error)")
					self?.errorTitle = "Enrollment Error"
					self?.errorMessage = error.localizedDescription
				}
			}, receiveValue: { result in
				switch result {
				case .credentialAssertion:
					print("Login successful")
				case .credentialRegistration:
					print("Registration successful")
				}
			})
			.store(in: &cancellables)
	}

	func authenticate() {}
}
