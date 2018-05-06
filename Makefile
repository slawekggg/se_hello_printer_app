#
.PHONY: test test-api test_api test_ui

deps:
	pip install -r requirements.txt ; \
	pip install -r test_requirements.txt

lint:
	flake8  hello_world  test

test:
	PYTHONPATH=. py.test  --verbose -s

test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=.

test_api:
	python test-api/skrypcior.py

test_ui:
	py.test test_ui/test_ui.py

test_xunit:
	PYTHONPATH=. py.test -s --cov=.  --junit-xml=test_results.xml --ignore=test_ui

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
	--name hello-world-printer-dev \
	-p 5000:5000 \
	-d hello-world-printer

USERNAME=slawekdocker
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG); \
	docker logout
