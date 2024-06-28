.ONESHELL:

projectName = templateProject
appName = exampleName

run:
	make format
	make venv
	start http://127.0.0.1:8000/
	python $(projectName)/manage.py runserver
	

build:
	make venv
	pipreqs $(projectName)/ --savepath projectRequirements.txt
	python zipAndMinify.py -OO


venv:
	ifeq ($(OS),Windows_NT)
		venv/Scripts/activate
	endif
	ifeq ($(UNAME_S),Linux)
		source venv/Scripts/activate
	endif

format:
	make venv
	ruff check --fix $(projectName)/ --config ruff.toml
	ruff format $(projectName)/ --config ruff.toml

setup:
	python -m venv venv
	make venv
	make pip
	django-admin startproject $(projectName)
	python $(projectName)/manage.py migrate
	cd $(projectName)/
	python manage.py startapp $(appName)

pip: buildRequirements.txt
	make venv
	python -m pip install -r buildRequirements.txt --no-color
	python -m pip install -r projectRequirements.txt --no-color
