//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
	var sections: some View {
		ForEach(viewModel.sections) { section in
			DisclosureGroup(
				isExpanded: Binding(
					get: { expandedSectionId == section.id },
					set: { isOpen in
						expandedSectionId = isOpen ? section.id : nil
					}
				),
				content: {
					VStack {
						Divider()
							.padding(.top, 10)
						switch section.id {
						case .register:
							usernameField()
							options(for: section)
						case .authenticate:
							usernameField(isAutoFillAssisted: true)
							options(for: section)
						case .authenticateUsernameless:
							EmptyView()
						}
						button(for: section)
						message
					}
				},
				label: {
					Text(section.title)
						.font(.headline)
						.foregroundColor(.primary)
				}
			)
			.accentColor(.accentColor)
			.padding(10)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(.separator), lineWidth: 1)
					.background(Color(.systemGray6).cornerRadius(10))
			)
			.onChange(of: expandedSectionId) { _ in
				viewModel.message = nil
			}
		}
	}
}
