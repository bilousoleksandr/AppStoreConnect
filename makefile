all: install_dependencies generate_project

install_dependencies:
	mise install
	tuist install

generate_empty_mock_files:
	bash ./Scripts/Sourcery/generate_empty_mock_files.sh

generate_project:
	tuist generate

generate: generate_empty_mock_files generate_project
	