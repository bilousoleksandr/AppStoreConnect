all: install_dependencies generate_project

install_dependencies:
	mise install
	tuist install
	
generate_project:
	tuist generate